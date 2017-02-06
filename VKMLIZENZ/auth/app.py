#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
from _ast import In
import flask_wtf
from flask import Flask, url_for, redirect, render_template, request, abort
from flask_sqlalchemy import SQLAlchemy
from flask_security import Security, SQLAlchemyUserDatastore, \
    UserMixin, RoleMixin, login_required, current_user
from flask_security.utils import encrypt_password
import flask_admin
from flask_admin.contrib import sqla
from flask_admin import helpers as admin_helpers
from flask_admin.contrib.sqla.validators import ItemsRequired,Unique
from wtforms.validators import *
from flask_admin.model.form import InlineFormAdmin
#from flask_admin.contrib.sqla.form import InlineModelConverter
#from wtforms import StringField
from wtforms import ValidationError
try:
    from wtforms.validators import InputRequired
except ImportError:
    from wtforms.validators import Required as InputRequired


# Create Flask application
app = Flask(__name__)
app.config.from_pyfile('config.py')
db = SQLAlchemy(app)


# Define models
roles_users = db.Table(
    'roles_users',
    db.Column('user_id', db.Integer(), db.ForeignKey('user.id')),
    db.Column('role_id', db.Integer(), db.ForeignKey('role.id'))
)


class Role(db.Model, RoleMixin):
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(80), unique=True)
    description = db.Column(db.String(255))

    def __str__(self):
        return self.name


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(255))
    last_name = db.Column(db.String(255))
    email = db.Column(db.String(255), unique=True)
    password = db.Column(db.String(255))
    active = db.Column(db.Boolean())
    confirmed_at = db.Column(db.DateTime())
    roles = db.relationship('Role', secondary=roles_users,
                            backref=db.backref('users', lazy='dynamic'))

    def __str__(self):
        return self.email


class Ip(db.Model):
    __tablename__ = 'ip'
    id = db.Column(db.Integer(), primary_key=True)
    address = db.Column(db.String(15),default="0.0.0.0")
    internetaccess = db.Column(db.Boolean(),default=True)
    networkdevice_id = db.Column(db.Integer, db.ForeignKey("networkdevice.id"))
    ip = db.relationship("Networkdevice", backref=db.backref(
        'ip', uselist=False, cascade="all, delete-orphan", single_parent=True))  # ))

    def __str__(self):
        if self.internetaccess:
            return self.address
        return self.address + " (nur intern)"

class Inventory(db.Model):
    __tablename__ = 'inventory'
    id = db.Column(db.Integer(), primary_key=True)
    inventory_number = db.Column(db.String(45))

    def __str__(self):
        return self.inventory_number

class Networkdevicetype(db.Model):
    __tablename__ = 'networkdevicetype'
    id = db.Column(db.Integer(), primary_key=True)
    name = db.Column(db.String(45))
    description = db.Column(db.String(45))

    def __str__(self):
        return self.name

class Networkdevice(db.Model):
    __tablename__ = 'networkdevice'
    id = db.Column(db.Integer, primary_key=True)
    network_name = db.Column(db.String(45))

    inventory_id = db.Column(db.Integer, db.ForeignKey("inventory.id"))
    inventory = db.relationship(Inventory, backref=db.backref(
        'networkdevice' ,cascade="all, delete-orphan",single_parent=True))#))

    networkdevicetype_id = db.Column(db.Integer, db.ForeignKey("networkdevicetype.id"))
    networkdevicetype = db.relationship(Networkdevicetype, backref=db.backref(
        'networkdevice',  uselist=False, cascade="all, delete-orphan", single_parent=True))  # ))

    cpu = db.Column(db.String(45))
    ram = db.Column(db.String(45))
    ram_details = db.Column(db.String(45))
    mainboard = db.Column(db.String(45))
    description = db.Column(db.String(45))

    bought_at = db.Column(db.DateTime())

    def __str__(self):
        return self.network_name


# Setup Flask-Security
user_datastore = SQLAlchemyUserDatastore(db, User, Role)
security = Security(app, user_datastore)


