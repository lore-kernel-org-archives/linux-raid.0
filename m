From: mwilck@arcor.de
Subject: [PATCH 0/6] More DDF fixes and unit tests
Date: Fri, 19 Jul 2013 21:04:09 +0200
Message-ID: <1374260655-5788-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Hi Neil,

here are some more fixes for the DDF patch series, and extended
DDF unit tests that helped me find the bugs.

Martin

*** BLURB HERE ***

Martin Wilck (6):
  DDF: err_bad_md_layout: fix return value
  DDF: kill_subarray_ddf: fix case without mdmon running
  DDF: getinfo_super_ddf_bvd: fix offset calculation for SVDs
  tests/10ddf-create: create RAID5 first
  test: increase number of devices to 13
  tests/10ddf-geometry: new unit test

 super-ddf.c          |   11 ++++--
 test                 |    4 +-
 tests/10ddf-create   |   10 +++---
 tests/10ddf-geometry |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 11 deletions(-)
 create mode 100644 tests/10ddf-geometry
