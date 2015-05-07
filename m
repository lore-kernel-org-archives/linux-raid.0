From: NeilBrown <neilb@suse.de>
Subject: Re: Removed disk vs. failed disk?
Date: Thu, 7 May 2015 13:07:07 +1000
Message-ID: <20150507130707.6c79a720@notabene.brown>
References: <DD68D119-D646-4D8E-8E14-498F996D8CCA@me.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/AnTGPcfw6WpVG_23i3sf3tj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DD68D119-D646-4D8E-8E14-498F996D8CCA@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Malissa <hmalissa@me.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/AnTGPcfw6WpVG_23i3sf3tj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 05 May 2015 10:42:29 -0600 Hans Malissa <hmalissa@me.com> wrote:

> I=E2=80=99m somewhat new to using RAID, but I may be looking at a broken =
hard drive already. I=E2=80=99ve been looking at the documentation of mdadm=
 and Linux software RAID, but I=E2=80=99m not sure if I understand everythi=
ng correctly. So I apologize if some of the questions have already been ans=
wered elsewhere, but I need to get this thing running again as soon as poss=
ible.
> I cannot mount the RAID (/dev/md0) anymore. /proc/mdstat looks like this:
>=20
> # cat /proc/mdstat
> Personalities : [raid1]=20
> md0 : active raid1 sdb1[0]
>       976760640 blocks super 1.0 [2/1] [U_]
>       bitmap: 3/8 pages [12KB], 65536KB chunk
>=20
> unused devices: <none>

This state shouldn't stop the filesystem on the array from being mounted.
It is a RAID1 with one missing device, so all the data is still present on
the other device.

What did you expect to be on /dev/md0?
What does "fsck /dev/md0" show?
What does "mount /dev/md0 /mnt" show ??



>=20
> and mdadm =E2=80=94detail looks like this:
>=20
> # mdadm =E2=80=94detail /dev/md0
> /dev/md0:
>         Version : 1.0
>   Creation Time : Sun Dec 15 16:03:28 2013
>      Raid Level : raid1
>      Array Size : 976760640 (931.51 GiB 1000.20 GB)
>   Used Dev Size : 976760640 (931.51 GiB 1000.20 GB)
>    Raid Devices : 2
>   Total Devices : 1
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Tue May  5 10:17:03 2015
>           State : active, degraded=20
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>            Name : eprb21:0  (local to host eprb21)
>            UUID : 34d12cbd:eef71d8d:14dcf224:dfe6c013
>          Events : 3509
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       0        0        1      removed
>=20
> So it looks like there is a problem with the second disc in the array has=
 some problem. First, I=E2=80=99m not sure what the difference between =E2=
=80=98removed=E2=80=99 and =E2=80=98failed=E2=80=99 is, because the disk is=
 physically still present. How does mdadm differentiate between both states?

A "failed" device is not much different from a "removed" device.

When md has a working device and discovers that it isn't working any more,
typically because a 'write' failed, it marks it as 'FAULTY'.

You can then remove it from the array with "mdadm --remove ...."
Then it will be "removed".

When you assemble an array, e.g. at boot time, and device that has previous=
ly
failed will not be allowed into the array.  So they won't appear as 'faulty'
in the description of the array, they will just be "removed".


> I understand that the next step would be to put in a new hard drive and r=
ebuild the array. Is there a way to figure out right away if the data on th=
e intact disk is uncompromised?

Certainly you should check the data you have is good before adding the other
device back into the array.  'fsck' and 'mount' are what I would suggest, b=
ut
it depends on what you think is stored on the array.

NeilBrown



> Best regards, and thanks for your help,
>=20
> Hans Malissa--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/AnTGPcfw6WpVG_23i3sf3tj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUrW2znsnt1WYoG5AQLvxw//b2B8u5eObfejQpdCN5SkIuPrfm/054eV
NVnsD8DeMIhEQxwTBfo9/QTeQACs9ob1G6wsgGHKZAhl/eGMA//885jjU+eefQ2J
dmsBBAJjzYX0+9tBnUP/ikDeTw6zokAL4Kfp/mNgIGOzvSIC2Xuz5C3/aPdgXOnv
HCcPDri+kKr/BvPAr8MId1qj2moSy8kEwEPaB0j6ZP3nDqJBafuWlyddovFdhtal
RCO7Mu2khaDKMtCJrbaQesMELFXx87aAa/GMGWOkosSZjO3sMGQfGnKtw/kg0E7b
hKtr+RUnb8mB9DcneJQanC1/Fi1TcsRTN9LcrdobUWVGDkmNLJb1u64CoCqOR2ex
13r4uSLWkLTwH1jgZ3vm/yiuZzA8Q7X7cMES0M4+GJJDI0AH+lKs/8rjdRXdDb/t
QOBqcDMLd4JKEATLV6HrYEF4mIOYRinJs4V1DoeFvwtRBuFfIPleWoAiyWhEtBfU
wlrOb9FjyOvVlpwMbTvtbejtSuU4yYBz8rUfVCOhhbzasHmEM40F0m+Cj6qnzY9M
kJ4FZ5LdAq9lue0K/mGbkVcKgLhsGhCAu7aJ8W/1N5Bqce5k5bisEPUhg3YxaaJQ
Dm2La2rxj3OeCf+yKmUjeAUPRimocEK4zYOj6V6qOqVILJfk9eGnQjiP4/WPUA0R
pk5SAS65YoE=
=pRD0
-----END PGP SIGNATURE-----

--Sig_/AnTGPcfw6WpVG_23i3sf3tj--
