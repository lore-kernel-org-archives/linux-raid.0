From: "bo" <bo@sosnetwork.net>
Subject: Re: resync patch & Neil's recent patches
Date: Fri, 28 Jun 2002 16:46:03 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001e01c21efd$f6afa2e0$5701a8c0@bomoon>
References: <1025113529.1793.8.camel@jason.storix.com><15642.421.825234.16918@notabene.cse.unsw.edu.au><1025114738.1794.19.camel@jason.storix.com><15642.1309.651737.496391@notabene.cse.unsw.edu.au><009b01c21d5e$e68c7050$5701a8c0@bomoon> <15644.32486.805715.177514@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

> > I saw some bug fixes and improvement on this topic from
> >  http://marc.theaimsgroup.com/?l=linux-kernel&m=100876771508736&w=2
>

According to log file(from above infor), it cleaned up many things related
with RESYNC, and had
some bug fixes. He mentioned it goes to linux2.5.x.

I think we should have the same changes to Linux 2.4.x, don't you?
If so which release should include them? Any problem to apply this patch
to my 2.4.5?

How about your patches(23+)? Can I apply them to my lINUX2.4.5?

> I don't think any of the patches that you mention are particularly
> relevant to your problem.
>
> Maybe if you give some more precise details of your setup??
>
> Also, try
>    echo 100000 > /proc/sys/dev/raid/speed_limit_min
> does that help?
>
> NeilBrown
>

I already use 100M  for speed _limit_min,  300M for speed _limit_max.
I could not notice a big difference from changing this values.

Q1: This value go back to the default at boot/reset,  Should I modify to
change this
       default value in "md.c"? By any config parameter?

Q2:  >hdparm -tT /dev/hdxx
          Timing buffer-cache reads: 52.24 MB/s
          Timing buffered disk reads: 24.43 MB/s

        The "resync" speed on the raid1 device with hdxx:  25.4MB/s.

        Do you think this speed is reasonable enough?

Thanks for your help,

Bo



