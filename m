From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] [RFC] md raid10: use rcu to avoid NULL dereference in raid10d()
Date: Sat, 03 Feb 2018 09:14:34 +1100
Message-ID: <87zi4rjayd.fsf@notabene.neil.brown.name>
References: <20171117200326.xqchu3r3elzvkg7z@kernel.org> <45cfa4a5-fe04-8b02-531d-c642ad6e7b4c@huawei.com> <7b5cb7fa-2dfa-0fab-752d-16cdfedffbca@huawei.com> <87o9l82vun.fsf@notabene.neil.brown.name> <2d7921ce-6ebf-fad5-2029-f54bb896863f@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2d7921ce-6ebf-fad5-2029-f54bb896863f@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: yuyufen <yuyufen@huawei.com>, colyli@suse.de, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 02 2018, yuyufen@huawei.com wrote:

>> I had forgotten about this patch and will resend.  However I think the
>> only change needs is adding some comments.  I still think the code is
>> correct.
> (1) When raid10 create, there are 4 disks in raid and 2 spare disks=20
> (sda5, sdd5)
>
> [  100.473118] RAID10 conf printout:
> [  100.473121]  --- wd:3 rd:4
> [  100.473123]  disk 0, wo:0, o:1, dev:sdb5
> [  100.473124]  disk 1, wo:1, o:0, dev:sdc5
> [  100.473126]  disk 2, wo:0, o:1, dev:sde5
> [  100.473127]  disk 3, wo:0, o:1, dev:sdf5
>
> (2) mdadm: hot removed /dev/sdc5 from /dev/md5
> [  100.473118] RAID10 conf printout:
> [  110.390027]  --- wd:3 rd:4
> [  110.390028]  disk 0, wo:0, o:1, dev:sdb5
> [  110.390029]  disk 2, wo:0, o:1, dev:sde5
> [  110.390030]  disk 3, wo:0, o:1, dev:sdf5
>
> However, as there are 2 spare disks, we expect raid10 can hot add a disk.
>
> (3)
> mdadm: added /dev/sdc5
> mdadm: hot removed /dev/sdc5 from /dev/md5
> [  148.680032] RAID10 conf printout:
> [  148.680035]  --- wd:2 rd:4
> [  148.680037]  disk 0, wo:0, o:1, dev:sdb5
> [  148.680038]  disk 2, wo:0, o:1, dev:sde5
>
> Now, there are 3 spare disks (sda5, sdc5, sdd5)
> Also, we expect hot add 2 disk, not just 2 disk in raid10.
>
> I try to explain, but not sure:
> The only place of the runtime to invoke mddev->pers->hot_add_disk(mddev,=
=20
> rdev) is md_check_recovery().

> But, it will set MD_RECOVERY_RUNNING before invoking=20
> remove_and_add_spares():

This is the piece I was missing.  Thanks for pointing that out,
definitely a bug in my patch.  I'll send a new patch which tests 'this'
as well as the flag.

Thanks a lot,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlp04soACgkQOeye3VZi
gbkF+A/9EVqr29aSOruoEtQvr8NBkYDigqI5F7ow4NuejdoLHrJPDQme7xJIQW4X
dN02PSn8DpQjEk0KN+77cHDsl8V5zPS7e1V7QrMW5oDTYMTTtJikTdpTfEIF6PCl
UVzsPylA9dKc1x9LrxQh7AZ5cVrOOYUvMJlglCo7TIKh/rdQ4eLtU5MfHOLY/is2
BN/4NnKcYGpLBzEpyk9gcCsiIRddltWTd4xS5UaAZZLPdFsNPRDO6APViy288Qem
QBN9RAqunw4ICtYVOj6kaa1V+l8Ae4hoN2GX/gZAKfpsREvtZqISRZ7SQUgqr/F1
YazmnaqrTwwpOt5lL2SFGe4K/3cmMWn2IkC3VX2D0EDpQmeQCG/sYfZ9GYyFijWR
L6rbxmdk67b5fhB7Xlwm1qF/TrudxEPlbwok49l5jSbR52cGFOUx17/GxjjQXYvg
WoZb4YVJsoNrDSKJu5Ob1CSJnR+ZUpaMGjIRCEMDGP/WPWLwq6wINCgyFeI3i0Qs
bv1JL9qlSzzl1PqYbt7YT9sJXEiJ62Tf1+rlrBvyU82ooII1ILxV9XmPhAbxyr9m
Xdwpv45QEbyU2P717CP3RRhgFbjn0u1soSrvm/TyGsd3ctAyxdMFqpimQnJTAZ35
BmZ+mMVmPt3mXfxKeBwbKmvLJu2ChLeYJvB5z7/u9yRYqwOWHBc=
=j4hZ
-----END PGP SIGNATURE-----
--=-=-=--
