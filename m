From: Neil Brown <neilb@suse.de>
Subject: Re: pata_via with software raid1: "attempt to access beyond end of
 device"
Date: Fri, 20 Jul 2007 12:59:41 +1000
Message-ID: <18080.9501.524388.160581@notabene.brown>
References: <dju2n4-lcf.ln1@tux.abusar.org>
	<18078.57482.951240.250360@notabene.brown>
	<mpm4n4-dr3.ln1@tux.abusar.org>
	<18080.6791.774446.512592@notabene.brown>
	<9fj5n4-uh5.ln1@tux.abusar.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Fraga on Thursday July 19
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 19, fragabr@gmail.com wrote:
> On Fri, 20 Jul 2007 12:14:31 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > What does
> >       od -D -j 65536 -N 4 /dev/md1
> > show.  This is the size the reiserfs thinks it is using.  Multiply by
> > 4 and you should get 77642048 or maybe a little less.  If you get
> > more, then reiserfs think the device is bigger than it is.  If don't
> > then I have no idea what the problem is.
> 
> 	The output is:
> 
> 0200000   19410528
> 0200004
> 
> 	so...
> 
> 19410528 x 4 = 77642112
> 
> 	The difference (77642048 - 77642112) is 64.

So reiserfs thinks the devices is 64K larger than it really is. I
wonder how that happened.

> 
> 	Does it help? What could I do now? Thanks!

It helps that we know why you get these errors.  It looks like you
should be able to fix it with resize_reiserfs.
Looking at the man page I have, you could
   umount /whatever
   resize_reiserfs -s -64K /dev/md1
   mount /whatever

However I recommend reading the man page yourself, as this isn't the
sort of thing you want to get wrong.

NeilBrown
