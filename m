From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] md: ping userspace on 'stop' events
Date: Tue, 29 Apr 2008 18:19:38 -0700
Message-ID: <20080430011938.20468.26068.stgit@dwillia2-linux.ch.intel.com>
References: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This additional notification to 'array_state' is needed to allow the monitor
application to learn about stop events via sysfs.  The
sysfs_notify("sync_action") call that comes at the end of do_md_stop() (via
md_new_event) is insufficient since the 'sync_action' attribute has been
removed by this point.

(Seems like a sysfs-notify-on-removal patch is a better fix.  Currently removal
 updates the event count but does not wake up waiters)

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/md.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/md/md.c b/drivers/md/md.c
index ad53035..606c8ee 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3693,6 +3693,9 @@ static int do_md_stop(mddev_t * mddev, int mode)
 
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
+			/* tell userspace to handle 'inactive' */
+			if (mddev->external)
+				sysfs_notify(&mddev->kobj, NULL, "array_state");
 
 			set_capacity(disk, 0);
 			mddev->changed = 1;

