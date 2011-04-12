From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Growing 6 HDD RAID5 to 7 HDD RAID5
Date: Wed, 13 Apr 2011 00:22:38 +0600
Message-ID: <20110413002238.3f31bdeb@natsu>
References: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
	<20110412231401.5bb9065c@natsu>
	<BANLkTim-iiYbza8ZZZv60ArRfXjnOuU7sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ssZLpGf_7=NkbA6H0UmdzAJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTim-iiYbza8ZZZv60ArRfXjnOuU7sg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ssZLpGf_7=NkbA6H0UmdzAJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Apr 2011 18:21:13 +0100
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> If I use --layout=3Dpreserve , what impact will that have?
> If I preserve the layout, what is the final result of the array
> compared to not preserving it?

Neil wrote about this on his blog:
"It is a very similar process that can now be used to convert a RAID5 to a
RAID6. We first change the RAID5 to RAID6 with a non-standard layout that h=
as
the parity blocks distributed as normal, but the Q blocks all on the last
device (a new device). So this is RAID6 using the RAID6 driver, but with a
non-RAID6 layout. So we "simply" change the layout and the job is done."
http://neil.brown.name/blog/20090817000931

Admittedly it is not completely clear to me what are the long-term downside=
s of
this layout. As I understand it does fully provide the RAID6-level redundan=
cy.
Perhaps just the performance will suffer a bit? Maybe someone can explain t=
his
more.

If anything, I think it is safe to use this layout for a while, e.g. in case
you don't want to rebuild 'right now'. You can always change the layout to =
the
traditional one later, by issuing "--grow --layout=3Dnormalise". Or perhaps=
 if
you plan to add another disk soon, you can normalise it on that occasion, a=
nd
still gain the benefit of only one full reshape.

>  Will the array have redundancy during the rebuild of the new drive?

If you choose --layout=3Dpreserve, your array immediately becomes a RAID6 w=
ith
one rebuilding drive. So this is the kind of redundancy you will have during
that rebuild - tolerance of up to one more (among the "old" drives) failure,
in other words, identical to what you currently have with RAID5.

--=20
With respect,
Roman

--Sig_/ssZLpGf_7=NkbA6H0UmdzAJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2kmG4ACgkQTLKSvz+PZwh+1ACfZ5AlZg/ZQpJ48nC3llGqmPLM
J+4Anj2ZdAkR4vXdKG59z9Z2wtm4aRPw
=X1gx
-----END PGP SIGNATURE-----

--Sig_/ssZLpGf_7=NkbA6H0UmdzAJ--
