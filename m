From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/2] a couple of readonly handling fixups
Date: Thu, 08 Jan 2009 00:24:33 -0700
Message-ID: <20090108072023.9577.3585.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The BUG_ON(mddev->ro == 1) in md_write_start can be triggered under two
circumstances in recent kernels.  One was reported by Justin Maggard:

1) Create an md array with >= 1 disk
2) Start a task writing to the array ("dd if=/dev/zero of=/dev/md0
bs=1M count=10000 &" does the trick for me)
3) Force an improper reboot with reboot -fn

...the other was discovered while investigating this issue.

1) Set a raid5 readyonly with mdadm
2) Set the array writable with blockdev
3) Attempt to write to the array

---

Dan Williams (2):
      Revert "Restore force switch of md array to readonly at reboot time."
      md: set mddev readonly flag on blkdev BLKROSET ioctl

 drivers/md/md.c |   35 ++++++++++++++++++++++++++++++-----
 1 files changed, 30 insertions(+), 5 deletions(-)

