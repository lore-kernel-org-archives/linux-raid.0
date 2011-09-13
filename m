From: Andriano <chief000@gmail.com>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 17:05:06 +1000
Message-ID: <CAGZH0-fRTkKOL8ofLbChmNH3fuiYwHkC0LAv1-VVyb22O7UnwA@mail.gmail.com>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
	<20110913082511.3c34dec9@notabene.brown>
	<CAGZH0-fEU+NTdAF1AWcU6SnyBPYgd51zjizaiZT_toV=k4EDFg@mail.gmail.com>
	<20110913084419.380babcc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110913084419.380babcc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 13, 2011 at 4:44 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 13 Sep 2011 16:33:36 +1000 Andriano <chief000@gmail.com> wrot=
e:
>
>> >
>> >> Hello Linux-RAID mailing list,
>> >>
>> >> I have an issue with my RAID6 array.
>> >> Here goes a short description of the system:
>> >>
>> >> opensuse 11.4
>> >> Linux 3.0.4-2-desktop #1 SMP PREEMPT Wed Aug 31 09:30:44 UTC 2011
>> >> (a432f18) x86_64 x86_64 x86_64 GNU/Linux
>> >> Gigabyte EP35C-DS3 motherboard with 8 SATA ports + SuperMicro
>> >> AOC-SASLP-MV8 based on Marvel 6480, firmware updated to 3.1.0.21
>> >> running mdadm 3.2.2, single array consists of 10 2T disks, 8 of t=
hem
>> >> connected to the HBA, 2 - motherboard ports
>> >>
>> >> I had some issues with one of the onboard connected disks, so tri=
ed to
>> >> plug it to different ports, just to eliminate possibly faulty por=
t.
>> >> After reboot, suddenly other drives got kicked out from the array=
=2E
>> >> Re-assembling them gives weird errors.
>> >>
>> >> --- some output ---
>> >> [3:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32=
 =A0/dev/sdb
>> >> [5:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32=
 =A0/dev/sdc
>> >> [8:0:0:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 =
CC34 =A0/dev/sdd
>> >> [8:0:1:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 =
CC34 =A0/dev/sde
>> >> [8:0:2:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 =
CC34 =A0/dev/sdf
>> >> [8:0:3:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 =
CC34 =A0/dev/sdg
>> >> [8:0:4:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST32000542AS =A0 =A0 =
CC34 =A0/dev/sdh
>> >> [8:0:5:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32=
 =A0/dev/sdi
>> >> [8:0:6:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32=
 =A0/dev/sdj
>> >> [8:0:7:0] =A0 =A0disk =A0 =A0ATA =A0 =A0 =A0ST2000DL003-9VT1 CC32=
 =A0/dev/sdk
>> >>
>> >> #more /etc/mdadm.conf
>> >> DEVICE partitions
>> >> ARRAY /dev/md0 level=3Draid6 UUID=3D82ac7386:a854194d:81b795d1:76=
c9c9ff
>> >>
>> >> #mdadm --assemble --force --scan /dev/md0
>> >> mdadm: failed to add /dev/sdc to /dev/md0: Invalid argument
>> >> mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
>> >> mdadm: failed to add /dev/sdh to /dev/md0: Invalid argument
>> >> mdadm: /dev/md0 assembled from 7 drives - not enough to start the=
 array.
>> >>
>> >> dmesg:
>> >> [ 8215.651860] md: sdc does not have a valid v1.2 superblock, not=
 importing!
>> >> [ 8215.651865] md: md_import_device returned -22
>> >> [ 8215.652384] md: sdb does not have a valid v1.2 superblock, not=
 importing!
>> >> [ 8215.652388] md: md_import_device returned -22
>> >> [ 8215.653177] md: sdh does not have a valid v1.2 superblock, not=
 importing!
>> >> [ 8215.653182] md: md_import_device returned -22
>> >>
>> >> mdadm -E /dev/sd[b..k] gives exactly the same Magic number and Ar=
ray
>> >> UUID for every disk, all checksums are correct,
>> >> the only difference is - =A0Avail Dev Size : 3907028896 is the sa=
me for
>> >> 9 disks, and 3907028864 for sdc
>> >
>> > Please provide that output so we can see it too - it might be help=
ful.
>> >
>> > NeilBrown
>>
>>
>> # mdadm --assemble --force --update summaries /dev/md0 /dev/sdc
>> mdadm: --update=3Dsummaries not understood for 1.x metadata
>>
>
> Sorry - I was too terse.
>
> I meant that output of "mdadm -E ...."
>
> NeilBrown
>
>
>>
>> >
>> >>
>> >> mdadm --assemble --force --update summaries /dev/sd.. - didn't im=
prove anything
>> >>
>> >>
>> >> I would really appreciate if someone could point me to the right =
direction.
>> >>
>> >> thanks
>> >>
>> >> Andrew
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >
>> >
>
>

/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4b31edb8:531a4c14:50c954a2:8eda453b

    Update Time : Mon Sep 12 22:36:35 2011
       Checksum : 205f92e1 - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 6
   Array State : AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
    Data Offset : 304 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : afa2f348:88bd0376:29bcfe96:df32a522

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : ee1facae - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d1a7cfca:a4d7aef7:47b6d3c6:82d1da5b

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : 5ab164a8 - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ba9497e9:7665c161:1e596d49:8a642880

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : 8a731bdf - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 8d503057:423c455d:665af78a:093b99b8

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : 6d8a7fa6 - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7d0284af:74ceb0e9:31eab49e:d9fedff5

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : a34e1766 - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 4
   Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a97e691f:f81bb643:9cedde86:87f9bc69

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : c947df28 - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c5970279:a68c84f0:a5803880:91f69e74

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : d3e2fa15 - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 8
   Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a62447a6:604c0917:1ab4d073:2ca99f8f

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : 36452bba - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 7
   Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 82ac7386:a854194d:81b795d1:76c9c9ff
           Name : hnas:0  (local to host hnas)
  Creation Time : Wed Jan 19 21:17:33 2011
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 31256230912 (14904.13 GiB 16003.19 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ac64f1b6:578eb873:9f28bbd4:8abc61b3

    Update Time : Tue Sep 13 11:50:18 2011
       Checksum : 284b3598 - correct
         Events : 6446662

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 9
   Array State : AAAAAA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
