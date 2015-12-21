From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/3] [mdadm] fixes and feature for journal device
Date: Mon, 21 Dec 2015 11:23:40 -0800
Message-ID: <1450725823-1832511-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

As we give journal device disk role of 0
(http://marc.info/?l=linux-raid&m=145030044008753), we need 2 fixes
in mdadm (patch 1 and 2).

Patch 3 tries to add journal to an existing array that does not have
journal before.

Song Liu (3):
  [mdadm] move journal to end of --detail list
  [mdadm] in --add assign raid_disk of 0 to journal
  Add new journal to array that does not have journal

 Assemble.c |  5 +----
 Detail.c   |  5 +++--
 Manage.c   | 34 +++++++++++++++++++++++++++-------
 3 files changed, 31 insertions(+), 13 deletions(-)

--
2.4.6
