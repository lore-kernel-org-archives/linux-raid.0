From: NeilBrown <neilb@suse.de>
Subject: Re: grub-probe: "found two disks with the index 3 for RAID md2"
 after changing superblock 0.9 to 1.0
Date: Tue, 16 Sep 2014 07:54:58 +1000
Message-ID: <20140916075458.155ca17a@notabene.brown>
References: <20140915064741.GH11855@bitfolk.com>
	<20140915170037.16f93daa@notabene.brown>
	<20140915171252.GI11855@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2TTJLa7W=FAqYN9F1nfRapq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140915171252.GI11855@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2TTJLa7W=FAqYN9F1nfRapq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Sep 2014 17:12:52 +0000 Andy Smith <andy@strugglers.net> wrote:

> Hi Neil,
>=20
> On Mon, Sep 15, 2014 at 05:00:37PM +1000, NeilBrown wrote:
> > On Mon, 15 Sep 2014 06:47:41 +0000 Andy Smith <andy@strugglers.net> wro=
te:
> > > The thing is, that bug report is quite old and is marked closed, and
> > > also states:
> > >=20
> > >     "The problem is that 0.9x metadata block doesn't have enough
> > >     info to check it. With 1.x we have no such problem."
> > >=20
> > > Of course, it *is* 1.x superblock. Did the poster actually mean to
> > > say that they have no problem with v1.1 and v1.2 (because they are
> > > located at or near the beginning of the device, not at the end)?
> >=20
> > 0.90 has the problem, 1.x doesn't.
>=20
> Right.
>=20
> > Maybe there is an old 0.90 superblock confusing things.  It lives in a
> > different location than the others and so there is room for confusion.
>=20
> I think that must be it.
>=20
> >   mdadm --examine --metadata=3D0.90 /dev/sda3
> >=20
> > which show you the 0.90 metadata if there is any.
>=20
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 0.90.01
>            UUID : 3905b303:ca604b72:be5949c4:ab051b7a
>   Creation Time : Sun Jun  4 08:18:58 2006
>      Raid Level : raid10
>   Used Dev Size : 309363264 (295.03 GiB 316.79 GB)
>      Array Size : 928089792 (885.10 GiB 950.36 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 2
>=20
>     Update Time : Sun Aug 24 14:26:50 2014
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : e613d577 - correct
>          Events : 312149996
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     5       8        3        5      active sync   /dev/sda3
>=20
>    0     0       8       51        0      active sync   /dev/sdd3
>    1     1       8       67        1      active sync
>    2     2       8       83        2      active sync
>    3     3       8       19        3      active sync   /dev/sdb3
>    4     4       8       35        4      active sync   /dev/sdc3
>    5     5       8        3        5      active sync   /dev/sda3
>=20
> This shows the array when it had 6 devices as well, so clearly from
> before the metadata update and shrink to 4 devices.
>=20
> >   mdadm --zero-super --metadata=3D0.90 /dev/sda3
> >=20
> > will remove any 0.90 metadata.
>=20
> Trying that whole the array is running:
>=20
> mdadm: Couldn't open /dev/sda3 for write - not zeroing
>=20
> This needs to be done with the array stopped, presumably?

It's preferred, but if you are really confident (and I think you are), then
adding --force is justified and should make it work.

NeilBrown


>=20
> Thanks for the explanation!
>=20
> Cheers,
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/2TTJLa7W=FAqYN9F1nfRapq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBdgMjnsnt1WYoG5AQJJ6g/+LhuC9bHT2HNAyO7rxbDxcwRsWdPrcc2g
Aat3uzHfs+1MEeLV++XJ93x9ZWQhWZ0/h6UCKa5evp2Nn6G6vgD6ZDXwUKYed7bc
v1OLZRLkIg2VIqDotCwuSQpH2kw6Z8U9Y419u3dnYzHbzYWlQk0J387LjbsS5NuE
tP+rguMsy5mginw5/m1/9yCMUQzmToT3YTIa4IkqIshlSjGpRQxitS5TAW0oAJ3y
m9jF17tZkBIGG7nm99mqu2Av3p/WhA0PDSHevD4mObV/ZOiJ7yg/G2ttWQByuCV4
9+aSeBKlzhV8659jkPd/og7uWSHlDIOAR4XTrGODSM6bd1GEuZ/o9UUKFVYaSvCn
I7G0p65u/uwBTrDohTe1QXd63RH644OWKJvmoUALhn8JOTxOmsFDdnNv5u+vqu3O
SQCG7wEWyvKl0VoHWE4v8EZdTatkzHlYZajPYLFQ4OmlagMpw/lBHHzt8x9O8Xp0
vUXpsTtF/j8jKnF9qLpSWEUPaOrs33CDyMbe6uBTGymZgNHqLkSIE6N/zYvoIff6
ZSjeUY7TmWSFygk7Bjn7ImxRJ1dqvQMwU7kVQM6DcwL+3UZyItmSY5amuuPuVhdO
Sy2Shp2ARh6GdVuX+Rp3iiiZPTnAkWBklCjkoWxVmAsFoaym4G0EF3VeaAWUs9ah
YN2oO0nbXM8=
=FtJJ
-----END PGP SIGNATURE-----

--Sig_/2TTJLa7W=FAqYN9F1nfRapq--
