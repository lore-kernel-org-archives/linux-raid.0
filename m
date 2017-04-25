From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Tue, 25 Apr 2017 12:40:37 +0200
Message-ID: <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
References: <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de> <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de> <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de> <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de> <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170425090122.GA4488@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-25 11:01 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Tue, Apr 25, 2017 at 10:44:15AM +0200, Patrik Dahlstr=C3=B6m wrote:
>> Would that mean that I should be able to get the checksum to match if
>> I remove one of the values in a mismatching series. I have tried this,
>> but never got it correct.
>
> No, there is no parity left with a missing drive in a raid5.
I was thinking if it was in fact a 5 disk raid + garbage from 1 disk,
then the checksum would be correct if the garbage disk was filtered
out. Does that make sens?
>
> But you might find some duplicate blocks of one drive still in 5disk
> layout on the other drives where it would have ended up in 6disk layout.
> You won't find all of them since there are parity blocks on both sides.
Not sure if I follow
>
>> Shouldn't I find something about it in my syslog or kernel log?
>
> I suppose so, if you didn't boot a rescue/live system in between
> (they assemble raid and grow continues and whatever happens there
> is not in your logs).
I did boot 1 rescue system, but it was a raid rescue system that,
according to their docs, never write anything to the disks so we
should be fine. I did a grep on mdadm in both syslogs and kernel logs
and I didn't find anything about kicking a drive.
>
> Mind showing the --examine output of the two raid sets you're working
> with, did you check that the offsets are correct for either one?
Attached to the end of the email. AFAIK, the data offsets are pointing
to where the ext4 file system begins. Honestly, I don't know what to
look for in the output.

>
> You found multiple filesystem headers, do you know the UUID it should
> have so you're not working with some old remnant?
The file systems looks correct:
$ grep storage /etc/fstab
# commented out during recovery
#UUID=3D345ec7b8-b523-45d3-8c2e-35cda1ab62c1 /storage        ext4
errors=3Dremount-ro 0       1
$ file -s /dev/md0
/dev/md0: Linux rev 1.0 ext4 filesystem data,
UUID=3D345ec7b8-b523-45d3-8c2e-35cda1ab62c1 (extents) (64bit) (large
files) (huge files)
$ file -s /dev/md1
/dev/md1: Linux rev 1.0 ext4 filesystem data,
UUID=3D345ec7b8-b523-45d3-8c2e-35cda1ab62c1 (extents) (64bit) (large
files) (huge files)

You mentioned something about linear device mapping before. What is
that? Is it something I could experiment with? How do I do that?
If I can get copies of files I know should be present on the raid set,
would that help?

Output of examine calls:
$ mdadm --examine /dev/mapper/sd{a,b,d,c,e}
/dev/mapper/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1d7570c5:da2c78dd:eb7add42:73d27d8d
           Name : rack-server-1:0  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:54 2017
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 23441584128 (22355.64 GiB 24004.18 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : c285c661:ae3a9df5:dadb24d8:ea226018

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:54 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 97093390 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
/dev/mapper/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1d7570c5:da2c78dd:eb7add42:73d27d8d
           Name : rack-server-1:0  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:54 2017
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 12111493040 (5775.21 GiB 6201.08 GB)
     Array Size : 23441584128 (22355.64 GiB 24004.18 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D390700976 sectors
          State : clean
    Device UUID : fe47f0cf:68894c26:9464bfc6:3dd1b973

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:54 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 97201a94 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
/dev/mapper/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1d7570c5:da2c78dd:eb7add42:73d27d8d
           Name : rack-server-1:0  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:54 2017
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 23441584128 (22355.64 GiB 24004.18 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : 80965407:ecae968e:936beab7:0dedbc67

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:54 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4b3126a - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
/dev/mapper/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1d7570c5:da2c78dd:eb7add42:73d27d8d
           Name : rack-server-1:0  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:54 2017
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 23441584128 (22355.64 GiB 24004.18 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : 121f2396:94a105f4:db8d9b34:8f950eb3

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:54 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c0f3586f - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
/dev/mapper/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1d7570c5:da2c78dd:eb7add42:73d27d8d
           Name : rack-server-1:0  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:54 2017
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 23441584128 (22355.64 GiB 24004.18 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : 973d238d:dd08107c:186646f0:2131ad56

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:54 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 9f47520d - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)

$ mdadm --examine /dev/mapper/sd{a,b,d,c,e,f}-2
/dev/mapper/sda-2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b83927d8:ec75eb8e:9d1d1016:4cce5dff
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:22 2017
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 29301980160 (27944.55 GiB 30005.23 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : 4536ac05:80fa79ce:fb940867:4dea2d14

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:22 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a7c0d060 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/mapper/sdb-2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b83927d8:ec75eb8e:9d1d1016:4cce5dff
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:22 2017
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 12111493040 (5775.21 GiB 6201.08 GB)
     Array Size : 29301980160 (27944.55 GiB 30005.23 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D390700976 sectors
          State : clean
    Device UUID : 2990130a:7759c23c:fed7a8e8:1ea1542f

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:22 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ce812210 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/mapper/sdd-2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b83927d8:ec75eb8e:9d1d1016:4cce5dff
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:22 2017
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 29301980160 (27944.55 GiB 30005.23 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : ebd7e323:0480c5e8:f6362f38:0926ec10

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:22 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ae28d543 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/mapper/sdc-2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b83927d8:ec75eb8e:9d1d1016:4cce5dff
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:22 2017
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 29301980160 (27944.55 GiB 30005.23 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : 5bd0d200:3878824d:f1ad243f:130503c0

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:22 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a5e11bed - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/mapper/sde-2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b83927d8:ec75eb8e:9d1d1016:4cce5dff
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:22 2017
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 29301980160 (27944.55 GiB 30005.23 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : b859bdd4:b10a1761:a5803a47:76c9775b

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:22 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 30eacedc - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
/dev/mapper/sdf-2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : b83927d8:ec75eb8e:9d1d1016:4cce5dff
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Mon Apr 24 21:54:22 2017
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 11720792240 (5588.91 GiB 6001.05 GB)
     Array Size : 29301980160 (27944.55 GiB 30005.23 GB)
  Used Dev Size : 11720792064 (5588.91 GiB 6001.05 GB)
    Data Offset : 252928 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D252840 sectors, after=3D176 sectors
          State : clean
    Device UUID : 1c2e4b33:e87a49fa:55e6f42e:bab18c10

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 24 21:54:22 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c57a616b - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
