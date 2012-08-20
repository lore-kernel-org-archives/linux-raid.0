From: NeilBrown <neilb@suse.de>
Subject: Re: md raid6 not working
Date: Tue, 21 Aug 2012 08:34:02 +1000
Message-ID: <20120821083402.5e5b2fcf@notabene.brown>
References: <CC5802CB.287BB%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/A_kpSM/=Gx=YzsQmabWGan/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CC5802CB.287BB%michael.vanhorn@wright.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/A_kpSM/=Gx=YzsQmabWGan/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Aug 2012 19:06:17 +0000 "Vanhorn, Mike"
<michael.vanhorn@wright.edu> wrote:

>=20
> I have/had an 8-disk md raid 6, /dev/md0. At some point over the weekend,
> two of the disks suddently became marked as "spare" and the other has
> disappeared completely (at least as far as mdadm is concerned).
>=20
> All eight disks seem to be just fine, so I think the data is okay, and if
> I could just convince it to start the array with all 8 disks, I actually
> think everything would be fine. However, everything I've tried has come to
> nothing, and now I think I am stuck.
>=20
> Is there some way to just "force" is to change the two spare disks from
> "spare" to "active", and then let it go?
>=20
> Here's what I think are relevant details:
>=20
> The RAID is/was composed of /dev/sd[bcdefghi]1.
>=20
> /proc/mdstat says:
>=20
> # cat /proc/mdstat
> Personalities : [raid6]
> md0 : inactive sdc1[1] sdd1[10] sdi1[8] sdg1[5] sdf1[4] sde1[3] sdh1[2]
>       13674583552 blocks
>       =20
> unused devices: <none>
> #=20
>=20
> So, here, sdb is the only one missing. However, if I try to start the arr=
ay
>=20
> # mdadm --assemble /dev/md0
> mdadm: /dev/sdi1 has no superblock - assembly aborted
> #

What is the result of:

  mdadm -S /dev/md0
  mdadm -Avvv /dev/md0
??

NeilBrown



--Sig_/A_kpSM/=Gx=YzsQmabWGan/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUDK7Wjnsnt1WYoG5AQI46A/9Glz0rMCHOn8xXkkzo+LjTyh1ltezyYVq
pXM/4dYdPRRmXa+oicxEld675QF9hx6PyTMkKuLxiWVoIGFdRxSn2bfYMPoFyblw
YxlBiErAXb1UqNyrktXtmFn8+fZB0ewa7c4CF56e91/BPY0bqn9ANsZ5EGH44SmI
azmoEZFdSwStsaz1+vK8jcOlkVpa8dRgmwI0MuV65JXk5EgxkAzAXFkwowXHnHuy
xu8GI9uhcVsETONnFpO2K/Dhnm7UCbnEV7HeZgGi+mnh2joutNr5obaJ5kKqpTRV
CuNBT8hd7XclrR4KE2Mi3mxCSSZXVFQgOodQov2B9oHpWNETBydw5wRCSffdph2k
fbn9v6P3KCPCbmYMRgn3mrC/Ny/nllvXPOWy/ag7NwGjKWchxw2WCYt2V4DKSHlU
A8a0BVtwc6XhzC9yaxf6t5709krvG8gW2dIVObwUQIQizPvb9bEGgDWySu2s0GdO
riTY5UU1Aysx8H49kRjmNBd26j9hMyo/BZa2R+VsVVn2beQvgNrU924s95a/O5BH
jgb1okwOcYWBZT4VNotyWFxvZbyCsh3OO2ZnZnxorXPUGHB7pDGil70lrcVlnFCX
1bD7xKdG+XWjwLI6r4P+H5yWsjhb6/bMSZQQgnL3MU4nmkPq5rdIc+qQj7zExuvm
MLJIDQzSYqw=
=OV3j
-----END PGP SIGNATURE-----

--Sig_/A_kpSM/=Gx=YzsQmabWGan/--
