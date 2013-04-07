From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 to 10 (Synology NAS)
Date: Mon, 8 Apr 2013 08:28:02 +1000
Message-ID: <20130408082802.5910fe6f@notabene.brown>
References: <CAODtcdcVkLDS6UvA8MubGdo7Oe_Vzp_X45u83rfJKQeDjdT_=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/52Nrm8M2T8=epT1Gscj0RTl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAODtcdcVkLDS6UvA8MubGdo7Oe_Vzp_X45u83rfJKQeDjdT_=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Grant <bigal.nz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/52Nrm8M2T8=epT1Gscj0RTl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 7 Apr 2013 09:54:20 +1200 Al Grant <bigal.nz@gmail.com> wrote:

> Hello,
>=20
> I have a Synology NAS with two 3Tb disks in RAID1 (sda+sdb).
>=20
> The output of /proc/mdstat is:
>=20
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md2 : active raid1 sda3[0] sdb3[1]
>       2925544256 blocks super 1.2 [2/2] [UU]
>=20
> md1 : active raid1 sdb2[1] sda2[0]
>       2097088 blocks [10/2] [UU________]
>=20
> md0 : active raid1 sdb1[1] sda1[0]
>       2490176 blocks [10/2] [UU________]
>=20
> unused devices: <none>
>=20
> I have added another two 3Tb disks (sdc and sdd).
>=20
> I would like if possible to convert the raid1 to raid10.
>=20
> I have seen guides on google on how to do this either by:
>=20
> Creating a RAID10 with the two new disks and specifying two disks as
> missing. Remove one old disk, sync and then add the fourth and final
> disk; OR
>=20
> Another method outlined here:
> http://www.linuxquestions.org/questions/linux-server-73/convert-raid-1-sy=
stem-into-raid-1-0-a-557471/

I would:
  Create a raid10 with the 2 new devices and alternating missing devices:
    mdadm -C  /dev/md3 -l10 -n4 /dev/sdc3 missing /dev/sdd3 missing

  copy data from /dev/md2 to /dev/md3 however you like.

  Confirm that you can see the new array after a reboot.

  Stop the old md2 and add the devices to md3
    mdadm -S /dev/md2
    mdadm /dev/md3 --add /dev/sdc3 /dev/sdd3

>=20
> My issue is that I actually have md0 md1 and md2 (presumably because
> there are partitions which hold the OS for the NAS).

They should not interfere at all.  If probably make sense to partition the
new devices the same as the old devices, and add sdc2 and sdd2 to md1, and =
add
sdc1 and sdd1 to md2.  They have clearly been created in a way that makes it
easy to add extra  partitions when extra devices are added to the box.

NeilBrown


>=20
> Can I still do this grow operation?
>=20
> Is anyone able to help me through this please?
>=20
> Thanks in advance
>=20
>=20
> --
> "Beat it punk!"
> - Clint Eastwood
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/52Nrm8M2T8=epT1Gscj0RTl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUWHy8jnsnt1WYoG5AQKnXhAAiHwrzXjZYB9ImfoHpDrgYoPNcQR1f5Ft
2lMz22zhUyUwQ2D3tsZJI/ipdPKQ5c5dhUuntPgJ9wH/57q4VEPxqPbKUT+GTxLH
9DwbjDeIMfiMOFhpBcHTWbLjjieTBnXBN/4AEK1JtRtzABGcbp26rJKj8peD0ESP
hYBHElzWBeLPzsQbfOcXPkYSG7YELhjS7wD9eJhHRsbEou3u+ZMPOnD67vAxoeYu
7leBNeQsedp/YKJVBdwddLG1y40alb9m3rxR5e2+KCqe6cU3Bba9wvcni4RioVGd
Mtv0NG2o19e4yAqOOXufxtiZ6hzADGLxzth242DiGWqqlsizFqWq5KuKwwOd46kA
RbIOoX0NicupmymkUnrfIDgHLH2oEwUY/B+mcUIy5CLwr+yjH4Gz1mMb3GoLomMk
on/M2S5UhdYY8Nh84BzTjm4w6WX+VMrvShoov9ulewTFK8PqV5kDnOKA7ipAcX/5
GZ+ZCa1wewaCYAamoVn5sPMlCxd/C5xTx7UML7gR64Z4YQb/ftHwUi34DTIAVcPc
1L2pK9lVXqVl7vXKezDXEr8BbGXV8mpZJYa34YBcI0vXOJ29l+U93dBvBGmWyr+4
WillcFyumDmdM6rFHIBoji2p+9swF5nQ3kRgE3+Nj3GekBwzGHMtbvKnaPbBkvoO
dpsYVR1iLTU=
=xxZp
-----END PGP SIGNATURE-----

--Sig_/52Nrm8M2T8=epT1Gscj0RTl--
