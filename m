From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Wed, 11 Sep 2013 09:54:59 +1000
Message-ID: <20130911095459.086d532d@notabene.brown>
References: <52090E6D.10104@profitbricks.com>
	<20130813143115.55dd27d1@notabene.brown>
	<5209E37D.6050107@profitbricks.com>
	<20130814104410.10bb2259@notabene.brown>
	<520B3B39.4060703@profitbricks.com>
	<522EFDD1.3000708@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fCsZ.fzNQw/ovMxrBa_xOjf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <522EFDD1.3000708@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Jack Wang <xjtuwjp@gmail.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fCsZ.fzNQw/ovMxrBa_xOjf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Sep 2013 13:09:05 +0200 Jack Wang <jinpu.wang@profitbricks.com>
wrote:

> snip
>=20
> Hi Neil,
>=20
> I notice you send out pull request for md update, which include fix for
> this bug.
>=20
> I think we'd better include the fix to stable tree at least from 3.4
> above, what do you think?

I don't think it is a situation that is at all like to occur in normal usag=
e,
so it doesn't seem justified for -stable.

Do you disagree?  Did you ever experience the deadlock in normal usage or
only in artificial situations?

>=20
> md: avoid deadlock when dirty buffers during md_stop.
>=20
> > http://git.neil.brown.name/?p=3Dmd.git;a=3Dcommit;h=3D260fa034ef7a4ff8b=
73068b48ac497edd5217491
>=20
> BTW: It will be great if you could add my Reported-by and Tested-by:)

Sorry I forgot those.  To late to add them now.

NeilBrown



>=20
> Best regards,
> Jack
>=20


--Sig_/fCsZ.fzNQw/ovMxrBa_xOjf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi+xUznsnt1WYoG5AQIl6A/+LUbDOF8r7qR5ajyh5hyv4vbeOBFRh058
ffSTJ0McssZhj9M31f+5zW43RzrAJQnZhiQD8JiRy1ur4LUNZgA9osXub32nxFSN
Q4faN2yrWK3M+ZX763OjgC8Vk/V26onO5DeewLz0phITWYyU7Ur/XOwTfuw4T+jz
ADp42HRFyRp1P3DSTTxMfD7rOQnNTKaufUCNpwxkMTvs+kNyqwIbWtq6fNNZtFFv
+CFsJJp8uXYykoRseowbj5JfIVqd0jLge/JWKvY0E1Nk4i110B/omJeb/v8DdHFl
8dBBqTFxxoKFncvsOv1+RFvoHhdN2cKB4abROXJkKhNEpyZpxvyL+SaGf/OiKjot
ehmIzCfBfu0pf9gB+l2X9ckS/xtemKOp52GkGklXlHCoFB8wgQ9SjbwoAdnVv9pZ
T23pNmES34xJdejkWWR6lZDn461eGWTezBQzaH8zTImvyDi1sGZmdcPH4oFb6vD1
zWeDgZIzAcAStiiKdANODH8u3nz+z5G5d/Gz5/FSvkAYn7SexLAt9xjzkreE530a
Lq4bdWRtxXnDluN4Tq7iJMMTZIu9jb0XnNELO2vPxwRZ5vPq32sOCe1NqKnYdBHA
xWAT3O5apWPWaM31eWusYhCdGk2YY3+OlCjgXNs//AdYMRDCxoLDT2rtWBMiXo+5
LWO7amZ3U+w=
=XnSc
-----END PGP SIGNATURE-----

--Sig_/fCsZ.fzNQw/ovMxrBa_xOjf--
