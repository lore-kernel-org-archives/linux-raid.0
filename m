From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: raid5: degraded after reboot
Date: Fri, 12 Oct 2007 11:08:56 -0500
Message-ID: <cccedfc60710120908m24724867had038d9729d16efe@mail.gmail.com>
References: <cccedfc60710120838nd2bb38pf57f03faa803b6c6@mail.gmail.com>
	 <20071012154755.GE21133@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071012154755.GE21133@skl-net.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/12/07, Andre Noll <maan@systemlinux.org> wrote:
> On 10:38, Jon Nelson wrote:
> > <4>md: kicking non-fresh sda4 from array!
> >
> > what does that mean?
>
> sda4 was not included because the array has been assembled previously
> using only sdb4 and sdc4. So the data on sda4 is out of date.

I don't understand - over months and months it has always been the three
devices, /dev/sd{a,b,c}4.
I've added and removed bitmaps and done other things but at the time it
rebooted the array had been up, "clean" (non-degraded), and comprised of the
three devices for 4-6 weeks.

> > I also have this:
> >
> > raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
> > RAID5 conf printout:
> >  --- rd:3 wd:2 fd:1
> >  disk 1, o:1, dev:sdb4
> >  disk 2, o:1, dev:sdc4
>
> This looks normal. The array is up with two working disks.

Two of three which, to me, is "abnormal" (ie, the "normal" state is three
and it's got two).

> > Why was /dev/sda4 kicked?
>
> Because it was non-fresh ;)

OK, but what does that MEAN?


> > md0 : active raid5 sda4[3] sdb4[1] sdc4[2]
> >       613409664 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]
> >       [==>..................]  recovery = 13.1% (40423368/306704832)
> > finish=68.8min speed=64463K/sec
>
> Seems like your init scripts re-added sda4.

No, I did this by hand. I forgot to say that.

--
Jon
