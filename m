From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm re-add fails
Date: Fri, 20 May 2011 09:51:33 +1000
Message-ID: <20110520095133.54b44dd4@notabene.brown>
References: <5AA430FFE4486C448003201AC83BC85E01B03522@EXHQ.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5AA430FFE4486C448003201AC83BC85E01B03522@EXHQ.corp.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Schmidt, Annemarie" <Annemarie.Schmidt@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 18 May 2011 10:43:47 -0400 "Schmidt, Annemarie"
<Annemarie.Schmidt@stratus.com> wrote:

> Hi!
>=20
> I have a 2 disk raid1 data array. As a result of other testing, the d=
evice info
> in the superblock for one of the partners, /dev/sdc2, ended up being =
in slot 3
> of the device info array:=20
>=20
> [root@typhon ~]# mdadm --detail /dev/md21
> /dev/md21:
> =A0=A0Version : 1.2
> =A0 Creation Time : Mon May=A0 9 11:19:43 2011
> =A0=A0Raid Level : raid1
> =A0 Array Size : 5241844 (5.00 GiB 5.37 GB)
> =A0 Used Dev Size : 5241844 (5.00 GiB 5.37 GB)
> =A0 Raid Devices : 2
> =A0 Total Devices : 2
> =A0 Persistence : Superblock is persistent
>=20
> =A0 Intent Bitmap : Internal
>=20
> =A0 Update Time : Thu May 12 15:51:50 2011
> =A0 State : active
> =A0 Active Devices : 2
>   Working Devices : 2
>  =A0Failed Devices : 0
> =A0 Spare Devices : 0
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : typhon.mno.stratus.com:21=A0 (l=
ocal to host typhon.mno.stratus.com)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 996d993f:baac367a:8b154ba9:43e5=
6cff
> =A0=A0=A0=A0=A0=A0=A0=A0  Events : 687
>=20
> =A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
> -->=A0=A0=A0 3=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 34=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc2
> =A0=A0=A0=A0=A0=A0  2=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=A0=A0 82=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdk2
>=20
> When I remove /dev/sdk2 and then a re-add it back in, the re-add fail=
s:
>=20
> >> [root@typhon ~]# mdadm /dev/md21 -f /dev/sdk2 -r /dev/sdk2
> mdadm: set /dev/sdk2 faulty in /dev/md21
> mdadm: hot removed /dev/sdk2 from /dev/md21
>=20
> >> [root@typhon ~]# mdadm /dev/md21 -a /dev/sdk2
> mdadm: /dev/sdk2 reports being an active member for /dev/md21, but a =
--re-add
> fails.
> mdadm: not performing --add as that would convert /dev/sdk2 in to a s=
pare.
> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdk2" =
first.
>=20
> I believe the re-add fails because the enough_fd function (util.c) is=
 not searching deep enough into the
> dev_info array with this line of code:
> =A0=A0 for (i=3D0; i<array.raid_disks + array.nr_disks; i++)
>=20
> array.raids_disk =3D 2 and array/nr_disks =3D 1, and so for this part=
icular md device, it is only looking at slots 0-2.=A0
> I believe the code needs to be changed to look at all possible dev_in=
fo array slots, taking into account the=20
> version of the superblock (like the Detail function does (Detail.c).=A0=
=20
>=20
> Do folks agree?
>

I do - largely.  I think there might be a better more general way to co=
ntrol
the loop though.
Could you try this please?

Thanks,
NeilBrown


diff --git a/util.c b/util.c
index 1056ae4..d005e0a 100644
--- a/util.c
+++ b/util.c
@@ -370,10 +370,14 @@ int enough_fd(int fd)
 	    array.raid_disks <=3D 0)
 		return 0;
 	avail =3D calloc(array.raid_disks, 1);
-	for (i=3D0; i<array.raid_disks + array.nr_disks; i++) {
+	for (i=3D0; i < 1024 && array.raid_disks > 0; i++) {
 		disk.number =3D i;
 		if (ioctl(fd, GET_DISK_INFO, &disk) !=3D 0)
 			continue;
+		if (disk.major =3D=3D 0 && disk.minor =3D=3D 0)
+			continue;
+		array.raid_disks--;
+
 		if (! (disk.state & (1<<MD_DISK_SYNC)))
 			continue;
 		if (disk.raid_disk < 0 || disk.raid_disk >=3D array.raid_disks)


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
