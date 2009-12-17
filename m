From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/1] md: expose behind writes counter
Date: Thu, 17 Dec 2009 17:08:20 -0500
Message-ID: <4B2AABD4.9040908@steeleye.com>
References: <4B266E40.4080202@steeleye.com> <20091215083209.1ea23291@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060901090206010507050205"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091215083209.1ea23291@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060901090206010507050205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

Thanks for the feedback...

Neil Brown wrote:
> On Mon, 14 Dec 2009 11:56:32 -0500
> Paul Clements <paul.clements@steeleye.com> wrote:
> 
>> This is a very simple patch that exposes the behind_writes counter of an 
>> md array via a sysfs entry. This is helpful when tuning the value of 
>> behind_writes. Knowing, for instance, the maximum value over time allows 
>> one to set a proper upper value for an array.
>>
> 
> Hi Paul,
>  while I can see that this information could be useful, I wonder if this is
>  the best way of accessing it.
>  I imagine that the count of behind_writes would change quite quickly, so you
>  would need to sample it at quite a high rate to get a meaningful number.
> 
>  I'm very conscious that the 'active_stripes' number provided by RAID5 is
>  close to useful as it almost always reads a 'zero' even when the array is
>  quite busy.
> 
>  Maybe having a sysfs attribute that reports the maximum value, and allow
>  that maximum to be reset by writing to the attribute?

OK, I did this. I called it behind_writes_top. I also left the 
behind_writes entry, since it might be useful too.

See attached.

Thanks,
Paul

--------------060901090206010507050205
Content-Type: text/x-diff;
 name="md_expose_behind_writes_2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_expose_behind_writes_2.diff"

This is a simple patch that exposes the behind_writes counter of an md
array via a sysfs entry. It also exposes a behind_writes_top (I used this name
because there is already a max_write_behind, which is the configured maximum
value for behind_writes) counter that tracks the highest value of
behind_writes (so that behind_writes doesn't have to be constantly
polled to find the highest value).

The behind_writes_top value is reset whenever you write into the sysfs entry.

Tested against 2.6.32-rc5.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---

 bitmap.c |    5 +++++
 bitmap.h |    3 ++-
 md.c     |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff -pur linux-2.6.32-rc5-PRISTINE/drivers/md/bitmap.c linux-2.6.32-rc5/drivers/md/bitmap.c
--- linux-2.6.32-rc5-PRISTINE/drivers/md/bitmap.c	2009-10-15 20:41:50.000000000 -0400
+++ linux-2.6.32-rc5/drivers/md/bitmap.c	2009-12-16 08:03:39.000000000 -0500
@@ -1250,6 +1250,11 @@ int bitmap_startwrite(struct bitmap *bit
 
 	if (behind) {
 		atomic_inc(&bitmap->behind_writes);
+		if (atomic_read(&bitmap->behind_writes) >
+		    bitmap->behind_writes_top) {
+			bitmap->behind_writes_top =
+			    atomic_read(&bitmap->behind_writes);
+		}
 		PRINTK(KERN_DEBUG "inc write-behind count %d/%d\n",
 		  atomic_read(&bitmap->behind_writes), bitmap->max_write_behind);
 	}
diff -pur linux-2.6.32-rc5-PRISTINE/drivers/md/bitmap.h linux-2.6.32-rc5/drivers/md/bitmap.h
--- linux-2.6.32-rc5-PRISTINE/drivers/md/bitmap.h	2009-10-15 20:41:50.000000000 -0400
+++ linux-2.6.32-rc5/drivers/md/bitmap.h	2009-12-16 08:09:00.000000000 -0500
@@ -238,7 +238,8 @@ struct bitmap {
 
 	int allclean;
 
-	unsigned long max_write_behind; /* write-behind mode */
+	unsigned long max_write_behind; /* max allowed value, set by admin */
+	unsigned long behind_writes_top; /* highest actual value at runtime */
 	atomic_t behind_writes;
 
 	/*
diff -pur linux-2.6.32-rc5-PRISTINE/drivers/md/md.c linux-2.6.32-rc5/drivers/md/md.c
--- linux-2.6.32-rc5-PRISTINE/drivers/md/md.c	2009-10-15 20:41:50.000000000 -0400
+++ linux-2.6.32-rc5/drivers/md/md.c	2009-12-17 11:52:56.000000000 -0500
@@ -3237,6 +3237,41 @@ static struct md_sysfs_entry md_bitmap =
 __ATTR(bitmap_set_bits, S_IWUSR, null_show, bitmap_store);
 
 static ssize_t
+behind_writes_show(mddev_t *mddev, char *page)
+{
+	if (mddev->bitmap) {
+		return sprintf(page, "%lu\n",
+			atomic_read(&mddev->bitmap->behind_writes));
+	} else {
+		return sprintf(page, "0\n");
+	}
+}
+
+static struct md_sysfs_entry md_behind_writes =
+__ATTR(behind_writes, S_IRUGO, behind_writes_show, NULL);
+
+static ssize_t
+behind_writes_top_show(mddev_t *mddev, char *page)
+{
+	if (mddev->bitmap) {
+		return sprintf(page, "%lu\n",
+			mddev->bitmap->behind_writes_top);
+	} else {
+		return sprintf(page, "0\n");
+	}
+}
+
+static ssize_t
+behind_writes_top_reset(mddev_t *mddev, const char *buf, size_t len)
+{
+	if (mddev->bitmap) mddev->bitmap->behind_writes_top = 0;
+	return len;
+}
+
+static struct md_sysfs_entry md_behind_writes_top =
+__ATTR(behind_writes_top, S_IRUGO | S_IWUSR, behind_writes_top_show, behind_writes_top_reset);
+
+static ssize_t
 size_show(mddev_t *mddev, char *page)
 {
 	return sprintf(page, "%llu\n",
@@ -3785,6 +3820,8 @@ static struct attribute *md_redundancy_a
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
 	&md_bitmap.attr,
+	&md_behind_writes.attr,
+	&md_behind_writes_top.attr,
 	&md_degraded.attr,
 	NULL,
 };

--------------060901090206010507050205--
