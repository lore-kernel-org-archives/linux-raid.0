From: Daniel Koch <koch@triple6.org>
Subject: Failed to grow
Date: Thu, 13 Aug 2015 17:53:35 +0200
Message-ID: <621f0ebc8080e4ab56eaacde5f9416cf@mail.triple6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello every one,

I have a huge problem. I started to grow a array with ( the added devic=
e=20
is /dev/sde )
# mdadm --grow --raid-devices=3D13 /dev/md0 --backup-file=3Dmd0.bak

after that there way 0 disk activity so i checked it with
# cat /proc/mdstat

everything looked fine but speed was 0K/sec for about 1-2 hours. I=20
decided to reboot the system as grow should continue after that. After=20
that the array wasn't assembled at all. So i wanted to do it myself:

# mdadm --assemble /dev/md0 /dev/sd[b-n] --backup-file=3Dmd0.bak --verb=
ose
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 10.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 12.
mdadm: /dev/sdf is identified as a member of /dev/md0, slot 11.
mdadm: /dev/sdg is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdh is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdi is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdj is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdk is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdl is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdm is identified as a member of /dev/md0, slot 8.
mdadm: /dev/sdn is identified as a member of /dev/md0, slot 9.
mdadm: :/dev/md0 has an active reshape - checking if critical section=20
needs to be restored
mdadm: No backup metadata on md0.bak
mdadm: No backup metadata on device-12
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.

Backup looks broken. What can i do ?

# mdadm --version
mdadm - v3.3.2 - 21st August 2014

# uname -a
Linux claw-storage 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1+deb8u3=20
(2015-08-04) x86_64 GNU/Linux

# du -sch md0.bak
56M     md0.bak

# mdadm --examine /dev/sd[b-n]
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
           State : clean
     Device UUID : f3d9392c:a9290f8e:4ded7efc:284b4ecf

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : 11cb12c0 - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
           State : clean
     Device UUID : a5b4533d:d5a4cdc5:e6dcd3aa:4a845044

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : 7dfa9159 - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
           State : clean
     Device UUID : d39aede2:af92f321:8b6fbd9f:45c73ddf

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : f913b0b - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 10
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D976752816 sectors
           State : clean
     Device UUID : 13fcdab1:69ce4358:5f1ee2b2:c809b990

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : d976c9a6 - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 12
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdf:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
           State : clean
     Device UUID : 487f70bd:b63c29d6:185aa418:208dc16d

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : a5b479ef - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 11
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdg:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D816 sectors
           State : clean
     Device UUID : b798e990:6b50f1a0:3cde1ced:3a20dfaf

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : 2053b0c9 - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdh:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D816 sectors
           State : clean
     Device UUID : bfe03a04:fda138cc:ef11727c:ff1b58d2

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : 70ba79db - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdi:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
           State : clean
     Device UUID : 4fdb8a05:3157bd26:f93ee8d7:fdd42f9f

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : 2f151d28 - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdj:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D816 sectors
           State : clean
     Device UUID : 6010b774:e02b08ed:29484f97:b03e8a48

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : 93158c4c - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdk:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D816 sectors
           State : clean
     Device UUID : afab65ff:a79ed9e7:30ccd918:e2e1c21a

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : 6c58c19c - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdl:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262056 sectors, after=3D976752816 sectors
           State : clean
     Device UUID : 8a9031cf:f9b5a888:70363d53:b269047d

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : b3d8bda7 - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 7
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdm:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D816 sectors
           State : clean
     Device UUID : 1eefdd8c:75b58c0c:f0c555bd:e704e89e

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : 472538a0 - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 8
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)
/dev/sdn:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
            Name : claw-storage:0  (local to host claw-storage)
   Creation Time : Tue Jan 14 12:48:49 2014
      Raid Level : raid6
    Raid Devices : 13

  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D262064 sectors, after=3D816 sectors
           State : clean
     Device UUID : b8f9a259:c4522982:88538283:497eed43

   Reshape pos'n : 0
   Delta Devices : 1 (12->13)

     Update Time : Thu Aug 13 17:11:05 2015
        Checksum : f4b8e783 - correct
          Events : 72402

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 9
    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,=
 'R' =3D=3D=20
replacing)


--=20
Viele Gr=C3=BC=C3=9Fe,

Daniel Koch
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
