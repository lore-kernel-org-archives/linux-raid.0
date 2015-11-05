From: Clement Parisot <clement.parisot@inria.fr>
Subject: Re: Reconstruct a RAID 6 that has failed in a non typical manner
Date: Thu, 5 Nov 2015 11:35:50 +0100 (CET)
Message-ID: <1861199271.16131793.1446719750662.JavaMail.zimbra@inria.fr>
References: <1874721715.14008052.1446134381481.JavaMail.zimbra@inria.fr> <5633B79D.4000009@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5633B79D.4000009@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

=46irst of all, thanks for your answer. Here is an update of what we di=
d:

We got surprised to see two drives that were announced in 'failed' stat=
e back in 'working order' after a reboot. At least they were not consid=
ered in failed state anymore. So we tried something a bit tricky.
We removed the drive we changed and re-introduced the old one (supposed=
 to be broken)
Thanks to this, we were able to re-create the array with "mdadm --assem=
ble --force /dev/md2", restart the volume group and mount read-only the=
 logical volume.
Sadly, trying to rsync data into a safer place, most of it failed with =
I/O error, often ending killing the array.
We still have two drives that were not physicaly removed, so that theor=
ically contains datas, but that appears as spare in mdadm --examine, pr=
obably because of the 're-add' attempt we made.

> Your subject is inaccurate.  You've described a situation that is
> extraordinarily common when using green drives.  Or any modern deskto=
p
> drive -- they aren't rated for use in raid arrays.  Please read the
> references in the post-script.
After reading your links, it seems that indeed, the situation we experi=
ment is what is described in link [3] or link [6].

> Did you run "mdadm --stop /dev/md2" first?  That would explain the
> "busy" reports.
Yes we did. This is why the 'busy' is surprising. It seems to come from=
 drives:
# mdadm --verbose --assemble /dev/md2
[...]
mdadm: /dev/sdp is identified as a member of /dev/md2, slot 15.
mdadm: /dev/sdo is identified as a member of /dev/md2, slot 14.
mdadm: /dev/sdn is identified as a member of /dev/md2, slot 13.
mdadm: /dev/sdm is identified as a member of /dev/md2, slot 12.
mdadm: /dev/sdl is identified as a member of /dev/md2, slot 11.
mdadm: /dev/sdk is identified as a member of /dev/md2, slot 10.
mdadm: /dev/sdj is identified as a member of /dev/md2, slot 9.
mdadm: /dev/sdi is identified as a member of /dev/md2, slot 8.
mdadm: /dev/sdh is identified as a member of /dev/md2, slot 7.
mdadm: /dev/sdg is identified as a member of /dev/md2, slot -1.
mdadm: /dev/sdf is identified as a member of /dev/md2, slot 5.
mdadm: /dev/sde is identified as a member of /dev/md2, slot 4.
mdadm: /dev/sdc is identified as a member of /dev/md2, slot 2.
mdadm: /dev/sdd is identified as a member of /dev/md2, slot 3.
mdadm: /dev/sdb is identified as a member of /dev/md2, slot -1.
mdadm: /dev/sda is identified as a member of /dev/md2, slot -1.
mdadm: no uptodate device for slot 0 of /dev/md2
mdadm: no uptodate device for slot 1 of /dev/md2
mdadm: added /dev/sdd to /dev/md2 as 3
mdadm: added /dev/sde to /dev/md2 as 4
mdadm: added /dev/sdf to /dev/md2 as 5
mdadm: no uptodate device for slot 6 of /dev/md2
mdadm: added /dev/sdh to /dev/md2 as 7
mdadm: added /dev/sdi to /dev/md2 as 8
mdadm: added /dev/sdj to /dev/md2 as 9
mdadm: added /dev/sdk to /dev/md2 as 10
mdadm: added /dev/sdl to /dev/md2 as 11
mdadm: added /dev/sdm to /dev/md2 as 12
mdadm: added /dev/sdn to /dev/md2 as 13
mdadm: added /dev/sdo to /dev/md2 as 14
mdadm: added /dev/sdp to /dev/md2 as 15
mdadm: added /dev/sdg to /dev/md2 as -1
mdadm: failed to add /dev/sdb to /dev/md2: Device or resource busy
mdadm: failed to add /dev/sda to /dev/md2: Device or resource busy


> Before proceeding, please supply more information:
>=20
> for x in /dev/sd[a-p] ; mdadm -E $x ; smartctl -i -A -l scterc $x ; d=
one
>=20
> Paste the output inline in your response.


I couldn't get smartctl to work successfully. The version supported on =
debian squeeze doesn't support aacraid.
I tried from a chroot in a debootstrap with a more recent debian versio=
n, but only got:

# smartctl --all -d aacraid,0,0,0 /dev/sda
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-2.6.32-5-amd64] (local buil=
d)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

Smartctl open device: /dev/sda [aacraid_disk_00_00_0] [SCSI/SAT] failed=
: INQUIRY [SAT]: aacraid result: 0.0 =3D 22/0

Here is the output for mdadm -E:

$ for x in /dev/sd[a-p] ; do sudo mdadm -E $x ; done
/dev/sda:
          Magic : a92b4efc
        Version : 1.2
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 27a0fe11:278b30d3:3251ee70:66b015d0

    Update Time : Wed Oct 28 13:46:13 2015
       Checksum : 5b99bd5 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : spare
   Array State : ..AAAA.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b58fb9e7:72e48374:44a9862c:5b8de755

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : be982cb8 - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
:mdadm: No md superblock detected on /dev/sdd.
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1aff07a9:0ac3fa0c:6bb5e685:bac7893e

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : 5a5fc14a - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 30bfa9d2:2a483372:5a489324:c2f5f729

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : 7354c76b - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 5          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 93fd1f09:6ca19143:002a3e5c:17813675

    Update Time : Wed Oct 28 13:46:13 2015
       Checksum : fdacb903 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : spare
   Array State : ..AAAA.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425472 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
    Data Offset : 512 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d656d255:5ece759c:2deca760:3ae659c3

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : f636719b - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 7
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d93661b8:40996a0b:b373cfd8:df0e2bd6

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : 52b2d4a4 - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : cf9d8d29:42956b39:79841196:9d3281e4

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : bd786c40 - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 9
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d9ae5754:4b1fffcb:b76d34e4:fed2f192

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : 776990dc - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 10
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)

/dev/sdk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e44e950f:09456ec5:35463869:13663a98

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : b662c230 - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 11
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdl:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 51b3c930:27332156:535ec2d3:a77cc127

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : 625b436e - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 12
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdm:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 83fa2210:26f430cf:6ef35e86:13be77c8

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : e172228 - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 13
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdn:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6700962b:ed334ee5:98e00751:79f25fb9

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : fb388963 - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 14
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdo:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9b099832:da80cf49:d62f76d9:7681a6a5

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : db70bdc0 - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 15
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
/dev/sdp:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
   Raid Devices : 16

 Avail Dev Size : 1952425984 (930.99 GiB 999.64 GB)
     Array Size : 27333956608 (13033.85 GiB 13994.99 GB)
  Used Dev Size : 1952425472 (930.99 GiB 999.64 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : df2bcc6a:5d7e060c:6ab4ac39:b11a631f

    Update Time : Wed Nov  4 10:31:19 2015
       Checksum : afcefb47 - correct
         Events : 5834314

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : .AAA.A.AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)


Regards,

Cl=E9ment and Marc
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
