From: Mike Tran <mhtran@us.ibm.com>
Subject: [PATCH] Consider user space generated checksum
Date: 13 Jul 2004 10:54:16 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089734056.3065.97.camel@star2.austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-pf4ismvtUq3wQkpSUwBY"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-pf4ismvtUq3wQkpSUwBY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On alpha systems, the kernel computed checksum, csum_partial(), and user
space computed checksum are different.  As a consequence, the kernel MD
driver aborts detection of MD superblock.  This means running mdadm
--assemble -f or -U summaries will not always work.

I have been wondering... Should MD driver use csum_partial() at all?

The attached patch includes the checksum function found in mdadm code. 
If the architecture dependent checksum validation fails, at least try
the common function (only for 0.90 superblock format).

Regards,
Mike T.


--=-pf4ismvtUq3wQkpSUwBY
Content-Disposition: attachment; filename=md.c.patch
Content-Type: text/plain; name=md.c.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- a/drivers/md/md.c	2004-06-16 00:19:03.000000000 -0500
+++ b/drivers/md/md.c	2004-07-12 18:18:31.000000000 -0500
@@ -439,6 +439,22 @@
 	return csum;
 }
 
+static unsigned int calc_sb_csum_common(mdp_super_t *super)
+{
+	unsigned int  disk_csum = super->sb_csum;
+	unsigned long long newcsum = 0;
+	unsigned int csum;
+	int i;
+	unsigned int *superc = (int*) super;
+	super->sb_csum = 0;
+                                                                              
+	for (i=0; i<MD_SB_BYTES/4; i++)
+		newcsum+= superc[i];
+	csum = (newcsum& 0xffffffff) + (newcsum>>32);
+	super->sb_csum = disk_csum;
+	return csum;
+}
+
 /*
  * Handle superblock details.
  * We want to be able to handle multiple superblock formats
@@ -522,10 +538,15 @@
 		goto abort;
 
 	if (calc_sb_csum(sb) != sb->sb_csum) {
+		printk(KERN_WARNING "md: First attemp to validate checksum on %s failed."
+			"  Trying the common method...\n",
+			b);
+		if (calc_sb_csum_common(sb) != sb->sb_csum) {
 		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
 			b);
 		goto abort;
 	}
+	}
 
 	rdev->preferred_minor = sb->md_minor;
 	rdev->data_offset = 0;

--=-pf4ismvtUq3wQkpSUwBY--

