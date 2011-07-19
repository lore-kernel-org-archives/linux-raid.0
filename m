From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: data corruption after rebuild
Date: Wed, 20 Jul 2011 00:12:28 +0600
Message-ID: <20110720001228.7d3d45b2@natsu>
References: <2073005.NH8LALaxuD@bloomfield>
	<4879002.CX4iSyfhxZ@bloomfield>
	<20110719224819.7aa5582d@natsu>
	<2015932.L0f6vYYk3Y@bloomfield>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BoqpXx7bGq1rxnE/+JA1ZR."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2015932.L0f6vYYk3Y@bloomfield>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Herrmann <morpheus.ibis@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BoqpXx7bGq1rxnE/+JA1ZR.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jul 2011 19:05:39 +0200
Pavel Herrmann <morpheus.ibis@gmail.com> wrote:

> > How it got there and how to prevent that from
> > happening in the future - that's a whole different question.
>=20
> would ZFS in raidz2 mode be much better than raid6+ext4? I understand its=
 not=20
> the topic of this list, but file-level checksummed rebuild looks like a n=
ice=20
> feature

Personally I prefer to not bother with ZFS, it brings way too many complica=
tions into software choice, and I just want to use my favorite GNU/Linux di=
stro and not Solaris, and also not trusting 12 TB of data to a third-party =
kernel module or a FUSE driver which are barely tested and have uncertain f=
uture. I'd put more hope in BTRFS RAID5, but that one is a long way ahead f=
rom becoming a viable option too.

Regarding mdadm+raid6, AFAIK it currently does not try to heal itself from =
silent corruption inside a single chunk, even though that should be possibl=
e with RAID6. On a repair, if the data chunks are readable with no I/O erro=
r, they are considered to be the golden standard and all parity chunks are =
simply recalculated from data and overwritten (also incrementing mismatch_c=
nt, if they changed). So maybe implementing a more advanced repair feature =
could give protection against silent corruption not much weaker than what i=
s offered by per-file checksumming RAID implementations.

--=20
With respect,
Roman

--Sig_/BoqpXx7bGq1rxnE/+JA1ZR.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4lyQwACgkQTLKSvz+PZwgTMQCfWxRJzCYbn71lqyWbBrOhPiYI
WDoAn2OFO6Ofsrm9leHTqDaSDnqmgeBa
=92YN
-----END PGP SIGNATURE-----

--Sig_/BoqpXx7bGq1rxnE/+JA1ZR.--
