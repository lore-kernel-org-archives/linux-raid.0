From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH] md: fix 32-bit build warning
Date: Thu, 15 Oct 2015 09:11:28 +1100
Message-ID: <876129xfqn.fsf@notabene.neil.brown.name>
References: <5304496.D8N6u074t0@wuerfel> <87fv1g1y34.fsf@notabene.neil.brown.name> <11281560.gJ28rX782P@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <11281560.gJ28rX782P@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Arnd Bergmann <arnd@arndb.de> writes:

> On Monday 12 October 2015 15:59:27 Neil Brown wrote:
>> > diff --git a/drivers/md/md.c b/drivers/md/md.c
>> > index 7fff1e6884d6..e13f72a3b561 100644
>> > --- a/drivers/md/md.c
>> > +++ b/drivers/md/md.c
>> > @@ -8987,9 +8987,9 @@ static void check_sb_changes(struct mddev *mddev=
, struct md_rdev *rdev)
>> >=20=20
>> >       /* recovery_cp changed */
>> >       if (le64_to_cpu(sb->resync_offset) !=3D mddev->recovery_cp) {
>> > -             pr_info("%s:%d recovery_cp changed from %lu to %lu\n", _=
_func__,
>> > -                             __LINE__, mddev->recovery_cp,
>> > -                             (unsigned long) le64_to_cpu(sb->resync_o=
ffset));
>> > +             pr_info("%s:%d recovery_cp changed from %llu to %llu\n",=
 __func__,
>> > +                             __LINE__, (u64)mddev->recovery_cp,
>> > +                             (u64) le64_to_cpu(sb->resync_offset));
>> >               mddev->recovery_cp =3D le64_to_cpu(sb->resync_offset);
>> >       }
>> >=20=20
>>=20
>> Thanks, but is this really right?
>> I think u64 is "unsigned long" on 64bit.
>> I have always used (unsigned long long) when I want to use %llu on
>> sector_t.
>>=20
>> How confident are you of using "u64" ?
>
> Very confident ;-)
>
> This used to not work until some linux-2.6 version when we changed all
> architectures to use asm-generic/int-ll64.h in the kernel, because
> a lot of code relied on printing u64 variables using %lld.
>
> I tend to use u64 for things like this because it's shorter than
> 'unsigned long long'.
>

Ahh.. good to know - thanks.

It seems that we've since removed those 'pr_info' lines, so there is
nothing to fix any more.  I'll remember that about using "u64" though -
using "unsigned long long" always felt so clumsy.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWHtMQAAoJEDnsnt1WYoG53MIQAMMhGuvsTYRbwIJhboMEetTl
8cCjTwfdy83myGDGeCTPdJ6k4UPn3lKEV29Dj1851iVL3KHTa23nEObHFuVmXYuC
Lvl2n5tdIunKpIVSL1cQZjcAfqVBJUF+deqKvFETOsysSmb38zOU+STeje0CyvQX
PDRCVsQWpExJM90zpyTv8lEpL3Lq6c3kFXkuQ2/SAHHWcw1cW4D4trQqCq+B01qc
5lE9cw5M5p1FJGtJN1zS0zek6b3BRgKslWwRDknNUtlPmcS/fMWWNu3e2iLQ2INy
kBjPfq9tz8s/oDWqg2HdSKZt7sPR9DbYt5+iUC3ZZgBdfjvm0MBmMBYh5Yhiolg3
WYR+LIDCwsYnLQQqDOW+GVXuTLBbyByx440+/rWANB14f5kNI2nbN7+cogn2HO6t
K0Bg1vYPecwSyT/WQYsRhV0zeh1Rujq2MpH2b5c3lfHli4z+yAem89lsIWWrgdQK
W7X+/0v1njb2UwFEt2GMViPKSbjRAv4zjk2+GbH/7sx/D620LX/0uiFlliM8y/nB
uOCeAxoRCwxHktk1ogTkXyc5EuyrS/eaONqbtDNAPKA8M3DOKy+3O2wmP3pH+XXC
m89fNcyUDghNowZisL1S7nyq2JnC21bHIZm/H7uUgxAW0JGrGhMomEJc5mql+GxZ
o/G99Ah4QX3OappVT1nC
=b7t1
-----END PGP SIGNATURE-----
--=-=-=--
