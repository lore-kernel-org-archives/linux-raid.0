From: mwilck@arcor.de
Subject: [PATCH 00/10] Two bug fixes and a lot of debug code
Date: Tue, 30 Jul 2013 23:18:24 +0200
Message-ID: <1375219114-5626-1-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

This patch series fixes the "suspicious test failure" mentioned
in an earlier posting to linux-raid, and another bug introduced
by myself. Besides, it contains a lot of DEBUG code that was 
necessary to understand the "suspicious" problem.

Verified that the 09 and 10 unit test series are not broken.

Martin Wilck (10):
  DDF: ddf_activate_spare: bugfix for 62ff3c40
  DDF: log disk status changes more nicely
  DDF: ddf_process_update: log offsets for conf changes
  DDF: load_ddf_header: more error logging
  DDF: ddf_set_disk: add some debug messages
  monitor: read_and_act: log status when called
  mdmon: wait_and_act: fix debug message for SIGUSR1
  mdmon: manage_member: debug messages for array state
  mdmon: manage_member: fix race condition during slow meta data writes
  tests/10ddf-create-fail-rebuild: new unit test for DDF

 managemon.c                     |   11 +++++-
 monitor.c                       |   25 +++++++++++--
 super-ddf.c                     |   75 +++++++++++++++++++++++++++++---------
 tests/10ddf-create-fail-rebuild |   77 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 166 insertions(+), 22 deletions(-)
 create mode 100644 tests/10ddf-create-fail-rebuild
