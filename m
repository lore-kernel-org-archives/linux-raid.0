From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Wed, 18 Feb 2015 12:09:36 +1100
Message-ID: <20150218120936.3c7beed2@notabene.brown>
References: <20150206085133.2c1ab892@notabene.brown>
	<20150206113930.GK23123@twins.programming.kicks-ass.net>
	<20150209121357.29f19d36@notabene.brown>
	<20150209091000.GN5029@twins.programming.kicks-ass.net>
	<20150210135017.7659e49c@notabene.brown>
	<20150210092936.GW21418@twins.programming.kicks-ass.net>
	<20150213162600.059fffb2@notabene.brown>
	<20150213083250.GN2896@worktop.programming.kicks-ass.net>
	<20150213194953.0368355d@notabene.brown>
	<20150213102746.GO2896@worktop.programming.kicks-ass.net>
	<20150213144803.GA11574@worktop.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/TaG/BqeDjBm_Aa6xQBbOoo+"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150213144803.GA11574@worktop.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

--Sig_/TaG/BqeDjBm_Aa6xQBbOoo+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2015 15:48:03 +0100 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Fri, Feb 13, 2015 at 11:27:46AM +0100, Peter Zijlstra wrote:
>=20
> > > I've moved blk_flush_plug to the beginning of the function.
> >=20
> > > I wondered if it really make sense to call blk_flush_plug with nr_iow=
ait
> > > elevated and delayacct_blkio active.  blk_flush_plug() could call sch=
edule()
> > > for non-"io" reasons and maybe that could upset stuff???
> >=20
> > Yeah, good question that. Lemme ponder that a bit.
>=20
> Yes, I thikn your version makes most sense as, you say, even regular
> schedule() call nested in my version would go towards blk delayacct --
> and I doubt that was the intent; even though the current kernel works
> that way.
>=20
> I'll move the now rudimentary io_schedule() into sched.h as an inline.

Thanks.

Are you OK with this going to -stable for 3.19?

NeilBrown

--Sig_/TaG/BqeDjBm_Aa6xQBbOoo+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOPmUDnsnt1WYoG5AQKlqw/+JIOoF3pIESzETgCli5VPCz7Ru6/EqfQ8
dNNHrtbXjFWq2XjTKLIt/CsLXIpUyf/NEpeGW4c5Ycb2U87GyYDHEYQbD0qVKZUx
9rLCKELP230WZjGI/VBSCbJer3wygJCc02G+dkVr19xpHi0B1khutlVU5/4yS5PZ
Zw4TXJEUG90xZul1rPgBU2RIsPMEwu0+aYJxjP9F2w3NQ70kFnPyEdoW8ARi59Ry
/QW59rgQBiUAMaAZmhdhrdaPisVFTDuKCnihPE64JUz+SwVXFJSpJVoHfiqTz3rs
SJ0lT4l2wSYK+HM58/G2oTyUta3YbWwvKsv4YAE3n76AsPsD0i+eeUQweG1VifQe
w42eA0fwfk5yLB/Cpv/XMdTNq8b295SdNqZ69bKF+/WgAuLQkvJ9oDS8nQVNafwp
+kUQdoUGwv6me0v2OZlxj8Ri604/0LU45k8R5iPp95Gy+8np/upF29MEQYJouBqq
k4sefEaOynl98vix9+fur4x3i50Sa3ymc5E1ootmIMoi8e2Pio5FXsZyHOhNuD9J
A+h75veJ1w2dA7NJsB/vNPMg3aAWSyxYftr2AkgttFslWaj/Lypvy4PZCYxonCbQ
Ary8Xhht5VTDK0MnGsr040WI8e9AzgZuXC5aELBQxirUZ0AAi/6Q2lBedpfWMMLt
sNlb7q9HMhY=
=910t
-----END PGP SIGNATURE-----

--Sig_/TaG/BqeDjBm_Aa6xQBbOoo+--
