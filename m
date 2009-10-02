From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] md fixes for 2.6.32-rc
Date: Thu, 01 Oct 2009 18:18:20 -0700
Message-ID: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

A few fixes:
1/ The multicore option is not ready for prime time
2/ A fix for raid5 init failures
3/ A reminder that the fix you sent to Greg a while back has not found
   its way upstream.

Thanks,
Dan

---

Dan Williams (2):
      Revert "md/raid456: distribute raid processing over multiple cores"
      md/raid5: initialize conf->device_lock earlier

NeilBrown (1):
      Allow sysfs_notify_dirent to be called from interrupt context.


 drivers/md/Kconfig |   11 ---------
 drivers/md/raid5.c |   62 +++++++++++++---------------------------------------
 fs/sysfs/file.c    |   14 +++++++-----
 3 files changed, 23 insertions(+), 64 deletions(-)
