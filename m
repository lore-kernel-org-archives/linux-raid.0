From: NeilBrown <neilb@suse.de>
Subject: Re: Determining if a stripe/RAID0 has failed
Date: Wed, 10 Jul 2013 07:46:09 +1000
Message-ID: <20130710074609.37ff918d@notabene.brown>
References: <CAJ_JamCpdFHRyYOzEg=yH4k_rv0KnZD8UJ_GwvSrSmHHOSzFAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JXeD8t/eMU05HS5=Uk2v6Wj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ_JamCpdFHRyYOzEg=yH4k_rv0KnZD8UJ_GwvSrSmHHOSzFAA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curtis <serverascode@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/JXeD8t/eMU05HS5=Uk2v6Wj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Jul 2013 15:33:29 -0600 Curtis <serverascode@gmail.com> wrote:

> Hi All,
>=20
> I'm wondering what the best way to determine when a RAID0 has failed?
>=20
> We have some stateless servers that use a stripe/RAID0, but we'll need
> to know if it failed so we can pull it out of the "cluster" and
> rebuild it. It would be better to find out sooner than later that the
> stripe has failed.
>=20
> I know from reading the man page that I can't use mdadm to monitor the
> stripe. Is it basically just that the device becomes unusable in some
> fashion?
>=20

How would you determine if a lone drive had failed?
Presumably by error messages in the kernel logs, or similar.
Use exactly the same mechanism to test if a RAID0 has failed.

(A "RAID0" doesn't fail as whole.  Bits of it might, other bits might keep
working, just like a drive which can lose some sectors but other sectors ke=
ep
working.  Certainly a whole drive can fail if it's logic-board dies.
Similarly a whole RAID0 can fail if the SATA/SCSI/USB controller dies.)

NeilBrown

--Sig_/JXeD8t/eMU05HS5=Uk2v6Wj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdyEoTnsnt1WYoG5AQKNPA/+KjgTh9uT0wPBMCps8Wv2UylEd0pbKxxC
8Jh+UhSSPROkhjbUsCdZKYyuZvD51T6h1U1abO0Qbj1oQTYcIDdOJcVBSPYYyDGE
eIeOK4PCMRM96X20pmbCT/ycBd/EkApadDzNPukEEr5DNH/i6BxEPbHr552JdbA5
eJh3VpIm88ahymgbMnvF3xQEV3qoHMBGP8IPFPhBgny8caCkIr81psee36eqOcwO
qt0dyaclPwJhuspf8a4X+8mCR/Azp4a/okNuWnj0SNuoUGU+EA96OIwUcNEji/C5
1BXgUXPFBUaGLqj/n9hLrYYMxWa7bOe4Tr+wwHTUWSq5J7fcYWEr18VQtOoINpd6
oj+vIvDVXYQVYboTaL89oU07npezXGMWkN/AMKsEQwsLU8cTcUbcO7qwPD3JbcsJ
GcRg1fl/3gWHIS+0iLo1bwyGyuwRgRcuojrcaXs5/AOtfkde1ALui/lQTMzQI9nu
+iEEnnOAG/8hrwZUAZwHGE03k3stsIsAF6Zr8y6PkEa07upTvZaZ6wwBHOt0OJNW
q05DxjPu1bqt1Nox21lTleDfBx5ChRpjYgkO8VACBxS+I7VChBpIYeyMVh02ThlJ
1XdrRzWuvQ+LuL2qVc8DtL3KFGDAFW8ckO8d+zlKY8c8GO6YmKiabVu73PiusfTR
QpzYz2dDKUg=
=p5UD
-----END PGP SIGNATURE-----

--Sig_/JXeD8t/eMU05HS5=Uk2v6Wj--
