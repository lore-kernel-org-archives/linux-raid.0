From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 0/5] Assorted mdadm patch
Date: Mon, 27 Mar 2017 14:36:55 +1100
Message-ID: <149058575542.15679.9804611071393072863.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I found these while tidying up....
I post a couple already, but then realised that I
have quite a few, so here they are all together.
Sorry for the duplication.

NeilBrown


---

Hannes Reinecke (1):
      udev-md-raid-assembly.rules: Skip non-ready devices

NeilBrown (4):
      Retry HOT_REMOVE_DISK a few times.
      Introduce sys_hot_remove_disk()
      Add 'force' flag to *hot_remove_disk().
      Detail: handle non-existent arrays better.


 Detail.c                    |    8 ++++++++
 Grow.c                      |    9 +--------
 Manage.c                    |   14 +++++---------
 mdadm.h                     |    2 ++
 udev-md-raid-assembly.rules |    3 +++
 util.c                      |   30 ++++++++++++++++++++++++++++++
 6 files changed, 49 insertions(+), 17 deletions(-)

--
Signature

