From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/11] Degradation during reshape
Date: Tue, 6 Dec 2011 11:53:38 +1100
Message-ID: <20111206115338.2032996c@notabene.brown>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VLg6sb2D53Qt6jLH7TmXr4f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/VLg6sb2D53Qt6jLH7TmXr4f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Nov 2011 13:17:10 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> The following series implements support for array degradation during resh=
ape.
>=20
> Series mostly fixes problems in handling degradation during reshape=20
> in imsm metadata .
>=20
> Main common problem that last patch resolves is is lack of BBM support.
> md on disk failure reports BBM event to user space and waits for an answe=
r.
> The side effect of this action is stopping reshape process. The last patch
> /together with md patch sent separately/ allows for disabling BBM mechani=
sm.
> This is similar as native metadata v0.9 works.
>=20
> BR
> Adam
>=20
>

Sorry for the long delay in getting to these - I've been busy :-(

>=20
> Adam Kwolek (11):
>       Disable BBM when it is not supported

Not applied as discussed separately.  I'll follow up on this issue separate=
ly.

>       imsm: FIX: Check maximum allowed degradation level in recover_backu=
p_imsm()
>       imsm: FIX: Check maximum allowed degradation level in open_backup_t=
argets()
>       imsm: FIX: Function rework - imsm_count_failed()

These 3 applied.

>       imsm: FIX: Manage second map state on array degradation

I've applied this, but I don't like the fact that you have used '2' and '4'
for MAP_0 and MAP_1.
I see that you use '&' to test a bit and you wanted separate bits, but I
don't see any place where "look_in_map" could have multiple bits set.
So why not MAP_0=3D=3D0 and MAP_1=3D=3D1 and use e.g. "look_in_map =3D=3D M=
AP_0".

I'm quite happy with defining the symbolic named (MAP_0 and MAP_1),
just confused by the values chosen.

Could you please explain the logic, or fix it up with a new patch?  Thanks.

>       imsm: FIX: Restore critical section on degraded array
>       imsm: FIX: Remove single map state limitation in getinfo
>       imsm: FIX: Finalize degraded migration
>       imsm: FIX: Do not end migration when missing drive is handled

These 4 applied.

>       imsm: FIX: Mark both maps on degradation while migrating

applied, but I think mark_failure might still be wrong.
What if the device that fails is in MAP_1 but not in MAP_0?  I don't think =
it
gets marked as failed in that case.

>       imsm: FIX: Return longer map for failure setting

I changed the type of 'map2' from 'void *' to 'struct imsm_map *', and appl=
ied the result.

Thanks.

BTW if you want these in SLES11-SP2 I'll need a request through bugzilla.
Just one is enough, not one for every patch.

NeilBrown


--Sig_/VLg6sb2D53Qt6jLH7TmXr4f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt1nkjnsnt1WYoG5AQLzAhAAofD4W9kWdgaoaPGBhsKjtKjSX1OGRY12
RDCNRo6wtWKkO6QnvndO5fjH/l2t5UbLe+Tjmao6pk53MFNtP47o153TMWlkuTQK
e8jb4vpSfXePQAIVUl6tY9jEvUVhpkkM10kh9c24NX0c9ELJ7/E2faQoPFQf3p8+
jYf7zM7chrkxZHHyugtum94G88GJQQOnEseT4XzOavdh478qYe82A+FxLaGbb9uK
PgL4ylrl1kMB7PSZddKrGDMm1uB3xt3SEUBo+UR66Ml3xQ+8pIaSswhdoMFKcDdC
b/H106TN1DfhMBvIb1kpwCkK/WKjcm2E8WB0ulC1996u60MLXEjtBwnonGSuXY0Z
49EM2m+0xVgcmKXt+44d2UWJ+rhthpt3vR2xQfAN4TIJNp5MP/hFNsqyXEMA03sO
F7fYnxwxYN927dCIjTXIvnRiR+UhHBmh5tviQ/g2NDsSPF9wEOhJ+3y6YXHKUfan
JYstOjsIX73RCMkbfinBPUX+uT8Z3bm0cYLrrz04F3RdB8+mJvNdn1emPbOMcrLe
hezFBtcfh81mLPozoAh9TmqW+zVKIR8sxMWH3vQUhHwtNArmNMY+KUYq4pjYlf7a
TkQc9VubpVpdZbJ0eRsWIOKxlX2bqT/7HZQ7tSXXI9uyRpiYuC7iVUGxEmzLCY4y
O+g19YeHh6U=
=UJie
-----END PGP SIGNATURE-----

--Sig_/VLg6sb2D53Qt6jLH7TmXr4f--
