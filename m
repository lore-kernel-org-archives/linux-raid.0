From: Neil Brown <neilb@suse.de>
Subject: Re: raid 5 read performance
Date: Sat, 10 Jun 2006 08:59:21 +1000
Message-ID: <17545.64841.443046.249299@cse.unsw.edu.au>
References: <5d96567b0606090850q6185e6a0u8b16860b4f826d4f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Friday June 9
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday June 9, raziebe@gmail.com wrote:
> Neil hello
> 
> Sorry for the delay. too many things to do.

You aren't alone there!

> 
> I have implemented all said in :
> http://www.spinics.net/lists/raid/msg11838.html
> 
> As always I have some questions:
> 
> 1.  mergeable_bvec
>      I did not understand first i must admit. now i do not see how it
> differs from the
>      one of raid0.  so i  actually copied it and renamed it.

Sounds fine.  For raid5 there is no need to force write requests to be
split up, but that's a minor difference.

> 
> 2. statistics.
>     i have added md statistics since the code does not reach the
> statics in make_request.
>     it returns from make_request before that.

Why not put the code *after* that?  Not that it matters a great deal.
I'll comment more when I see the code I expect.

> 
> 3. i have added the new retry list called toread_aligned to raid5_conf_t .
>     hope this is correct.
> 

Sounds good.


> 4.  your instructions are to add a failed bio to sh, but it does not
> say to handle it directly.
>     i have tried it and something is missing here. raid5d handle
> stripes only if  conf->handle_list is not empty. i added handle_stripe
> and and release_stripe of my own.
>    this way i managed to get from the completion routine:
>    "R5: read error corrected!! " message . ( i have tested by failing
> a ram disk ).
> 

Sounds right, but I'd need to see the code to be sure.

> 
> 5. I am going to test the non common path heavily before submitting
> you the patch ( on real disks  and use  several file systems and
> several chunk sizes).

I'd rather see the patch earlier, even if it isn't fully tested.

>  It is quite a big patch so I need to know which kernel do you want me
> to use ? i am using poor 2.6.15.

A patch against the latest -mm would be best, but I'm happy to take it
against anything even vaguely recent.

However, it needs to be multiple patches, not just one.
This is a *very* important point.  As that original email said:

  This should be developed and eventually presented as a sequence of
  patches.

There are several distinct steps in this change and they need to be
reviewed separately or it is just too hard.
So I would really like it if you could separate out the changes into
logically distinct patches.
If you can't or won't, then still send the patch, but I'll have to
break it up so it'll probably take longer to process.


Thanks for your efforts,

NeilBrown

