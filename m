From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm ignoring X as it reports Y as failed
Date: Mon, 8 Jul 2013 11:28:11 +1000
Message-ID: <20130708112811.5b3fad4b@notabene.brown>
References: <20130706210614.180228gmgmc172qu@mail.netbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ahhGC5vhNIhyheV+3YtTph."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130706210614.180228gmgmc172qu@mail.netbox.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Marek Jaros <mjaros1@nbox.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ahhGC5vhNIhyheV+3YtTph.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 06 Jul 2013 21:06:14 +0200 "Marek Jaros" <mjaros1@nbox.cz> wrote:

> Hey everybody.
>=20
> To keep it short, I have a RAID-5 mdraid, just today 2 out of the 5 =20
> drives dropped out. It was a cable issue and has since been fixed. The =20
> array was not being written to or utilized in other way so no data has =20
> been lost.
>=20
> However when I attempted to reassemble the array with
>=20
> mdadm --assemble --force --verbose /dev/md0 /dev/sdc /dev/sdd /dev/sde =20
> /dev/sdf /dev/sdg
>=20
>=20
> I got the folowing errors
>=20
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 4.
> mdadm: ignoring /dev/sde as it reports /dev/sdc as failed
> mdadm: ignoring /dev/sdf as it reports /dev/sdc as failed
> mdadm: ignoring /dev/sdg as it reports /dev/sdc as failed
> mdadm: added /dev/sdd to /dev/md0 as 1
> mdadm: no uptodate device for slot 2 of /dev/md0
> mdadm: no uptodate device for slot 3 of /dev/md0
> mdadm: no uptodate device for slot 4 of /dev/md0
> mdadm: added /dev/sdc to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.
>=20

Try the same assemble command, but rearrange the devices so that one of sde
sdf sdg is first.  That might work.

The super blocks all have the same event count, but report different things
about which devices have failed.  That shouldn't really happen but it
obviously did.
I'll see if I can figure out how to make mdadm cope correctly with this
situation.

Thanks for the report,

NeilBrown


>=20
> After doing --examine* I indeed found out that the StateArray info =20
> inside the superblock has marked the first two drives as missing. That =20
> is however not true anymore but I can't force it to assemble the array =20
> or update the superblock info.
>=20
> So is there anyway to force mdadm to assemble the array? Or perhaps =20
> edit the superblock info manually? I'd rather avoid having to recreate =20
> the array from scratch.
>=20
> Any help or pointers with more info are highly appreciated. Thank you.
>=20
>=20
> Regards,
>=20
> Marek Jaros
>=20
>=20
> *--examine output here:
>=20
> /dev/sdc:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 43222604:a15a957d:313d7b6c:d087ba6a
>             Name : YSGARD:0
>    Creation Time : Thu Apr 25 12:38:17 2013
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>       Array Size : 3906525184 (3725.55 GiB 4000.28 GB)
>    Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : d2a4d8ed:b2c2bf12:6d553d16:7aabe804
>=20
>      Update Time : Sat Jul  6 14:43:14 2013
>         Checksum : 1b569235 - correct
>           Events : 2742
>=20
>           Layout : left-symmetric
>       Chunk Size : 512K
>=20
>     Device Role : Active device 0
>     Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdd:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 43222604:a15a957d:313d7b6c:d087ba6a
>             Name : YSGARD:0
>    Creation Time : Thu Apr 25 12:38:17 2013
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>       Array Size : 3906525184 (3725.55 GiB 4000.28 GB)
>    Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : f729ddca:adb2eaec:748ad0b6:0e321903
>=20
>      Update Time : Sat Jul  6 14:29:42 2013
>         Checksum : 7149bfc6 - correct
>           Events : 2742
>=20
>           Layout : left-symmetric
>       Chunk Size : 512K
>=20
>     Device Role : Active device 1
>     Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sde:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 43222604:a15a957d:313d7b6c:d087ba6a
>             Name : YSGARD:0
>    Creation Time : Thu Apr 25 12:38:17 2013
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>       Array Size : 3906525184 (3725.55 GiB 4000.28 GB)
>    Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : 83aea2f7:dc6a7d68:0d875248:c54d2bc9
>=20
>      Update Time : Sat Jul  6 14:46:15 2013
>         Checksum : 713418b2 - correct
>           Events : 2742
>=20
>           Layout : left-symmetric
>       Chunk Size : 512K
>=20
>     Device Role : Active device 2
>     Array State : ..AAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdg:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 43222604:a15a957d:313d7b6c:d087ba6a
>             Name : YSGARD:0
>    Creation Time : Thu Apr 25 12:38:17 2013
>       Raid Level : raid5
>     Raid Devices : 5
>=20
>   Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>       Array Size : 3906525184 (3725.55 GiB 4000.28 GB)
>    Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : b8295773:a4a73e18:6a097100:15ecc829
>=20
>      Update Time : Sat Jul  6 14:46:15 2013
>         Checksum : b565f15d - correct
>           Events : 2742
>=20
>           Layout : left-symmetric
>       Chunk Size : 512K
>=20
>     Device Role : Active device 4
>     Array State : ..AAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> ----------------------------------------------------------------
> This message was sent using IMP, the Internet Messaging Program.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/ahhGC5vhNIhyheV+3YtTph.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdoVqznsnt1WYoG5AQLWWg/9HruOEWxom9eltSz894KSOQprMvIoKRoI
MLwibbubQaFjy/WcACPRytcVXTgEjrgYeVn9tmDYyTLxT/9Ci5NWeI1kos3mF2B2
T56mchu/1FDsPDTj6jYgYhU9qyyqyoe6XwV3hEseWPp4v914d/EfDBwN1ryAzG9q
0hZBMP69edNLTUOpBrHu9yAjS3Rh9TMbkLdGMLoZEOO8dG4rqYf5r4G7D2iFB0sT
mNHyJudw6pmigdVICN82e72hzymSoQVMo4Ts5uaPl8SvShV5MYWbVNMw7Y2+1ihs
+exqotpci7/Dz1G5wYFztsmyd1wKZeLnMS3BMBUh+OJEiZI3b+q6pNkxao6rRbLg
qlaq+PIvxQ/iKHWJq5Ck8wPu0SMEJBt8+9AwezQaPG+5bLd5A02pEjOykDa4e1PY
pErTl7/U6MBjvs0/MGXyRhpeg/K1lcj3RjzMpk1t4/k/WcmMsHYzhN/zf58RhRFQ
Nlf6W/NTwkAzSRa9elK9g7sA+u4+O6ztTCq/phiXmiJ4c2YakzPMWU+gPAjZfMqk
9ETHiTAh+3VW6BYznd6Q3MHiRgk4eSVPbWU19VhB7U8r+ba8utwcqLNoYnwp2qY1
+EbkvFKQgjid9+AAOdeKnSVJ7kTo5k4dypckFPW6GZk4cWJ+NwblNP006LHaY3CH
kIzEUaD95X8=
=cfiQ
-----END PGP SIGNATURE-----

--Sig_/ahhGC5vhNIhyheV+3YtTph.--
