From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Bug in RAID1 in 2.4
Date: Sun, 21 Dec 2003 20:44:51 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16357.27539.548714.836688@notabene.cse.unsw.edu.au>
References: <20031220082547.GB18118@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Pete Zaitcev on Saturday December 20
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-raid@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
List-Id: linux-raid.ids

On Saturday December 20, zaitcev@redhat.com wrote:
> In drivers/md/raid1.c, raid1_sync_request contains the following:
>   
>         block_nr = sector_nr;
>         bsize = 512;
>         while (!(block_nr & 1) && bsize < PAGE_SIZE
>                         && (block_nr+2)*(bsize>>9) < (mddev->sb->size *2)) {
>                 block_nr >>= 1;
>                 bsize <<= 1;
>         }
> 
> Suppose that a mirror is 4K in size. The code above produces
> reads (and writes) of the following offsets and sizes:
>  0K[2K], 2K[1K], 3K[0.5K], 3.5K[0.5K]
> 
> The above is correct, but it makes the RAID1 completely unuseable
> on s390, because I/O with sizes less than 4K is not supported.
> I would like the attached patch applied to correct the issue.

Yes, I agree.  Marcelo, could you please apply this patch.
The '<' test is just to make sure a request of 2*bsize at block_nr
will still fit within the size of the device, so a <= is appropriate.

NeilBrown

--- linux-2.4.23/drivers/md/raid1.c	2003-06-13 07:51:34.000000000 -0700
+++ linux-2.4.23-nip/drivers/md/raid1.c	2003-12-19 23:57:57.000000000 -0800
@@ -1436,7 +1436,7 @@
 	block_nr = sector_nr;
 	bsize = 512;
 	while (!(block_nr & 1) && bsize < PAGE_SIZE
-			&& (block_nr+2)*(bsize>>9) < (mddev->sb->size *2)) {
+			&& (block_nr+2)*(bsize>>9) <= (mddev->sb->size *2)) {
 		block_nr >>= 1;
 		bsize <<= 1;
 	}
