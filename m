From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 22:39:49 -0800
Message-ID: <4877c76c0911022239q5af451d7o6739d597e6de06a0@mail.gmail.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	 <4AEEF29C.10309@tmr.com>
	 <cccedfc60911020703s3188ebcsac867922f937bb39@mail.gmail.com>
	 <9e52db7bed791d8c8f5653b1958b1874.squirrel@neil.brown.name>
	 <4877c76c0911022209g60e40364i2cb82909e31f707d@mail.gmail.com>
	 <763d89fcf9c0164cbe8b6245dc3d2d7f.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <763d89fcf9c0164cbe8b6245dc3d2d7f.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>
> A reshape is a fundamentally slow operation. =A0Each block needs to
> be read and then written somewhere else so there is little opportunit=
y
> for streaming.
> An in-place reshape (i.e the array doesn't get bigger or smaller) is
> even slower as we have to take a backup copy of each range of blocks
> before writing them back out. =A0This limits streaming even more.
>
> It is possible to get it fast than it is by increasing the
> array's stripe_cache_size and also increasing the 'backup' size
> that mdadm uses. =A0mdadm-3.1.1 will try to do better in this respect=
=2E
> However it will still be significantly slower than e.g. a resync.
>
> So reshape will always be slow. =A0It is a completely different issue
> to filesystem activity on a RAID array being slow. =A0Recent reports =
of
> slowness are, I think, not directly related to md/raid. =A0It is eith=
er
> the filesystem or the VM or a combination of the two that causes
> these slowdowns.
>
>
> NeilBrown
>

stripe_cache_active =3D default 0?
stripe_cache_size =3D default 256? (1mb per disk)
cat /sys/block/md52/md/stripe_cache_*
0
8192

I bumped it up, but I haven't seen a real increase in the speed yet.
Do I need to mdadm -S /dev/md52 and then re-assemble it to have this
take effect, or is it the fact that the stripe cache active seems to
be 'deactivated'?  Can I safely set this to 1 mid-reshape?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
