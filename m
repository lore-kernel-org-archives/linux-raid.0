From: NeilBrown <neilb@suse.de>
Subject: Re: Data scribbling for raid6 is wrong?
Date: Thu, 15 Dec 2011 15:27:23 +1100
Message-ID: <20111215152723.1d2bcca0@notabene.brown>
References: <CAAV8rnKoga_DM1qh28ZGEsJMZAKPYDZcVFfLBSH9kPNHysf7LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.DAPd5Bkc8_=H8jpPY50reT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAV8rnKoga_DM1qh28ZGEsJMZAKPYDZcVFfLBSH9kPNHysf7LQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tao Guo <glorioustao@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.DAPd5Bkc8_=H8jpPY50reT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 11:15:42 +0800 Tao Guo <glorioustao@gmail.com> wrote:

> Hi all,
>=20
> Today I checked the raid6's scribbling code, and I think there may be
> some improvements to handle bad sectors:

I think the common term is "scrubbing" rather than "scribbling".

>=20
> If we have one bad sector(with corrupted data) in the data block,
> scribbling thread will find parity mismatch and will try to
> recompute&rewrite P&Q, but that will cause final data loss.
> Since we have P & Q,=C2=A0 actually we can try to use them and find out t=
he
> wrong data block then fix it.
>=20
> But the algorithm to find the bad data block seems not
> straightforward... Does anyone know if there is any paper discussed
> this issue before?
>=20
> Update: I just found there is one talk about this in FAST08:
> http://www.usenix.org/events/fast08/tech/krioukov.html.
> But that approach will add checksums.etc. For bare-bones raid6, does
> any guru have any better ideas?

http://neil.brown.name/blog/20100211050355

NeilBrown

--Sig_/.DAPd5Bkc8_=H8jpPY50reT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTul3Kznsnt1WYoG5AQIHvxAAs1OrcLmFOjdyEVN8ZYsawDT51CjT4qYt
M7NLuZsNdx2A4BbYRXPRtkwdCzmAtzY+vzt4IEQyD8JBrg+MKPdqiUH8F3qpsPUT
4V/QNmcliPxP/zK9wLAklODoe/TMsk/jnKQ4hIOS+8LhEbzMp2lMMeYWYcmQt8+v
0gGmI0yjlNuVlO68C9Cdyezf+0OUGMn8uPn9YtWEy4CYl7yHmyRNNYHyct56Vljb
3lFcyFGtCne6mz17zvOdgzoo1gDBbPdY50hJhoFanuU/Tbf8sn2cUaKMLG4JJI5q
TBGDBrcvLUNkHA7onTcZOsgX9MuVudDOY6Dsyh1gxsUGudRGIS2s9o2p6NRdleG4
ETKxwfCjD+fRc71+3DKxQ2PJEEP/AjGPrRHXpArU541yv+S00VWE9onHhTC9/LAg
PP0IKZH5+xXmvfp9swl6mffHfjRvjn/t9t+TeQK9ex2Zb9M7AYWPBwdTn66GkgVb
xWCRfLG0pRLpzICH3NVzFUQLpc1QxgqJIh4ixodtSVMZE7cmp56R3c19Co0q3Xlw
fYZBG5UY9ExPjenMRpPO+g8mX3T0OBGiEIkcf7pSyiqm4R3Oba5eAmY/CSLfG6TP
STkrY6qZWbNnmv5xHhdDM902Lgbm8KTj/y+4ajg7xE2djOmILchp44Alkk+EQv4J
E44uYssTmHw=
=Orl+
-----END PGP SIGNATURE-----

--Sig_/.DAPd5Bkc8_=H8jpPY50reT--
