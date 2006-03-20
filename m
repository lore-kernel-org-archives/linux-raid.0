From: Neil Brown <neilb@suse.de>
Subject: Re: Neil, where are your Patches !
Date: Mon, 20 Mar 2006 14:54:47 +1100
Message-ID: <17438.10119.117697.502421@cse.unsw.edu.au>
References: <fd8d0180603150510h37865209p@mail.gmail.com>
	<17433.61627.891961.775442@cse.unsw.edu.au>
	<17434.39235.49589.69449@cse.unsw.edu.au>
	<fd8d0180603170430r5cf8883dg@mail.gmail.com>
	<fd8d0180603180131k517bc899y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francois Barre on Saturday March 18
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday March 18, francois.barre@gmail.com wrote:
> > > Ok, look again, under
> > >   http://cgi.cse.unsw.edu.au/~neilb/patches/linux-devel/
> > >
> 
> Early comments :
> I tested with patch-all-2006-03-17-10 on top of 2.6.16-rc6-mm1.
> I had two compilation issues :
> * in include/linux/raid/md_k.h, external is not defined in mddev_s. I
> supposed it was an int.
> 
> * in drivers/raid/md.c and include/linux/raid/md.h, md_do_sync is
> confused, being declared static, but used in other places, like
> raid5.c. I supposed it shall be declared non-static.
> 
> With these 2 modifications, compilation is ok.

Yes... If you grabbed all the patches, it would have included some
that I haven't worked on for a while, and haven't tested recently
either...

I'll do another patch set in a day or so with these fixed up.

> 
> Raid5 resize testing :
> I tried using it with 4 loop devices, creating a 3 10Mb raid5 and adding a 4th.
> - mdadm -C -n 3 -l 5 /dev/md1 /dev/loop[123] : no problem
> - mdadm -a /dev/md1 /dev/loop4 : loop4 is a spare
> - mdadm -G -n 4 /dev/md1 returns error, but nothing happens : the 4th
> is not added, and stays as a spare. md1 is still accessible, no
> problem about that.

That is deliberate.  You need a new version of mdadm to use
raid5-reshape safely.  A pre-release will be out soon.

NeilBrown
