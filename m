From: NeilBrown <neilb@suse.de>
Subject: Re: Help with corrupted MDADM Raid6
Date: Sat, 14 Jun 2014 20:31:46 +1000
Message-ID: <20140614203146.5e99a84f@notabene.brown>
References: <CAH4F3SZ4Q8MO5Ci8ihSrLf1myo8pTfJ8SNC5EwJZQHf_H44GPA@mail.gmail.com>
	<20140613202541.584dc8f1@notabene.brown>
	<CAH4F3SZm-Va4a-2ac0E-_GHde0Vcqgrw0xs0GPn+hBkTjnsL9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Upcm7f_RYwqh0HoeuOZbNvT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH4F3SZm-Va4a-2ac0E-_GHde0Vcqgrw0xs0GPn+hBkTjnsL9Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "ptschack ." <ptschack@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Upcm7f_RYwqh0HoeuOZbNvT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 Jun 2014 11:54:58 +0200 "ptschack ." <ptschack@googlemail.com>
wrote:

> Hi Neil,
>=20
> I ran mdadm --examine on the devices (as opposed to the partitions)
> and was surprised:
> Apparently the superblocks are present on some the devices, even if I
> remember differently.
> I attached the output of mdadm to this mail.
>=20
> For the sake of clarity, this is how the raid looked like before it
> all went wrong:
>=20
> 11 Drives (/dev/sd[abcdefghijk]) alltogether as a RAID 6.
> 2 of those are spares (/dev/sd[jk]).
> 1 is either close to failing of has failed (/dev/sdg).
>=20
> I tried
>=20
> mdadm --assemble --run /dev/md0 -v /dev/sd[abcdefghi]
>=20
> which gave me
>=20
> mdadm: looking for devices for /dev/md0
> mdadm: no RAID superblock on /dev/sdg
> mdadm: /dev/sdg has no superblock - assembly aborted
>=20
> So it seems I somehow have to restore the superblocks on drives
> /dev/sd[ghijk], or at least on /dev/sd[ghi].
> Is this possible? Any help would be greatly appreciated!
>=20
> Regards,
> -P.

Well, you've definitely made progress.  You've found 6 of the devices.
They all look consistent and it appears the array was completely coherent a=
t=20
    Mon Jun  9 21:52:48 2014

You think that the 7th device is dead or dying, so you just need to find 2
more (1 would do).

Presumably these are sdh and shi, but it is very strange that we cannot find
the superblock on either of them.
When was the last time the machine was rebooted prio to the date given  -9th
Jun?
Do you have boot logs from that time?  What lines contain 'md'??
Particularly "bind" lines will show you exactly which devices were included.

Maybe also try

  od -x /dev/sdh | grep '4efc a92b'

If the superblock is at some strange location, that might find it.

NeilBrown


--Sig_/Upcm7f_RYwqh0HoeuOZbNvT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5wkkjnsnt1WYoG5AQKzYw//RLMNeYVD1s+Cr5Kgb+BVO0K5EIKDAzXO
GEbXGRVY/EVvOwYCrqbv7wO225ZeTUQLdwLwyEUxn+fenNcgRNIOj2PcWNgVLo/x
3EotEY8ZtkalNVg+07N7sN6mPlqptSaDUxkF1CXyGoSgm09mbGvp6gv9AUBaXIor
NAMsOSasYxMuNVvjjFWML3sJb8PvQCFRzSwyU0uZUHLGzeuupUcrV8EtHMvppHCY
o0C7/71SSmAQVzmFxYWyu+8yd6rI+yM8L9/UwKtDjLfKf6efmFdzu8E572NG8PQD
AKCFgvmk9IZM6WT8Bl6yqdTQ4DHhV9aIikItkRMuGEnr5t91mQ07jZXOvYflWOOy
Jo5c2uhK+p2fexCsgq0W3SOvfXBfqn6UdggwcPtHGgj/XaX4oYwB3avp/16/05GO
ZncZ+iTI92VQKnOMcqWLYE+Ouhjf+x2o4499TUFthUZ1NRHFJ0fEkt4lE2edJKg/
SQ0mOlm4+t44VjH8mx9ZPvmmMlm3Vz6Rkjyzjrptw+/ge2JhO7DnjdkY6mkrdWgH
GxyMvnXUjKH9IOmDSt6S92iPhqpbJv3HbdXweM21+gqbk5wntyM3EvOrR3vpMLAQ
4wTltLYCUSTLFfm3HymBFcLHvRYN1No+dSVu9UhLilZ+Kzj1PgyUcTkPNHJ7KDis
0PGPZqo/Vwc=
=ed5l
-----END PGP SIGNATURE-----

--Sig_/Upcm7f_RYwqh0HoeuOZbNvT--
