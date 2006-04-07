From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Fri, 7 Apr 2006 16:17:58 +0300
Message-ID: <5b170a7d0604070617s304b3366i4573e97b4fbe6650@mail.gmail.com>
References: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>
	 <4433E073.8040502@fnuck.dk>
	 <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
	 <5b170a7d0604050920p674e10a9u9e26a52fcf3933c1@mail.gmail.com>
	 <c79e949d0604050959o6feb6badx5f854a937a337a1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c79e949d0604050959o6feb6badx5f854a937a337a1d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mike Garey <random51k@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> but wouldn't I need to have /dev/md0 available before doing mdadm
> --assemble?  When booting from an initrd image, /dev/md0 is never
> created for some reason..
>

Sorry, I didn't realize initrd adds to the mix.

> > Note, you should never do any read/write access to the component disks
> > after creating the raid. I guess you know this already, but some
> > wording seemed suspect.
>
> I take it you mean after the disks are synchronized, it's a bad thing
> to write directly to /dev/hda1 or /dev/hdc1... In my case, I've
> written directly to /dev/hdc1, but it's the only disk in the array,
> and I'm going to be resyncing /dev/hda1 anyways, so it seems in this
> instance it's okay?

Correct, unless the disks are already halfway synchronized. Didn't
check this, but IIRC modern-day md remembers how much is synchronized,
it sync is aborted (cleanly).

Glad your problem got solved!

BTW, if you're still having problems with sync speed, try fiddling around with

/proc/sys/dev/raid/speed_limit_min

as the md sync speed detection code is not foolproof (at least lvms as
component devices has fooled it on occasion).
