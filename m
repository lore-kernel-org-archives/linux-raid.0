From: NeilBrown <neilb@suse.de>
Subject: Re: ddf failed disk disappears after adding spare
Date: Wed, 15 Aug 2012 09:39:04 +1000
Message-ID: <20120815093904.79b9ac8c@notabene.brown>
References: <5018E8FF.6030402@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7Ogqkm8kLOjW4xjrUHqfNmT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5018E8FF.6030402@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7Ogqkm8kLOjW4xjrUHqfNmT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 01 Aug 2012 10:29:51 +0200 Albert Pauw <albert.pauw@gmail.com> wrot=
e:

> Hi Neil,
>=20
> here is a procedure which shows you another problem. It has to do with=20
> the table produced at the end of the mdadm -E command, showing the disks=
=20
> and their status. Seems when a disk has failed and another added, the=20
> failed one disappears.
>=20
> Hope you can find the problem and fix it.
>=20
> Regards,
>=20
> Albert
>=20
> Here is the exact procedure which shows the problem:
>=20
> Create a container with 5 disks:
>=20
> mdadm -CR /dev/md127 -e ddf -l container -n 5 /dev/loop[1-5]
>=20
>   Physical Disks : 5
>        Number    RefNo      Size       Device      Type/State
>           0    d1c8c16e    479232K /dev/loop1 Global-Spare/Online
>           1    6de79cb6    479232K /dev/loop2 Global-Spare/Online
>           2    b5fd1d6c    479232K /dev/loop3 Global-Spare/Online
>           3    0be2d310    479232K /dev/loop4 Global-Spare/Online
>           4    5d8ac3d0    479232K /dev/loop5 Global-Spare/Online
>=20
>=20
> Create a RAID 5 set of 3 disks in container:
>=20
> mdadm -CR /dev/md0 -l 5 -n 3 /dev/md127
>=20
> Physical Disks : 5
>        Number    RefNo      Size       Device      Type/State
>           0    d1c8c16e    479232K /dev/loop1      active/Online
>           1    6de79cb6    479232K /dev/loop2      active/Online
>           2    b5fd1d6c    479232K /dev/loop3      active/Online
>           3    0be2d310    479232K /dev/loop4 Global-Spare/Online
>           4    5d8ac3d0    479232K /dev/loop5 Global-Spare/Online
>=20
>=20
> Create a RAID 1 set of 2 disks in container:
>=20
> mdadm -CR /dev/md1 -l 1 -n 2 /dev/md127
>=20
> Physical Disks : 5
>        Number    RefNo      Size       Device      Type/State
>           0    d1c8c16e    479232K /dev/loop1      active/Online
>           1    6de79cb6    479232K /dev/loop2      active/Online
>           2    b5fd1d6c    479232K /dev/loop3      active/Online
>           3    0be2d310    479232K /dev/loop4      active/Online
>           4    5d8ac3d0    479232K /dev/loop5      active/Online
>=20
>=20
> Fail first disk in RAID 5 set:
>=20
> mdadm -f /dev/md0 /dev/loop1
>=20
> Physical Disks : 5
>        Number    RefNo      Size       Device      Type/State
>           0    d1c8c16e    479232K /dev/loop1      active/Offline, Failed
>           1    6de79cb6    479232K /dev/loop2      active/Online
>           2    b5fd1d6c    479232K /dev/loop3      active/Online
>           3    0be2d310    479232K /dev/loop4      active/Online
>           4    5d8ac3d0    479232K /dev/loop5      active/Online
>=20
>=20
> Remove failed disk:
>=20
> mdadm -r /dev/md0 /dev/loop1
>=20
> Physical Disks : 5
>        Number    RefNo      Size       Device      Type/State
>           0    d1c8c16e    479232K                 active/Offline,=20
> Failed, Missing
>           1    6de79cb6    479232K /dev/loop2      active/Online
>           2    b5fd1d6c    479232K /dev/loop3      active/Online
>           3    0be2d310    479232K /dev/loop4      active/Online
>           4    5d8ac3d0    479232K /dev/loop5      active/Online
>=20
>=20
> Add failed disk back:
>=20
> mdadm -a --force /dev/md0 /dev/loop1
>=20
> Physical Disks : 5
>        Number    RefNo      Size       Device      Type/State
>           0    d1c8c16e    479232K /dev/loop1      active/Offline,=20
> Failed, Missing
>           1    6de79cb6    479232K /dev/loop2      active/Online
>           2    b5fd1d6c    479232K /dev/loop3      active/Online
>           3    0be2d310    479232K /dev/loop4      active/Online
>           4    5d8ac3d0    479232K /dev/loop5      active/Online
>=20
>=20
> Add spare disk to container:
>=20
> mdadm -a --force /dev/md0 /dev/loop6
>=20
> Physical Disks : 5
>        Number    RefNo      Size       Device      Type/State
>           0    6de79cb6    479232K /dev/loop2      active/Online
>           1    b5fd1d6c    479232K /dev/loop3      active/Online
>           2    0be2d310    479232K /dev/loop4      active/Online
>           3    5d8ac3d0    479232K /dev/loop5      active/Online
>           4    1dcfe3cf    479232K /dev/loop6      active/Online, Rebuild=
ing
>=20
> This is wrong! Physical disks should be 6 now!

