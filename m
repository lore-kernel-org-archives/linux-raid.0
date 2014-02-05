From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] raid6check.c: reduce verbosity
Date: Wed, 5 Feb 2014 20:18:45 +0100
Message-ID: <20140205191845.GA11653@lazy.lzy>
References: <20140201160334.GA9378@lazy.lzy>
 <20140204161025.579257b1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140204161025.579257b1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 04, 2014 at 04:10:25PM +1100, NeilBrown wrote:
> On Sat, 1 Feb 2014 17:03:34 +0100 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
> > This patch removes some printouts, which
> > are not really useful here.
> > These could be re-added later, in case a
> > verbosity parameter will be provided.
> > 
> > Signed off: piergiorgio.sartor@nexgo.de
> > 
> > diff -uNrp a/raid6check.c b/raid6check.c
> > --- a/raid6check.c	2014-01-23 19:36:23.151837870 +0100
> > +++ b/raid6check.c	2014-02-01 16:56:14.123771170 +0100
> > @@ -188,8 +188,6 @@ int check_stripes(struct mdinfo *info, i
> >  	while (length > 0) {
> >  		int disk[chunk_size >> CHECK_PAGE_BITS];
> >  
> > -		printf("pos --> %llu\n", start);
> > -
> >  		err = lock_stripe(info, start, chunk_size, data_disks, sig);
> >  		if(err != 0) {
> >  			if (err != 2)
> > @@ -221,7 +219,6 @@ int check_stripes(struct mdinfo *info, i
> >  			int disk = geo_map(i, start, raid_disks, level, layout);
> >  			blocks[i] = stripes[disk];
> >  			block_index_for_slot[disk] = i;
> > -			printf("%d->%d\n", i, disk);
> >  		}
> >  
> >  		qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);
> > 
> > 
> 
> This and other 3 all applied - thanks.
> 
> NeilBrown

Hi Neil,

thanks for the update.

It seems the patch removing the commented code
(the one you complained about), was not added.

Below the patch again.

Thanks,

bye,

--- --- --- --- ---

This patch will remove some legacy code.
It is part of the verbosity "cleanup".
In any case, if information about the P
and Q parity mismatches is required, it
should go inside the code handling page
size blocks, not full stripe size.

Signed off: piergiorgio.sartor@nexgo.de
diff -uNrp a/raid6check.c b/raid6check.c
--- a/raid6check.c      2014-01-20 19:48:10.435721613 +0100
+++ b/raid6check.c      2014-01-23 19:36:23.151837870 +0100
@@ -231,15 +231,7 @@ int check_stripes(struct mdinfo *info, i
                block_index_for_slot[diskP] = data_disks;
                blocks[data_disks+1] = stripes[diskQ];
                block_index_for_slot[diskQ] = data_disks+1;
-/* Do we really need the code below? */
-#if 0
-               if (memcmp(p, stripes[diskP], chunk_size) != 0) {
-                       printf("P(%d) wrong at %llu\n", diskP, start);
-               }
-               if (memcmp(q, stripes[diskQ], chunk_size) != 0) {
-                       printf("Q(%d) wrong at %llu\n", diskQ, start);
-               }
-#endif
+
                raid6_collect(chunk_size, p, q, stripes[diskP], stripes[diskQ], results);
                raid6_stats(disk, results, raid_disks, chunk_size);




-- 

piergiorgio
