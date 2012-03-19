From: NeilBrown <neilb@suse.de>
Subject: Re: How to update homehost of an existing raid component
Date: Tue, 20 Mar 2012 08:28:28 +1100
Message-ID: <20120320082828.0937662d@notabene.brown>
References: <4F670361.6090902@ivitera.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2LD4i2PHPfonAwOmxlwzeoL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F670361.6090902@ivitera.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/2LD4i2PHPfonAwOmxlwzeoL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Mar 2012 10:58:57 +0100 Pavel Hofman <pavel.hofman@ivitera.com>
wrote:

> Hi,
>=20
> Please is there a way to update a homehost value for a specific raid
> component?
>=20
> md7 is raid1 composed of md5 and md6. UUID of md7 is listed in mdadm.conf:
>=20
> ARRAY /dev/md7 level=3Draid1 num-devices=3D2 metadata=3D01.00
> UUID=3Ddde16cd5:2e17c743:fcc7926c:fcf5081e
>=20
>=20
> Every time I reboot, md7 is auto assembled only from md5. When running
> manually, I get
>=20
> mdadm  --verbose -A /dev/md7  --scan
> ...
> mdadm: /dev/md6 misses out due to wrong homehost
> ...
>=20

There is something very strange here.
md5 and md6 look to some extent like different parts of the same RAID1.
They have the same Array UUID, the same "Update Time" and the same "Events"
counter.
However they have different "Creation Time" (19/Jan/2011 vs 17/Jun/2010) and
different names ("orfeus:7" vs "'orpheus':7").

I cannot imagine how that would happen.

mdadm notices they are different so it cannot use them both.  It chooses md5
over md6 as md5 has the 'correct' homehost name.

Your best bet would be to re-create the array so it gets good clean metadat=
a.

mdadm -S /dev/md7
mdadm -C /dev/md7 -l1 -n2 --assume-clean --metadata=3D1.0 /dev/md6 /dev/md5

should do it.  If you want to keep the same uuid, add
   --uuid=3Ddde16cd5:2e17c743:fcc7926c:fcf5081e

to that command.

--update=3Dhomehost only works when assembling, and updates the homehost for
all members of the array.  The would work if the create times were the same,
but a they are different, mdadm thinks they are different arrays.

NeilBrown


>=20
> Indeed, all the raid components (there are many more belonging to
> different raids on my machine) list the "local to host orfeus" homehost,
> such as:
>=20
> orfeus:~# mdadm --examine /dev/md5
> /dev/md5:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : dde16cd5:2e17c743:fcc7926c:fcf5081e
>            Name : orfeus:7  (local to host orfeus)
>   Creation Time : Wed Jan 19 21:36:19 2011
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 4356361184 (2077.27 GiB 2230.46 GB)
>      Array Size : 4356361184 (2077.27 GiB 2230.46 GB)
>    Super Offset : 4356361440 sectors
>           State : clean
>     Device UUID : a4973bb6:2cd83805:ba441193:56321f9b
>=20
>     Update Time : Mon Mar 19 02:36:33 2012
>        Checksum : 7b8eeffd - correct
>          Events : 11853346
>=20
>=20
>    Device Role : Active device 1
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> While the md6 has the homehost different:
> orfeus:~# mdadm --examine /dev/md6
> /dev/md6:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : dde16cd5:2e17c743:fcc7926c:fcf5081e
>            Name : 'orfeus':7
>   Creation Time : Thu Jun 17 22:51:47 2010
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>  Avail Dev Size : 4356361184 (2077.27 GiB 2230.46 GB)
>      Array Size : 4356361184 (2077.27 GiB 2230.46 GB)
>    Super Offset : 4356361440 sectors
>           State : clean
>     Device UUID : 9144c9ad:8ee3ed37:69b53956:03bebdd6
>=20
>     Update Time : Mon Mar 19 02:36:33 2012
>        Checksum : 94c11ff3 - correct
>          Events : 11853346
>=20
>=20
>    Device Role : Active device 0
>    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> There is no "local to host orfeus" in homehost of md6. Otherwise, the
> array UUID fits that of md7. It was added after last reboot when the
> array failed to assemble automatically.
>=20
> Following the man page, I tried running
>=20
> mdadm --verbose -A /dev/md7 --update=3Dhomehost --scan
>=20
> with no difference. Unfortunately I was not able to find how to change
> the homehost of md6 to be local to orfeus. I do not want to force adding
> md6 to the array and go through the whole rebuild since the data
> themselves are OK.
>=20
>=20
> Thanks a lot for any hints and help.
>=20
> Best regards,
>=20
>=20
> Pavel.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/2LD4i2PHPfonAwOmxlwzeoL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2ek/Dnsnt1WYoG5AQK5RQ/+KfgXbHZ1oFGiEa0z5fdf96bDshkMI7DR
5d8saVw+3JUfZGFBloZEvK4UrDE0lb9lMlKI+6c88itcXp3gYbRBtrW4z/FSuQuv
pg/ehOAVeGxUabu8VSHSzlv3Q8AVJ3djH55FnFvbagXtmDVzbMVeUq1ZqJwY3Ugn
l71SL9zjByOCTnYVKuTQyIlRraCGYfpyVIK4dqSPrYfxbtScY43jVjgVcXCNXhyH
5Xj9Pr+wisFcKjLpOjyfSpqBUnhczFVq9+aMUg2ogwnInOpJEjLlGfcipyQOvl1G
lru8j2x/ig3BeppgJow9PZFRC1EMZhnJdEi5DCoccSg/7m8QpGz6kS8P8u6xnZaL
2h1TitfCN/CyO1N7BRQLeeJp/cN12zHSBWZS3tXs3yXemDrVa85SCy+FmZ1OTb1E
xU+t0vvbhaLbGhsCj3usj9vNe2uZm0GWZKBYwV/WyRPYNSkBYKCj0o115k6aHkNe
zKHqhZ9ywAseRE4vOqEa2AMiqC+TXmh5frbwKpEg/t1dLViWjfcZFZgwlKn32v7Q
Zp8bgGpu86p6727FeH3P1piPOkw3yzcu55sNOnndvcvXRZW4y+PQAieRbNqKZcwh
vfhG2m9f5VXvw1L80xt3QwflHp+vd+sVaOtptCNaoQOVoriBGEH4QSgarVFOycWt
YkUzc/qHBPg=
=gSFC
-----END PGP SIGNATURE-----

--Sig_/2LD4i2PHPfonAwOmxlwzeoL--
