From: NeilBrown <neilb@suse.de>
Subject: Re: How to activate a spare?
Date: Sun, 17 Jun 2012 18:13:00 +1000
Message-ID: <20120617181300.27deb1eb@notabene.brown>
References: <S1756982Ab2FOO6f/20120615145835Z+98@vger.kernel.org>
	<4FDB4F14.3030609@leibman.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/f+J.dqvTSSU=OV4AU=aKwMB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FDB4F14.3030609@leibman.net>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Leibman <roberto@leibman.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/f+J.dqvTSSU=OV4AU=aKwMB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Jun 2012 08:04:52 -0700 Roberto Leibman <roberto@leibman.net>
wrote:

> I must be missing something completely obvious, but I've read the man=20
> page, and went through the archive for this list.
>=20
> One of the hard drives in my raid array failed... I have taken the hard=20
> drive out, replaced it with a new one, copied the partition table (using=
=20
> gdisk) and then added the drive to the raid array with:
>=20
> mdadm --add /dev/md0 /dev/sdb3
>=20
> I then monitor it with "mdadm --detail /dev/md0" or "cat /proc/mdstat"=20
> until it synchronizes
> After an ungodly number of hours, the thing finishes synchronizing, but=20
> the new drive only shows up as a spare. So the RAID is still degraded....

The only explanation for this that I can think of is that the drive reported
an error near the end of the recovery process.
There could be some kernel bug, but you didn't say what kernel you are
running so it is hard to check.

>=20
> I have not been able to get the new drive to become part of the array as=
=20
> active, web searches have proved useless (people with the same problem=20
> and no resolution). I've even failed/removed the active drive, at which=20
> point the spare becomes active, but when I add the original drive it=20
> still adds it as a spare)

That sounds wrong.  If you have an array with one working drive and one
spare, and you fail the working drive, then you end up with no drive.  There
is no way that the spare will suddenly become active.

Maybe you are misinterpreting something and thinking it is spare when it
isn't.

The below looks perfectly normal.  What does it look like when the recovery
stops?  Are there any messages in the kernel logs when it stops?

NeilBrown



>=20
> So how do I make it active???
>=20
> (it's in the middle of trying again, but here's what I have)
> --------------
> root@frogstar:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
> [raid4] [raid10]
> md0 : active raid1 sda3[2] sdb3[0]
>        1943454796 blocks super 1.2 [2/1] [U_]
>        [>....................]  recovery =3D  1.0% (20096128/1943454796)=
=20
> finish=3D737.0min speed=3D43493K/sec
>=20
> unused devices: <none>
> --------------
> and
> root@frogstar:~# mdadm --detail /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Sat Apr 14 13:52:25 2012
>       Raid Level : raid1
>       Array Size : 1943454796 (1853.42 GiB 1990.10 GB)
>    Used Dev Size : 1943454796 (1853.42 GiB 1990.10 GB)
>     Raid Devices : 2
>    Total Devices : 2
>      Persistence : Superblock is persistent
>=20
>      Update Time : Thu Jun 14 13:13:54 2012
>            State : clean, degraded, recovering
>   Active Devices : 1
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 1
>=20
>   Rebuild Status : 1% complete
>=20
>             Name : frogstar:0  (local to host frogstar)
>             UUID : 88ed6cd4:de463005:31ed764c:2b23a266
>           Events : 47610
>=20
>      Number   Major   Minor   RaidDevice State
>         0       8       19        0      active sync   /dev/sdb3
>         2       8        3        1      spare rebuilding   /dev/sda3
>=20
> The version of mdadm I'm using is the stock on ubuntu 10.10 (v3.1.4)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/f+J.dqvTSSU=OV4AU=aKwMB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT92RjDnsnt1WYoG5AQJHhA//QHhz12N2BBZUUYU3dz3J+6aKfdmvPjVz
4am2TpHQXBhpEd7BydFL9xQkzW2DP/m6Ht7qMBDXIXxWee7J+GT2yTBpwhej+iBX
VbKkdwelDqF5oCPoewzpRwozIvFJhFvsd228sPBJ6fmW3kZLtShTkNtmsjlFloe1
rEP6S8Z0+B07eUZ4OaFn9hrMqpjVY+MFfgoZVwe0fEDQAp88FuKYSeTn/2kRcL10
LWv8Ctns4roQG4XafxvTN73Ce2E56Oqfy3Fbq6XMOG6WmHZxrddfiSb8o1qFxmvE
XBTLXluERXDrk62lwK62F+hT2yXFpUHyzoM8ClSTuoAy43/5FNs7taAbCzhUERQj
aN77VpIPNDqoLaZazAvH2+3ENbVn4OoKuiEx9a5/N0ZQOOTgR6mwurkIOAYQuWy9
xJt++gcxIwjVtjUiYZP4uy+v/iLj6udevB0oUbDppL4a02U/wmllQKVgU1j6QcfV
JbPBNpqFi5qzovY4Iq4E8Eymipsl2rM02C9ErZRVGY6bwGAHVb2oKdFL+Q+U0iDi
QHHPDpQEinsSBXsuVgankAxw7EEFD70ab1tNh0FkSGCwCUp4y/gD9NqffDPL+rqR
IlCV/VB/NPaAi0VMnXERl+m1QDG2I0B0vRxn0lgYLM9NAEgMuvT1EAFtqwFgiF1U
pJvDiuG0/Rw=
=MOxk
-----END PGP SIGNATURE-----

--Sig_/f+J.dqvTSSU=OV4AU=aKwMB--