# Create customized model view class
class MyModelView(sqla.ModelView):

    def is_accessible(self):
        if not current_user.is_active or not current_user.is_authenticated:
            return False

        if current_user.has_role('superuser'):
            return True

        return False

    def _handle_view(self, name, **kwargs):
        """
        Override builtin _handle_view in order to redirect users when a view is not accessible.
        """
        if not self.is_accessible():
            if current_user.is_authenticated:
                # permission denied
                abort(403)
            else:
                # login
                return redirect(url_for('security.login', next=request.url))



class NetworkdeviceInlineModelForm(InlineFormAdmin):
    form_columns = ('id','network_name','networkdevicetype','mainboard','cpu','ram',"ram_details",'description','ip',"description","bought_at")
    column_labels = dict(network_name='Netzwerkname', mainboard="Modellbezeichnung/ Mainboard", networkdevicetype='Geräte-Typ',ram="Arbeitsspeicher",ram_details='Arbeitsspeicher Details')
    column_descriptions = dict(
        network_name = "Name des Geräts im Netzwerk (gemäß VKM-Policy; Bsp.: Tanja2).",
        networkdevicetype="Art des netwerk-fähigen Gerätes.",
        mainboard="Je nach Typ Herstellerbezeichung/ Baureihe der Hardware (Bsp.: ASUS Z170-A | HP Aruba 2720 | KYOCERA FS1020D | Raspberry v3)",
        ram='Anzahl des zur Verfügung stehenden Arbeitsspeichers in Gigabytes (Bsp.: 8 )',
        ram_details='Format: [S0 bei Notebook-RAM],Chip,Modul,Weiteres (Bsp.: DDR3-2133,PC3-17000,ECC | S0,DDR4-3200,PC4L-25600,nur schnellster Riegel )'
    )
#    #column_list = ( Systems.name)
    #column_auto_select_related = True


class ItemsRequiredExactly(InputRequired):
    """
    A version of the ``InputRequired`` validator that works with relations,
    to require a minimum number of related items.
    """
    def __init__(self, min=1, message=None):
        super(ItemsRequiredExactly, self).__init__(message=message)
        self.min = min

    def __call__(self, form, field):
        if len(field.data) < self.min or len(field.data) > self.min:
            if self.message is None:
                message = field.ngettext(
                    u"Only %d item is allowed!",
                    u"Only least %d items are allowed!",
                    self.min
                ) % self.min
            else:
                message = self.message

            raise ValidationError(message)
        if field.data[0]["network_name"] == None:
            raise ValidationError(str(field.data[0]["network_name"]))

class InventoryNetworkDevicesView (MyModelView):
    inline_models = (NetworkdeviceInlineModelForm(Networkdevice),)
    can_delete = False
    form_widget_args = {
        'networkdevice': {
            'disabled': True
        },
    }
    #column_hide_backrefs = False
    #column_list = (Inventar.id,Inventar.inventarnr)
    #column_select_related_list = ()
    #model1 = db.relation(Systems, backref='systems')
    form_args = {
        "networkdevice": {"default": [{"id":None}],
                          "validators": [ItemsRequiredExactly()]
                          },
        #"name": {"validators": [InputRequired()]},
        "inventory_number": {"validators": [InputRequired(),Unique(db.session,Inventory,Inventory.inventory_number)]}
    }

    column_labels = dict(networkdevice='Gerät',inventory_number="Inventarnummer",network_name="Netzwerkname")
    column_list = (
        "id",
        "inventory_number",
    #    "inventar_id",
        "network_name"
    )
  #  column_editable_list = ("id")
    #column_default_sort = (Systems.name)
    def create_form(self):
        return self._use_filtered_parent2(
            super(InventoryNetworkDevicesView, self).create_form()
        )

    def edit_form(self, obj):
        return self._use_filtered_parent(
            super(InventoryNetworkDevicesView, self).edit_form(obj)
        )

    def _use_filtered_parent(self, form):
        form.networkdevice[0].ip.query_factory = self._get_parent_list
        return form

    def _get_parent_list(self):
        return Ip.query.filter((Ip.networkdevice_id == None) | (Ip.networkdevice_id == Networkdevice.id)).all()

    def _use_filtered_parent2(self, form):
        form.networkdevice[0].ip.query_factory = self._get_parent_list2
        return form

    def _get_parent_list2(self):
        return Ip.query.filter(Ip.networkdevice_id == None).all()

    def __unicode__(self):
        return self.name

    def get_query(self):
        return (
            self.session.query(
                Inventory.id.label("id"),
                Inventory.inventory_number.label("inventory_number"),
                #Systems.inventar_id.label("inventar_id"),
                Networkdevice.network_name.label("network_name")
            )
            .join(Networkdevice)
        )

    def scaffold_sortable_columns(self):
        return {'network_name':'network_name','inventory_number':'inventory_number'}

    def scaffold_list_columns(self):
        return ['id','inventory_number','inventory_id','network_name']


