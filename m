From: mwilck@arcor.de
Subject: Fixes for the DDF patch series
Date: Mon,  8 Jul 2013 23:50:36 +0200
Message-ID: <1373320248-7520-1-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Hi Neil,

This series fixes some issues I found with my last series of patches.
The new series is based on your merges as of Jul 8, 2013. 
To avoid confusionwith the previous series, I started numbering at 28.
Moreover, it implements kill_subarray(), so that array creation and
deletion works with DDF.

Basically, there were two problems: 1. Array creation would fail if 
the set of devices was given explicitly rather than doing auto-layout, and 
mdmon was already running; 2. Creation of RAID10 would fail if mdmon
was already running.

29 and 30 are optional, but I think they're correct.
31 implements kill_subarray().
32 and 33 are the fixes for problem 1.
34-38 are just debug messages that I needed to track the problems down.
39 is the fix for problem 2.

Regards
Martin

Martin Wilck (12):
  test/10-ddf-create: fix comments
  Monitor: Don't write metadata in inactive array state
  DDF: write_init_super_ddf: don't zero superblocks for subarrays
  DDF: implement kill_subarray
  DDF: getinfo_super_ddf_bvd: identify disk by refnum
  DDF: getinfo_super_ddf_bvd: fix raid_disk calculation
  DDF: fix endianness of refnum in debug messages
  DDF: add debug message in add_super_ddf_bvd
  DDF: ddf_process_update: add debug messages fore adding VDs
  DDF: guid_str: more readable output
  DDF: ddf_process_update: some more debug messages
  DDF: ddf_process_update: Fix updates for SVDs

 monitor.c          |    3 +-
 super-ddf.c        |  241 ++++++++++++++++++++++++++++++++++++++++++----------
 tests/10ddf-create |    3 +-
 3 files changed, 199 insertions(+), 48 deletions(-)
