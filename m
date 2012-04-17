From: NeilBrown <neilb@suse.de>
Subject: Re: RAID 1 partition with hot spare shows [UUU] ?
Date: Wed, 18 Apr 2012 09:12:33 +1000
Message-ID: <20120418091233.23d77dfc@notabene.brown>
References: <4F8DF1EE.70402@reetspetit.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kP_Ck53dB5OZaWJpvq1i_1h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8DF1EE.70402@reetspetit.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Crisp <john@reetspetit.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kP_Ck53dB5OZaWJpvq1i_1h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 00:42:54 +0200 John Crisp <john@reetspetit.net> wrote:

> Hi,
>=20
> Sorry to trouble people, and I am sure you have better things to do, but
> I can't find an answer to the following and don't know where else to go.
>=20
> I have been struggling with this problem for weeks and having read all I
> can I still don't know the answer.
>=20
> I have a server running a version of CentOS 5.x   Yes, mdadm is old at
> 2.6.9 but it isn't possible to update it currently.
>=20
> A year or so ago I clean installed with a software RAID 1 array using
> /dev/sda & /dev/sdb and two partitions, md1 & md2 configure
> automatically on install.
>=20
> I restored data to the RAID and then added manually added a third drive
> /dev/sdc as a spare.
>=20
> All appeared hunky dory, but whilst trying to figure a slightly
> different problem on a different machine, I went back to the first one
> to check how it was configured. Although I am sure all looked normal
> when I had last looked, this time is looked a bit strange.
>=20
> Unfortunately I don't have an exact copy of things before I started
> messing about but it looked something like this :
>=20
>=20
> cat /proc/mdstat revealed :
>=20
> Personalities : [raid1]
> md1 : active raid1 sdc1[2] sdb1[1] sda1[0]
>       104320 blocks [3/3] [UUU]
>=20
> md2 : active raid1 sdc2(S) sdb2[1] sda2[0]
>       244091520 blocks [2/2] [UU]
>=20
> unused devices: <none>
>=20
>=20
> I don't understand how md1 shows [UUU] ??

You have a RAID1 with 3 devices.  What it difficult to comprehend about tha=
t.
Each block is written to all three devices.

You don't want that?  Change it.

   mdadm --grow /dev/md1 --raid-disks=3D4

now it has 4 devices - though one will be missing.

   mdadm --grow /dev/md1 --raid-disks=3D2

now it has 2 devices.  Actually that won't work until you mark one of the
devices as failed, so

   mdadm /dev/md1 --fail /dev/sdc1
   mdadm --grow /dev/md1 --raid-disks=3D2


But maybe you really wanted a 3-disk RAID1 before - it is a configuration
that certainly has a place.

Next you'll be telling me that a RAID5 cannot be made with just 2 devices!
:-)

NeilBrown


>=20
>=20
> On my other machine which has a similar configuration it shows the
> following which I expect :
>=20
> Personalities : [raid1]
> md1 : active raid1 sda1[2](S) hdc1[1] hda1[0]
>       104320 blocks [2/2] [UU]
>=20
> md2 : active raid1 sda2[2](S) hdc2[1] hda2[0]
>       312464128 blocks [2/2] [UU]
>=20
> unused devices: <none>
>=20
> I thought I could fail and remove the drive, dd/fdisk/reformat, sfdisk
> and then try to re add it back to the array effectively as a new drive.
> No joy.
>=20
> If I just fail and remove it md1 shows as [UU_]
>=20
> I have tried checking mdadm.conf which has the following :
>=20
> DEVICE partitions
> ARRAY /dev/md1 level=3Draid1 num-devices=3D2
> uuid=3D8833ba3d:ca592541:20c7be04:42cbbdf1 spares=3D1
> ARRAY /dev/md2 level=3Draid1 num-devices=3D2
> uuid=3D43a5b70d:9733da5c:7dd8d970:1e476a26 spares=3D1
>=20
> Somewhere along the line the RAID is remembering the earlier
> configuration but having changed stuff left right and Cambridge, I can't
> seem to get it to forget.
>=20
> I have tried different variations of mdadm.conf, and tried to rebuild
> initrd but that didn't fix it and I am clean out of ideas where to go
> next. mdadm.conf seems to be ignored.
>=20
> Undoubtedly it will take some clever tweaking and I'm scared witless at
> trashing the array as I am in a different country from the hardware and
> would struggle to get back to fix it !
>=20
> Any advice on how to put it back to RAID 1 with a 'hot' spare would be
> appreciated.
>=20
> B. Rgds
> John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/kP_Ck53dB5OZaWJpvq1i_1h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4344Tnsnt1WYoG5AQIQIg/9GvuN2cExBFUx35JixsFcBG7ceFCWmA7i
3RQpN/Xizse52HjEwnUHh7WIEmLbpwnwPSrp55UBU/K6AG6J87Pi64Qj7F6XdBL5
ppRitSt6RfRAai33hllIduR/qHMkrpDYzWhfHEqOCMbOci8x8D3UPVt1hL4ZyuHi
+MQPxBHd45Vzf/C0xFe4fLTm5AWwgX/pK7dG5Vq5dyxo9CypuWrrEBTd/2pb3FTO
0WBb4l+nOHpw/bOhOeAHYcp49QGjjLtleKkEAbVB86V+uaoiPyk3pCv5lWLrsW84
pGb+pgdIvro+6iHap4OLljqp8F8w1xTcQC8qANn99loUu6O6hYrn4mwhSqWJ4/f7
pMx6Wi2ySMcUujxdXYtcvEI65d87M7N/dgmfZZtj34xXF+HW+2tkBI5UGsC2CRrb
N+XZwQdXRSAzihCGo5OYk59qJW1BwWkAyFjxNe70dsFkwXtrlKkXEOeNa/xyzEBw
dcO3/vefvbDfHSqAGyUeYrlyesBYFde/yJUmX5sG67Wwxx5/1ugd8FZ+qZDw4Udo
sBpHePI5ht8X4DoV9UZaTVPfSG/JhFmRiqIbBQkT4hjfxzfuMcNFV9J7soC072E5
8wqk+mgJKv2qy+GeKYzK82c0kvjxebMxiQ8tXC2TgddjjdaL++J8GJOZ9Wr/f6Ae
P49suI+alaM=
=vKgn
-----END PGP SIGNATURE-----

--Sig_/kP_Ck53dB5OZaWJpvq1i_1h--
