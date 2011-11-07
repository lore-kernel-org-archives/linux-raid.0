From: NeilBrown <neilb@suse.de>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Mon, 7 Nov 2011 15:30:37 +1100
Message-ID: <20111107153037.50627ff6@notabene.brown>
References: <20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
	<20111107135241.64ae261d@notabene.brown>
	<CAPXgP115f-QezrxM4wZJ5EPJ=YGBAG7rcRtKNayD5mMO3UkjcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RJQKRanrRjpSaZKooge48WC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPXgP115f-QezrxM4wZJ5EPJ=YGBAG7rcRtKNayD5mMO3UkjcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

--Sig_/RJQKRanrRjpSaZKooge48WC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Nov 2011 04:42:54 +0100 Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Mon, Nov 7, 2011 at 03:52, NeilBrown <neilb@suse.de> wrote:
>=20
> > However there is an important piece missing. =A0When you remount,ro a
> > filesystem, the block device doesn't get told so it thinks it is still =
open
> > read/write. =A0So md cannot tell mdmon that the array is now read-only
>=20
> That ro/rw flag is visible in /proc/self/mountinfo, shouldn't it be
> possible for mdmon to poll() that file and let the kernel wake stuff
> up when the ro/rw flag changes, like we do for the usual mount changes
> already?
>=20
> Kay

The ro/rw flag for file systems is in /proc/self/mountinfo.

However I want the ro/rw flag for the block device.
A block device can be partitioned so it might have multiple filesystems on =
it.
and it might have swap too.
or a dm table or another md device or an open file descriptor or ....

Yes, I could maybe parse various different files and try to work out what is
going on.  But the kernel can easily *know* what is going on.

Making this work "perfectly" would require md dropping its write-access to
member devices when the last write-access to the top level device goes.  And
the same for dm and loop and .....

But just filesystems would go a long way to catching the common cases
correctly.

Thanks,
NeilBrown


--Sig_/RJQKRanrRjpSaZKooge48WC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrde7Tnsnt1WYoG5AQLdag/7BfzQgpM2oY0iLp7OF3v5LUGD88NiJHyG
JMxR+yYUtaJbSbdCc9Ac0MlpS+RUBy15HpNnyzFOMjSf9RcKUM3YQnWSa9abOius
8lXhLpYRSPr8gdt36qidVgwgsfJusfnQrxm8sLFXrPsR8NULRscEMGw4YjU/SKho
do9iLY6E6ok3ecJtaidothHU/lHFazrbHuzseIOz3mK7SMWo7WDQi6+mrQNB+IJt
wjy1/33P22iaef7GbCwTfPWSCfcln/Bhdp1OfYtCTEXZSD3d/9cbe+HLb2xUwIkG
fI4UiIT0m2AGiuTJB29ijSag4G4iOz3RDz8X/NmvVX+QhyhqFAHMzBT+lCJnik6q
uEubjdLVe22/Pfpn6JbITt8M4pCHEG2x9C3u/vnaYJxM/tgy2t8mbZ8HDuad7AC8
ysv+mrQsspkn6BxkYslk2KymtFI8Yh1Aars6lJRNAcSnN8KHiLk80ht4D0ri6mLk
F7ki2uSlSpfZ/xRhpRv6MSk56MVSrBt3MZCJvRQAt4yDlRL1pEvt26K/BaptqJHQ
kZbVzEwMfS2LlvFrVEJkMdccCh7jN/9cjpw/ksPF9WRzhyRnFMYLZVPMjFM5DbUs
WENPdQG+jLGCCdRXlFV8mJGo5wQPcSLtupgzAiqPXS31N05UGb2KjBOlfFTUESCg
PP6QlSqWGOY=
=CIXX
-----END PGP SIGNATURE-----

--Sig_/RJQKRanrRjpSaZKooge48WC--
