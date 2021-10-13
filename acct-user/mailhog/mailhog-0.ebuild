# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-mail/mailhog"
ACCT_USER_ID=618
ACCT_USER_GROUPS=( mailhog )

ACCT_USER_ID=200
ACCT_USER_HOME=/var/lib/mailhog
ACCT_USER_HOME_OWNER=mailhog:mailhog
ACCT_USER_HOME_PERMS=02755
ACCT_USER_GROUPS=( mailhog )

acct-user_add_deps

SLOT="0"
