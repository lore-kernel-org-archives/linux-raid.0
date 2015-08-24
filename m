From: Christian Hesse <list@eworm.de>
Subject: Re: unable to handle kernel NULL pointer dereference in
 get_free_stripe
Date: Mon, 24 Aug 2015 17:26:49 +0200
Message-ID: <20150824172649.2cd87a30@leda.localdomain>
References: <20150823230341.3dd46f66@leda.localdomain>
	<87pp2dnt9s.fsf@notabene.i-did-not-set--mail-host-address--so-tickle-me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HXWjM+Eho76ux4q8w=gB1YP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87pp2dnt9s.fsf@notabene.i-did-not-set--mail-host-address--so-tickle-me>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/HXWjM+Eho76ux4q8w=gB1YP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Neil Brown <neilb@suse.com> on Mon, 2015/08/24 07:35:
> Christian Hesse <list@eworm.de> writes:
>=20
> > Hello everybody,
> >
> > with linux 4.1.x I am hit by this issue with RAID5:
> >
> > BUG: unable to handle kernel NULL pointer dereference at           (nul=
l)
> > IP: [<ffffffffa05a4b91>] get_free_stripe+0x31/0xf0 [raid456]
>=20
> Thank for the report.
> Please add upstrem commit:
>=20
> Commit: 49895bcc7e56 ("md/raid5: don't let shrink_slab shrink too far.")
>=20
> fix it.

My system is up for eight hours now, doing a lot of I/O without issue.
Thanks a lot!
--=20
Best regards,
Chris

--Sig_/HXWjM+Eho76ux4q8w=gB1YP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJV2ze5AAoJEIlFIdfMgPR22LkIAJeRmHmt4f1T29/JgR3+go9u
eVjTPXRHmqnXnxiqVZhiryd1xeJw6YZ4E+K7cACIwsV9euePNqFN28sdVHd3fKOP
GyRL0Qxsr8+MRoLeGyvgrAEnxMFJ8G1YnTdp5aSo57mfRk/W+Dm3nXY5JV7rjCkI
kk65GCWymHMcKzpwuNEuobeDSsX3TaQYIzc3n34nkFJttsJ6EWRNdHKauEOA1IQ/
iyuDAi43+3xw0fY59g35m2qBKYXolg2O+5qyYgU2Io7RyXn0kAfXrfjd3zzs794x
Dd6oveimUJV1ErUkuZb4SMFz47n11w/l5g1/35beky4Hy7UxeOEcgzRv7GWAtcU=
=ayKK
-----END PGP SIGNATURE-----

--Sig_/HXWjM+Eho76ux4q8w=gB1YP--
