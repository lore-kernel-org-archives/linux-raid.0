From: Doug Nazar <nazard.michi@gmail.com>
Subject: Fwd: Endian issue assembling arrays
Date: Wed, 15 Sep 2010 18:20:18 -0400
Message-ID: <4C9146A2.2020305@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060108010201090709040807"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060108010201090709040807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Has anyone had a chance to look at this?

Thanks,
Doug

-------- Original Message --------
Subject: 	Endian issue assembling arrays
Date: 	Wed, 28 Jul 2010 16:53:47 -0400
From: 	Doug Nazar <nazard.michi@gmail.com>
To: 	linux-raid@vger.kernel.org


   Came across this while testing some updates to GRUB's RAID support.

Assembling a RAID1 array on a PPC box results in the following warning:

mdadm: device 1 in /dev/md/0 has wrong state in superblock, but
/dev/sdb2 seems ok
mdadm: /dev/md/0 has been started with 2


Doug




--------------060108010201090709040807
Content-Type: text/plain;
 name="mdadm-assemble-roles-endian-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadm-assemble-roles-endian-fix.diff"

--- mdadm-3.1.2/super1.c	2010-03-09 18:26:44.000000000 -0500
+++ mdadm-3.1.2.dev/super1.c	2010-07-28 16:41:41.000000000 -0400
@@ -673,10 +673,10 @@
 		int d = info->disk.number;
 		int want;
 		if (info->disk.state == 6)
-			want = __cpu_to_le32(info->disk.raid_disk);
+			want = info->disk.raid_disk;
 		else
 			want = 0xFFFF;
-		if (sb->dev_roles[d] != want) {
+		if (__le16_to_cpu(sb->dev_roles[d]) != want) {
 			sb->dev_roles[d] = want;
 			rv = 1;
 		}


--------------060108010201090709040807--
