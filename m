From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 000 of 8] Introduction
Date: Mon, 22 Aug 2005 11:59:13 +1000
Message-ID: <20050822115252.4868.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Following are 8 patches for md in 2.6.13-rc6-mm1.

The first patch could usefully go into 2.6.13.  The remainder should wait
for 2.6.14-rc1.

Number 001 simply calls md_wakeup_thread during raid startup to make
sure that resync gets started.  It is always perfectly safe to call
this function -- as long as we don't call it continuously -- as an
extra wakeup doesn't hurt.
The remainder fix:
    bugs in code that is only in -mm as yet, 
    minor bugs in recently added 'bitmap' code,
    fix a long standing shortcoming with 'linear' the only one person has 
      complained about.

Thanks,
NeilBrown


 [PATCH md 001 of 8] Make sure resync gets started when array starts.
 [PATCH md 002 of 8] Support md/linear array with components greater than 2 terabytes.
 [PATCH md 003 of 8] raid1_quiesce is back to front, fix it.
 [PATCH md 004 of 8] Make sure bitmap_daemon_work actually does work.
 [PATCH md 005 of 8] Do not set mddev->bitmap until bitmap is fully initialised
 [PATCH md 006 of 8] Allow hot-adding devices to arrays with non-persistant superblocks.
 [PATCH md 007 of 8] Allow md to load a superblock with feature-bit '1' set
 [PATCH md 008 of 8] Fix bitmap/read_sb_page so that it handles errors properly.
