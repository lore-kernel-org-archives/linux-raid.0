From: NeilBrown <neilb@suse.de>
Subject: Re: --grow RAID6 gives: md: md_do_sync() got signal ... exiting +
 hang
Date: Tue, 7 May 2013 22:14:11 +1000
Message-ID: <20130507221411.6d0542b3@notabene.brown>
References: <CANU9nTmqXjPFqU=p0vex2SgXjyv9L2NO5mafHoWqfH7n1kkhcw@mail.gmail.com>
	<CANU9nTnGL8pR9Qnp_W-akDHz-ruqVOu5TLgJAE5aTTNC9DeOpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1.1NeTd9Of_zpaA6t3uezRN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANU9nTnGL8pR9Qnp_W-akDHz-ruqVOu5TLgJAE5aTTNC9DeOpQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <tange@binf.ku.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1.1NeTd9Of_zpaA6t3uezRN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 May 2013 13:56:55 +0200 Ole Tange <tange@binf.ku.dk> wrote:

> On Tue, May 7, 2013 at 1:36 PM, Ole Tange <tange@binf.ku.dk> wrote:
>=20
> > I am expanding my 9 harddisk RAID6 to 10 harddisk RAID6:
> :
> > It is, however, hanging the system.
>=20
> I can mdadm -E:
>=20
> /dev/sdi:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : 242d6530:e2562ecb:1dcd2a97:15a1a868
>            Name : lemaitre:1  (local to host lemaitre)
>   Creation Time : Mon Nov  5 16:27:45 2012
>      Raid Level : raid6
>    Raid Devices : 10
>=20
>  Avail Dev Size : 7814035120 (3726.02 GiB 4000.79 GB)
>      Array Size : 31256138752 (29808.18 GiB 32006.29 GB)
>   Used Dev Size : 7814034688 (3726.02 GiB 4000.79 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 4b8de95b:90a2aed7:c0ae092b:a056dd95
>=20
>   Reshape pos'n : 8192 (8.00 MiB 8.39 MB)
>   Delta Devices : 1 (9->10)
>=20
>     Update Time : Tue May  7 13:12:19 2013
>        Checksum : a4f483fd - correct
>          Events : 298792
>=20
>          Layout : left-symmetric
>      Chunk Size : 128K
>=20
>    Device Role : Active device 9
>    Array State : AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> So it seems stuck on the first 8 MB. Is it safe to reboot?
>=20
> This hangs:
>=20
>   grep . /sys/block/md1/md/*
>=20
> $ mdadm --version
> mdadm - v3.2.5 - 18th May 2012
>=20
> $ uname -r
> 3.2.0-0.bpo.1-amd64
>=20

It should be safe to reboot though until we know why it is hanging, I cannot
promise it won't hang straight  away again.

You didn't answer my question about dmesg output:  did you leave anything o=
ut?

NeilBrown

--Sig_/1.1NeTd9Of_zpaA6t3uezRN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYjwEznsnt1WYoG5AQJM8BAAiGx62Ypyf8uMnt6onWqNKu+CJlNW/0n1
nvGALkGnAOaRomKnm/HZGK2Chl8mRPIi/BHMY9/kxLvQQA53is8lPMZZQ7cRIimI
cjIfcVDtccKrYLNCoFA8VoeTRMWrmsKSRHZSaXQ0IV5+0BlZVNqNobRqsd0vGVL0
vlYCsx+F6Elj6eSKZr08vx+oD82vN9bFHDJvLton9HCr5j7yxLfIYW6HqplolHkK
NAkACH6Umwb9aHMKbndTN5FMJrT+1PCvVCSYbX+wz9TP3Hg0HAYXKxemTTUP7EPj
tIvw7yC6JJ4n/ZCCeBAVnl89dZD37cewXM4Vmb9QDASIX/R0ASn/y4Q3zDgYqhCZ
S8wr5i0YzdOn+cJWzEJDtQwhhoodW69d8KwXQjxVkgo/eooJ8Ge7694LgxiNTRdu
7FOSl1ZFfjDf9lq56F2+aS8HHdOJQsOLYsj1NUk/mArOhNu8sR5pl2ZDWZqw5cwI
Fxt+c4zuzun1yTnBr7P6ujNW+rYpVqWMGHeRXwSXmieyABBni0Guc5R6s3vab5++
iwVi31xIGSJdIWZE7R9iZDqRZeNQOQgMN5HCgZdqYaad7lCxLYfuPqT/YjPSBkX7
ibzrxdCXi5uztxTTLOmYZ9KRZzXG9fA3T64kSnARcz0mzwRYUGdBRUIBE0LYAMg2
qGoZpuhzUA8=
=ULLy
-----END PGP SIGNATURE-----

--Sig_/1.1NeTd9Of_zpaA6t3uezRN--
