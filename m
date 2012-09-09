From: NeilBrown <neilb@suse.de>
Subject: Re: Wrong array size detected after reboot
Date: Mon, 10 Sep 2012 09:13:52 +1000
Message-ID: <20120910091352.38dfdc20@notabene.brown>
References: <CAFEwywaeGevnDMu7Do_wK+_Jgtyd0vman0804C2LyqbyzcJ9Sw@mail.gmail.com>
	<504C0462.2000609@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uEyZUZFfPPzt4O_Hqhgq8/5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <504C0462.2000609@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Markus Irle <tha.bear@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/uEyZUZFfPPzt4O_Hqhgq8/5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 08 Sep 2012 22:52:18 -0400 Phil Turmel <philip@turmel.org> wrote:

> Hi Markus,
>=20
> On 09/07/2012 04:54 PM, Markus Irle wrote:
> > Hi guys,
> >=20
> > After a reboot mdadm detects a much too small size for a raid5 array.
> > The array is part of a lvm volume group, which fails because the
> > device mapper notices that the physical volume is too small for the
> > volume group. At the moment I can't access any data.
>=20
> As soon as I read this far I thought "version 0.90?".
>=20
> > What I did:
> >=20
> > Array consisted of 3x 1.5TB disks.
> > After a disk failure a replaced the disks one by one with 3TB disks.
> > Resized array, volume group and partition to the new size according to
> > these instructions: https://raid.wiki.kernel.org/index.php/Growing
> >=20
> > Everything went fine the array's up and running for a couple of months.
> > I believe this is the first reboot since.
> >=20
> > I'm at a complete loss as what to do now. Any help is greatly appreciat=
ed.
> >=20
> > Here's the kern.log (I don't remember the misaligned warning, when I
> > replaced the disks):
> > Sep  7 19:09:43 fandango kernel: [    3.259374] raid5: device sde1
> > operational as raid disk 2
> > Sep  7 19:09:43 fandango kernel: [    3.259378] raid5: device sdd1
> > operational as raid disk 1
> > Sep  7 19:09:43 fandango kernel: [    3.259380] raid5: device sdb1
> > operational as raid disk 0
> > Sep  7 19:09:43 fandango kernel: [    3.259727] raid5: allocated 3228kB=
 for md2
> > Sep  7 19:09:43 fandango kernel: [    3.259764] raid5: raid level 5
> > set md2 active with 3 out of 3 devices, algorithm 2
> > Sep  7 19:09:43 fandango kernel: [    3.259766] RAID5 conf printout:
> > Sep  7 19:09:43 fandango kernel: [    3.259768]  --- rd:3 wd:3
> > Sep  7 19:09:43 fandango kernel: [    3.259770]  disk 0, o:1, dev:sdb1
> > Sep  7 19:09:43 fandango kernel: [    3.259771]  disk 1, o:1, dev:sdd1
> > Sep  7 19:09:43 fandango kernel: [    3.259773]  disk 2, o:1, dev:sde1
> > Sep  7 19:09:43 fandango kernel: [    3.259781] md2: Warning: Device
> > sde1 is misaligned
> > Sep  7 19:09:43 fandango kernel: [    3.259783] md2: Warning: Device
> > sdd1 is misaligned
> > Sep  7 19:09:43 fandango kernel: [    3.259785] md2: Warning: Device
> > sdb1 is misaligned
> > Sep  7 19:09:43 fandango kernel: [    3.259806] md2: detected capacity
> > change from 0 to 1603139141632
> > Sep  7 19:09:43 fandango kernel: [    3.261439]  md2: unknown partition=
 table
