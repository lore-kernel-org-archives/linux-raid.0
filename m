From: Roman Mamedov <rm@romanrm.net>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 2 Jul 2014 15:52:24 +0600
Message-ID: <20140702155224.072d09ef@natsu>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xPzoLQL62zMV6Tm/AM2gvO_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/xPzoLQL62zMV6Tm/AM2gvO_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Jul 2014 10:32:41 +0100
Pedro Teixeira <finas@aeiou.pt> wrote:

> - I'm having the following problem on a raid6 md volume consisting og =20
> 16 1TB Seagtes SSHD's. ( using kernel 3.15.3 or 3.14.0 ) mdadm is 3.3.
>=20
>   - every time I run a fsck.ext4 I will get the exact same errors ( =20
> ...short read ). Forcing a repair on the md0 volume shows no errors =20
> and completes without problems. All disks are active and the volume is =20
> not degraded, still I can't get rid of the short errors on those 16 =20
> blocks and when the filesystem is mounted the read errors will come up =20
> from time to time as they are probably in use.

Are you sure that Ext4 in your kernel, and all tools that you use with it (=
such
as the fsck) really support 16 TB filesystems? I recall there have been some
semi-obvious problems with that. Try a different FS, e.g. XFS or Btrfs inst=
ead
of Ext4.

> - If I try to read those blocks with DD  ( dd if=3D/dev/md0  of=3Dtest.tx=
t =20
> seek=3D458227712 count=3D6 bs=3D4096 ) it will instantly create a 1.8T fi=
le =20
> but the file doesn't appear to have nothing on it ( and the file =20
> doesn't take the 1.8T on disk as the disk is much smaller )

> root@nas3:/# dd if=3D/dev/md0  of=3Dteste.txt seek=3D458227712 count=3D6 =
bs=3D4096
> 6+0 records in
> 6+0 records out
> 24576 bytes (25 kB) copied, 0.0019239 s, 12.8 MB/s
> root@nas3:/# ls -lah teste.txt
> -rw-r--r-- 1 root root 1.8T Jul  2 10:22 teste.txt

Here you need to use skip=3D, not seek=3D. See "man dd".

--=20
With respect,
Roman

--Sig_/xPzoLQL62zMV6Tm/AM2gvO_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOz1lgACgkQTLKSvz+PZwizxQCdH5I7GUhltXi2Fg3vVUc+LTEQ
7lsAn1E0Rwyhy8HdoFaQmTl1+OGlDNI1
=j+8s
-----END PGP SIGNATURE-----

--Sig_/xPzoLQL62zMV6Tm/AM2gvO_--
