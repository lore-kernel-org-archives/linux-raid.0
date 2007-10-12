From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid5: degraded after reboot
Date: Fri, 12 Oct 2007 18:18:09 +0200
Message-ID: <20071012161809.GF21133@skl-net.de>
References: <cccedfc60710120838nd2bb38pf57f03faa803b6c6@mail.gmail.com> <20071012154755.GE21133@skl-net.de> <cccedfc60710120908m24724867had038d9729d16efe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4VrXvz3cwkc87Wze"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60710120908m24724867had038d9729d16efe@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--4VrXvz3cwkc87Wze
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:08, Jon Nelson wrote:

> > sda4 was not included because the array has been assembled previously
> > using only sdb4 and sdc4. So the data on sda4 is out of date.
>=20
> I don't understand - over months and months it has always been the three
> devices, /dev/sd{a,b,c}4.
> I've added and removed bitmaps and done other things but at the time it
> rebooted the array had been up, "clean" (non-degraded), and comprised of =
the
> three devices for 4-6 weeks.

You said you had to reboot your box using sysrq. There are chances you
caused the reboot while all pending data was written to sdb4 and sdc4,
but not to sda4. So sda4 appears to be non-fresh after the reboot and,
since mdadm refuses to use non-fresh devices, it kicks sda4.

> > This looks normal. The array is up with two working disks.
>=20
> Two of three which, to me, is "abnormal" (ie, the "normal" state is three
> and it's got two).

Sure. I should have said: It's normal if one disk in a raid5 array is
missing (or non-fresh).

> > > Why was /dev/sda4 kicked?
> >
> > Because it was non-fresh ;)
>=20
> OK, but what does that MEAN?

To be precise, it means that the event counter for sda4 is less than
the event counter on the other devices in the array. So mdadm must
assume the data on sda4 is out of sync and hence the device can't be
used. If you are not using bitmaps, there is no other way out than
syncing the whole device, i.e. writing good data (computed from sdb4
and sdc4) to sda4.

Hope that helps.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--4VrXvz3cwkc87Wze
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHD55BWto1QDEAkw8RAtOKAJ9BFcSDaJpfqzjPaXd3LZnl/X8bbwCfZWch
txhA4bw05bTPJ0WB44X1OpI=
=eV0h
-----END PGP SIGNATURE-----

--4VrXvz3cwkc87Wze--
