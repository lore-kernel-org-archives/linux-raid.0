From: NeilBrown <neilb@suse.de>
Subject: Re: ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under
 Linux
Date: Tue, 15 May 2012 07:32:19 +1000
Message-ID: <20120515073219.1275b10a@notabene.brown>
References: <2598499.YYnUQlf0Se@localhost>
	<4FB16B68.3000201@redhat.com>
	<1714869.L4aqWfddyq@localhost>
	<4FB17212.3000308@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pWRLlOGay66KZpMIAf4+3sF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB17212.3000308@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/pWRLlOGay66KZpMIAf4+3sF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 14 May 2012 22:58:58 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> On 05/14/12 22:57, Pawe=C5=82 Sikora wrote:
> > On Monday 14 of May 2012 22:30:32 Jes Sorensen wrote:
> >> On 05/12/12 08:36, Pawe=C5=82 Sikora wrote:
> >>> fyi, this release contains a hidden strict-aliasing-violation bug [1].
> >>> please fix this correctly or build mdadm with -fno-strict-aliasing op=
tion.
> >>>
> >>> [1] http://www.spinics.net/lists/raid/msg37298.html
> >>
> >> If you provide a patch, you're more likely to get the issue fixed than
> >> by just telling other people to fix it for you.
> >=20
> > i have sent you a revert request with a proper fix 3 months ago
> > and you have finally rejected it with "invalid commit message",
> > so feel free to keep broken mdadm sources as long as you wish :>
> >=20
>=20
> If you post a patch without including a proper commit message and
> signed-off-by lines, which is standard practice, then that is equivalent
> to you not having posted a patch in the first place.
>=20
> Don't blame others for not doing the basic work everybody else does when
> posting patches. It really isn't hard to comply with the standard patch
> posting rules!

I decided a better approach is just to refresh from upstream:

      http://gcc.gnu.org/svn/gcc/branches/cilkplus/include/sha1.h
      http://gcc.gnu.org/svn/gcc/branches/cilkplus/libiberty/sha1.c

have been copied into mdadm with just a tiny change to not include config.h

Seems to work, and probably has the *right* fix.

NeilBrown


--Sig_/pWRLlOGay66KZpMIAf4+3sF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7F54znsnt1WYoG5AQLhnw/+N2uqA7XvBWcg0rMpYZilNqcQmas9DeUB
AraDFGzGh1CreQlIbJbnD8xuXHIVi8jEihRxH3uPm0m6gvxBlG44a6mSI37FmqRi
knaOGNa4o9Vrc+Ugvnth9UqDqu05FhFFknwz6ez0z+VlOuuB4X16gFZeFP8C5B6Y
ekjSxyPad2lXcMhqJCUp8vjCx5ZlLgM98Wz3Yqbn9dnTCLBDHd0XATRo9tX4Q9d3
FH/gWeIdy/C23nze1NB811bqJmzeahSV51QNN2JPn0arnZo10d/JVQyKM1ClUN/B
VvV+pnYl8960m2y/FABEYy6/B2o6Fexod+iUo6/K/hlr8XwHGCwuNs1eZIpTHTBu
y2u5TRKWUFqTCOn0XeDaJu7jvDFL0t4DR+Ei8ngZ/i9bWGZwJZ0o+ofhhzIOB8aV
ExtRWgVoOuawLb37FdLWbMO/hbzD1592dwOEKAUqCsSIl77qQoH+2JBahAYNRg7q
OLuvsnPFuIWqyAwdYWjOZkdJy/tKlQkhZi7FSHQBF8lsN1zos6jUsKPdCc1/j8TO
3fBV2ix65NcacQ1axVuaZx01AbHsSxBhU4R0Imb7uNwsT2y+adEDsLyLFci2XX6d
mR6Iz6FbCYlszFLifjLooWg0fL74ynFDDNkwbU/GfkaA1qXyHC1+funa37xoO0V+
a8Fb9/YgJF0=
=ixhs
-----END PGP SIGNATURE-----

--Sig_/pWRLlOGay66KZpMIAf4+3sF--
