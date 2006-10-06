From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH/BUG] mdadm: write behind value does not have endian conversion
Date: Fri, 06 Oct 2006 13:53:57 -0400
Message-ID: <45269835.2020801@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090304040107000505040204"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090304040107000505040204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

The write behind value does not get converted to/from little endian 
which causes write behind not to work on big endian machines (RUN ARRAY 
fails with invalid argument error):

# mdadm -B /dev/md0 -l1 -n2 --write-behind=256 /dev/sdb10 --write-mostly 
/dev/nbd0 --bitmap=/bitmaps/test5
mdadm: RUN_ARRAY failed: Invalid argument

# tail /var/log/messages
Oct  6 13:14:48 caspian kernel:   daemon sleep: 5s
Oct  6 13:14:48 caspian kernel:      sync size: 1001456 KB
Oct  6 13:14:48 caspian kernel: max write behind: 65536
Oct  6 13:14:48 caspian kernel: md0: failed to create bitmap (-22)


Attached patch for mdadm fixes this.

Thanks,
Paul

--------------090304040107000505040204
Content-Type: text/plain;
 name="mdadm-2.5.1-write-behind-endian-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-2.5.1-write-behind-endian-fix.diff"

--- mdadm-2.5.1/bitmap.c.orig	Fri Oct  6 13:40:35 2006
+++ mdadm-2.5.1/bitmap.c	Fri Oct  6 13:40:53 2006
@@ -33,6 +33,7 @@ inline void sb_le_to_cpu(bitmap_super_t 
 	sb->chunksize = __le32_to_cpu(sb->chunksize);
 	sb->daemon_sleep = __le32_to_cpu(sb->daemon_sleep);
 	sb->sync_size = __le64_to_cpu(sb->sync_size);
+	sb->write_behind = __le32_to_cpu(sb->sync_size);
 }
 
 inline void sb_cpu_to_le(bitmap_super_t *sb)

--------------090304040107000505040204--
