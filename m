From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Wed, 7 Dec 2016 18:21:01 +0100
Message-ID: <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
 <22600.7486.444800.536687@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22600.7486.444800.536687@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello John, and thanks for your time

Giuseppe> I've had sporadic resets of the JBOD due to a variety of reasons
Giuseppe> (power failures or disk failures =E2=80=94the JBOD has the bad ha=
bit of
Giuseppe> resetting when one disk has an I/O error, which causes all of the
Giuseppe> disks to go offline temporarily).

John> Please toss that JBOD out the window!  *grin*

Well, that's exactly why I bought the new one which is the one I'm
currently using to host the backup disks I'm experimenting on! 8-)
However I suspect this is a misfeature common to many if not all
'home' JBODS which are all SATA based and only provide eSATA and/or
USB3 connection to the machine.

Giuseppe> The thing happened again a couple of days ago, but this time
Giuseppe> I tried re-adding the disks directly when they came back
Giuseppe> online, using mdadm -a and confident that since they _had_
Giuseppe> been recently part of the array, the array would actually go
Giuseppe> back to work fine =E2=80=94except that this is not the case when =
ALL
Giuseppe> disks were kicked out of the array! Instead, what happened
Giuseppe> was that all the disks were marked as 'spare' and the RAID
Giuseppe> would not assemble anymore.

John> Can you please send us the full details of each disk using the
John> command:
John>
John>   mdadm -E /dev/sda1
John>

Here it is. Notice that this is the result of -E _after_ the attempted
re-add while the RAID was running, which marked all the disks as
spares:

=3D=3D8<=3D=3D=3D=3D=3D=3D=3D

/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
           Name : labrador:oneforall  (local to host labrador)
  Creation Time : Fri Nov 30 19:57:45 2012
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262048 sectors, after=3D944 sectors
          State : clean
    Device UUID : 543f75ac:a1f3cf99:1c6b71d9:52e358b9

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 17:11:19 2016
  Bad Block Log : 512 entries available at offset 80 sectors - bad
blocks present.
       Checksum : 1e2f00fc - correct
         Events : 31196

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : .... ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
           Name : labrador:oneforall  (local to host labrador)
  Creation Time : Fri Nov 30 19:57:45 2012
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262048 sectors, after=3D944 sectors
          State : clean
    Device UUID : 649d53ad:f909b7a9:cd0f57f2:08a55e3b

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 17:11:19 2016
  Bad Block Log : 512 entries available at offset 80 sectors - bad
blocks present.
       Checksum : c9dfe033 - correct
         Events : 31196

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : .... ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
           Name : labrador:oneforall  (local to host labrador)
  Creation Time : Fri Nov 30 19:57:45 2012
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262048 sectors, after=3D944 sectors
          State : clean
    Device UUID : dd3f90ab:619684c0:942a7d88:f116f2db

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 17:11:19 2016
  Bad Block Log : 512 entries available at offset 80 sectors - bad
blocks present.
       Checksum : 15a3975a - correct
         Events : 31196

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : .... ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
           Name : labrador:oneforall  (local to host labrador)
  Creation Time : Fri Nov 30 19:57:45 2012
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262048 sectors, after=3D944 sectors
          State : clean
    Device UUID : f7359c4e:c1f04b22:ce7aa32f:ed5bb054

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 17:11:19 2016
  Bad Block Log : 512 entries available at offset 80 sectors - bad
blocks present.
       Checksum : 3a5b94a7 - correct
         Events : 31196

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : .... ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

=3D=3D8<=3D=3D=3D=3D=3D=3D=3D

I do however know the _original_ positions of the respective disks
from the kernel messages

At assembly time:

[  +0.000638] RAID conf printout:
[  +0.000001]  --- level:6 rd:4 wd:4
[  +0.000001]  disk 0, o:1, dev:sdf
[  +0.000001]  disk 1, o:1, dev:sde
[  +0.000000]  disk 2, o:1, dev:sdd
[  +0.000001]  disk 3, o:1, dev:sdc

After the JBOD disappeared and right before they all get kicked out:

[  +0.000438] RAID conf printout:
[  +0.000001]  --- level:6 rd:4 wd:0
[  +0.000001]  disk 0, o:0, dev:sdf
[  +0.000001]  disk 1, o:0, dev:sde
[  +0.000000]  disk 2, o:0, dev:sdd
[  +0.000001]  disk 3, o:0, dev:sdc


John> You might be able to just for the three spare disks (assumed in this
John> case to be sda1, sdb1, sdc1; but you need to be sure first!) to
John> assemble into a full array with:
John>
John>  mdadm -A /dev/md50 /dev/sda1 /dev/sdb1 /dev/sdc1
John>
John> And if that works, great.   If not, post the error message(s) you get
John> back.

