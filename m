From: Neil Brown <neilb@suse.de>
Subject: Re: [GIT PATCH 0/2] external-metadata recovery checkpointing for
 2.6.33
Date: Mon, 14 Dec 2009 15:07:25 +1100
Message-ID: <20091214150725.49de72f1@notabene.brown>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: ed.ciechanowski@intel.com, marcin.labun@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 12 Dec 2009 21:17:01 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Hi Neil,
> 
> A bit late, but hopefully acceptable.  This allows mdmon to restart
> recovery operations.
> 
>      git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git for-neil
> 
> The modifications to mdadm/mdmon need a bit more testing but you can see
> the current results on my 'scratch' [1] branch, and I have copied the
> meat of the mdmon implementation below:  'mdmon: add recovery checkpoint
> support'.
> 

Thanks Dan.

> Dan Williams (2):
>       md: rcu_read_lock() walk of mddev->disks in md_do_sync()

This one is fine.

>       md: add 'recovery_start' sysfs attribute

This one I don't like so much.
recovery_start should be a per-device value, not a per-array value,
and each device can theoretically have been recovered to a different place.
We don't make much use of that fact, but maybe we could one day.

So I have change the code to simply expose rdev->recovery_offset through
sysfs, which should provide all the functionality you need.
Patch below.
It still says "From: Dan Williams" because I started with you patch
and then changes almost all of it (but not quite all).  That seems a
bit odd but doesn't bother me - tell me if it bothers you.

NeilBrown

From d8fe7d6fbbd73a89f7be356791699cb2e9b95f78 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 12 Dec 2009 21:17:12 -0700
Subject: [PATCH] md: add 'recovery_start' per-device sysfs attribute

Enable external metadata arrays to manage rebuild checkpointing via a
md/dev-XXX/recovery_start attribute which reflects rdev->recovery_offset

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 Documentation/md.txt |   27 +++++++++++++++++++++++----
 drivers/md/md.c      |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index 21d26fb..188f476 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -233,9 +233,9 @@ All md devices contain:
 
   resync_start
      The point at which resync should start.  If no resync is needed,
-     this will be a very large number.  At array creation it will
-     default to 0, though starting the array as 'clean' will
-     set it much larger.
+     this will be a very large number (or 'none' since 2.6.30-rc1).  At
+     array creation it will default to 0, though starting the array as
+     'clean' will set it much larger.
 
    new_dev
      This file can be written but not read.  The value written should
@@ -379,8 +379,9 @@ Each directory contains:
 	Writing "writemostly" sets the writemostly flag.
 	Writing "-writemostly" clears the writemostly flag.
 	Writing "blocked" sets the "blocked" flag.
-	Writing "-blocked" clear the "blocked" flag and allows writes
+	Writing "-blocked" clears the "blocked" flag and allows writes
 		to complete.
+	Writing "in_sync" sets the in_sync flag.
 
 	This file responds to select/poll. Any change to 'faulty'
 	or 'blocked' causes an event.
@@ -417,6 +418,24 @@ Each directory contains:
         array.  If a value less than the current component_size is
         written, it will be rejected.
 
+      recovery_start
+
+        When the device is not 'in_sync', this records the number of
+	sectors from the start of the device which are known to be
+	correct.  This is normally zero, but during a recovery
+	operation is will steadily increase, and if the recovery is
+	interrupted, restoring this value can cause recovery to
+	avoid repeating the earlier blocks.  With v1.x metadata, this
+	value is saved and restored automatically.
+
+	This can be set whenever the device is not an active member of
+	the array, either before the array is activated, or before
+	the 'slot' is set.
+
+	Setting this to 'none' is equivalent to setting 'in_sync'.
+	Setting to any other value also clears the 'in_sync' flag.
+	
+
 
 An active md device will also contain and entry for each active device
 in the array.  These are named
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ea64a68..6bf2f5c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2551,12 +2551,49 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 static struct rdev_sysfs_entry rdev_size =
 __ATTR(size, S_IRUGO|S_IWUSR, rdev_size_show, rdev_size_store);
 
+
+static ssize_t recovery_start_show(mdk_rdev_t *rdev, char *page)
+{
+	unsigned long long recovery_start = rdev->recovery_offset;
+
+	if (test_bit(In_sync, &rdev->flags) ||
+	    recovery_start == MaxSector)
+		return sprintf(page, "none\n");
+
+	return sprintf(page, "%llu\n", recovery_start);
+}
+
+static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *buf, size_t len)
+{
+	unsigned long long recovery_start;
+
+	if (cmd_match(buf, "none"))
+		recovery_start = MaxSector;
+	else if (strict_strtoull(buf, 10, &recovery_start))
+		return -EINVAL;
+
+	if (rdev->mddev->pers &&
+	    rdev->raid_disk >= 0)
+		return -EBUSY;
+
+	rdev->recovery_offset = recovery_start;
+	if (recovery_start == MaxSector)
+		set_bit(In_sync, &rdev->flags);
+	else
+		clear_bit(In_sync, &rdev->flags);
+	return len;
+}
+
+static struct rdev_sysfs_entry rdev_recovery_start =
+__ATTR(recovery_start, S_IRUGO|S_IWUSR, recovery_start_show, recovery_start_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_errors.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,
 	&rdev_size.attr,
+	&rdev_recovery_start.attr,
 	NULL,
 };
 static ssize_t
-- 
1.6.5.4

