From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 02/36] md/bad-block-log: add sysfs interface for accessing bad-block-log.
Date: Tue, 26 Jul 2011 17:48:27 +0900
Message-ID: <87livlxw9w.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025847.8422.8246.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025847.8422.8246.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:47 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> This can show the log (providing it fits in one page) and
> allows bad blocks to be 'acknowledged' meaning that they
> have safely been recorded in metadata.
>
> Clearing bad blocks is not allowed via sysfs (except for
> code testing).  A bad block can only be cleared when
> a write to the block succeeds.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>
>  drivers/md/md.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 127 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 220fadb..9324635 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2712,6 +2712,35 @@ static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *buf, size_t le
>  static struct rdev_sysfs_entry rdev_recovery_start =
>  __ATTR(recovery_start, S_IRUGO|S_IWUSR, recovery_start_show, recovery_start_store);
>  
> +
> +static ssize_t
> +badblocks_show(struct badblocks *bb, char *page, int unack);
> +static ssize_t
> +badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack);
> +
> +static ssize_t bb_show(mdk_rdev_t *rdev, char *page)
> +{
> +	return badblocks_show(&rdev->badblocks, page, 0);
> +}
> +static ssize_t bb_store(mdk_rdev_t *rdev, const char *page, size_t len)
> +{
> +	return badblocks_store(&rdev->badblocks, page, len, 0);
> +}
> +static struct rdev_sysfs_entry rdev_bad_blocks =
> +__ATTR(bad_blocks, S_IRUGO|S_IWUSR, bb_show, bb_store);
> +
> +
> +static ssize_t ubb_show(mdk_rdev_t *rdev, char *page)
> +{
> +	return badblocks_show(&rdev->badblocks, page, 1);
> +}
> +static ssize_t ubb_store(mdk_rdev_t *rdev, const char *page, size_t len)
> +{
> +	return badblocks_store(&rdev->badblocks, page, len, 1);
> +}
> +static struct rdev_sysfs_entry rdev_unack_bad_blocks =
> +__ATTR(unacknowledged_bad_blocks, S_IRUGO|S_IWUSR, ubb_show, ubb_store);
> +
>  static struct attribute *rdev_default_attrs[] = {
>  	&rdev_state.attr,
>  	&rdev_errors.attr,
> @@ -2719,6 +2748,8 @@ static struct attribute *rdev_default_attrs[] = {
>  	&rdev_offset.attr,
>  	&rdev_size.attr,
>  	&rdev_recovery_start.attr,
> +	&rdev_bad_blocks.attr,
> +	&rdev_unack_bad_blocks.attr,
>  	NULL,
>  };
>  static ssize_t
> @@ -7775,6 +7806,102 @@ void md_ack_all_badblocks(struct badblocks *bb)
>  }
>  EXPORT_SYMBOL_GPL(md_ack_all_badblocks);
>  
> +/* sysfs access to bad-blocks list.
> + * We present two files.
> + * 'bad-blocks' lists sector numbers and lengths of ranges that
> + *    are recorded as bad.  The list is truncated to fit within
> + *    the one-page limit of sysfs.
> + *    Writing "sector length" to this file adds an acknowledged
> + *    bad block list.
> + * 'unacknowledged-bad-blocks' lists bad blocks that have not yet
> + *    been acknowledged.  Writing to this file adds bad blocks
> + *    without acknowledging them.  This is largely for testing.
> + *
> + */

Empty line in comment.

And you might need this as well:
(or maybe it should be located somewhere in Documentation/ABI/)

From 95c3f191bd0cbe6d339fced75656502b2d591fe4 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 26 Jul 2011 17:39:52 +0900
Subject: [PATCH] md: add documentation for bad block log

Previous patch in the bad block series added new sysfs interfaces
([unacknowledged_]bad_blocks) for each rdev without documentation.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 Documentation/md.txt |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index f0eee83ff78a..be88a24b8584 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -562,6 +562,20 @@ also have
      that number to reach sync_max.  Then you can either increase
      "sync_max", or can write 'idle' to "sync_action".
 
+   bad_blocks
+     This gives the list of all known bad blocks in the form of
+     start address and length (in sectors respectively). If output
+     is too big to fit in a page, it will be truncated. Writing
+     "sector length" to this file will add new acknowledged (i.e.
+     saved to disk safely) bad blocks.
+
+   unacknowledged_bad_blocks
+     This gives the list of known-but-not-yet-saved-to-disk bad
+     blocks in the same form of 'bad_blocks'. If output is too big
+     to fit in a page, it will be truncated. Writing to this file
+     adds bad blocks without acknowledging them. This is largely
+     for testing.
+
 
 Each active md device may also have attributes specific to the
 personality module that manages it.
-- 
1.7.6

