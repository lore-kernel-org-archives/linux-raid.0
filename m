From: NeilBrown <neilb@suse.de>
Subject: Re: hung in raise_barrier() in raid1.c  -- any ideas?
Date: Fri, 21 Sep 2012 07:27:51 +1000
Message-ID: <20120921072751.38319b46@notabene.brown>
References: <505B49E2.8070109@genband.com>
	<505B5876.4040405@genband.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w9l8ugWesK6U1tBYqcfiQ3n"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505B5876.4040405@genband.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/w9l8ugWesK6U1tBYqcfiQ3n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 11:55:02 -0600 Chris Friesen <chris.friesen@genband.com>
wrote:

> On 09/20/2012 10:52 AM, Chris Friesen wrote:
> >
> > Hi,
> >
> > I've got a fairly beefy (32 cpus, 64GB ram, isci-based SAS disks,=20
> > etc.) embedded system running 2.6.27.
> >
> > We're seeing issues where disk operations suddenly seem to stall.  In=20
> > the most recent case we had the hung-task watchdog indicate that=20
> > md1_resync was stuck for more than 120sec in raise_barrier().
> >
> > There are a bunch of "normal" tasks also stuck in wait_barrier(), so=20
> > based on that I assume we're stuck in the second call to=20
> > wait_event_lock_irq().
> >
> > Has anyone seen anything like this?  Could commit 73d5c38 be related?=20
> > What about 1d9d524?
>=20
> Could d6b42dc be related?

That last one seems more likely.  Does the scenario fit your config.
i.e. is your RAID1 being used under LVM?

If it does, then I would say it is very likely this issue.

> Also, what's the meaning of RESYNC_DEPTH?

The maximum number of resync requests that can be concurrently active.

RESYNC_WINDOW should really be RESYNC_BLOCK_SIZE * RESYNC_DEPTH
I wonder why it isn't.

NeilBrown

--Sig_/w9l8ugWesK6U1tBYqcfiQ3n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFuKWDnsnt1WYoG5AQKWnxAAxBI7CYHlZEx88ObK7V+UN9qjW3wb3C22
COzobqF17icweHCD00FwwNlh/T5heKcfViUwClSKmIiSBN+wjxsqisWgFZUCx69e
wyB4pIhC+scEl/JC6dMTyJ6AH9P92Xk0irf16H9w7KeJN0d80bn7Rj0LPh+GA8mU
hv2xt/8Oo2lP+2qXO8SMJOTja6Rn68zsGhElpnGXviarWD1u40BSOQznsmti/FOz
lOUIJtutGjLy1m2xEA72/0Orvi8XIdeH0KxSprF7CYgsrSLL2LiUBK6yDAGgl/wJ
VKHLYCr8gm5cVat1VHFw2IiFsr5UHQ1/FoaLG7nO70zrdpMECsHbbQP4zyXLNaMT
a+lGDZd2ZQdxyOvZK1MJk0lIaVpWzwLUFpuNDO3zhjwnEfOO+MxRec3lzCz78kH9
IGMdQM9iWEvOAMWxBqi3OFokyTu4ydEH5h12m5FcO6oB8XEOIJlYTCT+SXAhDlZ6
RZ9kVdYPN6FJ0v432+7hTfXGYgq3QhWuohhUZiGSQ3xb4fnnC/koFQlDI/WgQi0h
Ns5+H4hqSdrLAURkRcMrW3WTbuAN1xXV9L1D5ysgzPsvVP2krogM5ugr5yffHPrF
qVsyv0k1ciJOJZwz6s7s02FEuBCe2a5rgNx2NkZPtWkMM5ULoSqBpCFJ2vXyjatY
s5wzYrs73Qo=
=ruwB
-----END PGP SIGNATURE-----

--Sig_/w9l8ugWesK6U1tBYqcfiQ3n--