> > Sep  7 19:09:43 fandango kernel: [    3.409802] device-mapper: table:
> > 252:2: md2 too small for target: start=3D384, len=3D11721064448,
> > dev_size=3D3131131136
> >=20
> > mdadm:
> > /dev/md2:
> >         Version : 00.90
>=20
> Uh-huh.
>=20
> >   Creation Time : Wed Apr 29 23:31:24 2009
> >      Raid Level : raid5
> >      Array Size : 1565565568 (1493.04 GiB 1603.14 GB)
> >   Used Dev Size : 782782784 (746.52 GiB 801.57 GB)
> >    Raid Devices : 3
> >   Total Devices : 3
> > Preferred Minor : 2
> >     Persistence : Superblock is persistent
> >=20
> >     Update Time : Fri Sep  7 21:30:40 2012
> >           State : clean
> >  Active Devices : 3
> > Working Devices : 3
> >  Failed Devices : 0
> >   Spare Devices : 0
> >=20
> >          Layout : left-symmetric
> >      Chunk Size : 64K
> >=20
> >            UUID : bbc76518:54235173:67388cd8:6b8a4141 (local to host fa=
ndango)
> >          Events : 0.16232920
> >=20
> >     Number   Major   Minor   RaidDevice State
> >        0       8       17        0      active sync   /dev/sdb1
> >        1       8       49        1      active sync   /dev/sdd1
> >        2       8       65        2      active sync   /dev/sde1
> >=20
> >=20
> > The size is much too small. It should be around 6TB not 1.5TB.
> > Interestingly enough, the Array Size / Used Dev Size ratio seems to be =
correct.
>=20
> Until recently, due to a long-standing bug, devices larger than 2T were
> not usable with v0.90 meta-data.  I don't remember precisely when that
> bug was fixed, but I believe it was in the past year.  There are also
> potential identification problems with v0.90 when used on the last
> partition of a device, but you have a misalignment warning that would
> prevent that.

The bug was fixed in 3.1-rc6, (commit 27a7b260f71439c40546)

NeilBrown

>=20
> You should see that the used dev size is very close to 2TiB less than
> the actual size of your devices.
>=20
> First, try the latest stable mainline kernel that you can.  That should
> let you back up your data.
>=20
> Second, reconstruct your array with a recent version of fdisk or parted
> that won't put your first partition at sector 63.  Use metadata version
> 1.0 for bootable mirrored partitions, or version 1.2 otherwise (the
> modern default).
>=20
> HTH,
>=20
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/uEyZUZFfPPzt4O_Hqhgq8/5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE0isTnsnt1WYoG5AQI9Sw/9GT7k4SQRtOvfYpkNze7vZNf0tSOuo9om
QI+DbyrCzKrbVBaaUBq8Xq+d1kMmr5AuJ4WhFTh7kOmlslpeW5tR978SZamYBdE9
s6fM/QN0A44kfWG1eu9dDde/TFJK8FDeWFDQt73Z0BwTFlc5p4C2DNM1KXRJu2ap
8zT85geokreEJcLqGMzg65NM3athGcg3z/Jjy9bds2zEyeeieeRiL/70KMrrlmwL
hVgOAh+Cnm5mip9WVG05IhCNIZuiGCqI+g3GfMsps2ZLgh1FY55kr+orHXbtMt9l
vZXRsfTyEaqZp1VWvKERX2ZQJ3OdMFJlpR3BnD6tojU8bJEooAOTuI6GTselJasB
dQMmJEQ/sDfTaKBgIBXE58ml/QIi4kdfFZckFuEcZcWv5x3Va6Gnm4YOjOZOGHR2
KEE6VvyLDAO6YB4veZWmtzGVOEGSFqbktFTG6eFH6sysr8N7nR9s15ML9rUYRSqd
v3Ec4Nhn8JB7/uBb6/rFePyZnkF7RHMXuUeGlQLrQzOvkITuwtuLaeJQe6lgYNEH
OZS1N81ND5gmFvf3kAHsxKeiDGUInKHqKGqO9F2gFsWFSnuMPvpurXWghDQzd1LH
5Zbp+S1YkIo1WrmAQgTwb7U7QbbZ4OVRs//lUFuPIAT8YFdM+NS5vm1v5z/2meVD
vd7ZPQTR4uY=
=CWR3
-----END PGP SIGNATURE-----

--Sig_/uEyZUZFfPPzt4O_Hqhgq8/5--
