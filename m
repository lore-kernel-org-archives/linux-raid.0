From: Neil Brown <neilb@suse.de>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under
 Linux
Date: Thu, 4 Jun 2009 12:30:52 +1000
Message-ID: <18983.12764.413037.150661@notabene.brown>
References: <18980.48553.328662.80987@notabene.brown>
	<alpine.LNX.2.01.0906031749270.15124@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Wednesday June 3
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 3, babydr@baby-dragons.com wrote:
>  	Hello Neil ,  I am getting a interesting Error during compiling 3.0 .
>  	Is there a particular version of kernel that 3.0 is supposed to be 
> compiled with ?

This has nothing to do with kernel version.  You must be using a
different compiler version - it is picking up an error that might
didn't.

The fix is below.
Thanks,
NeilBrown


> 
>  		Tia ,  JimL
> 
> gcc -Wall -Werror -Wstrict-prototypes -ggdb -DSendmail=\""/usr/sbin/sendmail 
> -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"   -c 
> -o super-intel.o super-intel.c
> cc1: warnings being treated as errors
> super-intel.c: In function 'mark_failure':
> super-intel.c:3632: warning: comparison is always false due to limited range of 
> data type
> make: *** [super-intel.o] Error 1
> 

commit 4291d691b66f65695b5b4be22b80fd00da73b544
Author: NeilBrown <neilb@suse.de>
Date:   Thu Jun 4 12:29:21 2009 +1000

    super-intel: fix test on failed_disk_num.
    
    We sometimes set failed_disk_num to ~0.
    However we cannot test for equality with that as  failed_disk_num
    is 8bit and ~0 is probably 32bit with lots of 1's.
    So test if ~failed_disk_num is 0 instead.
    
    Reported-By: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-intel.c b/super-intel.c
index 73fe5fa..7e2a086 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3629,7 +3629,7 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 
 	disk->status |= FAILED_DISK;
 	set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD);
-	if (map->failed_disk_num == ~0)
+	if (~map->failed_disk_num == 0)
 		map->failed_disk_num = slot;
 	return 1;
 }
