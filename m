From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 to raid6 - reshape very slow
Date: Tue, 29 May 2012 10:56:19 +1000
Message-ID: <20120529105619.4dd15511@notabene.brown>
References: <4FC41970.5080009@infinitedepth.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R95JdjpxOIB/rnvnBG7NT1r"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC41970.5080009@infinitedepth.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Molyneux <jonathan@infinitedepth.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R95JdjpxOIB/rnvnBG7NT1r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 May 2012 10:33:52 +1000 Jonathan Molyneux
<jonathan@infinitedepth.com.au> wrote:

> Hi Everyone,
>=20
> I'm currently reshaping my raid5 array into a raid6 array (by adding a=20
> spare and growing).
>=20
> Unfortunately I didn't research the nuances before doing so and missed=20
> the opportunity to --layout=3Dpreserve.
>=20
> As a result the array is rebuilding by use of a backup-file, at a rather=
=20
> slow pace.
>=20
> md1 : active raid6 sde1[0] sdb1[6] sdh1[5] sdc1[4] sdg1[3] sdd1[2] sdf1[1]
>        7325679680 blocks super 0.91 level 6, 64k chunk, algorithm 18=20
> [7/6] [UUUUUU_]
>        [=3D=3D=3D=3D=3D=3D=3D=3D=3D>...........]  reshape =3D 47.0% (6894=
13888/1465135936)=20
> finish=3D4126.9min speed=3D3132K/sec
>=20
> I have tried the following so far:
>=20
> * read ahead tweaking
> * stripe_cache_size tweaking (not a limiting factor - mdadm seems to=20
> tune this appropriately)
> * running the backup file from dev/shm (only for testing purposes)
>=20
> The reshape does not seem to be IO or CPU bound, it just seems to be=20
> limited by the sync's and meta data updates to each disk.
>=20
> Is it possible to increase the buffer/stripes that mdadm process in a=20
> batch to speed up the process (~41m/2 -> 1G) ?
>=20
> Any thoughts would be appreciated (even to confirm there is nothing to=20
> be done).

The only thing to do is to wait.  This is very much a seek-bound operation
and there is little room for making it go faster.

In a few months we might see the need for the backup file disappear, which
will improve things somewhat, but it will still be slowish.

NeilBrown

--Sig_/R95JdjpxOIB/rnvnBG7NT1r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8Qesznsnt1WYoG5AQLOVhAAjoF8XFROpz+/IA+w0ja/NfddBdPEUwCz
TMTrOfRXSZBK0vQ99TRnzvRD2fFhg4TTPlpidoz3575FVo6YUhH0dkqOKTGEHSZC
sy/ZuMUCBdU9Wb5k67PedD6PcObtXgW6EyqZaS6LOBh62AoyupXx+ohheVU6BLVR
bg5YS+9NSqS8TloFzosqy/4k3WNdxDKl0QsTebjU5zmpIb7GrmUo2hNIy6jywOEX
RB5HUfuwEomT5RkKovW5DMojVld8c1CWtLNb/778on2Ss0gBQcXD8/kJszWF3AqN
150swoMtdvKxeyxCKi8gxyZq2rN62NPIDLHBVHxA1IgpfnkXRO/MNXENel0iWkMR
Zq7LWrWgOLyyUcnfdVgH1ZyEkbIXLdyv25FJHuGfkm+K+8A92s/UXZVRwWSmwQ1e
zgvCvYpkY+juxKDSQfLy+VyA0XRAxH+ROHyrvPwMn3HqcFFoIc3DTnINLcNHaUxa
7zSX495LXbjg+1jMhLfEvEyE55crJ+bYd64sIOFUAGUvjcDinEPsTbYXPLSlBqCw
z6U03b3m24y41sUaNXbGWmgd1AN4NRsIA/T36Eo7UKmk7y2GZkowuHr6lV0//9+l
ztASTr2YIifNmA1Ah8LY3Ous6eCwKK3gO4EbkXXMSjkBrnIFK8JDGXnTzfuNWi+o
drkCiQ21boI=
=YH8i
-----END PGP SIGNATURE-----

--Sig_/R95JdjpxOIB/rnvnBG7NT1r--
