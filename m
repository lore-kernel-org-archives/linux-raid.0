From: martin f krafft <madduck@madduck.net>
Subject: Re: Speeding up reading with RAID1 and --write-mostly
Date: Sat, 13 Sep 2014 18:23:01 +0200
Message-ID: <20140913162301.GB14969@fishbowl.rw.madduck.net>
References: <20140913060143.GA15849@fishbowl.rw.madduck.net>
 <CAH3kUhGEaon77fpNm2mjRwPbNMZe9BLK3eA6LTB4xQeg0hMF-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH3kUhGEaon77fpNm2mjRwPbNMZe9BLK3eA6LTB4xQeg0hMF-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Roberto Spadim <roberto@spadim.com.br> [2014-09-13 13:56 +0200]:
> Try a bcache or something like it

The problem with a cache is that the data have to be read once from
the slow disk anyway, whereas I am proposing to keep a shadow copy
on rotational disk, really, just in case the MMC may need to be
removed at some point.

--=20
@martinkrafft | http://madduck.net/ | http://two.sentenc.es/
=20
"a fundamentalist is someone who hates sin more than he loves virtue."
                                                     -- john h. schaar
=20
spamtraps: madduck.bogus@madduck.net

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQLvBAEBCgDZBQJUFG9lwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xKeS
EADKce7sp3JAniZ/YkZip3XGIKUBRsbi7fDgT0ceRzvZangTtfLZTmlNBhp/2O1W
yLGAcF52OrJKXmPLMh9B/+hA9iphrW3fvp19MJkai51LuzhrbAqaK0CjuDbeYzdJ
fs3SRhPkj5KSEdLIMRCskzDulv6HwpTZjN6RgSKpY4L5bq1B+fkAJBC+o2f+jU/9
4bSlww3De1VnFhPbueqpBXZBsuQpr0U+IKzsjCJwu07iLNnPEcOLOKY0eUEe+rcP
Tu536pb0V0Ggg90NnHRhJd5hJc1XZBTHteq0zKbbGubaJjVJrW7LBj/ThF9MvEg4
POzGm+dEMq5f9BNU/a4qduvMkyc3eePSnmCDxVn1A4l6Hugq5TuJSFhgUtPsDaXm
GeAJLQmbg57C4rnIW158lOkr5mgC7vFs8bkrTMEozB02ZluerLmfAWKzh3svk3bt
9XhfcEJ1BIeC9vEV7XrXAqvca1LnUBkwwnJlhxx3kTl6Jgte3LrpqwX9pQ4sgBl7
19T5+BGoXBaA/qtIFu164q7MkiZM36olp94XH7FizLjk3wpenlpAeLYbNpyPHfsF
R4dMaRG6/RFAkjUmtlwN/FMjlCDLR4niwVwKJV8mYAa1Liut0grGCCQFk9ncPf+M
XOAUXkz1oih6mR/TyNkfAHK5WMhUhQo34vHLPJUoTWwrFQ==
=KOL3
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--

