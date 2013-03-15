From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having
 alive mirrors?
Date: Fri, 15 Mar 2013 12:02:57 +0600
Message-ID: <20130315120257.60735a6f@natsu>
References: <20130315041054.79eb5dcc@natsu>
	<E8003AD2-CDB8-4007-A80C-D95350144C90@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fW8LXeICxypcB45LcC2smkt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E8003AD2-CDB8-4007-A80C-D95350144C90@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fW8LXeICxypcB45LcC2smkt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Mar 2013 22:04:17 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> 2. sdg is encountering UNC read errors, probably bad sectors, why it's ne=
w right?

It's not new, in fact it is in a questionable condition, but that's not the
issue I am looking for help with, in fact I am glad if me using this disk
suddenly helps uncover/solve some bug in mdadm :) I doubt it receives too m=
uch
testing with regard to its behavior in such rare circumstances (encountering
bad sectors on a member configured as write-mostly with btrfs on top of
everything, etc).

> 3. md3 might be getting the mirrored copy off sdf, I can't actually tell
>=20
> [  771.438945] btrfs: bdev /dev/md3 errs: wr 0, rd 9, flush 0, corrupt 0,=
 gen 0
>=20
> That line is btrfs reporting read errors from md3, not corruptions.
>=20
> [  771.439011] ata11: EH complete
> [  771.439035] btrfs no csum found for inode 31016 start 5668864
> [  771.479594] btrfs csum failed ino 31016 off 5668864 csum 2731683453 pr=
ivate 0
>=20
> What are your btrfs mount options? Are you using nodatasum or nodatacow?

rw,noatime,nodiratime,compress=3Dlzo,ssd,discard,space_cache,inode_cache

--=20
With respect,
Roman

--Sig_/fW8LXeICxypcB45LcC2smkt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFCuZEACgkQTLKSvz+PZwg4tgCfYzwt5/5C0IYAPSqhJlP5Juzv
Yj4AoIycUtlCkdNormtbs4LsTR6bFnaC
=w7PP
-----END PGP SIGNATURE-----

--Sig_/fW8LXeICxypcB45LcC2smkt--
