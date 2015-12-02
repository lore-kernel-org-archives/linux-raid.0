From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/3] mdadm: re-add journal to array with bad journal
Date: Tue, 1 Dec 2015 17:13:23 -0800
Message-ID: <1449018805-320020-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

These patches try to recreate missing/faulty journal in mdadm. Since
the array is readonly with journal missing, it is necessary to
restart the array after recreating journal.

Song Liu (3):
  add sysfs_array_state to struct mdinfo
  [mdadm] recreate journal in mdadm
  make .spec file work

 Assemble.c                  |  8 +++++++-
 Manage.c                    | 32 +++++++++++++++++++++++++++++++-
 ReadMe.c                    |  3 ++-
 mdadm.c                     |  8 ++++++++
 mdadm.h                     |  5 +++++
 mdadm.spec                  |  8 ++++----
 super1.c                    |  3 ++-
 sysfs.c                     |  7 +++++++
 udev-md-raid-assembly.rules |  2 +-
 9 files changed, 67 insertions(+), 9 deletions(-)

--
2.4.6
