From: NeilBrown <neilb@suse.de>
Subject: Re: Data Offset
Date: Tue, 25 Feb 2014 08:38:40 +1100
Message-ID: <20140225083840.11cec0f1@notabene.brown>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com>
	<20120602095237.3822e2c2@notabene.brown>
	<CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com>
	<20120604133526.6da3bf10@notabene.brown>
	<4FCCFDBB.201@pierre-beck.de>
	<20120605085728.7e922359@notabene.brown>
	<530B2B84.3010208@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jAHs0Cfd=gVHw/OrkykJ8zI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530B2B84.3010208@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: wiebittewas <wiebittewas@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jAHs0Cfd=gVHw/OrkykJ8zI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Feb 2014 12:22:44 +0100 wiebittewas <wiebittewas@googlemail.com>
wrote:

> Am 05.06.2012 00:57 schrieb "NeilBrown" bzgl. "Re: Data Offset":
>=20
>=20
> > OK, try:
> >=20
> >    git clone -b data_offset git://neil.brown.name/mdadm
> >    cd mdadm
> >    make
> >=20
> >    ./mdadm -C /dev/md1 -e 1.2 -l 5 -n 5 --assume-clean -c 512 \=20
> >       /dev/sdc3:2048s /dev/sdb3:2048s ???  /dev/sdd3:1024s ???
> >=20
> > The number after ':' after a device name is a data offset.  's' means s=
ectors.
>=20
> well, luckily I've found this message and was able to rescue an array
> with two failed disks with only a few damaged files...
>=20
> but is there any possibility that this features comes into normal tree,
> so it will be usable in near future from rescue-sticks like grml?

This feature is in mdadm-3.3.

NeilBrown

>=20
> > Don't install this mdadm, and don't use it for anything other than
> > re-creating this array.
>=20
> or does it interfere with other necessary features?
>=20
> I've viewed a diff to standard 3.2.5 and doesn't see real complex
> things, but even a lot of smaller changes.
>=20
> at least thanks for your work.
>=20
> w.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/jAHs0Cfd=gVHw/OrkykJ8zI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwu74Dnsnt1WYoG5AQL/sw//TwwwM5cNU4DsuEqA57Gx2fiEiOu8U3eN
PRvVQUlpEmPCqbaNlYTVhBEsdrtObiZIRd4qXQ9Oboprimfoxipq5mEYKEZOIzkR
FT07sBJuFwamgnouf8OR4ZIJVY3hYeYSJ6RlHxcvaGcV+9tteEJRENqnAXLKfjd0
1f8a+8yXd9fKgvxCikP7MhQDT701Q+1dqqVrLmjQjhlAnuh5fUqwuQ0L6L/ZPQdF
wfS/hL8tVZ9H4LbtFVulU0Sk0bKXKF7uNaFWph9ujVXZ7B85BrmT1rYad5IaZbWI
2oWoWXZDKRCNzh5+vw9yfSkfA8KFSoTwIPt3Flm+2rYmPmUqsm9/DOJReCz6fLrG
2RYnwmCVUmUQHndmlsNKOW14uJQSYR2fLSWl+kjtuXPy/9JoT8FnwMdbk6DbM2ZN
pGFF3DcgDsnwuE2J9Q/br5RpX1oGn/yyp6fuHtjpicrQWOnf/Ayv7Jrm1Q/xOgGe
alDXZQwMgIwufv78RKdvFawaOysC43yWMpS6s2ywypjYJveMrZHw1Tr41/azOEV8
YhoP4djRIe9nrcV6STlO0/K7sQ2K3IXvA2JEOWULCiBB5SN2p7TyVEoLfPuQRcxp
fAs10A+/rsf2LTVkNWdrp375VYSAk9ACDl2ZnHcqhbehp4PHN6ipydaNmBN5o7HZ
yjLCec4TEdQ=
=wIJO
-----END PGP SIGNATURE-----

--Sig_/jAHs0Cfd=gVHw/OrkykJ8zI--
