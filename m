From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 NAS Recovery...00.90.01 vs 00.90
Date: Wed, 21 Nov 2012 08:39:36 +1100
Message-ID: <20121121083936.1a4d4b13@notabene.brown>
References: <CAKcp_7ZrR+L5jZBK3cd-z780Cw76XpwMuWmwtUGt=ecwbx_LPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9cOXGz09=HfIk2iDl9wFqcx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKcp_7ZrR+L5jZBK3cd-z780Cw76XpwMuWmwtUGt=ecwbx_LPg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Haran <steveharan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9cOXGz09=HfIk2iDl9wFqcx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2012 15:41:57 -0500 Stephen Haran <steveharan@gmail.com> wro=
te:

> Hi, I'm trying to recover a Western Digital Share Space NAS.
> I'm able to assemble the RAID5 and restore the LVM but it can't see
> any filesystem.
>=20
> Below is a raid.log file that shows how the raid was configured when
> it was working.
> And also the output of mdadm -D showing the raid in it's current state.
> Note the Version difference 00.90.01 vs. 0.90. And the array size
> difference 2925293760  vs. 2925894144
> I'm thinking this difference may be the reason Linux can not see a filesy=
stem.

Probably not - losing a few blocks from the end might make 'fsck' complain,
but it should still be able to see the filesystem.

How did you test if you could see a filesystem?  'mount' or 'fsck -n' ?

It looks like you re-created the array recently (Nov 18 12:07:53 2012)  Why
did you do that?
It has been created slightly smaller - not sure why.  Maybe if you explicit=
ly
request the old per-device size with "--size=3D975097920" it might get it r=
ight.

Are you sure the dm cow devices show exactly the same size and content as t=
he
originals?

The stray '.01' at the end of the version number is not relevant.  It just
indicates a different version of mdadm in use to report the array.

NeilBrown


>=20
> My question is would the version difference explain the array size differ=
ence?
> And is it possible to create a version 00.90.01 array? I do not see
> that in the mdadm docs.
>=20
> ....original working raid config....
> /dev/md2:
>         Version : 00.90.01
>   Creation Time : Wed Jun 24 19:00:59 2009
>      Raid Level : raid5
>      Array Size : 2925293760 (2789.78 GiB 2995.50 GB)
>     Device Size : 975097920 (929.93 GiB 998.50 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Thu Jun 25 02:36:31 2009
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            UUID : 6860a291:a5479bc6:e782da22:90dbd792
>          Events : 0.45705
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        4        0      active sync   /dev/sda4
>        1       8       20        1      active sync   /dev/sdb4
>        2       8       36        2      active sync   /dev/sdc4
>        3       8       52        3      active sync   /dev/sdd4
>=20
>=20
> ....and here is the raid as it stands now. Note the end user I'm
> helping tried to rebuild back on Sunday...
>=20
>  % mdadm -D /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Sun=20
>      Raid Level : raid5
>      Array Size : 2925894144 (2790.35 GiB 2996.12 GB)
>   Used Dev Size : 975298048 (930.12 GiB 998.71 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Tue Nov 20 16:06:10 2012
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            UUID : 2ac5bacd:b40dc3f5:cb031839:58437670
>          Events : 0.1
>=20
>     Number   Major   Minor   RaidDevice State
>        0     253       19        0      active sync   /dev/dm-19  <<<
> Note I am using cow devices via dmsetup
>        1     253       11        1      active sync   /dev/dm-11
>        2     253       15        2      active sync   /dev/dm-15
>        3     253        7        3      active sync   /dev/dm-7
>=20
> Thank you for any and all help.
>=20
> Regards,
> Stephen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/9cOXGz09=HfIk2iDl9wFqcx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKv4mDnsnt1WYoG5AQJDoBAAt9aIgcvEcV/hMU8m0hCwSOJZsq/GfGBI
gL8Ayvrqat+t2/ib1iQoilYN4lMRn9zyYUrO/aZQVcpeMNBYhrY+UHymhAzZP1Vb
vg4VEYhMdkOxNrnQu2gkrZLWjDbQphXl8fgPvwI2DNGInNHqVkBkf5YcU+NHXhFt
SYHKXbF7AGCuEQ/qyrAvQj7h5GyE3ZJs4RJGcDkIVA47MF1wMWX/wZ2lVeR+f6qr
NKFWj1GZRVeLnqShBUNFSYBi8ux7Kpztsfp6cDa1OGNvLajEQ7/XsBKb53COwiPX
TDG0kKsIs/kXKYJ8v3nq07QlqE7PB05Yr2XZXXivZ3HULdBV3hsMaXE2PwlfFi0I
wfQPE4G8tzpC1Y07QKsfCM7HyWOPY7J3mcM0Xzujvm1PgIfZELLUCK6l43/CYeny
tFOy7GiW5gxsQDe6N/JE59SnF7+AqItwRcEmcweAZt+vZwvfSShpu+nxGLzNLux3
lrg2JYCHky6p6ORdlO2NZ1KH09kYuRv2YkBkRbXI9eJZL0VEmbFYh9yM6J4wec9V
SwAQNFwnRbYm/sbvWcyXzGoDUnKogIW7/Ceeiy4b9N2VdZ6uR2UlZeEheT1OmDSg
gJVXjwZzhAs2qRaP5+yKK5Oq+cOmTgBKUJiSueeqz1svmHEJlAMw8xs2hwkotjsH
bMmF+CnYpXk=
=Y4en
-----END PGP SIGNATURE-----

--Sig_/9cOXGz09=HfIk2iDl9wFqcx--
