From: NeilBrown <neilb@suse.de>
Subject: Re: Some info given by 'mdadm --detail --export' are not convenient
 to use
Date: Sat, 12 Apr 2014 09:43:30 +1000
Message-ID: <20140412094330.12fbf1a7@notabene.brown>
References: <5347CB9D.5090702@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RSrgr4go/M=cFLXF0zF95Go"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5347CB9D.5090702@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/RSrgr4go/M=cFLXF0zF95Go
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Apr 2014 13:01:49 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello,
>=20
> I'm writing a tool that relies udev lib in order to manage block
> devices connected to my computer.
>=20
> One thing that I need is to retrieve disks contained by a RAID array.
>=20
> The current usefull information exported by udev are, for example:
>=20
> MD_DEVICES=3D3
> MD_DEVICE_loop0p1_DEV=3D/dev/loop0p1
> MD_DEVICE_loop0p1_ROLE=3D0
> MD_DEVICE_loop1p1_DEV=3D/dev/loop1p1
> MD_DEVICE_loop1p1_ROLE=3D1
> MD_DEVICE_loop2p1_DEV=3D/dev/loop2p1
> MD_DEVICE_loop2p1_ROLE=3D2
>=20
> but this is not really easy to exploit since I need to know the disk
> names in order to poke the devices used by the array :-/
>=20
> why not simply using ?
>=20
> MD_DEVICE_DEV_1=3D/dev/loop0p1
> MD_DEVICE_ROLE_1=3D0
>=20

What number would I use for spare devices?
Certainly something like this could be done, but it wasn't.

Maybe what you are really asking is:

"Could we please have another record which lists all the devices, e.g.
  MD_DEVICE_LIST=3Dloop0p1 loop1p1 loop2p1
??"

Obviously you can extract that from the output above, but it might be easier
to have it explicitly.

Would that meet your need, or have I misunderstood you completely?

NeilBrown

--Sig_/RSrgr4go/M=cFLXF0zF95Go
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0h+Ijnsnt1WYoG5AQJTwRAApc5mU5QPX4n25TJXWSAuU1uZBsxBKQZK
6XcxdxveKYgPqxeZ6ER1tNww8Cp80r0Ho77h+ctC1EuQewD+WrevmpIwUCe4Jar9
ar7NsDPbdPQ/RvzyhO9c1a7blugbZK2XSUn41Ctj3IPEs0z2VHi6MWfnWI2SGhqr
STyv8LKmIfAXVjwHuMa6S2DG0Rff9/7p69E35rcv17rgewKqIqHdaAwBzc38FUKm
rMQ2KMKzo5bHgAhpl4ShGkXc5XjAWnm6Gbn6zXCM/KBcCXC4Z7BL8trcvdehxc0z
6DAqSFU8tTo7hHzjMMdQVb95htnqE/5SVZLfSXYWSmwRyJ4ggpriG2PcQejb77p8
hY+4PiqOWX023lFDQEx5PSol911VFSCTsoJ/PIbhT+PdJ8eH0LnlADHM17ZJDu/2
CqgULJ9eZEtJ/zYyDciQ59N1XWB9sRzuvhGHtZxLkDdSY0lAp9AgkD3SqS2qRNzR
5eGHdq7pPntWfpFQe1wOigkUU3Yk4iyeEymhKzkGlYZOYTXBBQzlIHW0xQiYaHkG
PTaF0yQpkvsGu9j5hYjdS6wFTRQWQ4jQy7p3gNlp0lYn/y4FCsZAi8K1EitsMC/K
+ul+nXevSZnbLHVokgQRtG7TaCPNzgffsVtWBaD3b5ZDwGo9agx/fAFkLJBaJjMq
YgvWxOf7jUA=
=ideW
-----END PGP SIGNATURE-----

--Sig_/RSrgr4go/M=cFLXF0zF95Go--
