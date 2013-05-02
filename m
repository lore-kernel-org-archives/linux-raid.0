From: Stefan Borggraefe <stefan@spybot.info>
Subject: Help with recovering a RAID5 array
Date: Thu, 02 May 2013 14:24:04 +0200
Message-ID: <34199580.p6EyCyMeIZ@chablis>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am using a RAID5 software RAID on Ubuntu 12.04 (kernel
3.2.0-37-generic x86_64).

It consits of 6 Hitachi drives with 4 TB and contains an ext 4 file system.
There are no spare devices.

Yesterday evening I exchanged a drive that showed SMART errors and the
array started rebuilding its redundancy normally.

When I returned to this server this morning, the array was in the following
state:

md126 : active raid5 sdc1[7](S) sdh1[4] sdd1[3](F) sde1[0] sdg1[6] sdf1[2]
      19535086080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/4] 
[U_U_UU]

sdc is the newly added hard disk, but now also sdd failed. :( It would be
great if there was a way to have the this RAID5 working again. Perhaps sdc1
can then be fully added to the array and after this drive sdd also exchanged.

I have not started experimenting or changing this array in any way, but wanted 
to ask here for assistance first. Thank you for your help!

mdadm --examine /dev/sd[cdegfh]1 | egrep 'Event|/dev/sd'

shows

/dev/sdc1:
         Events : 494
/dev/sdd1:
         Events : 478
/dev/sde1:
         Events : 494
/dev/sdf1:
         Events : 494
/dev/sdg1:
         Events : 494
/dev/sdh1:
         Events : 494



mdadm --examine /dev/sd[cdegfh]1

showsThank you for your help! :)

