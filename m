From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 "out of memory" error, was Re: 2.6.21-rc5-mm4
Date: Wed, 11 Apr 2007 13:31:07 +1000
Message-ID: <17948.22139.163549.68639@notabene.brown>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<461524BF.7050304@reub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Reuben Farrelly on Friday April 6
Sender: linux-raid-owner@vger.kernel.org
To: Reuben Farrelly <reuben-linuxkernel@reub.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday April 6, reuben-linuxkernel@reub.net wrote:
> 
> Looks like some damage, or maybe intolerance to on-disk damage, to RAID-1.

Difference is that kzalloc(0, ) now returns NULL.  Maybe it is a
SLUB/SLAB difference? (So maybe it did use memory it shouldn't have
before, but now it fails, which is the better behaviour).

This patch fixes the maths and should probably go in various 'stable'
kernels.  Bug is in 2.6.18, but not 2.6.16.

Patch won't work for 2.6.18 as DIV_ROUND_UP is missing, but 2.6.19 and
later have it.

Thanks for the bug report.

NeilBrown


-----------------------------
Fix calculation for size of filemap_attr array in md/bitmap.

If 'num_pages' were ever 1 more than a multiple of 8 (32bit platforms)
for of 16 (64 bit platforms). filemap_attr would be allocated one
'unsigned long' shorter than required.  We need a round-up in there.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-04-11 13:24:50.000000000 +1000
+++ ./drivers/md/bitmap.c	2007-04-11 13:24:59.000000000 +1000
@@ -863,9 +863,7 @@ static int bitmap_init_from_disk(struct 
 
 	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
 	bitmap->filemap_attr = kzalloc(
-		(((num_pages*4/8)+sizeof(unsigned long)-1)
-		 /sizeof(unsigned long))
-		*sizeof(unsigned long),
+		roundup( DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
 		GFP_KERNEL);
 	if (!bitmap->filemap_attr)
 		goto out;
