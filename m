From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: mount-by-label finds drive not array ????
Date: Thu, 22 Jul 2004 13:56:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001f01c47015$28724ca0$0201a8c0@windows>
References: <S266708AbUGVQdP/20040722163315Z+2366@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, robin-lists@robinbowes.com
List-Id: linux-raid.ids

Check the archives for the list.. There was a discussion on labels within
the last two months, I believe. The only solution was to avoid mounting by
label.


----- Original Message ----- 
From: <robin-lists@robinbowes.com>
To: "'Tom Oehser'" <tom@toms.net>; <linux-raid@vger.kernel.org>
Sent: Thursday, July 22, 2004 12:33 PM
Subject: RE: mount-by-label finds drive not array ????


> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tom Oehser
> > Sent: 01 July 2004 11:41
> > To: linux-raid@vger.kernel.org
> > Subject: mount-by-label finds drive not array ????
> >
> >
> > Hi,
> >
> > I'm accustomed to doing something like:
> >
> > LABEL=tomsvol2  /mnt/foo   ext3      defaults        0 2
> >
> > But if I do that on my raid-5 md arrays, it tries to mount
> > disk 1 of the 4 disks that make up the array!  Apparently,
> > the first stripe has enough of the filesystem that it must be
> > thinking that is what to mount!  Even with type "FD"!!!
> >
> > So, with an array /dev/md0 made of hda1 hdb1 hdc1 hdd1, I am
> > having to do a literal:
> >
> > /dev/md0        /mnt/bar      ext3      defaults        0 4
> >
> > Since if I do it by "LABEL=", it tries to mount hda1, not md0!
> >
> > Is this just a known/accepted brain-deadness of the mount code?
>
> Tom,
>
> I'm just considering doing something like this.
>
> Did you ever get any resolution to this issue?
>
> Thanks,
>
> R.
> --
> http://robinbowes.com
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