/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13051471:fba5785f:4365dea1:0670be37
           Name : teraturm:2  (local to host teraturm)
  Creation Time : Tue Feb  5 14:23:06 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 7814035053 (3726.02 GiB 4000.79 GB)
     Array Size : 19535086080 (18630.11 GiB 20003.93 GB)
  Used Dev Size : 7814034432 (3726.02 GiB 4000.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7433213e:0dd2e5ed:073dd59d:bf1f83d8

    Update Time : Tue Apr 30 10:06:55 2013
       Checksum : 9e83f72 - correct
         Events : 494

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.A.AA ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13051471:fba5785f:4365dea1:0670be37
           Name : teraturm:2  (local to host teraturm)
  Creation Time : Tue Feb  5 14:23:06 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 7814035053 (3726.02 GiB 4000.79 GB)
     Array Size : 19535086080 (18630.11 GiB 20003.93 GB)
  Used Dev Size : 7814034432 (3726.02 GiB 4000.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : c2e5423f:6d91a061:c3f55aa7:6d1cec87

    Update Time : Mon Apr 29 17:24:26 2013
       Checksum : 37b97776 - correct
         Events : 478

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13051471:fba5785f:4365dea1:0670be37
           Name : teraturm:2  (local to host teraturm)
  Creation Time : Tue Feb  5 14:23:06 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 7814035053 (3726.02 GiB 4000.79 GB)
     Array Size : 19535086080 (18630.11 GiB 20003.93 GB)
  Used Dev Size : 7814034432 (3726.02 GiB 4000.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 68207885:02c05297:8ef62633:65b83839

    Update Time : Tue Apr 30 10:06:55 2013
       Checksum : f0b36c7f - correct
         Events : 494

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.A.AA ('A' == active, '.' == missing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13051471:fba5785f:4365dea1:0670be37
           Name : teraturm:2  (local to host teraturm)
  Creation Time : Tue Feb  5 14:23:06 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 7814035053 (3726.02 GiB 4000.79 GB)
     Array Size : 19535086080 (18630.11 GiB 20003.93 GB)
  Used Dev Size : 7814034432 (3726.02 GiB 4000.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7d328a98:6c02f550:ab1837c0:cb773ac1

    Update Time : Tue Apr 30 10:06:55 2013
       Checksum : d2799f34 - correct
         Events : 494

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.A.AA ('A' == active, '.' == missing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13051471:fba5785f:4365dea1:0670be37
           Name : teraturm:2  (local to host teraturm)
  Creation Time : Tue Feb  5 14:23:06 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 7814035053 (3726.02 GiB 4000.79 GB)
     Array Size : 19535086080 (18630.11 GiB 20003.93 GB)
  Used Dev Size : 7814034432 (3726.02 GiB 4000.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 76b683b1:58e053ff:57ac0cfc:be114f75

    Update Time : Tue Apr 30 10:06:55 2013
       Checksum : 89bc2e05 - correct
         Events : 494

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : A.A.AA ('A' == active, '.' == missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 13051471:fba5785f:4365dea1:0670be37
           Name : teraturm:2  (local to host teraturm)
  Creation Time : Tue Feb  5 14:23:06 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 7814035053 (3726.02 GiB 4000.79 GB)
     Array Size : 19535086080 (18630.11 GiB 20003.93 GB)
  Used Dev Size : 7814034432 (3726.02 GiB 4000.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3c88705f:9f3add0e:d58d46a7:b40d02d7

    Update Time : Tue Apr 30 10:06:55 2013
       Checksum : 541f3913 - correct
         Events : 494

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : A.A.AA ('A' == active, '.' == missing)

This is the dmesg output from when the failure happened:

[6669459.855352] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.855362] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.855368] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 2a 00 00 08 
00
[6669459.855387] end_request: I/O error, dev sdd, sector 590910506
[6669459.855456] raid5_end_read_request: 14 callbacks suppressed
[6669459.855463] md/raid:md126: read error not correctable (sector 590910472 
on sdd1).
[6669459.855490] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.855496] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.855501] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 32 00 00 08 
00
[6669459.855515] end_request: I/O error, dev sdd, sector 590910514
[6669459.855594] md/raid:md126: read error not correctable (sector 590910480 
on sdd1).
[6669459.855608] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.855611] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.855620] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 3a 00 00 08 
00
[6669459.855648] end_request: I/O error, dev sdd, sector 590910522
[6669459.855710] md/raid:md126: read error not correctable (sector 590910488 
on sdd1).
[6669459.855720] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.855723] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.855727] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 42 00 00 08 
00
[6669459.855737] end_request: I/O error, dev sdd, sector 590910530
[6669459.855796] md/raid:md126: read error not correctable (sector 590910496 
on sdd1).
[6669459.855814] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.855817] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.855821] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 4a 00 00 08 
00
[6669459.855831] end_request: I/O error, dev sdd, sector 590910538
[6669459.855889] md/raid:md126: read error not correctable (sector 590910504 
on sdd1).
[6669459.855907] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.855910] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.855914] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 52 00 00 08 
00
[6669459.855924] end_request: I/O error, dev sdd, sector 590910546
[6669459.855982] md/raid:md126: read error not correctable (sector 590910512 
on sdd1).
[6669459.855990] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.855992] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.855996] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 5a 00 00 08 
00
[6669459.856004] end_request: I/O error, dev sdd, sector 590910554
[6669459.856062] md/raid:md126: read error not correctable (sector 590910520 
on sdd1).
[6669459.856072] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856075] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856079] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 62 00 00 08 
00
[6669459.856088] end_request: I/O error, dev sdd, sector 590910562
[6669459.856153] md/raid:md126: read error not correctable (sector 590910528 
on sdd1).
[6669459.856171] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856174] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856178] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 6a 00 00 08 
00
[6669459.856188] end_request: I/O error, dev sdd, sector 590910570
[6669459.856256] md/raid:md126: read error not correctable (sector 590910536 
on sdd1).
[6669459.856265] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856268] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856272] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 72 00 00 08 
00
[6669459.856281] end_request: I/O error, dev sdd, sector 590910578
[6669459.856346] md/raid:md126: read error not correctable (sector 590910544 
on sdd1).
[6669459.856364] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856368] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856374] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 7a 00 00 08 
00
[6669459.856385] end_request: I/O error, dev sdd, sector 590910586
[6669459.856445] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856449] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856456] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 82 00 00 08 
00
[6669459.856466] end_request: I/O error, dev sdd, sector 590910594
[6669459.856526] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856530] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856537] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 8a 00 00 08 
00
[6669459.856547] end_request: I/O error, dev sdd, sector 590910602
[6669459.856607] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856611] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856617] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 92 00 00 08 
00
[6669459.856628] end_request: I/O error, dev sdd, sector 590910610
[6669459.856687] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856691] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856697] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 9a 00 00 08 
00
[6669459.856707] end_request: I/O error, dev sdd, sector 590910618
[6669459.856767] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856772] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856778] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 a2 00 00 08 
00
[6669459.856788] end_request: I/O error, dev sdd, sector 590910626
[6669459.856847] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856851] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856859] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 aa 00 00 08 
00
[6669459.856869] end_request: I/O error, dev sdd, sector 590910634
[6669459.856928] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.856932] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.856938] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 b2 00 00 08 
00
[6669459.856949] end_request: I/O error, dev sdd, sector 590910642
[6669459.857008] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.857011] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.857018] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 ba 00 00 08 
00
[6669459.857028] end_request: I/O error, dev sdd, sector 590910650
[6669459.857088] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.857092] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.857098] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 c2 00 00 08 
00
[6669459.857109] end_request: I/O error, dev sdd, sector 590910658
[6669459.857168] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.857171] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.857178] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 ca 00 00 08 
00
[6669459.857188] end_request: I/O error, dev sdd, sector 590910666
[6669459.857248] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.857251] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.857258] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 d2 00 00 08 
00
[6669459.857269] end_request: I/O error, dev sdd, sector 590910674
[6669459.857328] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.857333] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.857339] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 da 00 00 08 
00
[6669459.857349] end_request: I/O error, dev sdd, sector 590910682
[6669459.857408] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.857412] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.857418] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 94 e2 00 00 08 
00
[6669459.857429] end_request: I/O error, dev sdd, sector 590910690
[6669459.857488] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.857492] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.857499] sd 6:1:10:0: [sdd] CDB: Read(10): 28 00 23 38 93 4a 00 00 08 
00
[6669459.857509] end_request: I/O error, dev sdd, sector 590910282
[6669459.857569] sd 6:1:10:0: [sdd] Unhandled error code
[6669459.857573] sd 6:1:10:0: [sdd]  Result: hostbyte=DID_ABORT 
driverbyte=DRIVER_OK
[6669459.857579] sd 6:1:10:0: [sdd] CDB: 
[6669459.857585] aacraid: Host adapter abort request (6,1,10,0)
[6669459.857639] Read(10): 28 00 23 38 93 42 00 00 08 00
[6669459.857648] end_request: I/O error, dev sdd, sector 590910274
[6669459.857844] aacraid: Host adapter reset request. SCSI hang ?
[6669470.028090] RAID conf printout:
[6669470.028097]  --- level:5 rd:6 wd:4
[6669470.028101]  disk 0, o:1, dev:sde1
[6669470.028105]  disk 1, o:1, dev:sdc1
[6669470.028109]  disk 2, o:1, dev:sdf1
[6669470.028112]  disk 3, o:0, dev:sdd1
[6669470.028115]  disk 4, o:1, dev:sdh1
[6669470.028118]  disk 5, o:1, dev:sdg1
[6669470.034462] RAID conf printout:
[6669470.034464]  --- level:5 rd:6 wd:4
[6669470.034465]  disk 0, o:1, dev:sde1
[6669470.034466]  disk 2, o:1, dev:sdf1
[6669470.034467]  disk 3, o:0, dev:sdd1
[6669470.034468]  disk 4, o:1, dev:sdh1
[6669470.034469]  disk 5, o:1, dev:sdg1
[6669470.034484] RAID conf printout:
[6669470.034486]  --- level:5 rd:6 wd:4
[6669470.034489]  disk 0, o:1, dev:sde1
[6669470.034491]  disk 2, o:1, dev:sdf1
[6669470.034494]  disk 3, o:0, dev:sdd1
[6669470.034496]  disk 4, o:1, dev:sdh1
[6669470.034499]  disk 5, o:1, dev:sdg1
[6669470.034571] RAID conf printout:
[6669470.034577]  --- level:5 rd:6 wd:4
[6669470.034581]  disk 0, o:1, dev:sde1
[6669470.034584]  disk 2, o:1, dev:sdf1
[6669470.034587]  disk 4, o:1, dev:sdh1
[6669470.034589]  disk 5, o:1, dev:sdg1

Please let me know if you need any more information.
-- 
Best regards,
Stefan Borggraefe
