From: luvar@plaintext.sk
Subject: stray raid10 with 9 hdd with -n3 layout
Date: Wed, 6 Aug 2014 08:55:36 +0100 (GMT+01:00)
Message-ID: <2137843278.261407311736686.JavaMail.root@shiva>
References: <1564432307.211407311660054.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_8_1125681043.1407311736679"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1564432307.211407311660054.JavaMail.root@shiva>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_8_1125681043.1407311736679
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,
I have personal nas with open media vault. It is working quite good, if it is up and running. When I turn it off for a week, it does not assemble my raid, or it assembles it in degraded mode. Problem is in hardware. I use port replicators. They probably need to be warmed up before they provide access to all hdd. Beside this problem, can someone guide me to magic of linux software raid?

I have one disk for OS (no raid, no problems :)
Than I have three disks without raid.
And than I have nine disks which should assemble single raid with raid10, n3 layout. I have done mdadm --examine on all of them. Results are attached. I reference all disks by ID. Here is my mdadm.conf:

root@nas:~# grep ARRAY /etc/mdadm/mdadm.conf 
ARRAY /dev/md/3 metadata=1.2 name=nas:3 devices=/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V0VD64,/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DJTWJ,/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DHUUW,/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DUVZY,/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V0WAP9,/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V0VCHR,/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXG1C12P3593,/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1CHAWF,/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V0V9A4

See that if you do "grep "Array UUID" *" command on all attachement, that all disks have same array UUID and despite this, array state is not same from point of view of given disk:
root@nas:~/temp/raid10n3examine$ grep "Array State" *
disk1-ata-ST320LT012-9WS14C_W0V0VD64:               Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
disk2-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DJTWJ:   Array State : .AA.AA..A ('A' == active, '.' == missing, 'R' == replacing)
disk3-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DHUUW:   Array State : ..A.....A ('A' == active, '.' == missing, 'R' == replacing)
disk4-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DUVZY:   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
disk5-ata-ST320LT012-9WS14C_W0V0WAP9:               Array State : .AA.AA..A ('A' == active, '.' == missing, 'R' == replacing)
disk6-ata-ST320LT012-9WS14C_W0V0VCHR:               Array State : .AA.AA..A ('A' == active, '.' == missing, 'R' == replacing)
disk7-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXG1C12P3593:   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
disk8-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1CHAWF:   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
disk9-ata-ST320LT012-9WS14C_W0V0V9A4:               Array State : .AA.AA..A ('A' == active, '.' == missing, 'R' == replacing)


I have these questions:
 1. why does my array assemble automatically?
 2. is there possibility to assemble array in a such way, that array will "elect" which data is on more disks and rewrite last disk if needed?
 3. is there possibility to assemble array in cooperation with filesystem? That filesystem will have chance to choose blocks from all three disks and choose correct one from his point of view?
 4. what should I do to have my data OK?

PS: I have lvm on top of that raid with a few volumes. All volumes with ext4 fs on them.

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk1-ata-ST320LT012-9WS14C_W0V0VD64
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk1-ata-ST320LT012-9WS14C_W0V0VD64

/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V0VD64:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : clean
    Device UUID : 83c3c3be:9e845320:8a29784f:acdb4835

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jul 21 08:25:33 2014
       Checksum : ba8a7659 - correct
         Events : 54403

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk2-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DJTWJ
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk2-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DJTWJ

/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DJTWJ:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : clean
    Device UUID : 2a28c3b4:eedae163:2bef10b4:ca5d625d

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 30 08:26:45 2014
       Checksum : 80c756df - correct
         Events : 54423

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : .AA.AA..A ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk3-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DHUUW
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk3-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DHUUW

/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DHUUW:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : active
    Device UUID : ca4d24bf:a8803950:9d3187e9:4e94fb0b

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 30 09:06:50 2014
       Checksum : 5b87a49b - correct
         Events : 54426

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : ..A.....A ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk4-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DUVZY
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk4-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DUVZY

/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1DUVZY:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : clean
    Device UUID : 25509aed:47f4ea45:4333a46e:b5354e9d

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jul 21 08:25:33 2014
       Checksum : 9629d661 - correct
         Events : 54403

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk5-ata-ST320LT012-9WS14C_W0V0WAP9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk5-ata-ST320LT012-9WS14C_W0V0WAP9

/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V0WAP9:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : clean
    Device UUID : bd194e66:0c30ff7f:c32f2ceb:559d8890

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 30 08:26:45 2014
       Checksum : b8b11dbd - correct
         Events : 54423

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 4
   Array State : .AA.AA..A ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk6-ata-ST320LT012-9WS14C_W0V0VCHR
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk6-ata-ST320LT012-9WS14C_W0V0VCHR

/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V0VCHR:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : clean
    Device UUID : 9e7ecbc9:36fa64a3:a3fc5d7d:862d939b

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 30 08:26:45 2014
       Checksum : dcd0a9da - correct
         Events : 54423

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 5
   Array State : .AA.AA..A ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk7-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXG1C12P3593
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk7-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXG1C12P3593

/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXG1C12P3593:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : clean
    Device UUID : 94ad8e88:769cabee:896b2080:0f0d9178

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jul 21 08:25:33 2014
       Checksum : c69deba2 - correct
         Events : 54403

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 6
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk8-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1CHAWF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk8-ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1CHAWF

/dev/disk/by-id/ata-WDC_WD3200BPVT-80JJ5T0_WD-WXF1EC1CHAWF:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : clean
    Device UUID : 230dc753:4ddbb8de:cd80ddce:0f59338b

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jul 21 08:25:33 2014
       Checksum : e342eb53 - correct
         Events : 54403

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 7
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679
Content-Type: application/octet-stream;
	name=disk9-ata-ST320LT012-9WS14C_W0V0V9A4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=disk9-ata-ST320LT012-9WS14C_W0V0V9A4

/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V0V9A4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 78e085ee:6bf8cbfc:507b0f37:2ff66460
           Name : nas:3  (local to host nas)
  Creation Time : Sun Dec  8 21:36:53 2013
     Raid Level : raid10
   Raid Devices : 9

 Avail Dev Size : 625140400 (298.09 GiB 320.07 GB)
     Array Size : 937709952 (894.27 GiB 960.21 GB)
  Used Dev Size : 625139968 (298.09 GiB 320.07 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=432 sectors
          State : clean
    Device UUID : 7f05af72:19c0b056:806f23c3:2b29c339

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 30 08:26:45 2014
       Checksum : 1cf56522 - correct
         Events : 54423

         Layout : near=3
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : .AA.AA..A ('A' == active, '.' == missing, 'R' == replacing)

------=_Part_8_1125681043.1407311736679--
