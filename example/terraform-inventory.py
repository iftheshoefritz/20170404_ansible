#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Builds an Ansible inventory for an environment from terraform environment
outputs.

Usage::

  terraform-inventory.py --list

The output of ``terraform output -json`` should contain a map of ``host_ips``
and ``host_tags``. The ``host_tags`` values should contain a ``Groups`` key
that contains a list of groups that the host should be part of. All hosts are
added to a group named ``servers``::

    {
        "host_ips": {
            "sensitive": false,
            "type": "map",
            "value": {
                "rabbitmq_staging": "52.57.221.57"
            }
        },
        "host_tags": {
            "sensitive": false,
            "type": "map",
            "value": {
                "rabbitmq_staging": {
                    "Name": "rabbitmq_staging"
                    "Groups": ["rabbitmq_servers"]
                }
            }
        }
    }

See http://docs.ansible.com/ansible/developing_inventory.html for documentation
on writing dynamic Ansible inventory scripts.
"""

import argparse
import json
import subprocess


class AnsibleInventory(object):
    """ An Ansible Inventory. """
    def __init__(self):
        self._groups = {}
        self._hostvars = {}

    def add_host(self, ip, groups, vars):
        self._hostvars[ip] = vars
        for group_name in groups:
            group = self._groups.setdefault(group_name, {
                "hosts": [], "vars": {},
            })
            group["hosts"].append(ip)

    def to_dict(self):
        inventory = {
            "_meta": {
                "hostvars": self._hostvars,
            },
        }
        inventory.update(self._groups)
        return inventory

    def print_inventory(self):
        """ Pretty print an inventory. """
        print(json.dumps(self.to_dict(), sort_keys=True, indent=2))


def read_terraform_output(terraform_env):
    """ Read terraform output. """
    data = subprocess.check_output(
        ["terraform", "output", "-json"], cwd=terraform_env)
    return json.loads(data)


def parse_terraform_output(output):
    """ Parse terraform output into an AnsibleInventory. """
    host_ips = output["host_ips"]["value"]
    host_tags = output["host_tags"]["value"]
    inventory = AnsibleInventory()
    for host, ip in host_ips.items():
        tags = host_tags[host]
        tag_groups = tags.get("Groups", "").split(",")
        tag_groups = [g.strip() for g in tag_groups]
        groups = ["servers"] + tag_groups
        vars = {"name": host, "tags": tags}
        inventory.add_host(ip, groups=groups, vars=vars)
    return inventory


def terraform_inventory(terraform_env):
    """ Return the terraform inventory. """
    output = read_terraform_output(terraform_env)
    inventory = parse_terraform_output(output)
    return inventory


def cli_args_parser():
    """ Return the CLI arguments parser. """
    parser = argparse.ArgumentParser(
        description='Generate an Ansible inventory from Terraform output')
    parser.add_argument(
        'terraform_env',
        help='The path to the terraform environment to read output from.')
    parser.add_argument(
        '--list', action='store_true', default=True,
        help='List instances (default: True)')
    return parser


def main():
    """ Generate an Ansible inventory from Terraform output. """
    parser = cli_args_parser()
    args = parser.parse_args()
    if args.list:
        inventory = terraform_inventory(args.terraform_env)
        inventory.print_inventory()


if __name__ == "__main__":
    main()
