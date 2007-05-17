From: Neil Brown <neilb@suse.de>
Subject: RE: Software raid0 will crash the file-system, when each disk is
 5TB
Date: Thu, 17 May 2007 15:03:31 +1000
Message-ID: <17995.57891.56738.592100@notabene.brown>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
	<17995.42562.870806.396617@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
	<17995.49602.427417.500049@notabene.brown>
	<Pine.LNX.4.64.0705162145060.31624@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from david@lang.hm on Wednesday May 16
Sender: linux-fsdevel-owner@vger.kernel.org
To: david@lang.hm
Cc: Jeff Zheng <Jeff.Zheng@endace.com>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 16, david@lang.hm wrote:
> On Thu, 17 May 2007, Neil Brown wrote:
> 
> > On Thursday May 17, Jeff.Zheng@endace.com wrote:
> >>
> >>> The only difference of any significance between the working
> >>> and non-working configurations is that in the non-working,
> >>> the component devices are larger than 2Gig, and hence have
> >>> sector offsets greater than 32 bits.
> >>
> >> Do u mean 2T here?, but in both configuartion, the component devices are
> >> larger than 2T (2.25T&5.5T).
> >
> > Yes, I meant 2T, and yes, the components are always over 2T.
> 
> 2T decimal or 2T binary?
> 

Either.  The smallest as actually 2.75T (typo above).
Precisely it was
  2929641472  kilobytes
or 
  5859282944 sectors
or 
  0x15D3D9000 sectors.

So it is over 32bits already...

Uhm, I just noticed something.
'chunk' is unsigned long, and when it gets shifted up, we might lose
bits.  That could still happen with the 4*2.75T arrangement, but is
much more likely in the 2*5.5T arrangement.

Jeff, can you try this patch?

Thanks.
NeilBrown


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-05-17 10:33:30.000000000 +1000
+++ ./drivers/md/raid0.c	2007-05-17 15:02:15.000000000 +1000
@@ -475,7 +475,7 @@ static int raid0_make_request (request_q
 		x = block >> chunksize_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
 	}
-	rsect = (((chunk << chunksize_bits) + zone->dev_offset)<<1)
+	rsect = ((((sector_t)chunk << chunksize_bits) + zone->dev_offset)<<1)
 		+ sect_in_chunk;
  
 	bio->bi_bdev = tmp_dev->bdev;
