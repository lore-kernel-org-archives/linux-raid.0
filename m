From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: raid issues after power failure
Date: Fri, 30 Jun 2006 11:51:24 +0200
Message-ID: <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
	 <fd8d0180606300221x2280e220qd6f5fcd1096ff37b@mail.gmail.com>
	 <49971.82.141.169.118.1151659502.squirrel@mail.tyrell.hu>
	 <fd8d0180606300250q6fbab5d3wdf343b530f3119a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180606300250q6fbab5d3wdf343b530f3119a9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2006/6/30, =C1kos Mar=F3y <darkeye@tyrell.hu>:
> Francois,
>
> Thank you for the very swift response.
>
> > First, what is your mdadm version ?
>
> # mdadm --version
> mdadm - v1.12.0 - 14 June 2005
>
Rather old, version, isn't it ?
The freshest meat is 2.5.2, and can be grabbed here :
http://www.cse.unsw.edu.au/~neilb/source/mdadm/

It's quite strange that you have such an old mdadm with a 2.6.16 kernel=
=2E
That could be a good idea to upgrade...

> what I see is that /dev/sdb1 is signaled as faulty (though it was kno=
wn to
> be not fault before the power failure), and that the whole array is d=
irty
> because of the power failure - thus it can't resync.

Yep, this looks like it.
The events difference is quite big : 0.2701790 vs. 0.2607131... Could
it be that the sdb1 was marked faulty a couple of seconds before the
power failure ?

>
> but even if I hot-add /dev/sdb1 after starting the array, it will say=
 that
> it's resyncing, but actually nothing will happen (no disk activity
> according to vmstat, no CPU load, etc.)
>

That's strange. Once again, maybe upgrading your mdadm.

If it does not make it, I guess you'll have to re-constuct your array.
That does not necessarily mean you'll loose data, just playing with -C
and miscelaneous stuff, but I'm not good at that games... Neil is,
definitly.

Good luck.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