Note that the RAID has no active disks anymore, since when I tried
re-adding the formerly active disks that
where kicked from the array they got marked as spares, and mdraid
simply refuses to start a RAID6 setup with only spares. The message I
get is indeed

mdadm: /dev/md126 assembled from 0 drives and 3 spares - not enough to
start the array.

This is the point at which I made a copy of 3 of the 4 disks and
started playing around. Specifically, I dd'ed sdc into sdh, sdd into
sdi and sde into sdj and started playing around with sd[hij] rather
than the original disks, as I mentioned:

Giuseppe> So one thing that I've done is to hack around the superblock in t=
he
Giuseppe> disks (copies) to put back the device roles as they were (getting=
 the
Giuseppe> information from the pre-failure dmesg output). (By the way, I've=
 been
Giuseppe> using Andy's Binary Editor for the superblock editing, so if anyo=
ne is
Giuseppe> interested in a be.ini for mdraid v1 superblocks, including check=
sum
Giuseppe> verification, I'd be happy to share). Specifically, I've left the
Giuseppe> device number untouched, but I have edited the dev_roles array so=
 that
Giuseppe> the slots corresponding to the dev_number from all the disks map =
to
Giuseppe> appropriate device roles.

Specifically, I hand-edited the superblocks to achieve this:


=3D=3D8<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
           Name : labrador:oneforall  (local to host labrador)
  Creation Time : Fri Nov 30 19:57:45 2012
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262048 sectors, after=3D944 sectors
          State : clean
    Device UUID : 543f75ac:a1f3cf99:1c6b71d9:52e358b9

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 17:11:19 2016
  Bad Block Log : 512 entries available at offset 80 sectors - bad
blocks present.
       Checksum : 1e3300fe - correct
         Events : 31196

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
           Name : labrador:oneforall  (local to host labrador)
  Creation Time : Fri Nov 30 19:57:45 2012
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262048 sectors, after=3D944 sectors
          State : clean
    Device UUID : 649d53ad:f909b7a9:cd0f57f2:08a55e3b

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 17:11:19 2016
  Bad Block Log : 512 entries available at offset 80 sectors - bad
blocks present.
       Checksum : c9e3e035 - correct
         Events : 31196

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
           Name : labrador:oneforall  (local to host labrador)
  Creation Time : Fri Nov 30 19:57:45 2012
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262048 sectors, after=3D944 sectors
          State : clean
    Device UUID : dd3f90ab:619684c0:942a7d88:f116f2db

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Dec  4 17:11:19 2016
  Bad Block Log : 512 entries available at offset 80 sectors - bad
blocks present.
       Checksum : 15a7975c - correct
         Events : 31196

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

=3D=3D8<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

And I _can_ assemble the array, but what I get is this:

[  +0.003574] md: bind<sdi>
[  +0.001823] md: bind<sdh>
[  +0.000978] md: bind<sdj>
[  +0.003971] md/raid:md127: device sdj operational as raid disk 1
[  +0.000125] md/raid:md127: device sdh operational as raid disk 3
[  +0.000105] md/raid:md127: device sdi operational as raid disk 2
[  +0.015017] md/raid:md127: allocated 4374kB
[  +0.000139] md/raid:md127: raid level 6 active with 3 out of 4
devices, algorithm 2
[  +0.000063] RAID conf printout:
[  +0.000002]  --- level:6 rd:4 wd:3
[  +0.000003]  disk 1, o:1, dev:sdj
[  +0.000002]  disk 2, o:1, dev:sdi
[  +0.000001]  disk 3, o:1, dev:sdh
[  +0.004187] md127: bitmap file is out of date (31193 < 31196) --
forcing full recovery
[  +0.000065] created bitmap (22 pages) for device md127
[  +0.000072] md127: bitmap file is out of date, doing full recovery
[  +0.100300] md127: bitmap initialized from disk: read 2 pages, set
44711 of 44711 bits
[  +0.039741] md127: detected capacity change from 0 to 6000916561920
[  +0.000085] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000064] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000022] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000022] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000019] ldm_validate_partition_table(): Disk read failed.
[  +0.000021] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000026] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000022] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000021] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000019] Dev md127: unable to read RDB block 0
[  +0.000016] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000022] Buffer I/O error on dev md127, logical block 0, async page re=
ad
[  +0.000030]  md127: unable to read partition table

and any attempt to access md127 content gives an I/O error.


--=20
Giuseppe "Oblomov" Bilotta
