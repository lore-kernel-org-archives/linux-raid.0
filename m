From: NeilBrown <neilb@suse.de>
Subject: Re: Possible data corruption after rebuild
Date: Mon, 9 Jul 2012 10:16:24 +1000
Message-ID: <20120709101624.3dc4cdab@notabene.brown>
References: <CAB1R3sjHtWwE7=MOqTzS7omiE-ebxqBPNaMMh-+_AYw3WgLtxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/35wZPKBxB2+2kVz_EgO5FK+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sjHtWwE7=MOqTzS7omiE-ebxqBPNaMMh-+_AYw3WgLtxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/35wZPKBxB2+2kVz_EgO5FK+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jul 2012 12:09:43 -0400 Alex <mysqlstudent@gmail.com> wrote:

> Hi,
>=20
> I had a situation where after rebooting all three drives of a RAID5
> array were marked as spares. I rebuild the array using "mdadm -C
> /dev/md1 -e 1.1 --level 5 -n 3  --chunk 512 --assume-clean /dev/sda2
> /dev/sdb2 /dev/sdc2" and mdstat showed it was again assembled. The
> filesystem types on /dev/sdb were all "Linux" instead of "Linux raid
> autodetect", so I changed them back.

You've been bitten by http://neil.brown.name/blog/20120615073245

So md1 is all happy again is it?

>=20
> /dev/md2 also has a problem, and I have no idea what to do there either.
>=20
> When I tried to fsck it to be sure it was intact, it prompted me that
> there was a problem with the superblock, and I answered Yes to "Fix?".

Always use "fsck -n" to check if something is intact!!

>=20
> After there being a number of further errors, I quit fsck, and am here fo=
r help.
>=20
> Did I perhaps assemble the array in the wrong disk order? Is there
> another superblock that may be useful here and how would I find it?

Certainly possible.  With only 3 devices there aren't may different orders =
to
test so you could try them all.

As fsck thought it recognised a filesystem it is very likely that the first
device is correct, so just try swapping the other to and issuing a new
--create command.  Then "fsck -n".

NeilBrown


>=20
> I'm really concerned that I've lost the data and really hope someone
> has some ideas.
>=20
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md1 : active raid5 sda2[0] sdc2[2] sdb2[1]
>       51196928 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/3] [U=
UU]
>=20
> md2 : active raid5 sdc3[0] sdb3[2] sda3[1]
>       1890300928 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/3] =
[UUU]
>=20
> md0 : active raid1 sdc1[0] sdb1[1]
>       255988 blocks super 1.0 [3/2] [U_U]
>=20
> unused devices: <none>
>=20
> # mdadm -E /dev/md1
> mdadm: No md superblock detected on /dev/md1.
>=20
> # mdadm --detail /dev/md1
> /dev/md1:
>         Version : 1.1
>   Creation Time : Fri Jul  6 13:41:54 2012
>      Raid Level : raid5
>      Array Size : 51196928 (48.83 GiB 52.43 GB)
>   Used Dev Size : 25598464 (24.41 GiB 26.21 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
>=20
>     Update Time : Fri Jul  6 16:01:18 2012
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : sysresccd:1  (local to host sysresccd)
>            UUID : 4ce6925e:b6cbd20e:7f3efbfc:668295fe
>          Events : 2
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
>=20
> Thanks for any ideas,
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/35wZPKBxB2+2kVz_EgO5FK+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/oi2Dnsnt1WYoG5AQJL7Q/9HrREoUeHXQFrp7B1vu2FRCLXu0pgPYir
OCoy/L4sdB0RbnU1szBS1+mR96b0XI+jxEpyvyk+mFrXFQhVPGs3yRyXTDz0WZLB
Cwlhphp3BeamoUpR98K03PF8h7mtH1mMSJZQALvdEMqGfxIWBQrCtNBPQSghSEO1
G5aK/PA4NZAcyJuIviXrk2OE2Ifg4lCifSHkg57p0dg0bqPOf4d1YO2vXvbZBjK2
1xdhQRJvpVXjP2tuJwagpAtdU4r1V9l7spoSJmMSFD2JeRedx1yJVdJPDWUrhwR7
KfZ5Bq1ygxDBXfFNGsfc4rvU/urvMTSsiY3qarpBtOCCbOmVjeHz+OnsAhl3EAAr
9gXpSLd0cwO3ukqYaJ9pQyvuzMvdgy0iBefI0sWy+UFysb3W0+SMjPNJ1pANpZ+R
Ew7RS0Twm3Xu2SAKqX9F+k7GZnKN60SBzg/f3RgeZL1r/UqELcWgficAKFD2YHMM
XK48ouFDZd5orbsCYFipytcz8eRD4hZNdQ40PyS0bdFSrFnOz7otCz430czko9M0
BxfAyp7c4QDQ1eLBk8xJkosIZAxpwB3S0pHDW+GCePrgQEu+ziQiM3Lfp+Wv3VR9
HN5ZmCESky+ZhZxPS9M2A7dws88XZNflEbtD14hypTIyW+R+VvXdAa6qPCgmJdQ5
/wEKA/6KffE=
=QP3b
-----END PGP SIGNATURE-----

--Sig_/35wZPKBxB2+2kVz_EgO5FK+--
