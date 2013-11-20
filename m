From: NeilBrown <neilb@suse.de>
Subject: Re: MDADM 3.3 broken?
Date: Wed, 20 Nov 2013 13:30:16 +1100
Message-ID: <20131120133016.7de2d400@notabene.brown>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
	<20131120114833.695fc9d4@notabene.brown>
	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>
	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1yipBzIx.Rb9Hd7st.DJES9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1yipBzIx.Rb9Hd7st.DJES9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Nov 2013 17:34:29 -0800 "David F." <df7729@gmail.com> wrote:


> Contents of /proc/partitions:
> major minor  #blocks  name
>=20
>    8       32  143638992 sdc
>    8       33     102400 sdc1
>    8       34  143535568 sdc2
>    8       48  143638992 sdd
>    8       64  143638992 sde
>    8       80  143638992 sdf
>    8       81     102400 sdf1
>    8       82  143535568 sdf2
>    8       96  143638992 sdg
>   11        0      48160 sr0
>    8       16    7632892 sdb

This seems to suggest that there are no md devices that are active.


> Contents of /proc/mdstat (Linux software RAID status):
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath]
> md127 : inactive sdg[0](S)
>       1061328 blocks super external:ddf
>=20
> unused devices: <none>

And this confirms it - just md127 which is inactive and is a ddf 'container=
'.

> Contents of /etc/mdadm/mdadm.conf (Linux software RAID config file):
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>=20
> # by default (built-in), scan all partitions (/proc/partitions) and all
> # containers for MD superblocks. alternatively, specify devices to scan, =
using
> # wildcards if desired.
> DEVICE partitions containers
>=20
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>=20
> ARRAY metadata=3Dddf UUID=3D7ab254d0:fae71048:404edde9:750a8a05
> ARRAY container=3D7ab254d0:fae71048:404edde9:750a8a05 member=3D0
> UUID=3D45b3ab73:5c998afc:01bbf815:12660984

This shows that mdadm is expecting a container with
      UUID=3D7ab254d0:fae71048:404edde9:750a8a05
which is presumably found, and a member with
      UUID=3D45b3ab73:5c998afc:01bbf815:12660984
which it presumably has not found.

> >
> >> mdadm --examine --scan
> > ARRAY metadata=3Dddf UUID=3D7ab254d0:fae71048:
> > 404edde9:750a8a05
> > ARRAY container=3D7ab254d0:fae71048:404edde9:750a8a05 member=3D0
> > UUID=3D5337ab03:86ca2abc:d42bfbc8:23626c78

This shows that mdadm found a container with the correct UUID, but the memb=
er
array inside the container has the wrong uuid.

Martin: I think one of your recent changes would have changed the member UU=
ID
for some specific arrays because the one that was being created before wasn=
't
reliably stable.  Could  that apply to David's situation?

David: if you remove the "UUID=3D" part for the array leaving the
"container=3D.... member=3D0" as the identification, does it work?


> >
> >> mdadm --assemble --scan --no-degraded -v
> > mdadm: looking for devices for further assembly
> > mdadm: /dev/md/ddf0 is a container, but we are looking for components
> > mdadm: no RAID superblock on /dev/sdf
> > mdadm: no RAID superblock on /dev/md/MegaSR2
> > mdadm: no RAID superblock on /dev/md/MegaSR1
> > mdadm: no RAID superblock on /dev/md/MegaSR

This seems to suggest that there were 3 md arrays active, where as the
previous data didn't show that.  So it seems the two sets of information are
inconsistent and any conclusions I draw are uncertain.

NeilBrown


--Sig_/1yipBzIx.Rb9Hd7st.DJES9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoweuDnsnt1WYoG5AQJ/hRAAr+RdWJMdhL1BPbYQYx9UJaIOluA+g5OM
4Xk5Sek8saY3M7HYTqCjd0eNic37xu4JngSAyQaKsT+NTT+V2Y6tIWz+ucBvJ8Im
cMFwWf6LxDULDSF03AIHqfp4bSGbcP5/70+OYYn2DtDv2hmK9rYD31OhF5AXbnYj
9+TTtM5FgBpPu+efgcz3yQdjcFlLVii8F0eYPQasscjOlML4BvSxu+sl9ob7fEnq
HefGGLMdfl5oAYcyGS3SxHupyM3tJ+WXn6b266exfRJjQuvXm3ysUcPGqtuecL54
4SGiSuKc34/PaRUeBwGZPmH6TdLmicfE4k14TttoLJ843gSYYp31jsXNHnEEbA0z
BnFJATpd53OMbigho1I+RYmQ0kiyytlVZxJ+2aWIav5CieWLThMcUiJsh5ke0GCa
TnPyZOt+/oKymIk23qsxkDx2MlleWvqFgbxT1TrobFI+aLLUv0JF2omWeI1aPXcV
YMuvr9rElcFuk0xw7qnseWzez//9F9PkyC+1kJr6CUv8cZA9y8S4eZnBrou4AyFo
FvlSttzuz3hSGU4qwcIFSfz8GoR4tudt7CRKMuNyYwqQCeL/lRaKS2lo3kGy+kLE
YtqZm9jpz44wXlJAdo2tntbazBmHmUFHc170JAyx8pxXuuFxSB/JFi6ErCleuLCM
9oeQSyxoQo8=
=nP/p
-----END PGP SIGNATURE-----

--Sig_/1yipBzIx.Rb9Hd7st.DJES9--
