From: NeilBrown <neilb@suse.de>
Subject: Re: Can't mount partitions after "mdadm --zero-superblock"
Date: Tue, 7 Apr 2015 11:52:57 +1000
Message-ID: <20150407115257.1e3eba73@notabene.brown>
References: <F271C907-A2A7-4132-BA11-D33353AE9FFF@pobox.com>
	<20150407105230.4ff9a97a@notabene.brown>
	<CE6323D1-485D-4951-9E99-CBE5A09AE7BD@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/nKIl_gk+/yi.iVhVB621ZKq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE6323D1-485D-4951-9E99-CBE5A09AE7BD@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eduard Rozenberg <eduardr@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nKIl_gk+/yi.iVhVB621ZKq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Apr 2015 18:33:36 -0700 Eduard Rozenberg <eduardr@pobox.com> wrot=
e:

> Thanks very much Neil!
>=20
> I never do anything forward thinking like mdadm =E2=80=94examine before
> doing destructive things :). Unfortunately.
>=20
> I couldn=E2=80=99t figure out how to make the offset work so I used
>=20
> losetup -f --show -P /dev/sdac

Sounds like you are saying "I couldn't make the drill work, so I tried usin=
g a
hammer"... and then were surprised that you couldn't make any holes.

Try harder to make the offset work.  if/when it doesn't, report exactly what
you did and exactly what the result was.

NeilBrown

--Sig_/nKIl_gk+/yi.iVhVB621ZKq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSM4eTnsnt1WYoG5AQJa2w/8C+YnFFwudkPnm8OPN6g9CYgecMZBwFPY
o+2Jjn7yioD+tzVBY59KL4QltwrmIKi5B6hzyTQiafq5Dq4humPVRp4YI7XymYos
/wYotCZ0DydXVirYR+edcQAV0X+54WiVGzTkb2+p8FDlP+VncV3S5oNf/Xf+enbx
sOUDlRWkgyywcHikSt1tG0ogyAhWVE1XfHWC6tIfMGcnU3JBpI0emOhvR53zzZF0
6201Au87gxgkAm5kqTnhdg6HHJX8Ce0DwCWeGKzwpfc8Bl9BWru0LEnHJLiDOqxd
X5HbhgORZbG1kUMYYfzv0fZrNf47anEr4qLvZprbPlRmEFm9Ojdf31tGv12RBNe2
D9cXBHoItiRl0z4ITmI5WMfUEGLMOAxXxTE7y4d2vFQheHFjZK2WwOfbJYdLlMTC
2X81z8Bjm8CNfIo2qKoSwtCASQzi03VcG6FxPZ+xNqXDuUCVPcCjiIFV9+/7wuYW
sDWgSAFfRijTsfIT4i1TsaAG343FGc4q6AEWqz4uUe7cILUweZqNvkaiZ2tejvVm
y6MIugATTreSg2M/LTbTrGgUspVSeg3dX0MhFH7Rq8ppUQhAMH4ejcsNPAnHMrA6
6D52GEblL7cx4fSh2ulIUbwQq4oapAQawEWbh34G968SniVVI/lUH/SIY6pfwWij
9Ycyo0AsLg8=
=mLvY
-----END PGP SIGNATURE-----

--Sig_/nKIl_gk+/yi.iVhVB621ZKq--
