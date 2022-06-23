# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for www-apps/libreddit"
ACCT_USER_ID=635
ACCT_USER_GROUPS=( libreddit )
ACCT_USER_HOME="/var/empty"
acct-user_add_deps
SLOT="0"
