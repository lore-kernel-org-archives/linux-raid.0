From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/3] improve mdadm support of write journal
Date: Wed, 21 Oct 2015 11:35:13 -0700
Message-ID: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Per discussion in

http://marc.info/?l=linux-raid&m=144522071120149

and related threads, the following patches add more support
for write journal (test script, man page, small refactoring).

Song Liu (3):
  mdadm: refactor write journal code in Assemble and Incremental
  mdadm: Add description of write journal to md.4
  mdadm: add test script for raid456 journal

 Assemble.c           | 24 +++++---------------
 Incremental.c        | 25 ++++++--------------
 md.4                 | 20 ++++++++++++++++
 mdadm.h              |  6 ++---
 super1.c             | 19 +++-------------
 test                 |  9 ++++++++
 tests/20raid5journal | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 111 insertions(+), 56 deletions(-)
 create mode 100644 tests/20raid5journal

--
2.4.6
