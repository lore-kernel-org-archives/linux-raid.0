From: NeilBrown <neilb@suse.de>
Subject: Re: Update to mdadm V3.2.5 => RAID starts to recover (reproducible)
Date: Mon, 26 Aug 2013 15:52:02 +1000
Message-ID: <20130826155202.7a11dff5@notabene.brown>
References: <CAE65G7kMP2rFLGuO1rfsFp7V-rHGz-3K+VWuLMZqmGUPANyqcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/21WKkuRDTrgZEDRJ8GirasF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE65G7kMP2rFLGuO1rfsFp7V-rHGz-3K+VWuLMZqmGUPANyqcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Baer <synthetic.gods@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/21WKkuRDTrgZEDRJ8GirasF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Aug 2013 15:20:06 +0200 Andreas Baer <synthetic.gods@gmail.com>
wrote:

> Short description:
> I've discovered a problem during re-assembly of a clean RAID. mdadm
> throws one disk out because this disk apparently shows another disk as
> failed. After assembly, RAID starts to recover on existing spare disk.
>=20
> In detail:
> 1. RAID-6 (Superblock V0.90.00) created with mdadm V2.6.4 and with 7
> active disks and 1 spare disk (disk size: 1 TB), fully synced and
> clean.
> 2. RAID-6 stopped and re-assembled with mdadm V3.2.5, but during that
> one disk is thrown out.
>=20
> Manual assembly command for /dev/md0, relevant partitions are /dev/sd[b-i=
]1:
> # mdadm --assemble --scan -vvv
> mdadm: looking for devices for /dev/md0
> mdadm: no RAID superblock on /dev/sdi
> mdadm: no RAID superblock on /dev/sdh
> mdadm: no RAID superblock on /dev/sdg
> mdadm: no RAID superblock on /dev/sdf
> mdadm: no RAID superblock on /dev/sde
> mdadm: no RAID superblock on /dev/sdd
> mdadm: no RAID superblock on /dev/sdc
> mdadm: no RAID superblock on /dev/sdb
> mdadm: no RAID superblock on /dev/sda1
> mdadm: no RAID superblock on /dev/sda
> mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 7.
> mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 6.
> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> mdadm: ignoring /dev/sdb1 as it reports /dev/sdi1 as failed
> mdadm: no uptodate device for slot 0 of /dev/md0
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: added /dev/sde1 to /dev/md0 as 3
> mdadm: added /dev/sdf1 to /dev/md0 as 4
> mdadm: added /dev/sdg1 to /dev/md0 as 5
> mdadm: added /dev/sdh1 to /dev/md0 as 6
> mdadm: added /dev/sdi1 to /dev/md0 as 7
> mdadm: added /dev/sdc1 to /dev/md0 as 1
> mdadm: /dev/md0 has been started with 6 drives (out of 7) and 1 spare.
>=20
> I finally made a test by modifying mdadm V3.2.5 sources to not write
> any data to any superblock and to simply exit() somewhere in the
> middle of assembly process to be able to reproduce this behavior
> without any RAID re-creation/synchronization.
> So using mdadm V2.6.4 /dev/md0 assembles without problems and if I
> switch to mdadm V3.2.5 it shows the same messages as above.
>=20
> The real problem:
> I have more than a single machine receiving a similar software update
> so I need to find a solution or workaround around this problem. By the
> way, from another test without an existing spare disk, there seems to
> be no 'throwing out'-problem when switching from V2.6.4 to V3.2.5.
>=20
> It would also be a great help if someone could explain the reason
> behind the relevant code fragment for rejecting a device, e.g. why is
> only the 'most_recent' device important?
>=20
> /* If this device thinks that 'most_recent' has failed, then
>   * we must reject this device.
>   */
> if (j !=3D most_recent &&
>     content->array.raid_disks > 0 &&
>     devices[most_recent].i.disk.raid_disk >=3D 0 &&
>     devmap[j * content->array.raid_disks +
> devices[most_recent].i.disk.raid_disk] =3D=3D 0) {
>     if (verbose > -1)
>         fprintf(stderr, Name ": ignoring %s as it reports %s as failed\n",
>             devices[j].devname, devices[most_recent].devname);
>     best[i] =3D -1;
>     continue;
> }
>=20
> I also attached some files showing some details about related
> superblocks before and after assembly as well as about RAID status
> itself.


Thanks for the thorough report.  I think this issue has been fixed in 3.3-r=
c1
You can fix it for 3.2.5 by applying the following patch:

diff --git a/Assemble.c b/Assemble.c
index 227d66f..bc65c29 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -849,7 +849,8 @@ int Assemble(struct supertype *st, char *mddev,
 		devices[devcnt].i.disk.minor =3D minor(stb.st_rdev);
 		if (most_recent < devcnt) {
 			if (devices[devcnt].i.events
-			    > devices[most_recent].i.events)
+			    > devices[most_recent].i.events &&
+			    devices[devcnt].i.disk.state =3D=3D 6)
 				most_recent =3D devcnt;
 		}
 		if (content->array.level =3D=3D LEVEL_MULTIPATH)

The "most recent" device is important as we need to choose one to compare a=
ll
others again.  The problem is that the code in 3.2.5 can sometimes choose a
spare, which isn't such a good idea.

The "most recent" is also important because when a collection of devices is
given to the kernel it will give priority to some information which is on t=
he
last device passed in.  So we make sure that the last device given to the
kernel is the "most recent".

Please let me know if the patch fixes your problem.

NeilBrown

--Sig_/21WKkuRDTrgZEDRJ8GirasF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhrtAjnsnt1WYoG5AQL4mBAAhAY20auvSNWJt/dKWPcSmx1cETnTcey2
k3P5waFIqSG0CyMAaHcUIl/tbRQDU6Qv590QMi+02SP5yYOiGa+XTRa10gYOMm9J
O1SzLFBMknCu48HoI+55X1WjsRvYIzwff6v8wYSdbwHDoTMMa+atMOYmEBqNr37U
9DESUeQBEcqWqBFI9ZxeA1Lm7xWUU8hvadgDBWANGDhYCKd4fDBJSSYBjCy6vyDW
8ITvPI9LfXsH/ZVLUkWBeY4WBS6f1pyL7jXadOK2pY7pXR7J2KCVfMLkM76bAo5l
M1xr9ifASb/bcP4c0chXucf9j4qCgKUqMUesX9BQkd56qT9QfjQUTSiB4EG1nnmQ
mvMaAY9eVenJfVwd7jc4vijiVZXUI7cwIIUsGUxYAMHPb2dlCjqy3yXQS/r7VG6p
wkP8T8mxXk9yTz7b4APmAho5FOxrReBQLO9/SeuNGqWC+bGpoVPfW8P9QhjgKNdU
kblcTjlEmMrWsAlrz9Qu66ELqqF2mBBJJifYfzjKHMyGJMOujaL4DL7BIn41fhK1
yg+IqZR6gn6m4Xt26NF7mCPIhZbZGZBByGXlgteBukBLOWWcOQfqgqfJr0xEa5ff
XHVjl2FWqIp8+smWL27wylbHNnlBRgQmBDQ5SzjMs4maHc/zRSC/+e4nriu7e8Z4
Axjbqpkba9M=
=ISTq
-----END PGP SIGNATURE-----

--Sig_/21WKkuRDTrgZEDRJ8GirasF--
