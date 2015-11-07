From: Francisco Parada <cisco@abitofthisabitofthat.com>
Subject: RAID 6 Not Mounting (Block device is empty)
Date: Sat, 7 Nov 2015 12:05:21 -0500
Message-ID: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I=E2=80=99m not sure if this is the right way to go about it, so let me=
 give you my story.  I had a 7 x 3TB RAID array (12TB in total), 6 driv=
es in the array and 1 spare that was also part of the array but simply =
a spare waiting at the ready in case of a drive failure, is what I had =
running before my array broke.  I added two new arrays to my system las=
t night, in order to back up my current RAID 6.  The first array was a =
3 x 3TB RAID 0, for a total of 9TB.  Then a 2 x 1TB RAID 0 array, for a=
 total of 2TB.  9+2 =3D 11 and although I=E2=80=99m 1TB shy, I knew I h=
ad a bunch of crap and redundancy to get rid of, I just really needed a=
 solid backup after I was going to clean up.

After creating the new arrays, I started transferring from my 12TB arra=
y, 2TB worth of data to the 2TB RAID 0 array.  At some point during the=
 transfer, rsync complained of an I/O error.  It seemed to have transfe=
rred 500GB worth of data before this mishap.  The following morning, I =
noticed that error, and saw that I couldn=E2=80=99t mount my 12TB array=
 anymore.  Mind you, I didn=E2=80=99t touch this original array, but I =
think what happened was that the I/O error blew 2 of my drives. =20

What I=E2=80=99m thinking of doing is the following, but I=E2=80=99m ju=
st looking for some advice in case I=E2=80=99m missing anything:=20

sudo mdadm create --assume-clean --level=3D6 --raid-devices=3D7 --size=3D=
2930135040 /dev/md127 /dev/sde /dev/sdf /dev/sdg /dev/sdh missing missi=
ng /dev/sdd=20


Here is the output of mdadm examination:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sdb
/dev/sdb:
        Magic : a92b4efc
      Version : 1.2
  Feature Map : 0x1
   Array UUID : 4259892e:2291b1be:a1cac81d:81d59c9d
         Name : Rex:en1
Creation Time : Mon Apr 20 19:11:03 2015
   Raid Level : raid6
 Raid Devices : 6

Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
   Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
  Data Offset : 262144 sectors
 Super Offset : 8 sectors
 Unused Space : before=3D262064 sectors, after=3D944 sectors
        State : active
  Device UUID : b4f8af9e:5d486bf7:d86fba0d:0af9e3a5

Internal Bitmap : 8 sectors from superblock
  Update Time : Wed Nov  4 03:14:41 2015
     Checksum : 3c08c930 - correct
       Events : 58344

       Layout : left-symmetric
   Chunk Size : 512K

 Device Role : Active device 3
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sdc
/dev/sdc:
        Magic : a92b4efc
      Version : 1.2
  Feature Map : 0x1
   Array UUID : 4259892e:2291b1be:a1cac81d:81d59c9d
         Name : Rex:en1
Creation Time : Mon Apr 20 19:11:03 2015
   Raid Level : raid6
 Raid Devices : 6

Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
   Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
  Data Offset : 262144 sectors
 Super Offset : 8 sectors
 Unused Space : before=3D262064 sectors, after=3D944 sectors
        State : active
  Device UUID : 822e5181:1c731970:3ae49e25:06a93621

Internal Bitmap : 8 sectors from superblock
  Update Time : Wed Nov  4 03:14:41 2015
     Checksum : 2a8f4e1b - correct
       Events : 58344

       Layout : left-symmetric
   Chunk Size : 512K

 Device Role : Active device 4
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sdd
/dev/sdd:
        Magic : a92b4efc
      Version : 1.2
  Feature Map : 0x1
   Array UUID : 4259892e:2291b1be:a1cac81d:81d59c9d
         Name : Rex:en1
Creation Time : Mon Apr 20 19:11:03 2015
   Raid Level : raid6
 Raid Devices : 6

Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
   Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
  Data Offset : 262144 sectors
 Super Offset : 8 sectors
 Unused Space : before=3D262064 sectors, after=3D944 sectors
        State : active
  Device UUID : d8c57aac:91fb811c:eab9e82d:a60ca6bf

