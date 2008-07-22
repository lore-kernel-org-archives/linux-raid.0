From: martin f krafft <madduck@madduck.net>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for
	all devices to init
Date: Tue, 22 Jul 2008 12:36:05 +0200
Message-ID: <20080722103605.GA13268@piper.oerlikon.madduck.net>
References: <20080720151140.4aa7c682@infradead.org> <20080720151339.6f4a83d8@infradead.org> <18563.50428.659101.868745@notabene.brown> <20080721113417.GA8152@piper.oerlikon.madduck.net> <18565.6836.784228.255912@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18565.6836.784228.255912@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>, 462617@bugs.debian.org
List-Id: linux-raid.ids


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[462617@bugs.debian.org added to Cc]

also sprach Neil Brown <neilb@suse.de> [2008.07.22.0124 +0200]:
> > It was my understanding that write-intent bitmaps slow down all
> > operations and are not suggested on e.g. workstations. No?
>=20
> Well, they don't slow down reads.
> If you have a separate root filesystem (i.e. /home and /var are
> elsewhere), it is likely to be read-mostly, so bitmaps probably won't
> hurt much.
> And an external bitmap on a dedicated device has minimal performance
> cost.
>=20
> However I neither suggest having nor not-having bitmaps.  The choice to
> use them involves a trade-off which I cannot make for other people.

Ok, in the light of http://bugs.debian.org/462617, this answers my
question and Debian will not make them default. It would be nice to
have the option though, during installation.

Including the rest of your reply for the sake of the bug record,
which is on Cc:

> They would, however, be very useful to cover the gap when assembling
> arrays incrementally.
> If, for example, you have a 6 disk raid5 array and 5 disks have been
> found, what do you do? =20
>   - wait for the 6th, that might never arrive
>   - start degraded and if a write happens before the 6th disk arrives,
>     have to rebuild the 6th disk completely.
>=20
> Neither is a good option.
> An alternate is
>   - add an internal bitmap, and remove it after the 6th disk has
>     arrived, or after we are sure there are no more disks to find.
>=20
> Doing this means that if a recovery is needed when the 6th disk
> arrives, it will be very fast.
>=20
> It's not hard to notice that the bitmap proposed here does not need to
> be on stable storage.  It is not protecting against a crash, just
> against a window when the array is degraded.  So if we could support
> bitmaps on a tmpfs, we could use an external bitmap in /tmp instead of
> an internal bitmap.
> Or even - we could enhance the md code to always use a bitmap, but
> simply not write it to storage if no such was configured.

This would be very nice. In fact, everything that makes md better
and requires less complexity in the mdadm packaging is nice. :)

> (If a crash happens during that window between writing to the degraded
> array and recovering the few blocks needed on the final device, then
> you would be in an unfortunate position.  For raid1/10 you would just
> need a full resync, which you would have needed anyway, so no loss.
> For raid4/5/6, you have a potential for dataloss, so I probably would
> not make this behaviour the default for those levels...)

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
drink canada dry! you might not succeed, but it *is* fun trying.
=20
spamtraps: madduck.bogus@madduck.net

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiFuBQACgkQIgvIgzMMSnVwngCg5yLrJuqsLGGc0r63EAznzrDz
JNgAnixA1qkowhR7/mYKlV1Sq8YbU8nW
=IHKH
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
