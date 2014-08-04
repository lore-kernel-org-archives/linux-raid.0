From: NeilBrown <neilb@suse.de>
Subject: Re: Status of Tripe Parity RAID
Date: Mon, 4 Aug 2014 11:07:52 +1000
Message-ID: <20140804110752.09fe58ae@notabene.brown>
References: <D00269CC.3E6BB%ronnyegner@ronnyegner-consulting.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/HVFtXPJCjHKbyBDtpfRCAog"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D00269CC.3E6BB%ronnyegner@ronnyegner-consulting.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ronny Egner <ronnyegner@ronnyegner-consulting.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/HVFtXPJCjHKbyBDtpfRCAog
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Aug 2014 08:11:31 +0000 Ronny Egner
<ronnyegner@ronnyegner-consulting.de> wrote:

> Dear All,
>=20
> i would like to ask about the status of Tripe Parity RAID.
>=20
> I=C2=B4ve found some posts on the list from Andrea Mazzoleni dating back =
to
> 2013=20
> but after that nothing seemed to be moving.
>=20
> If this is currently not on the wish list i would like to add that as
> Feature Request :-)

If you want wishes fulfilled, you'll need to find a genie.

>=20
>=20
> Thanks Neil for this great piece of software.

Thanks, but of course it isn't just me.
RAID6 (i.e. double-parity raid) is a good case in point.
That was developed and tested and pushed by Peter Anvin, not at all by me.
I eventually merged his separate raid6main.c into raid5.c and then merged s=
ome
of the functions.  So I did some "maintainer" stuff, but didn't do the
development.   It is likely that Triple Parity RAID will only happen if
someone else steps up like Peter did, because I'm really not that intereste=
d.

So we don't need feature requests, we need code submissions.

NeilBrown

>=20
>=20
> Mit freundlichen Gr=C3=BC=C3=9Fen
> Ronny Egner
> --
> Ronny Egner
> Oracle Certified Master 11g (OCM)
> =20
> EMail:      ronnyegner@ronnyegner-consulting.de
> <mailto:roonnyegner@ronnyegner-consulting.de>
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/HVFtXPJCjHKbyBDtpfRCAog
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU97c6Dnsnt1WYoG5AQKmfA//fm12kvr6Jw7VXhslDECtaoBH6s5wLFuZ
5my6ZvvjSN3kmPj/hbMmHiAHCvfyiKlHwgkwUlBMcOfAUPLdGoAN0vX7RPttUuGg
FMVBn1pejMQfiWoHsZLAZhvMXmaQhMVeSiovrkJblbK3Y8mPx6hfOOWBEJ2Ry3eo
M6ZVDSKUsoyhSrYHHPUfeVWcu+FzCw+rzwA/ZGLhuOEOeG0i+4+9zlKtQTzbNagA
FyDfLUhoARJKVVIyVypeRjjgUExmjv70Oct0xaDMmU61WETJDpkhCD53bonjXFxp
X1Ecetn4bdUKxARX0WR851nixbqJj6+MJ6TjfvxLj9Cnlk0AWyvriky+JeMV12+h
XMIET7gc63z4VHQQlZ17cCTobiFAU8afK0k84wtVzdjIbj/Rm3iMzUOxpzKdOhW8
gs7RzeZmS5BgcxZAcSMtb7N7sQWfCqCpjXAuZ1pqbAHGTFdKblCG2yCLM1V8AHCm
pw9NR8jLjhcxjVL1ofwTaX55sJZ3sNqI7rvFnSuTTyGvejLCzDa7Jyr/X/i1dwKK
mpJ7qFgnT7dQyyqVLPsN9V2+07elLjJ6YxcIO6KbOpejXB0AYeiw75bnYddYlDtN
0WluED5vJLz0SfQLPNm2qc14/qm9eIs2TTnzNqbVJO5/bx3n8RmE3hkhFA46J6eB
Spm2aNH8glY=
=fKdj
-----END PGP SIGNATURE-----

--Sig_/HVFtXPJCjHKbyBDtpfRCAog--
