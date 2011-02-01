From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 17:02:46 +0100
Message-ID: <20110201160245.GA25659@www2.open-std.org>
References: <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ii8lcv$3jg$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 01, 2011 at 11:01:33AM +0100, David Brown wrote:
> On 31/01/2011 23:52, Keld J=F8rn Simonsen wrote:
> >raid1+0 and Linux MD raid10 are similar, but significantly different
> >in a number of ways. Linux MD raid10 can run on only 2 drives.
> >Linux raid10,f2 has almost RAID0 striping performance in sequential =
read.
> >You can have an odd number of drives in raid10.
> >And you can have as many copies as you like in raid10,
> >
>=20
> You can make raid10,f2 functionality from raid1+0 by using partitions=
=2E=20
> For example, to get a raid10,f2 equivalent on two drives, partition t=
hem=20
> into equal halves.  Then make md0 a raid1 mirror of sda1 and sdb2, an=
d=20
> md1 a raid1 mirror of sdb1 and sda2.  Finally, make md2 a raid0 strip=
e=20
> set of md0 and md1.

I don't think you get the striping performance of raid10,f2 with this
layout. And that is one of the main advantages of raid10,f2 layout.
Have you tried it out?

As far as I can see the layout of blocks are not alternating between th=
e
disks. You have one raid1 of sda1 and sdb2, there a file is allocated o=
n
blocks sequentially on sda1 and then mirrored on sdb2, where it is also
sequentially allocated. That gives no striping.

> I don't think there is any way you can get the equivalent of raid10,o=
2=20
> in this way.  But then, I am not sure how much use raid10,o2 actually=
 is=20
> - are there any usage patterns for which it is faster than raid10,n2 =
or=20
> raid10,f2?

In theory raid10,o2 should have better performance on SSD's because of=20
the low latency, and raid10,o2 doing multireading from each drive, whic=
h
raid0,n2 does not.

We lack some evidence from benchmarks, tho.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
