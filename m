From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 0/3 v3] MD: improve raid1/10 write performance for fast
 storage
Date: Fri, 29 Jun 2012 12:52:56 +1000
Message-ID: <20120629125256.31de1c2b@notabene.brown>
References: <20120613091143.508417333@kernel.org>
	<20120628190352.4dc1dd76@notabene.brown>
	<4FED04F1.8010902@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8E27KY+NX1hhHZ1QtdSK9+8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FED04F1.8010902@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

--Sig_/8E27KY+NX1hhHZ1QtdSK9+8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Jun 2012 20:29:21 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 6/28/2012 4:03 AM, NeilBrown wrote:
> > On Wed, 13 Jun 2012 17:11:43 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> >> In raid1/10, all write requests are dispatched in a single thread. In =
fast
> >> storage, the thread is a bottleneck, because it dispatches request too=
 slow.
> >> Also the thread migrates freely, which makes request completion cpu no=
t match
> >> with submission cpu even driver/block layer has such capability. This =
will
> >> cause bad cache issue. Both these are not a big deal for slow storage.
> >>
> >> Switching the dispatching to percpu/perthread based dramatically incre=
ases
> >> performance.  The more raid disk number is, the more performance boost=
s. In a
> >> 4-disk raid10 setup, this can double the throughput.
> >>
> >> percpu/perthread based dispatch doesn't harm slow storage. This is the=
 way how
> >> raw device is accessed, and there is correct block plug set which can =
help do
> >> request merge and reduce lock contention.
> >>
> >> V2->V3:
> >> rebase to latest tree and fix cpuhotplug issue
> >>
> >> V1->V2:
> >> 1. droped direct dispatch patches. That has better performance imporve=
ment, but
> >> is hopelessly made correct.
> >> 2. Add a MD specific workqueue to do percpu dispatch.
>=20
>=20
> > I still don't like the per-cpu allocations and the extra work queues.
>=20
> Why don't you like this method Neil?  Complexity?  The performance seems
> to be there.
>=20

Not an easy question to answer.  It just doesn't "taste" nice.
I certainly like the performance and if this is the only way to get that
performance then we'll probably go that way.  But I'm not convinced it is t=
he
only way and I want to explore other options first.
I guess it feels a bit heavy handed.  On machines with 1024 cores, per-cpu
allocations and per-cpu threads are not as cheap as they are one 2-core
machines.  And I'm hoping for a 1024-core phone soon :-)

NeilBrown


--Sig_/8E27KY+NX1hhHZ1QtdSK9+8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+0YiDnsnt1WYoG5AQKL5Q//YL0oIQjqQwW5dNqTjiYcKTUXa6CKJv6j
C3OrZCrqkgC3iTEqLoJ7kKisPEe68Y/eDHuxfQkxDVcE4ty5CWboSBdUB8GvUeTc
7m3WCC9GB4+B62YjX1Su00Hj5l0zxe1eDhnluBw+/XMfRZMMux5gr6H0reFbwWuP
zRRJRgJ/HVsGfu5tmsO1AoDmbu/w0N2KavwO/hMFB/EkhA8CruuH656icXm2MtsY
KQZVWqth7tslHTsOs1o7IYAF2LV6tgFcONIcuNZ7R3aM90e0x6OaA0TMeYozekLx
S6ACQHz/1E6TH8q6lm/v9UNAz8sVaOco/LuMogoXJmqZtKnrxjtwNJefymezLnhh
fO0XWBQj4P8Gyw/EgmEZkGlIrlNYT5hKJIWuwxVFJANt7SN04MVTEGb3sBr7zwuF
vRC3uOOMxJtyb5kl2fdJN2OMzcZAEmR4CcGT6putOj5e3V5EM+0GzYKii4V1VNWe
8RsBGnbU6KGghOc4s9O8f1+b8ODTl0ATQgKq0fxhh3RA7SiDrQ4gwIc3HAT+Und8
k4ci871FXtnpdIbVvzPx4PMbdzsurJEfocnlr92aDd3sxvgmCeZVyPn4dJeTN036
twCUJruYS0kqwKbnFnuQnXFWzgWPGgRNFA9OIT18ZmV0+FYLQrwPqfBAiWgzsFxR
yKxa7s51Rqs=
=qu9+
-----END PGP SIGNATURE-----

--Sig_/8E27KY+NX1hhHZ1QtdSK9+8--
