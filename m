From: NeilBrown <neilb@suse.de>
Subject: Re: md metadata nightmare
Date: Mon, 5 Dec 2011 06:39:26 +1100
Message-ID: <20111205063926.3d42cd1e@notabene.brown>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
	<20111123114743.1085889e@notabene.brown>
	<CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
	<20111124093637.0c3bb2eb@notabene.brown>
	<CADzwnhXuW7ShBNGf+kqnZYrtRnWMPSRDWzb2h4Gt69Cih0-yGA@mail.gmail.com>
	<20111204061122.5bb5de4b@notabene.brown>
	<CADzwnhW+o69Dum10biobv8r093uUa+LABv71Jdg+obOt5Ev6+A@mail.gmail.com>
	<BLU0-SMTP331AF211B9C3D0D1799003C98B40@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zj2hsv98o=dzpjmCSUXoSzy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP331AF211B9C3D0D1799003C98B40@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: wilsonjonathan <piercing_male@hotmail.com>
Cc: Kenneth Emerson <kenneth.emerson@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zj2hsv98o=dzpjmCSUXoSzy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Dec 2011 17:31:06 +0000 wilsonjonathan <piercing_male@hotmail.com>
wrote:

>=20
> > So I finished my backup and attempted to recreate the array using:
> >=20
> > root@mythtv:/home/ken# mdadm -C /dev/md3 --metadata=3D1.0 --chunk=3D64k
> > --level=3D6 --raid-devices=3D5 missing /dev/sdb4 /dev/sdc4 /dev/sda4
> > /dev/sdd4 --assume-clean
> >=20
> > and received the error:
> >=20
> > mdadm: invalid chunk/rounding value: 64k
> >=20
> > What do I do now?
>=20
> Omit the "k" only M or G are allowed as the default is to assume K
>=20

Not strictly accurate.  'K' is allowed, though not 'k'.  But the default is
definitely 'K', so with

  --chunk=3D64
or
  --chunk-64K

should work.

Thanks,
NeilBrown

--Sig_/zj2hsv98o=dzpjmCSUXoSzy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtvMcznsnt1WYoG5AQLoCg/9G4jKdRZmwbLAa/evYNCEMirOMTSyD2Kh
Kj2KWqF15zRSscWTecDGDiwp8XJ3j6AExGUdagXvb/RI3QDx/2b+cLcPuHjX32Ph
jQINtgaZoMJwXA6AC5FZFyWY4AhO0sKEJaDYKsR2147kWr7r4431jhdn2RRfs1OF
TcJ9Ki6E6mMfnvG69nDnMyAVWrSDKQsc0QzJugmyMOP26Td8b21pA5TeLTE0M1Hr
VmdIXvj2dgTfuU7jlYAhDh65xxKxvPGecmKhg+BvntE9yvx+4P7Zevr7TLqwo4CF
jAHxTW4KIm7EgHEEEXHIpm42q8Yq4aPeM+k+q5iYO50fzY2uZEPfpL9XEsvvgwgT
eAcxKGPuMdtansgGWYjBIlUioFrP6fsiCNiRSciOcclZvw1bbKqJiPfHdtkGw7Kz
W5VnFjy8+uF4VeNyWUpU5/l2qjqS3s2lN5jw7hmKyJpZfuCcgx3yP2uJmPq912SN
TCSqXGkz0p/B7ixhLj6DHdMmoFQOjtdiIAMZ/iUL1OkpMCY8qhQT2pCV+71ZtMPo
I6kX7ib5yxP6z4wrDlwvNMgbYKRZVm5ACwgeznTJjD8bqHiQ0swo+R3YBCEb+fEG
Wq/M2WtTSoCM45KZJLqE5RxmA83xe+nhz/LBhyVgeClxvPVgwYbcKcSvOdys+FeB
YzkO1MO6Vqw=
=CSE3
-----END PGP SIGNATURE-----

--Sig_/zj2hsv98o=dzpjmCSUXoSzy--
