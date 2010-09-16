From: Neil Brown <neilb@suse.de>
Subject: Re: Endian issue assembling arrays
Date: Thu, 16 Sep 2010 21:03:08 +1000
Message-ID: <20100916210308.7314c6fb@notabene>
References: <4C5098DB.7040905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C5098DB.7040905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Nazar <nazard.michi@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Jul 2010 16:53:47 -0400
Doug Nazar <nazard.michi@gmail.com> wrote:

>   Came across this while testing some updates to GRUB's RAID support.
> 
> Assembling a RAID1 array on a PPC box results in the following warning:
> 
> mdadm: device 1 in /dev/md/0 has wrong state in superblock, but 
> /dev/sdb2 seems ok
> mdadm: /dev/md/0 has been started with 2
> 
> 
> Doug
> 

Thanks for the report and the more recent reminder.

Your patch :

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


isn't quite right.  The assignment needs a conversion too.

I have committed the following to
  http://neil.brown.name/git/mdadm/

Thanks a lot,
NeilBrown

commit a2ce5a1af19e5dcfd59cad117c0e9fccabce7322
Author: NeilBrown <neilb@suse.de>
Date:   Thu Sep 16 20:58:31 2010 +1000

    Fix byte-order conversion in update_super1("assemble")
    
    This code is wrong is several ways, and failed on big-endian machines.
    Put in correct endian coversions: 'want' is cpu-order, dev_roles[] is little-endian,
    16 bit.
    
    Reported-by: Doug Nazar <nazard.michi@gmail.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super1.c b/super1.c
index 01473d1..0eb0323 100644
--- a/super1.c
+++ b/super1.c
@@ -673,11 +673,11 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		int d = info->disk.number;
 		int want;
 		if (info->disk.state == 6)
-			want = __cpu_to_le32(info->disk.raid_disk);
+			want = info->disk.raid_disk;
 		else
 			want = 0xFFFF;
-		if (sb->dev_roles[d] != want) {
-			sb->dev_roles[d] = want;
+		if (sb->dev_roles[d] != __cpu_to_le16(want)) {
+			sb->dev_roles[d] = __cpu_to_le16(want);
 			rv = 1;
 		}
 	}
