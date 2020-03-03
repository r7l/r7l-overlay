# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Traefik user"
ACCT_USER_ID=500
ACCT_USER_GROUPS=( traefik )
acct-user_add_deps
SLOT="0"
