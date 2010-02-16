From: Neil Brown <neilb@suse.de>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 11:57:37 +1100
Message-ID: <20100216115737.5abfeed2@notabene.brown>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
	<4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
	<20100212090632.GA17020@cthulhu.home.robinhill.me.uk>
	<alpine.LNX.2.01.1002121247280.3504@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1002121247280.3504@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 12 Feb 2010 12:53:53 -0900 (AKST)
"Mr. James W. Laferriere" <babydr@baby-dragons.com> wrote:

>  	Hello Robin ,
> 
> On Fri, 12 Feb 2010, Robin Hill wrote:
> > On Thu Feb 11, 2010 at 05:52:41PM -0800, Michael Evans wrote:
> >
> >> On Thu, Feb 11, 2010 at 3:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >>> Hi,
> >>>
> >>> I may be converting a host to ext4 and was curious, is 0.90 still the only
> >>> superblock version for mdadm/raid-1 that you can boot from without having to
> >>> create an initrd/etc?
> >>>
> >>> Are there any benefits to using a superblock > 0.90 for a raid-1 boot volume
> >>> < 2TB?
> >>>
> >>> Justin.
> >>
> >> You need the superblock at the end of the partition:  If you read the
> >> manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and also
> >> NOT 1.2; those use the same superblock layout but different
> >> locations).
> >>
> > You also need it to be auto-assembled by the kernel, which is only
> > version 0.90.
> >
> > As for benefits, there's a number of benefits of 1.x over 0.90 - I don't
> > think any of them are terribly important for a small boot partition
> > though.  There's also benefits to having an initrd anyway.
> >
> > Cheers,
> >    Robin
> 
>  	One can use the 'append=""' functionality of lilo & I am user that 
> Grub2(and family) has some method of doing the same .
>  	ie:
> append=" md=1,/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1 md=2,/dev/sda2,/dev/sdb2,/dev/sdc2,/dev/sdd2 md=3,/dev/sda3,/dev/sdb3 md=4,/dev/sda4,/dev/sdb4 vt.default_utf8=0 sysrq_always_enabled=1"
>

As I said in a previous Email, I do not recommend this.  If a device fails
and is removed, then on the next reboot all subsequent device names can
change.  So assembling arrays be name is not safe.
 
>  	Not sure if this would be usable with a 1.1+ version of the MD headers .

Though yes: it does work with v1.x metadata.

> 
>  	I'd really like to see a REAL case that shows a good example of the use 
> of initrd that absolutely can NOT be done only because of someones 
> unwillingness to create it in the kernel or to allow others too .

Sure, anything can be done in the kernel.  It doesn't follow that everything
should be done in the kernel.
There are number of corner cases that can make assembling md arrays messy.
Most of these cases never happen for most people, but I still want to handle
them as robustly as possible.
I would rather do that just in mdadm, not in the kernel.

NeilBrown
