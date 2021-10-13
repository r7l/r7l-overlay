# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Grafana program user"
ACCT_USER_ID=200
ACCT_USER_GROUPS=( "${PN}" )

acct-user_add_deps
