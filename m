From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: Neil, where are your Patches !
Date: Sat, 18 Mar 2006 10:31:53 +0100
Message-ID: <fd8d0180603180131k517bc899y@mail.gmail.com>
References: <fd8d0180603150510h37865209p@mail.gmail.com>
	 <17433.61627.891961.775442@cse.unsw.edu.au>
	 <17434.39235.49589.69449@cse.unsw.edu.au>
	 <fd8d0180603170430r5cf8883dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180603170430r5cf8883dg@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > Ok, look again, under
> >   http://cgi.cse.unsw.edu.au/~neilb/patches/linux-devel/
> >

Early comments :
I tested with patch-all-2006-03-17-10 on top of 2.6.16-rc6-mm1.
I had two compilation issues :
* in include/linux/raid/md_k.h, external is not defined in mddev_s. I
supposed it was an int.

* in drivers/raid/md.c and include/linux/raid/md.h, md_do_sync is
confused, being declared static, but used in other places, like
raid5.c. I supposed it shall be declared non-static.

With these 2 modifications, compilation is ok.

Raid5 resize testing :
I tried using it with 4 loop devices, creating a 3 10Mb raid5 and adding a 4th.
- mdadm -C -n 3 -l 5 /dev/md1 /dev/loop[123] : no problem
- mdadm -a /dev/md1 /dev/loop4 : loop4 is a spare
- mdadm -G -n 4 /dev/md1 returns error, but nothing happens : the 4th
is not added, and stays as a spare. md1 is still accessible, no
problem about that.

I'll try of course to investigate more...

Regards,

F.-E.B.
