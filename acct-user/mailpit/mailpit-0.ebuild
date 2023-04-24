# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for mail-mta/mailpit"
ACCT_USER_ID=202
ACCT_USER_GROUPS=( mailpit )
ACCT_USER_HOME=/var/lib/mailpit
ACCT_USER_HOME_OWNER=mailpit:mailpit

acct-user_add_deps

SLOT="0"