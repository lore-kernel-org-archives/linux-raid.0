From: NeilBrown <neilb@suse.de>
Subject: Re: Persistent failures with simple md setup
Date: Thu, 21 Mar 2013 14:24:59 +1100
Message-ID: <20130321142459.2cd6b4da@notabene.brown>
References: <1565063.1kpR7lz4Ph@xrated>
	<20130313115235.01492c21@notabene.brown>
	<1407824.2kxT8nEo5d@xrated>
	<2777026.gm19DAWULs@xrated>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q6sHWVEh5saAO0=x14v37HK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2777026.gm19DAWULs@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Q6sHWVEh5saAO0=x14v37HK
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Mar 2013 12:20:57 +0100 Hans-Peter Jansen <hpj@urpla.net> wrote:

> Am Freitag, 15. M=E4rz 2013, 23:43:31 schrieb Hans-Peter Jansen:
> > Am Mittwoch, 13. M=E4rz 2013, 11:52:35 schrieben Sie:
> > > hi,
> > >=20
> > >  wonder if you could try one more test for me.
> > >  With the other (echo BEFORE / echo AFTER etc) tracing still there, c=
hange
> > >=20
> > > the /sbin/udevadm settle --timeout=3D$MDADM_DEVICE_TIMEOUT
> > >=20
> > >  to
> > > =20
> > >    /sbin/udevadm --debug settle --timeout=3D$MDADM_DEVICE_TIMEOUT >
> > >    /dev/kmsg
> > >=20
> > > 2>&1
> > >=20
> > >  I found there is a case where "udevadm settle" can exit before the q=
ueue
> > >  is
> > >=20
> > > empty.  It seems like a very unlikely scenario, but it seems clear th=
at
> > > something "unlikely" is happening.
> > >=20
> > >  I'm hoping to see
> > > =20
> > >     timeout waiting for udev queue
> > > =20
> > >  appear in the logs when this runs.
> > > =20
> > >  If you could add that and post the 'dmesg' output if you ever get th=
at
> > >  message - or maybe even if you don't - that would be very helpful.
> >=20
> > Did that right now and disabled the sleep 10 in front, that provisional=
ly
> > "solved" this issue BTW. Now waiting for another md issue to occur.
>=20
> Here we go: (not censored in any way, and I hope to get the "window" righ=
t:
> md0 was affected this time.
>=20

Thanks! Unfortunately it is not as helpful as I hoped, but it does suggest
that "udevadm settle" does sometimes appear to misbehave even if there aren=
't
any problems with the md array.

Could I ask for one more?
Prefix the "udevadm settle " command with
  strace  -o /tmp/udevadm.trace -s 500

(making sure that you have 'strace' installed) and then post the
"/tmp/udevadm.trace" file.  Hopefully that will at least allow me to rule o=
ut
some possibilities.

Thanks,
NeilBrown


--Sig_/Q6sHWVEh5saAO0=x14v37HK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUp9jDnsnt1WYoG5AQJyDA//XEGiNJLF2ugLQwclXES6bQWj1NxplZk8
aNzYFuvAe6gMSb2v5fUASHDQFysCtoG8B9KzOeoNv0esFtU8Mjtqd/LL3R8v7Ab7
ADN5AYLtNptQpeQI6gBpCMVozHuumM9u/SH94Kb9WzPc238/rSfV+UqwkzHukJW3
AplYH/8Y733QKttpKyBKkEsRkrbL6+puqEoNMIiWlE50/9Qmu3w5ihmO4ZsZjIl4
BlUl3e83HKRsPAUKgf1IVcEPd9c/DM9tj9FX/c/ncVpalSqB76ISgwLUha3sbvfK
qMjsJR+TXvs0w1MfFZJXY4rJ7g0ISgJSRywWi6tvDYBhgr3sIchj2YY9Xryeri66
5BkMFUNOVOpDHic5inhicltjGMXIVjxbD0yqfZLw1jDNj8opiKbYugpQ4lkpRATb
6Q7UGdsSbg8hw2GsFORK9UKEcJDMJNnQ9aV6GTSYuD/cTFgipdiDDq7UXOrzOzJi
suxiZE9R6XkbQST0sYgWc4HlZS9pfcb4pc1NxB7eaKctzOXo+Dk5IktCL0srEe/2
k9DE5McZtTHiccTzvqCxrQ4NNmxfckyM6q75XlBenFfpTZcBJlZz+bS1BW5EjhKh
ifjt2wxIsSlSwRDD/+3fhtCb41RK7IoseBKCpwWayGSTv+9FtvZFXnTevf7vlbOH
p2NNEFq4M+o=
=KvQP
-----END PGP SIGNATURE-----

--Sig_/Q6sHWVEh5saAO0=x14v37HK--
