From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Sat, 28 Apr 2012 10:24:37 +1000
Message-ID: <20120428102437.754d82c3@notabene.brown>
References: <4F9AFBC6.7070803@weboperative.com>
	<4F9B14FA.1090001@weboperative.com>
	<20120428080522.637bc564@notabene.brown>
	<4F9B2BE1.5080207@weboperative.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Io3d.MZGVtHyU.KJX9jKA2w"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9B2BE1.5080207@weboperative.com>
Sender: linux-raid-owner@vger.kernel.org
To: likewhoa <likewhoa@weboperative.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Io3d.MZGVtHyU.KJX9jKA2w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Apr 2012 19:29:37 -0400 likewhoa <likewhoa@weboperative.com> wro=
te:

> On 04/27/2012 06:05 PM, NeilBrown wrote:
> > On Fri, 27 Apr 2012 17:51:54 -0400 likewhoa <likewhoa@weboperative.com>=
 wrote:
> >
> >
> >> adding more verbose info gives me:
> >>
> >>> -> mdadm -A --verbose /dev/md1
> >> mdadm: looking for devices for /dev/md1
> >> mdadm: /dev/dm-8 is not one of
> >> /dev/sdg3,/dev/sdf3,/dev/sde3,/dev/sdd3,/dev/sdb3,/dev/sda3,/dev/sdc3
> > You seem to have an explicit list of devices in /etc/mdadm.conf
> > This is not a good idea for 'sd' devices as they can change their names,
> > which can mean they aren't on the list any more.  You should remove that
> > once you get this all sorted out.
> >
> > NeilBrown
> >
> >
> @Neil sorry but I didn't get to reply to all on my last 2 emails, so
> here is goes again so it's archived.
>=20
> /dev/sdh3:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : 828ed03d:0c28afda:4a636e88:7b29ec9f
>            Name : Darkside:1  (local to host Darkside)
>   Creation Time : Sun Aug 15 21:12:34 2010
>      Raid Level : raid10
>    Raid Devices : 8
>=20
>  Avail Dev Size : 902993648 (430.58 GiB 462.33 GB)
>      Array Size : 3611971584 (1722.32 GiB 1849.33 GB)
>   Used Dev Size : 902992896 (430.58 GiB 462.33 GB)
>    Super Offset : 902993904 sectors
>           State : clean
>     Device UUID : 00565578:e2eaaba3:f1eae17c:f474ee8d
>=20
>     Update Time : Wed Apr 25 17:22:58 2012
>        Checksum : 1e7c3692 - correct
>          Events : 82942
>=20
>          Layout : far=3D2
>      Chunk Size : 256K
>=20
>    Device Role : Active device 0
>    Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> =20
>=20
> The only drive that didn't get affected is far=3D3. Any suggestions? I
> have the drives on separate controllers and when I created the array I
> set up the order as /dev/sda3 /dev/sde3 /dev/sdb3 /dev/sdf3 and so on.
> so I would assume the same order would be used, also note that I ran
> luksFormat on /dev/md1 then ran pvcreate /dev/md1 and so on. Will I have
> issues with luksOpen after recreating the array? I removed the /dev/sdh1
> drive so now the output is like:

As the array is "far=3D2" you will need to create with --layout=3Df2

That means you cannot easily detect pairs by comparing the first few
kilobytes.

However if you are confident that you know the order of the drives (because
of they arrangement of controllers) then maybe you can just create the arra=
y.
Make sure you set --chunk=3D256


Yes, you will need to 'luksOpen' after recreating the array.  That will
quite possibly fail if you have the order wrong.
Then you would need to "pvscan" or whatever one does to find LVM components.
If both those succeed, then try "fsck -n".
If they fail, try a different ordering.

NeilBrown

--Sig_/Io3d.MZGVtHyU.KJX9jKA2w
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5s4xjnsnt1WYoG5AQJU2g/9EPhWup9oLoooYn9y+a7SGUGAXTdzrOZT
8YghnHWhokQB3zrluxXaPV9ORPMzK3sG+YnUwe+aagkqVhGXADlDnEmswXpi7FiF
Rjdetb+54vl6GfUzQxwaoc+R9gTQ07YOM9pDy4qnaH2CXzzIwPR071d7lV3xXrFK
2nh6oEis233G7NdxukrejWtRgZlOqlHiFWksbAtugxE5sUmGoOVMnk44K29ClL5E
8Aq9FefdGydz21BuezJepRHo3znNWH2KWcJawhVRPohx7j+ccOkXVsx2SMKw7mnf
5irAZIF6AreYwNGSZzLFeNHbWFY3WxUeATUTcVWfNCgdIfBgTSRvhxwGSSYyL/gB
d4OOOdKDbRR+eQxHDKbjVQ4hDwe58tUx4B6K+wbt0+0472rY80NhyZUMp7zuFwQ5
9/wHLk3TBFi0zT6ojAEusFy3iWk/F3df8mq36574RkHGWTqZB237oreU94K95k83
o6c5qhYd9DWe+YEpyKlU739oGZLpmftdF2PSA6m5nLYOzdeTVnMIoWsuxJbeZuR0
bX5ARnPDF5x5OrCkcVUQ3NMDfPXRFfnFlM+OIRBC690zUsu/jn6+Qgu11RhYg/Fo
QxJcdkcFs4L5ZXoqXDOwtTqA3RrQrCwmNdqz4P4vTPYUvYdRE7arnXWFgx4amoCT
7+s4UD2xbS8=
=ADOE
-----END PGP SIGNATURE-----

--Sig_/Io3d.MZGVtHyU.KJX9jKA2w--
