From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 grow failed
Date: Mon, 2 Apr 2012 12:12:59 +1000
Message-ID: <20120402121259.4032d1ad@notabene.brown>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
	<20120328192601.3db82133@notabene.brown>
	<CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
	<CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
	<20120401080036.355a8a23@notabene.brown>
	<CAJ72viOGCYrMqvX2=3BzWQZpfDUeNwHEVHbXyaKbrwvrBP6wPQ@mail.gmail.com>
	<CAJ72viPw=QrETGPU5OwBgL-GXfCUfqfbWCSAvp2_yzzxuJeT1w@mail.gmail.com>
	<20120402095425.168e5d94@notabene.brown>
	<CAJ72viOU2O-1rsaJWKbDbR6XS+VYfDuWa8DpN=+w-1BYp7fwNA@mail.gmail.com>
	<20120402102600.4046c483@notabene.brown>
	<CAJ72viMHqGKhMTFDE0LqRZ_5hXm_3R8B9FZ92HPJHbv4BXsEDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ANjJjppwl0QLAbiWL2qQc6u"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viMHqGKhMTFDE0LqRZ_5hXm_3R8B9FZ92HPJHbv4BXsEDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ANjJjppwl0QLAbiWL2qQc6u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Apr 2012 20:44:17 -0400 Bryan Bush <bbushvt@gmail.com> wrote:

> my mdadm version is
> root@diamond:/# mdadm -V
> mdadm - v2.6.7.1 - 15th October 2008

That's rather old... I'm not surprised that it doesn't cope with assembling
arrays that are in the middle of being reshaped.

>>=20
> When I use mdadm 3.2.1 I get
> root@diamond:~/mdadm/mdadm-3.2.1# ./mdadm -A --verbose /dev/md1
> /dev/sd[onjlkuhedcb]1
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
> mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
> mdadm: device 8 in /dev/md1 has wrong state in superblock, but
> /dev/sdk1 seems ok
> mdadm: device 10 in /dev/md1 has wrong state in superblock, but
> /dev/sdj1 seems ok
> mdadm: device 12 in /dev/md1 has wrong state in superblock, but
> /dev/sdh1 seems ok
> mdadm: no uptodate device for slot 1 of /dev/md1
> mdadm: added /dev/sdn1 to /dev/md1 as 2
> mdadm: added /dev/sdo1 to /dev/md1 as 3
> mdadm: added /dev/sdb1 to /dev/md1 as 4
> mdadm: added /dev/sdc1 to /dev/md1 as 5
> mdadm: added /dev/sdd1 to /dev/md1 as 6
> mdadm: added /dev/sde1 to /dev/md1 as 7
> mdadm: added /dev/sdk1 to /dev/md1 as 8
> mdadm: no uptodate device for slot 9 of /dev/md1
> mdadm: added /dev/sdj1 to /dev/md1 as 10
> mdadm: no uptodate device for slot 11 of /dev/md1
> mdadm: added /dev/sdh1 to /dev/md1 as 12
> mdadm: added /dev/sdl1 to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 10 drives - not enough to start the array.

That looks a lot more sensible.
So that array expects 13 drives, but you only have 10.
You'll need to find at least 1 more (preferably 3 more) to have any chance =
of
success.

>=20
>=20
> Should I try to force it?  Worried it might make things worse.

force won't help until you find those other devices.

'force' is unlikely to make things worse.  It does the best it can.  The
reason that you need to actually give "--force" (rather than mdadm always
doing the best it case) is that you need to know that something has gone
wrong and so not to trust the contents of the array until you have verified
that your data is safe (most of it will be, but no promises).

NeilBrown



--Sig_/ANjJjppwl0QLAbiWL2qQc6u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3kLKznsnt1WYoG5AQLMTQ/9GJqch9yKe6ZDJefC1e0kHoKg9ewV8YZ1
4v/FwfaGnYrDkOQY50KLKMwDWG//rGSTrKXwVGXR6ryTCmDWMzth+i0NDokbAjYC
jRUHR1eRn5wkwsFpczLewelUviXGLtjlVv0HUhay9RcGz8KVHq1yi21XXUDAnBsy
LmHX+ksgcPYYonkVmuwz/37mOWcnRwIjFLdha3sL4xhcQmch5+HaZJX6wQNrLGkN
VIKjmC4fAqRa1RBHPheBs52OKBS9q7wVA5xeUvwrrmAId3HqtMD9S41bLt1BlBDY
wC9Czy7d6RapyTOIRLpItoZ94lHYripkBHPfCYfBSTZKDNiYg0pCDcsNqQUyrFoC
hR2G4ExBkJGXY6qlfncnjbQfPChYFmssKdQgWHCEYjtHd/+VCD7ackad0pfgBljz
UMeHm+EgQOfXRedLe9ZinnPho34pQ1IjMXnH+hnVvYkoe17QO8xssulEsI9B4/wG
3F8s/l0+yrgCuytmvpUYaR2nd6uRLkW2yVUJCBDnELNZh60ZB2aIH1GVVNNf1HNq
ZPlTV97dkl2qPqwFRvRkx6GffQCWCM4ElGWcN3lrrzUAoJ9eDbOWD67mVrHwQlsv
wb4M+goMo0taKMFmoShduLeJn/0OcmYF9k/9XxEwkWwOuG1xYksxWDJNrxylVopp
tsCsSWiVHPs=
=IOve
-----END PGP SIGNATURE-----

--Sig_/ANjJjppwl0QLAbiWL2qQc6u--
