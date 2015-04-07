From: NeilBrown <neilb@suse.de>
Subject: Re: Creating volume in IMSM container
Date: Wed, 8 Apr 2015 07:28:53 +1000
Message-ID: <20150408072853.44d0890e@notabene.brown>
References: <mg0t3u$ol$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0LwBl0ZqoB0JVHlG7jrm6OA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <mg0t3u$ol$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0LwBl0ZqoB0JVHlG7jrm6OA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 07 Apr 2015 10:29:02 -0500 Ian Pilcher <arequipeno@gmail.com> wrote:

> I am trying to create an IMSM container and volume in a KVM virtual
> machine (so that I can create a reproducer for a Fedora problem that
> seems to only/mostly affect IMSM RAID).  I've  managed to create a
> container with the following command:
>=20
>    IMSM_NO_PLATFORM=3D1 mdadm --create --verbose /dev/md/imsm \
>        /dev/vd{a,b} --raid-devices 2 --metadata=3Dimsm
>=20
> /proc/mdstat now contains:
>=20
>    Personalities: [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] ...
>    md127 : inactive vdb[1](S) vda[0](S)
>          2210 blocks super external:imsm

2210 blocks is tiny.
I think each device needs at least 6306 sectors for IMSM.
I suggest going for at least 20,000.

>=20
> I haven't, however, been able to create a volume within the container:
>=20
>    # IMSM_NO_PLATFORM=3D1 mdadm --create --verbose /dev/md/vol0 \
>         /dev/md/imsm --raid-devices 2 --level 1 --metadata=3Dimsm
>    mdmon: not enough devices with space to create array.

This should  work once you have devices with enough space.

>=20
>    # IMSM_NO_PLATFORM=3D1 mdadm --create --verbose /dev/md/vol0 \
>         /dev/vd{a,b} --raid-devices 2 --level 1 --metadata=3Dimsm
>    mdadm: /dev/vda appears to be part of a raid array:
>           level=3Dcontainer devices=3D0 ctime=3DThu Jan  1 00:00:00 1970
>    mdmon: /dev/vdb is not in the same imsm set
>    mdadm: /dev/vdb is not suitable for this array.
>    mdadm: create aborted
>=20

This looks like a bug.  What version of mdadm.

NeilBrown


> Am I doing something wrong, or is this simply not possible?
>=20


--Sig_/0LwBl0ZqoB0JVHlG7jrm6OA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSRMFTnsnt1WYoG5AQJH8hAAlZvilAbEd+7ZGrKzeZRJQgbhoSpZl58G
+BAjBwiU9aFLy6gcjmroCsRHEc3Edi2p52kyU0RkmV5mu3vv0BjBsru2JzoX7MGu
YXk/gNga9ZhrAehk5noS/YetLsFST+8vLK4Hc1CCesSbPZu4biTqc9NTwFiqN1mg
qqOJIMzL5coCjckJPizOuv31ZgfSwnZMdztLum6FMxJrRqb4JolqQ0vXPXDuLRRy
ipLKOu2M7gSdqVgDQOzbtlY4f0dNecNWTFNUaX/yv5Tgnb4NjhiFyt4w9unZ5IWj
LG1SSqh1MFZXSmukDPkMFG97vfvlGDL4aGuUisVEkUvelRl/XyeenTZ+ap0dYmVX
f3/dVePo4gAEfEDkWKecilLmhaFZrvRJb6GwUJxe7pNvbSj0g59D/LCoqlYdsj+N
UCC+IPaw0MZm44HppCzVDt+3Vb8wR55Ikt7P7NYhVDD8w2PBLsODzVKAWf/lb1YP
l53KNqi1QsrnKaZfQ/MS7MRW3yXoPD/C7OeppGl/bXfUu47ElJ2sc8AeEnhSDoxH
iX3/BZG9m8LxdfftOqVvmyrjXlBECUEw3nui4Ojuq1wBD6dJ7TtUdkVeBzNjs1Ba
OiSXfT+D6IGJ8pkXAH1e9+BUm7LFf+rjD9DG1xfX3zcJc2+DRcBcU01iNu991nqv
ddhPVVjtmbI=
=qsgQ
-----END PGP SIGNATURE-----

--Sig_/0LwBl0ZqoB0JVHlG7jrm6OA--
