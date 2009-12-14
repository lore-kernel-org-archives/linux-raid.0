From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH 1/1] md: expose behind writes counter
Date: Mon, 14 Dec 2009 11:56:32 -0500
Message-ID: <4B266E40.4080202@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000104070800040102070102"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000104070800040102070102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a very simple patch that exposes the behind_writes counter of an 
md array via a sysfs entry. This is helpful when tuning the value of 
behind_writes. Knowing, for instance, the maximum value over time allows 
one to set a proper upper value for an array.

Tested against 2.6.32-rc5 (and 2.6.18).

Thanks,
Paul

--------------000104070800040102070102
Content-Type: text/x-diff;
 name="md_expose_behind_writes.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_expose_behind_writes.diff"

This is a very simple patch that exposes the behind_writes counter of an md
array via a sysfs entry. This is helpful when tuning the value of behind_writes.
Knowing, for instance, the maximum value over time allows one to set a
proper upper value for the array.

Tested against 2.6.32-rc5 (and 2.6.18).

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---

 md.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -pur linux-2.6.32-rc5-PRISTINE/drivers/md/md.c linux-2.6.32-rc5/drivers/md/md.c
--- linux-2.6.32-rc5-PRISTINE/drivers/md/md.c	2009-10-15 20:41:50.000000000 -0400
+++ linux-2.6.32-rc5/drivers/md/md.c	2009-10-30 11:00:24.000000000 -0400
@@ -3237,6 +3237,20 @@ static struct md_sysfs_entry md_bitmap =
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
 size_show(mddev_t *mddev, char *page)
 {
 	return sprintf(page, "%llu\n",
@@ -3785,6 +3799,7 @@ static struct attribute *md_redundancy_a
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
 	&md_bitmap.attr,
+	&md_behind_writes.attr,
 	&md_degraded.attr,
 	NULL,
 };

--------------000104070800040102070102--
