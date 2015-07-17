From: Roman Mamedov <rm@romanrm.net>
Subject: Re: degraded raid array with bad blocks
Date: Fri, 17 Jul 2015 07:09:25 +0500
Message-ID: <20150717070925.5b0246f1@natsu>
References: <55A7F47D.1020004@fabianfischer.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Gv=8UOXU/nO_jG57t=t597Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55A7F47D.1020004@fabianfischer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Fabian Fischer <raid@fabianfischer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Gv=8UOXU/nO_jG57t=t597Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jul 2015 20:14:21 +0200
Fabian Fischer <raid@fabianfischer.org> wrote:

> After booting, the removed disk wasn't re added to the array (maybe
> because of different event count). --re-add doesn't work.
> So I used --add.

As to why --re-add didn't work, I *just* had the same situation, maybe you
needed to do 'mdadm --remove /dev/md127 faulty' first.

> Because of the bad blocks on one of the remaining disks, the rebuild
> stops when reaching the first bad block. The re added disk is declared
> as spare, 2 disks active and the disk with bad blocks as faulty.

One course of action is to use dd_rescue to clone the disk with bad blocks =
to
a new clean disk (skipping the bad blocks as you go -- you will lose some
data), then assemble the array with the new disk in place of the cloned one=
 and
proceed with trying to rebuild. This  time it will not have bad blocks, but
will have just zeroes at those locations, so rebuild should complete
successfully. After the rebuild completes you should fsck the filesystem and
check file checksums (if you saved them), to figure out where the damage
actually landed, and restore those files from backup.

--=20
With respect,
Roman

--Sig_/Gv=8UOXU/nO_jG57t=t597Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWoY9UACgkQTLKSvz+PZwi7/ACeJJ0bHZNMBoWET7qC5gzx7rDf
CRUAnRzmL9PdJ3qQUYGD5oLZIQYvpuV0
=WZlM
-----END PGP SIGNATURE-----

--Sig_/Gv=8UOXU/nO_jG57t=t597Z--
