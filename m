From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: resync patch & Neil's recent patches
Date: Sat, 29 Jun 2002 23:02:28 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15645.45028.216750.35335@notabene.cse.unsw.edu.au>
References: <1025113529.1793.8.camel@jason.storix.com>
	<15642.421.825234.16918@notabene.cse.unsw.edu.au>
	<1025114738.1794.19.camel@jason.storix.com>
	<15642.1309.651737.496391@notabene.cse.unsw.edu.au>
	<009b01c21d5e$e68c7050$5701a8c0@bomoon>
	<15644.32486.805715.177514@notabene.cse.unsw.edu.au>
	<001e01c21efd$f6afa2e0$5701a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bo on Friday June 28
To: bo <bo@sosnetwork.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 28, bo@sosnetwork.net wrote:
> Neil,
> 
> > > I saw some bug fixes and improvement on this topic from
> > >  http://marc.theaimsgroup.com/?l=linux-kernel&m=100876771508736&w=2
> >
> 
> According to log file(from above infor), it cleaned up many things related
> with RESYNC, and had
> some bug fixes. He mentioned it goes to linux2.5.x.
> 
> I think we should have the same changes to Linux 2.4.x, don't you?

I don't think they were significant bugs.  resync works quite well in
2.4.  Well enough that I don't think it should be fiddled with too much.

> If so which release should include them? Any problem to apply this patch
> to my 2.4.5?

They won't work in 2.4 as they stand.  There were some major changes
to the block device layer in 2.5 and these patches require (and are
required by) these changes.

> 
> How about your patches(23+)? Can I apply them to my lINUX2.4.5?

No.  Same reason.  I might back-port the more significant ones, but
much of it was code-cleanliness rather than bug fixes.

> 
> I already use 100M  for speed _limit_min,  300M for speed _limit_max.
> I could not notice a big difference from changing this values.
> 
> Q1: This value go back to the default at boot/reset,  Should I modify to
> change this
>        default value in "md.c"? By any config parameter?

Don't modify md.c.  Just echo a number to the /proc file in a boot
script.

> 
> Q2:  >hdparm -tT /dev/hdxx
>           Timing buffer-cache reads: 52.24 MB/s
>           Timing buffered disk reads: 24.43 MB/s
> 
>         The "resync" speed on the raid1 device with hdxx:  25.4MB/s.
> 
>         Do you think this speed is reasonable enough?

You couldn't ask for better.  This speed looks fine.

NeilBrown
