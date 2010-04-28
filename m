From: Neil Brown <neilb@suse.de>
Subject: Re: Suggestion needed for fixing RAID6
Date: Wed, 28 Apr 2010 11:37:32 +1000
Message-ID: <20100428113732.03486490@notabene.brown>
References: <626601cae203$dae35030$0400a8c0@dcccs>
	<20100423065143.GA17743@maude.comedia.it>
	<695a01cae2c1$a72907d0$0400a8c0@dcccs>
	<4BD193D0.5080003@shiftmail.org>
	<717901cae3e5$6a5fa730$0400a8c0@dcccs>
	<4BD3751A.5000403@shiftmail.org>
	<756601cae45e$213d6190$0400a8c0@dcccs>
	<4BD569E2.7010409@shiftmail.org>
	<7a3e01cae53f$684122c0$0400a8c0@dcccs>
	<4BD5C51E.9040207@shiftmail.org>
	<80a201cae621$684daa30$0400a8c0@dcccs>
	<4BD76CF6.5020804@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD76CF6.5020804@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: Janos Haar <janos.haar@netcenter.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Apr 2010 01:02:14 +0200
MRK <mrk@shiftmail.org> wrote:

> On 04/27/2010 05:50 PM, Janos Haar wrote:
> >
> > ----- Original Message ----- From: "MRK" <mrk@shiftmail.org>
> > To: "Janos Haar" <janos.haar@netcenter.hu>
> > Cc: <linux-raid@vger.kernel.org>
> > Sent: Monday, April 26, 2010 6:53 PM
> > Subject: Re: Suggestion needed for fixing RAID6
> >
> >
> >> On 04/26/2010 02:52 PM, Janos Haar wrote:
> >>>
> >>> Oops, you are right!
> >>> It was my mistake.
> >>> Sorry, i will try it again, to support 2 drives with dm-cow.
> >>> I will try it.
> >>
> >> Great! post here the results... the dmesg in particular.
> >> The dmesg should contain multiple lines like this "raid5:md3: read 
> >> error corrected ....."
> >> then you know it worked.
> >
> > I am affraid i am still right about that....
> >
> > ...
> > end_request: I/O error, dev sdh, sector 1667152256
> > raid5:md3: read error not correctable (sector 1662188168 on dm-1).
> > raid5: Disk failure on dm-1, disabling device.
> > raid5: Operation continuing on 10 devices.
> 
> I think I can see a problem here:
> You had 11 active devices over 12 when you received the read error.
> At 11 devices over 12 your array is singly-degraded and this should be 
> enough for raid6 to recompute the block from parity and perform the 
> rewrite, correcting the read-error, but instead MD declared that it's 
> impossible to correct the error, and dropped one more device (going to 
> doubly-degraded).
> 
> I think this is an MD bug, and I think I know where it is:
> 
> 
> --- linux-2.6.33-vanilla/drivers/md/raid5.c     2010-02-24 
> 19:52:17.000000000 +0100
> +++ linux-2.6.33/drivers/md/raid5.c     2010-04-27 23:58:31.000000000 +0200
> @@ -1526,7 +1526,7 @@ static void raid5_end_read_request(struc
> 
>                  clear_bit(R5_UPTODATE, &sh->dev[i].flags);
>                  atomic_inc(&rdev->read_errors);
> -               if (conf->mddev->degraded)
> +               if (conf->mddev->degraded == conf->max_degraded)
>                          printk_rl(KERN_WARNING
>                                    "raid5:%s: read error not correctable "
>                                    "(sector %llu on %s).\n",
> 
> ------------------------------------------------------
> (This is just compile-tested so try at your risk)
> 
> I'd like to hear what Neil thinks of this...

I think you've found a real bug - thanks.

It would make the test '>=' rather than '==' as that is safer, otherwise I
agree.

> -               if (conf->mddev->degraded)
> +               if (conf->mddev->degraded >= conf->max_degraded)

Thanks,
NeilBrown


> 
> The problem here (apart from the erroneous error message) is that if 
> execution goes inside that "if" clause, it will eventually reach the 
> md_error() statement some 30 lines below there, which will have the 
> effect of dropping one further device further worsening the situation 
> instead of recovering it, and this is not the correct behaviour in this 
> case as far as I understand.
> At the current state raid6 behaves like if it was a raid5, effectively 
> supporting only one failed disk.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