# Flask views
@app.route('/')
def index():
    return render_template('index.html')

# Create admin
admin = flask_admin.Admin(
    app,
    'Example: Auth',
    base_template='my_master.html',
    template_mode='bootstrap3',
)

# Add model views
admin.add_view(MyModelView(Role, db.session))
admin.add_view(MyModelView(User, db.session))
admin.add_view(MyModelView(Ip, db.session))
admin.add_view(MyModelView(Inventory, db.session))
admin.add_view(MyModelView(Networkdevicetype, db.session))
admin.add_view(MyModelView(Networkdevice, db.session))
admin.add_view(InventoryNetworkDevicesView(Inventory, db.session, endpoint='inv'))

# define a context processor for merging flask-admin's template context into the
# flask-security views.
@security.context_processor
def security_context_processor():
    return dict(
        admin_base_template=admin.base_template,
        admin_view=admin.index_view,
        h=admin_helpers,
        get_url=url_for
    )


def build_sample_db():
    """
    Populate a small db with some example entries.
    """

    import string
    import random

    db.drop_all()
    db.create_all()

    with app.app_context():
        user_role = Role(name='user')
        super_user_role = Role(name='superuser')
        db.session.add(user_role)
        db.session.add(super_user_role)
        db.session.commit()

        test_user = user_datastore.create_user(
            first_name='Admin',
            email='admin',
            password=encrypt_password('admin'),
            roles=[user_role, super_user_role]
        )

        first_names = [
            'Harry', 'Amelia', 'Oliver', 'Jack', 'Isabella', 'Charlie', 'Sophie', 'Mia',
            'Jacob', 'Thomas', 'Emily', 'Lily', 'Ava', 'Isla', 'Alfie', 'Olivia', 'Jessica',
            'Riley', 'William', 'James', 'Geoffrey', 'Lisa', 'Benjamin', 'Stacey', 'Lucy'
        ]
        last_names = [
            'Brown', 'Smith', 'Patel', 'Jones', 'Williams', 'Johnson', 'Taylor', 'Thomas',
            'Roberts', 'Khan', 'Lewis', 'Jackson', 'Clarke', 'James', 'Phillips', 'Wilson',
            'Ali', 'Mason', 'Mitchell', 'Rose', 'Davis', 'Davies', 'Rodriguez', 'Cox', 'Alexander'
        ]

        for i in range(len(first_names)):
            tmp_email = first_names[i].lower() + "." + last_names[i].lower() + "@example.com"
            tmp_pass = ''.join(random.choice(string.ascii_lowercase + string.digits) for i in range(10))
            user_datastore.create_user(
                first_name=first_names[i],
                last_name=last_names[i],
                email=tmp_email,
                password=encrypt_password(tmp_pass),
                roles=[user_role, ]
            )
        db.session.commit()
    return

if __name__ == '__main__':
    #build_sample_db()
    # Start app
    app.run(debug=True,host='130.83.206.235')
