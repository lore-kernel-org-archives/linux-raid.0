From: Neil Brown <neilb@suse.de>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Thu, 17 May 2007 10:48:02 +1000
Message-ID: <17995.42562.870806.396617@notabene.brown>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Jeff Zheng on Wednesday May 16
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Zheng <Jeff.Zheng@endace.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 16, Jeff.Zheng@endace.com wrote:
> Here is the information of the created raid0. Hope it is enough.

Thanks.
Everything looks fine here.

The only difference of any significance between the working and
non-working configurations is that in the non-working, the component
devices are larger than 2Gig, and hence have sector offsets greater
than 32 bits.

This does cause a slightly different code path in one place, but I
cannot see it making a difference.  But maybe it does.

What architecture is this running on?
What C compiler are you using?

Can you try with this patch?  It is the only thing that I can find
that could conceivably go wrong.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid0.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-05-17 10:33:30.000000000 +1000
+++ ./drivers/md/raid0.c	2007-05-17 10:34:02.000000000 +1000
@@ -461,6 +461,7 @@ static int raid0_make_request (request_q
  
 	while (block >= (zone->zone_offset + zone->size)) 
 		zone++;
+	BUG_ON(block < zone->zone_offset);
     
 	sect_in_chunk = bio->bi_sector & ((chunk_size<<1) -1);
 
