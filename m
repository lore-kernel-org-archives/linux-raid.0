From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] md:Rewrite the md_write_start().
Date: Mon, 4 Jun 2012 11:12:18 +1000
Message-ID: <20120604111218.7cdfd138@notabene.brown>
References: <201206021616382814001@gmail.com>
	<CAA9_cmd9CBe+GGduR7oiUvfDZagx=5NiTTUrG-HVmdqQYK_4xA@mail.gmail.com>
	<201206040903521250721@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/71qhlZ0q34IkFyVSo00oAGK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206040903521250721@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/71qhlZ0q34IkFyVSo00oAGK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Jun 2012 09:03:57 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On Sun, 3 Jun 2012 14:11:41 -0700, Dan Williams wrote:
> >On Sat, Jun 2, 2012 at 1:16 AM, majianpeng <majianpeng@gmail.com> wrote:
> >> Remove the judgement "bio_data_dir(bi) !=3D WRITE" in md_write_start()=
.Put
> >> it before call md_write_start.
> >>
> >> Signed-off-by: majianpeng <majianpeng@gmail.com>
> >> ---
> >> ?drivers/md/md.c ? ? | ? ?4 +---
> >> ?drivers/md/md.h ? ? | ? ?2 +-
> >> ?drivers/md/raid1.c ?| ? ?4 ++--
> >> ?drivers/md/raid10.c | ? ?3 ++-
> >> ?drivers/md/raid5.c ?| ? ?3 ++-
> >> ?5 files changed, 8 insertions(+), 8 deletions(-)
> >
> >If the deletions had outnumbered the insertions then maybe, but I
> >think just like kfree() allowing NULL pointers it's cleaner if the
> >caller need not worry.
> >
> >--
> >Dan
> The patch had a anthor reason: first check,if read so not call function.
> Call function takes long time than check statment.
>=20

This is micro-optimisation that really isn't worth spending any time on.

NeilBrown

--Sig_/71qhlZ0q34IkFyVSo00oAGK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8wLcjnsnt1WYoG5AQKdsw//ePApnIH7gMOtOs5XEZ7z5YLicl0T6/Yh
dOMEanGDN8Zh88RMjYLWyfpbwv+mLmg8A2Yzh4mbqr16u+eEjzuZVLCpXsR1YwLA
APJtnhOsZaJMdOP5yjtuzehIEba8bs/TyGwen7XqaWx5lGMKRmlC5Nd7dBdEyH8Z
qVJ3nP1FY2MFfEl/5HDRB99thVD9pW2xBlVvd4AyJVtYqtbqerU5tolB56cuMLSV
PDbT5E7FcJ7InQ69mnI8hEaPN+J17P2yACunCmiWAAg86Auo19i5xGDjaLxaRsKW
8pwb0yj7MNLnTjEnTeGzzcvYptX5lrEbKuXNj1sPhD+cPxly5JSLw2mtnhCKOk2t
yk7QQzgfPYwffAvSiHNG5X5bIrbfkrNlTJ/Jg0ZGM2sqYyCWhuP0uHBNY1STn3PX
3isfTGOrKo6LssqnN8cWivDaIW+oi3nFsDPXr+OFoVouzq9tggasCeIrTaDdua0e
+v79fssvGXndKOQ5SB7GPWt1E1iaNd9v7uvKpLTJcn4a20OMXO0+JHce0sBr73n1
tdTN0QZ9iKOAN3Q2F9AUBR1j3FRL9tCyZ5xSSxtX4qfTGX4u8PosFbv6MtgTkCUv
MjBEy+bTfdp7AmnBQJWSIWd/JQy6qNjlGVgWy8eoad2VF8HAr10LhCY7QdHuhFdo
Fk6gxE91Y+0=
=2Gvv
-----END PGP SIGNATURE-----

--Sig_/71qhlZ0q34IkFyVSo00oAGK--
