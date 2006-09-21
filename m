From: Paul Clements <paul.clements@steeleye.com>
Subject: [BUG/PATCH] md bitmap broken on big endian machines
Date: Thu, 21 Sep 2006 16:26:05 -0400
Message-ID: <4512F55D.5030907@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070803030502040609040800"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070803030502040609040800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

We just discovered this problem on a 64-bit IBM POWER (ppc64) system. 
The symptom was this BUG():

Sep 20 20:55:51 caspian kernel: kernel BUG in sync_request at 
drivers/md/raid1.c
:1743!
Sep 20 20:55:51 caspian kernel: Oops: Exception in kernel mode, sig: 5 [#1]
Sep 20 20:55:51 caspian kernel: SMP NR_CPUS=128 NUMA PSERIES LPAR
Sep 20 20:55:51 caspian kernel: Modules linked in: nbd raid1 ipv6 nfs 
lockd nfs_
acl sunrpc apparmor aamatch_pcre loop dm_mod e1000 ide_cd cdrom lpfc 
scsi_transp
ort_fc pdc202xx_new sg st ipr firmware_class sd_mod scsi_mod


I traced the problem back to a bad value in bitmap->chunkshift (the 
value was 8, instead of 16, with a chunksize of 64K). I think this means 
that bitmaps are broken on all big endian systems. It looks like we 
should be using ffs instead of find_first_bit. Patch has been compile 
tested only.

Thanks,
Paul

--------------070803030502040609040800
Content-Type: text/plain;
 name="md_bitmap_find_first_bug.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_bitmap_find_first_bug.diff"

--- ./drivers/md/bitmap.c.orig	2006-09-21 16:10:17.000000000 -0400
+++ ./drivers/md/bitmap.c	2006-09-21 16:12:16.000000000 -0400
@@ -1578,8 +1578,7 @@ int bitmap_create(mddev_t *mddev)
 	if (err)
 		goto error;
 
-	bitmap->chunkshift = find_first_bit(&bitmap->chunksize,
-					sizeof(bitmap->chunksize));
+	bitmap->chunkshift = ffs(bitmap->chunksize) - 1;
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
  	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) /

--------------070803030502040609040800--
