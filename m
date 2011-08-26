From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: Raid 5 to Raid 1 (half of the data not required)
Date: Thu, 25 Aug 2011 20:11:46 -0400
Message-ID: <BAY148-W430CF038E32B43F69A88C0EF130@phx.gbl>
References: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>,<alpine.DEB.2.00.1108240851190.6833@unicorn.drogon.net>,<alpine.DEB.2.00.1108241018180.4709@uplift.swm.pp.se>,<20110824184235.2a165066@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110824184235.2a165066@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, swmike@swm.pp.se, linux-raid@vger.kernel.org, gordon@drogon.net
List-Id: linux-raid.ids


> On Wed, 24 Aug 2011 18:42:35 +1000 <neilb@suse.de> wrote:
> > On Wed, 24 Aug 2011 10:21:32 +0200 (CEST) Mikael Abrahamsson <swmik=
e@swm.pp.se> wrote:
> > On Wed, 24 Aug 2011, Gordon Henderson wrote:
> >=20
> > > This isn't as "glamorous" as Neils method involving lots of mdadm=
=20
> > > commands, shrinks and grows, but sometimes it's good to keep thin=
gs at a=20
> > > simpler level?
> >=20
> > Another way would be to add the new raid1 with missing drive to the=
 lv,=20
> > and pvmove all extents off of the existing raid5 md pv, then vgredu=
ce away=20
> > from it, stop the raid5, zero-superblock, and add one drive to add=20
> > redundancy for the raid1.
> >=20
> > But that has little to do with linux raid, and all to do with LVM. =
It also=20
> > means you can do everything online since pvmove doesn't require to =
offline=20
> > anything.
> >=20
>=20
> There are certainly lots of approaches. :-)
> But every approach will require either coping or shrinking the filesy=
stem and
> as extX doesn't support online shrinking the filesystem will have to =
be
> effectively off-line while that shrink happens.
> (if you shrink by coping, then it could be technically on-line but it=
 had
> better not be written to).
>=20

Wow! Thank you so much everyone for your feedback, I am truly very grat=
eful :)=20

Before tackling this task I plan to delete some unnecessary files to ha=
ve less to backup, then make the all so important backup, and lastly at=
tempt the migration. I had to remember how I decided to build up the LV=
M on the RAID 5 array :)


Model: Linux Software RAID Array (md)
Disk /dev/md0: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number=A0 Start=A0=A0 End=A0=A0=A0=A0 Size=A0=A0=A0 Type=A0=A0=A0=A0 Fi=
le system=A0 Flags
=A01=A0=A0=A0=A0=A0 1049kB=A0 2000GB=A0 2000GB=A0 primary=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 lvm

OR

=A0--- Physical volume ---
=A0 PV Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /dev/md0p1
=A0 VG Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 masterVG
=A0 PV Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.82 TiB / not us=
able 3.00 MiB
=A0 Allocatable=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 yes
=A0 PE Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.00 MiB
=A0 Total PE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 476932
=A0 Free PE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 261031
=A0 Allocated PE=A0=A0=A0=A0=A0=A0=A0=A0=A0 215901
=A0 PV UUID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 xiS8is-RR6D-Swre-=
IHQN-yGY2-cNmJ-wGGBY7

AND

=A0 --- Volume group ---
=A0 VG Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 masterVG
=A0 System ID
=A0 Format=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 lvm2
=A0 Metadata Areas=A0=A0=A0=A0=A0=A0=A0 1
=A0 Metadata Sequence No=A0 4
=A0 VG Access=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 read/write
=A0 VG Status=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 resizable
=A0 MAX LV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
=A0 Cur LV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2
=A0 Open LV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2
=A0 Max PV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0
=A0 Cur PV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0 Act PV=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0 VG Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1.82 TiB
=A0 PE Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 4.00 MiB
=A0 Total PE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 476932
=A0 Alloc PE / Size=A0=A0=A0=A0=A0=A0 215901 / 843.36 GiB
=A0 Free=A0 PE / Size=A0=A0=A0=A0=A0=A0 261031 / 1019.65 GiB
=A0 VG UUID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 eoZgIp-50Wb-Lrhg-=
Sawt-rWDV-YIDy-Ez2Glr



So it looks like the entire RAID 5 array is one LVM physical volume and=
 then one volume group.


=A0 --- Logical volume ---
=A0 LV Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /dev/masterVG/=
backupLV
=A0 VG Name=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 masterVG
=A0 LV UUID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wc61ER-uoNn-yn=
XI-2v64-wpa8-ON3g-im4fo8
=A0 LV Write Access=A0=A0=A0=A0=A0=A0=A0 read/write
=A0 LV Status=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 available
=A0 # open=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2
=A0 LV Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 700.00 GiB
=A0 Current LE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 179200
=A0 Segments=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1
=A0 Allocation=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 inherit
=A0 Read ahead sectors=A0=A0=A0=A0 auto
=A0 - currently set to=A0=A0=A0=A0 4096
=A0 Block device=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 254:9


The logical volume has a size of 700.00 GB, so this is less than the 1 =
TB size in which I plan the newly migrated RAID 1 mdadm array to be (wi=
th two 1 TB drives). I don't think I will therefore have any need to sh=
rink the ext4 filesystem, hopefully meaning I can complete the entire p=
rocess over some time while keeping the data available or online.

I remember that I had good reasons for using LVM, but I will have to ge=
t reacquainted again with the commands of LVM like pv/vg/lv[move/reduce=
]...


Thanks again to everyone for their help :D




 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
