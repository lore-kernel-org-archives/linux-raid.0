From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm fails to assemble arrays with quotes in name
Date: Thu, 9 May 2013 15:14:23 +1000
Message-ID: <20130509151423.7c0e2256@notabene.brown>
References: <5187E9AB.4040904@superhosting.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XxoaX+vgc4m3p9HQIz65q7R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5187E9AB.4040904@superhosting.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Marek Becka <marek.becka@superhosting.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XxoaX+vgc4m3p9HQIz65q7R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 May 2013 19:34:35 +0200 Marek Becka <marek.becka@superhosting.cz>
wrote:

> Hi,
>=20
> By accident I have created an array with simple quotes in name:
>=20
> mdadm --assemble /dev/md0 --name=3D\'newname\':0 --update=3Dname /dev/sdb=
1=20
> /dev/sdd1
>=20
> My mdadm.conf contains following line:
>=20
> ARRAY /dev/md/0 metadata=3D1.2 UUID=3D0324aa8b:e17efd1a:bae27dd0:66fc7573=
=20
> name=3D'newname':0

Try:
   ..... name=3D"'newname':-"

That should work.  Quotes are special.

I should probably update the mdadm.conf manpage to mention that.

NeilBrown


>=20
> Mdadm fails to assemble this array. After removing the name from=20
> mdadm.conf, everything works fine.
>=20
> mdadm  --assemble --scan -v 2>&1 | grep sd[bd]1
> mdadm: no RAID superblock on /dev/sdd1
> mdadm: no RAID superblock on /dev/sdb1
> mdadm: /dev/sdd1 has wrong uuid.
> mdadm: /dev/sdb1 has wrong uuid.
> mdadm: /dev/sdd1 has wrong name.
> mdadm: /dev/sdb1 has wrong name.
>=20
> I'm using mdadm - v3.2.5 - 18th May 2012 and kernel version 3.4.35. The=20
> superblock contains:
>=20
> mdadm  --examine /dev/sdb1
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 0324aa8b:e17efd1a:bae27dd0:66fc7573
>             Name : 'newname':0
>    Creation Time : Thu Apr 11 17:54:28 2013
>       Raid Level : raid1
>     Raid Devices : 2
>=20
>   Avail Dev Size : 2097128 (1024.16 MiB 1073.73 MB)
>       Array Size : 1048564 (1024.16 MiB 1073.73 MB)
>      Data Offset : 24 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : e9094b42:d1f2e7e4:71b7a626:77e008aa
>=20
>      Update Time : Sat Apr 13 00:53:27 2013
>         Checksum : afddd58 - correct
>           Events : 36
>=20
>=20
>     Device Role : Active device 0
>     Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> mdadm  --examine /dev/sdd1
> /dev/sdd1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 0324aa8b:e17efd1a:bae27dd0:66fc7573
>             Name : 'newname':0
>    Creation Time : Thu Apr 11 17:54:28 2013
>       Raid Level : raid1
>     Raid Devices : 2
>=20
>   Avail Dev Size : 2097128 (1024.16 MiB 1073.73 MB)
>       Array Size : 1048564 (1024.16 MiB 1073.73 MB)
>      Data Offset : 24 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : a841cc4e:b37b0765:70225714:71c65fdd
>=20
>      Update Time : Sat Apr 13 00:53:27 2013
>         Checksum : b8a5eef2 - correct
>           Events : 36
>=20
>=20
>     Device Role : Active device 1
>     Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/XxoaX+vgc4m3p9HQIz65q7R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYswrznsnt1WYoG5AQL6HBAAu0BHdhjh6U9WjyT2mma+rQAjMLmkQZST
PQ5pzqmlAv+txgD06XyPVfcUScYo0Xm3+QDi/TBDHs3rzh45QnmA+q2FPKSVnjti
Xk2tnoIQn3dpwUFk2fkwUTXRvHLyw2WsydWRb3zsWw0tWwdxSzM0pz/TPkTyaGXh
7QOhWDOE3DVSKKvU10KTUV3R+Dnn7mVG3O/b9q7ZYLU8Em63pduES5fcws+u3ZxB
59ThEB2QvbYNp4MQbZmgVO6s4bYOVb31F1CUfOhtTGTTERXLnkqh9/ab0UtSC8At
qZLNzbs/ebQMrMwBCTADAd4IeiJu4cPEzn4NsRFUQ3hrWH5LXZwELG15WjGHnDdx
uV0hUey0HBe0ULB9346WxSq9wWDwLA/+Z+dlbbyxcPqpw1HV/Mjp7vqZonkzRCQO
HClpUQ3oFju4iLVZ3kts5srqKqqMjcx2N+Rx5TaGIFsEzx4PxF6KXMYDySSHiTXS
3W05fI5JvhjwBYZ5o/nAGYbQfnd7o79eiS+tSvoZzDC9KfbE6+I973F6mXzVufmk
Gd6DMvkmSQltM7obwsTcIz6M8mWz+ZsfcYHIcIRaqb3xuBxSfEgqObK5lTWx4n5L
1gx+vDvEHWzL0BrMqg6iCrLs97ljW4M2L1/wnBg1KvVPnKmn/mqd/pPKeb3HktTm
2CIP+PHRSNA=
=+3VR
-----END PGP SIGNATURE-----

--Sig_/XxoaX+vgc4m3p9HQIz65q7R--
