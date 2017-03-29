#!/bin/bash
TERRAFORM_ENV="../terraform"
exec ../terraform-inventory.py "$TERRAFORM_ENV" "$@"