Internal Bitmap : 8 sectors from superblock
  Update Time : Wed Nov  4 03:14:41 2015
     Checksum : a8daa737 - correct
       Events : 58344

       Layout : left-symmetric
   Chunk Size : 512K

 Device Role : Active device 5
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sde
/dev/sde:
        Magic : a92b4efc
      Version : 1.2
  Feature Map : 0x1
   Array UUID : 4259892e:2291b1be:a1cac81d:81d59c9d
         Name : Rex:en1
Creation Time : Mon Apr 20 19:11:03 2015
   Raid Level : raid6
 Raid Devices : 6

Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
   Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
  Data Offset : 262144 sectors
 Super Offset : 8 sectors
 Unused Space : before=3D262064 sectors, after=3D944 sectors
        State : active
  Device UUID : 46ae26e3:8fc7b451:548951c6:44426755

Internal Bitmap : 8 sectors from superblock
  Update Time : Wed Nov  4 03:14:41 2015
     Checksum : 42e360a7 - correct
       Events : 58344

       Layout : left-symmetric
   Chunk Size : 512K

 Device Role : Active device 0
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sdf
/dev/sdf:
        Magic : a92b4efc
      Version : 1.2
  Feature Map : 0x1
   Array UUID : 4259892e:2291b1be:a1cac81d:81d59c9d
         Name : Rex:en1
Creation Time : Mon Apr 20 19:11:03 2015
   Raid Level : raid6
 Raid Devices : 6

Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
   Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
  Data Offset : 262144 sectors
 Super Offset : 8 sectors
 Unused Space : before=3D262064 sectors, after=3D944 sectors
        State : clean
  Device UUID : 9dc9106f:3a491437:d01b1b49:c7637240

Internal Bitmap : 8 sectors from superblock
  Update Time : Wed Nov  4 04:11:15 2015
     Checksum : 21f7bef6 - correct
       Events : 58362

       Layout : left-symmetric
   Chunk Size : 512K

 Device Role : Active device 1
 Array State : .AA... ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sdg
/dev/sdg:
        Magic : a92b4efc
      Version : 1.2
  Feature Map : 0x1
   Array UUID : 4259892e:2291b1be:a1cac81d:81d59c9d
         Name : Rex:en1
Creation Time : Mon Apr 20 19:11:03 2015
   Raid Level : raid6
 Raid Devices : 6

Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
   Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
  Data Offset : 262144 sectors
 Super Offset : 8 sectors
 Unused Space : before=3D262064 sectors, after=3D944 sectors
        State : clean
  Device UUID : cd8e1df7:b6a8a95e:a744b6f0:27c6fa00

Internal Bitmap : 8 sectors from superblock
  Update Time : Wed Nov  4 04:11:15 2015
     Checksum : 39bd6edb - correct
       Events : 58362

       Layout : left-symmetric
   Chunk Size : 512K

 Device Role : Active device 2
 Array State : .AA... ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sdh
/dev/sdh:
        Magic : a92b4efc
      Version : 1.2
  Feature Map : 0x0
   Array UUID : 4259892e:2291b1be:a1cac81d:81d59c9d
         Name : Rex:en1
Creation Time : Mon Apr 20 19:11:03 2015
   Raid Level : raid6
 Raid Devices : 6

Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
   Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
  Data Offset : 262144 sectors
 Super Offset : 8 sectors
 Unused Space : before=3D262064 sectors, after=3D944 sectors
        State : clean
  Device UUID : a130d2b7:77f8fe81:48203bc8:d2413cae

  Update Time : Sun Nov  1 01:00:56 2015
     Checksum : a2939695 - expected a2939694
       Events : 58339

       Layout : left-symmetric
   Chunk Size : 512K

 Device Role : spare
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sd[b-h] |grep "Array St=
ate"
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
 Array State : .AA... ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
 Array State : .AA... ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sd[b-h] |grep "Events"
       Events : 58344
       Events : 58344
       Events : 58344
       Events : 58344
       Events : 58362
       Events : 58362
       Events : 58339
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sd[b-h] |grep "raid.sta=
tus"
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sd[b-h] |grep "Role"
 Device Role : Active device 3
 Device Role : Active device 4
 Device Role : Active device 5
 Device Role : Active device 0
 Device Role : Active device 1
 Device Role : Active device 2
 Device Role : spare
cisco@DoctorBanner:~$ sudo mdadm --examine /dev/sd[b-h] |grep "Used"
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Thanks for your help in advance, I=E2=80=99m hoping to be able to find =
something, but so far this is all I=E2=80=99ve got.

Much appreciated!

Cisco--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
