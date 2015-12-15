From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 0/2] mdadm: re-add journal to array with bad journal
Date: Mon, 14 Dec 2015 17:43:41 -0800
Message-ID: <1450143823-1145846-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

These patches enable recreation of missing/faulty journal. This requires
kernel changes as well, which Shaohua will send out later.

Song Liu (2):
  add sysfs_array_state to struct mdinfo
  [mdadm] recreate journal in mdadm

 Manage.c | 42 +++++++++++++++++++++++++++++++++++++++---
 ReadMe.c |  1 +
 mdadm.c  |  8 ++++++++
 mdadm.h  |  5 +++++
 super1.c |  3 ++-
 sysfs.c  |  7 +++++++
 6 files changed, 62 insertions(+), 4 deletions(-)

--
2.4.6
