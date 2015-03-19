From: Guoqing Jiang <GQJiang@suse.com>
Subject: Re: [PATCH 1/1] Make bm_blocks to match previous semantic
Date: Thu, 19 Mar 2015 11:50:05 +0800
Message-ID: <550A476D.4060707@suse.com>
References: <1426560030-16152-1-git-send-email-jgq516@gmail.com> <20150318095712.1954b958@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150318095712.1954b958@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: jgq516@gmail.com, rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

NeilBrown wrote:
> On Tue, 17 Mar 2015 10:40:30 +0800 jgq516@gmail.com wrote:
>
>   
>> From: Guoqing Jiang <gqjiang@suse.com>
>>
>> The bm_blocks is modified by commit fe60ce (md/bitmap: use
>> sector_div for sector_t divisions), but it makes bm_blocks
>> has different value which is changed from like "a/b" to "a%b",
>> need to correct this to make sure cluster-md still works.
>>     
>
> One of us is confused here.
>
> This code is trying to find the start of the bitmap relevant to this host in
> a table of multiple bitmaps.  So it first needs to find out the size of each
> bitmap.  It then multiples the size by the index number of this host to get
> an offset.
>
>   
Thanks for detailed description, it really helps. I quoted related lines
from bitmap.c.

 574                 sector_t bm_blocks;
 575                 sector_t resync_sectors =
bitmap->mddev->resync_max_sectors; 
 576
 577                 bm_blocks = sector_div(resync_sectors,
 578                                       
bitmap->mddev->bitmap_info.chunksize >> 9);   
 579                 bm_blocks = bm_blocks << 3;
 580                 bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
 581                 bitmap->mddev->bitmap_info.offset +=
bitmap->cluster_slot * (bm_blocks << 3);

> So it take the total number of sectors (resync_max_sectors), divides by the
> chunksize (in sectors) to get a number of chunks.  This is the number of bits.
>
>   
L577 is supposed to do above job.
> Then it should div-round-up by 8 to get a number of bytes.
>   
I guess what you mean is about L579, while it used "<<3" rather than
">>3" now.
> Then div-round-up by 4096 to get number of 4-K blocks, because the bitmaps
> are always 4K aligned.
>   
L580 did the job.
> Then this number is multiplied by 8 (or shifted by 3) to get a number of
> sectors to add to the start of the table.
>   
L581 is for this, right? Is the shifted by 3 is to match the bitmap
format for each
nodes? Seems the relationship between slot and the bitmap region of the node
is like n <-----> [8*nK, 8*(n+1)K]. How about the following changes?

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 501f83f..b2a241b 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -571,12 +571,10 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 re_read:
        /* If cluster_slot is set, the cluster is setup */
        if (bitmap->cluster_slot >= 0) {
-               sector_t bm_blocks;
-               sector_t resync_sectors = bitmap->mddev->resync_max_sectors;
+               sector_t bm_blocks = bitmap->mddev->resync_max_sectors;
 
-               bm_blocks = sector_div(resync_sectors,
-                                     
bitmap->mddev->bitmap_info.chunksize >> 9);
-               bm_blocks = bm_blocks << 3;
+               sector_div(bm_blocks,
bitmap->mddev->bitmap_info.chunksize >> 9);
+               bm_blocks = bm_blocks >> 3;
                bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
> So the original code in commit b97e92574c0bf335db1cd2ec491d8ff5cd5d0b49
> is wrong because it uses sector_div in a way which destroys
> resync_max_sectors.
> And is wrong because it multiplies by 8 (<<3) instead of divides by 8 to
> convert from bits to bytes.
>
> commit f9209a323547f054c7439a3bf67c45e64a054bd
> removes the abuse of sector_div, which is good, but uses a simple "a/b"
> division, which isn't allowed in the kernel.
>
> commit fe60ce80488a2a481ac175c4ff98f90df22e1e46
> then does the right thing with sector_div, but the "<< 3" is still the wrong
> way around.
>
> If you still think your code is correct, please explain in detail why.
>
> Goldwyn: if you agree that "<< 3" should be ">> 3" or even
> DIV_ROUND_UP_SECTOR_T( , 8);
> please send a patch.  If you don't think so, please explain why.
>
>   
But anyway, it is better wait for Goldwyn's back from vacation, :)

Thanks,
Guoqing

