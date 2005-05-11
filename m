From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: grow problem
Date: Tue, 10 May 2005 21:43:54 -0400
Message-ID: <200505110143.j4B1hxm10566@www.watkins-home.com>
References: <17025.18070.800000.318669@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17025.18070.800000.318669@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@cse.unsw.edu.au>, 'John McMonagle' <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maybe you should be able to list the device(s) to be removed.
And maybe "missing" should be an option.

So, he could say:
--grow /dev/md0 --raid-disks 2 missing

I guess if it assumed you wanted to remove failed devices first, you could
just fail the devices you want to remove.

Just thinking!

Guy

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Tuesday, May 10, 2005 7:41 PM
> To: John McMonagle
> Cc: linux-raid@vger.kernel.org
> Subject: Re: grow problem
> 
> On Tuesday May 10, johnm@advocap.org wrote:
> > Having a problem changing my number of mirrors on a raid1 from 3 to 2.
> >
> > Did it about a week ago on another system so I'm a bit perplexed.
> >
> > mdadm --grow /dev/md0 --raid-disks 2
> > mdadm: Cannot set device size/shape for /dev/md0: Device or resource
> busy
> >
> >  cat /proc/mdstat
> > Personalities : [raid1]
> > md0 : active raid1 sda1[0] hda1[2]
> >       976640 blocks [3/2] [U_U]
> 
> md/raid1 currently requires and devices that you plan to remove with
> --grow, to already be missing.
> 
> So you would need to fail and re-add hda1, which would mean a full
> rebuild :-(
> 
> If you can afford to:
>    - wait a few days
>    - recompile your kernel
>    - be a guinea pig
> 
> I can get raid1 to try to move devices into earlier holes before
> reducing the size.  Let me know, and I'll start working on a patch.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

