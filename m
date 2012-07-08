From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 superblock and filesystem recovery after re-creation
Date: Mon, 9 Jul 2012 08:13:58 +1000
Message-ID: <20120709081358.199630c8@notabene.brown>
References: <CA+=meHXO02k4hSJihNFiYXb+LOjik_LX3n8UZbqERC2tYy+L-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b+YI4YTPowWU6SexmnwCN4f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+=meHXO02k4hSJihNFiYXb+LOjik_LX3n8UZbqERC2tYy+L-g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Schleifer <alexander.schleifer@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/b+YI4YTPowWU6SexmnwCN4f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Jul 2012 23:47:16 +0200 Alexander Schleifer
<alexander.schleifer@googlemail.com> wrote:

> Hi,
>=20
> after a new installation of Ubuntu, my RAID5 device was set to
> "inactive". All devices were set to spare device and the level was
> unknown. So I tried to re-create the array by the following command.

Sorry about that.  In case you haven't seen it,
   http://neil.brown.name/blog/20120615073245
explains the background

>=20
> mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-disk=3D6
> --chunk=3D512 --metadata=3D1.2 /dev/sde /dev/sdd /dev/sda /dev/sdc
> /dev/sdg /dev/sdh
>=20
> I have a backup of the mdadm -Evvvvs output, so I could recover the
> chunk size, metadata and offset (2048) from this information.
>=20
> The partially output of mdadm --create... shows this output:
>=20
> ...
> mdadm: /dev/sde appears to be part of a raid array:
>     level=3Draid5 devices=3D6 ctime=3DSun Jul  8 23:02:51 2012
> mdadm: partition table exists on /dev/sde but will be lost or
>        meaningless after creating array
> ...
>=20
> The array is recreated, but no valid filesystem is found on /dev/md0
> (dumpe2fs: Filesystem revision too high while trying to open /dev/md0.
> Couldn't find valid filesystem superblock.). Also fdisk /dev/sde shows
> no partition.
> My next step would be creating Linux RAID type partitions on the 6
> devices with fdisk and call mdadm --create with /dev/sde1 /dev/sdd1
> and so on.
> Is this step a possible solution for recovering the filesystem?

Depends.. Was the original array created on partitions, or on whole devices?
The saved '-E' output should show that.

Maybe you have the devices in the wrong order.  The order you have looks odd
for a recently created array.

NeilBrown

--Sig_/b+YI4YTPowWU6SexmnwCN4f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/oGJjnsnt1WYoG5AQKZ1g//Wchlvow8EGcVa6nyvSMweWc86HKKOZQE
YKvi3pKo4tjbfdu28YFqAThOroFQasuhDRX1gscLdQ5EOv3wEKduIjoxpbnf0QIE
8rsTMv/miNdNrciLtsBPKBaIyF/bXfWk4YTwdqUAi/CZE8GAVcLlhYeVqMvstD3G
coG8CdJhflHShUyfhTo5x6Lib77pBXqnY39VskP4hxiDA1rVE4JRgufeyVxgumAK
kpbSUlqZU8Voau9qpigkaLMlAoNigh79G1dpb2Kw5RHW4f9xieozuW4iWLSEV5pP
LHCqG3vCpznad5VZJ8OnzL2wrQsTeoEjlkQ2zRphvX4yxjVN88tQ/VJDVWS473DA
orJRE1GJsP7dY50gOzRX/dN6EjzcnvRJifEaVomgev5Z+dK48rP/egVINhHB8Hms
R8VrgtGQ4Di3+dSRJL4tSo+ehxai/lS79dl1bz1w8ibgFViDwnRNvJaruLK3NevK
h0hpbu4lR3faioa4iD2fKN3CDUMgN5IDGxjn4daq8BJYOtQpEVy0gQPn8JEndjSV
zFz2D95W+/7OUAHEnbiRQLHZzXmJmoc8bNhI227JXcFd6MSOa4Wr08fPs/6U3GTk
zoeYH1AMJm+whGP9QxRF8LG8j+vNCNvm8r1RRixwSN3gin0l2inQuDh9w6A8qn22
eAMiDp/BBik=
=v3y2
-----END PGP SIGNATURE-----

--Sig_/b+YI4YTPowWU6SexmnwCN4f--
