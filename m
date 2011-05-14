From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 18:06:27 +0600
Message-ID: <20110514180627.23f75ba0@natsu>
References: <20110513202900.GA1926@apartia.fr>
	<20110514073347.15dae0b8@notabene.brown>
	<20110514082159.GA306@apartia.fr>
	<20110514215821.58f49455@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CM1mM=uK5UJa7kApYYb7+Z2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514215821.58f49455@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CM1mM=uK5UJa7kApYYb7+Z2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 14 May 2011 21:58:21 +1000
NeilBrown <neilb@suse.de> wrote:

> If you don't have ext3, then you probably need to backup and restore - I
> don't think other filesystems support shrinking, but I could be wrong.

Well, ext4 does support shrinking as well.

And btrfs, it has both online shrinking and growing.

XFS, JFS can only be grown, not shrinked.

--=20
With respect,
Roman

--Sig_/CM1mM=uK5UJa7kApYYb7+Z2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3OcEMACgkQTLKSvz+PZwg+bgCfRx1hfJPlJpDx7DGaWfHzzhQ8
6v8An2qCzjbTTib8Qbp8UFiU0vCPTBtn
=s6hU
-----END PGP SIGNATURE-----

--Sig_/CM1mM=uK5UJa7kApYYb7+Z2--
