From: mwilck@arcor.de
Subject: [PATCH 0/4] Basic hotspare handling for RAID10
Date: Thu, 25 Jul 2013 20:59:09 +0200
Message-ID: <1374778753-6252-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This patch set contains a minor bug fix and code to make --fail/--add
work with DDF/RAID10.

Martin Wilck (4):
  DDF: find_vdcr: fix minor bug in debug message
  DDF: ddf_activate_spare: Add RAID10 code
  DDF: ddf_activate_spare: only activate good drives
  DDF: ddf_activate_spare: fix metadata update for SVDs

 super-ddf.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 95 insertions(+), 12 deletions(-)