Whenever we add a device to the ddf we currently remove any record of any
failed and missing device.  We have to forget about devices that have
disappeared at some stage, and this seems like a good place.

The problem here is that a device that is in the array is marked as
'missing'.  This due to the bug I mentioned in the previous email.  Current=
ly
worked around by --zeroing the device before adding it.

>=20
> Removed failed disk (which is missing from list now!) again, zero=20
> superblock and add again:
>=20
> mdadm -r /dev/md0 /dev/loop1
> mdadm --zero-superblock /dev/loop1
> mdadm -a --force /dev/md0 /dev/loop1
>=20
>=20
> Physical Disks : 6
>        Number    RefNo      Size       Device      Type/State
>           0    6de79cb6    479232K /dev/loop2      active/Online
>           1    b5fd1d6c    479232K /dev/loop3      active/Online
>           2    0be2d310    479232K /dev/loop4      active/Online
>           3    5d8ac3d0    479232K /dev/loop5      active/Online
>           4    1dcfe3cf    479232K /dev/loop6      active/Online
>           5    8147a3ef    479232K /dev/loop1 Global-Spare/Online
>=20
> And there they are, all 6 of them.
>=20

NeilBrown

--Sig_/7Ogqkm8kLOjW4xjrUHqfNmT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCrhmDnsnt1WYoG5AQKmzA//YtBnn2tkAL9jan66VbZMfAzh1NC83TLA
exFLiHImQ0g/s9ZaSj7gdhQWbf3wT0S9LNaIJp1Vz7g8gDP21apImxjkB/VAT6+L
91NjScWQEhPTfF2fxJfMG5YrzyYI3m2ebFrveXZGM1YkA/46uqASMnpURCUZTCS3
gCOxEwPI2m8nSikz8adOFAokmZadqnVEg19p/zd8pYVjzdSYzToRAGxVvdvC0IPc
TtgmaE4CrxXI+wogtzeMuwRWCTT6K5x0fxND9lw520yRK8wrynG8H/6ermXnGpUb
lKgrX23ST8khBpbB/d0EPQD0daIFcc1K/otDA1sRUHk9k9n8bP3177bNSlMTmrvR
scW/SenZXbB9CUyXbzfvtXQd7GRPr37DpJ/kIKJ9GvRw7/ZDz3BZsRaKciJDclOK
8Kpwkru4DHGOGo7y3yL27DRmIEP90ZCyEghiC9FjaCnjVCkqt/snvwR4yOiVd/lr
DQjB83EkfQecAA0lycwPg6kt/GRim3kuHLgawbC18g/T58wnkDEg0nMUVmo3S5H/
ylt1+M8iHZscx31KLcLaVXOl3juoL1QQf5qErqrKonwXHr3RmTafNvrKEeKY7RhK
oj9hDy21yh0/lTE1kNM0e4dvqOlluh/8ZykGPl2J1IeqTKN0a1fivmYkBHP7FHMP
h2TLIYXEuwI=
=xnwC
-----END PGP SIGNATURE-----

--Sig_/7Ogqkm8kLOjW4xjrUHqfNmT--
