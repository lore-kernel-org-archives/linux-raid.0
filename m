From: Shaohua Li <shli@fb.com>
Subject: [PATCH --resend 0/2] fix writesame
Date: Mon, 13 Feb 2017 11:55:46 -0800
Message-ID: <cover.1487015420.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

This is the writesame issue fix reported in bugzilla 118581. Sitsofe doesn't
reply to me if he tested these, but they do work for me with a scsi_debug test.
I'm going to apply them for 4.11 if no objection.

Shaohua Li (2):
  md: disable WRITE SAME if it fails for linear/raid0
  md/multipath: disable WRITE SAME if it fails for multipath

 drivers/md/linear.c    |  6 +++++-
 drivers/md/md.c        | 45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h        |  2 ++
 drivers/md/multipath.c |  4 ++++
 drivers/md/raid0.c     |  6 +++++-
 5 files changed, 61 insertions(+), 2 deletions(-)

-- 
2.9.3

