From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Recommendations for RAID setup needed
Date: Tue, 15 Sep 2015 23:57:31 +0500
Message-ID: <20150915235731.5fcc5f79@natsu>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
	<55F85E9F.1070100@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AOpGwkPk=acgfUDkNeRVPrA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55F85E9F.1070100@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Alex <mysqlstudent@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/AOpGwkPk=acgfUDkNeRVPrA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Sep 2015 19:08:31 +0100
Wols Lists <antlists@youngman.org.uk> wrote:

> Throwing something completely different into the mix, how about
> considering btrfs? It's not 100% solid yet, so you need to be careful
> with it, but if you back up with rsync and the "in place" option, it'll
> give you full backups for the cost of incremental.

However its RAID5/6 is not ready yet and even RAID1/10 lack some important
features compared to mdadm, not to mention performance optimizations.

On the other hand I have a great success running Btrfs without utilizing its
own RAID features, but as a regular filesystem on top of MD RAID5/6.

> What you MUST do is KEEP AN EYE ON DISK SPACE! The main failure mode for
> btrfs I'm aware of, is that a disk full can cause a fatal error. As in
> "I've just trashed the disk - it's 'format c:' time". So if you hit 80%
> or so, alarm bells should be ringing. Very loud.

And this is just an absolute deranged baseless FUD today, or maybe something
that might have been true about 5 years ago -- eons in Btrfs development.

--=20
With respect,
Roman

--Sig_/AOpGwkPk=acgfUDkNeRVPrA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlX4ahsACgkQTLKSvz+PZwiXPgCfflC3QOM84+oC8Pz3CnQXFiko
0/4AniNaEjRNDKuD2vekDciS2jZY3JOK
=hW5j
-----END PGP SIGNATURE-----

--Sig_/AOpGwkPk=acgfUDkNeRVPrA--
