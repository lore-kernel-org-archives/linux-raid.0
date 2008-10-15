From: Neil Brown <neilb@suse.de>
Subject: Re: Potential mdadm 2.6.7 bug: Cannot grow linear arrays with superblock v1.0,
 1.1, or 1.2
Date: Wed, 15 Oct 2008 14:32:06 +1100
Message-ID: <18677.25654.376918.24997@notabene.brown>
References: <8CAFC3107449F0E-C80-C20@mblk-d47.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from thomas62186218@aol.com on Tuesday October 14
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 14, thomas62186218@aol.com wrote:
> Hi all,
> 
> I have come across what is a potential bug in mdadm 2.6.7. (unless I am 
> missing something)
> 
> Environment:
> Ubuntu Linux 8.0.4 64-bit (Hardy)
> Intel dual socket quad-core server with 16GB RAM
> 10 SATA II 500GB hard drives
> mdadm v2.6.7
> 
> Test 1: Attempt to grow linear md device with v1.0 superblock with 
> additional hard drive. Failed.
> 
> root@localhost:/usr/local/apache2/htdocs# mdadm --grow /dev/md6 --add 
> /dev/sdd1
> mdadm: internal error - sb_offset is wrong
> Aborted

Hm, that's bad.
I've tested growing linear devices with 1.0 superblocks and it works.
But I only tested the case where the new device is exactly the same
size as the other devices in the array.  I'm guess this isn't the case
for you.

Are you able to test with the patch below applied?

Thanks.
> 
> Also, any plans on enabling "reshaping" or growth for RAID 0 and RAID 
> 10 md's?

Lots of plans.  Not so much time.

NeilBrown


diff --git a/super1.c b/super1.c
index bec0c5e..62a3ab9 100644
--- a/super1.c
+++ b/super1.c
@@ -599,7 +599,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 	}
 	if (strcmp(update, "linear-grow-new") == 0) {
 		int i;
-		int rfd;
+		int rfd, fd;
 		int max = __le32_to_cpu(sb->max_dev);
 
 		for (i=0 ; i < max ; i++)
@@ -620,6 +620,25 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 
 		sb->dev_roles[i] =
 			__cpu_to_le16(info->disk.raid_disk);
+
+		fd = open(devname, O_RDONLY);
+		if (fd >= 0) {
+			unsigned long long ds;
+			get_dev_size(fd, devname, &ds);
+			close(fd);
+			ds >>= 9;
+			if (__le64_to_cpu(sb->super_offset) <
+			    __le64_to_cpu(sb->data_offset)) {
+				sb->data_size = __cpu_to_le64(
+					ds - __le64_to_cpu(sb->data_offset));
+			} else {
+				ds -= 8*2;
+				ds &= ~(unsigned long long)(4*2-1);
+				sb->super_offset = __cpu_to_le64(ds);
+				sb->data_size = __cpu_to_le64(
+					ds - __le64_to_cpu(sb->data_offset));
+			}
+		}
 	}
 	if (strcmp(update, "linear-grow-update") == 0) {
 		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
