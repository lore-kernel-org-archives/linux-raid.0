From: Brian Candler <B.Candler@pobox.com>
Subject: Monitoring for failed drives
Date: Wed, 25 Apr 2012 13:39:51 +0100
Message-ID: <20120425123951.GB10172@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

One of the servers I've been setting up, which has an md RAID0 for temporary
storage, has just had a disk error.

  root@storage2:~# ls -l /disk/scratch/scratch/path/to/file
  ls: cannot access /disk/scratch/scratch/path/to/file/file.4000.new.1521.rsi: Remote I/O error
  ls: cannot access /disk/scratch/scratch/path/to/file/file.4000.new.1522.rsi: Remote I/O error
  ls: cannot access /disk/scratch/scratch/path/to/file/file.4000.new.1523.rsi: Remote I/O error
  ...

dmesg shows:

  [ 1232.406491] mpt2sas1: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
  [ 1232.406497] mpt2sas1: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
  [ 1232.406512] sd 5:0:0:0: [sdr] Unhandled sense code
  [ 1232.406514] sd 5:0:0:0: [sdr]  Result: hostbyte=invalid driverbyte=DRIVER_SENSE
  [ 1232.406518] sd 5:0:0:0: [sdr]  Sense Key : Medium Error [current] 
  [ 1232.406522] Info fld=0x30000588
  [ 1232.406524] sd 5:0:0:0: [sdr]  Add. Sense: Unrecovered read error
  [ 1232.406528] sd 5:0:0:0: [sdr] CDB: Read(10): 28 00 30 00 05 80 00 00 10 00
  [ 1232.406537] end_request: critical target error, dev sdr, sector 805307776

OK, so that's fairly obviously a failed drive.

The problem is, how to detect and report this? At the md RAID level,
`cat /proc/mdstat` and `mdadm --detail` show nothing amiss.

    # cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md127 : active raid0 sdk[8] sdf[4] sdb[0] sdj[9] sdc[1] sde[2] sdd[3] sdi[6] sdg[5] sdh[7] sdv[20] sdw[21] sdl[11] sdu[19] sdt[18] sdn[13] sds[17] sdq[14] sdm[10] sdx[22] sdr[16] sdo[12] sdp[15] sdy[23]
          70326362112 blocks super 1.2 512k chunks
          
    unused devices: <none>

    root@storage2:~# mdadm --detail /dev/md/scratch 
    /dev/md/scratch:
            Version : 1.2
      Creation Time : Mon Apr 23 16:53:59 2012
         Raid Level : raid0
         Array Size : 70326362112 (67068.45 GiB 72014.19 GB)
       Raid Devices : 24
      Total Devices : 24
        Persistence : Superblock is persistent

        Update Time : Mon Apr 23 16:53:59 2012
              State : clean
     Active Devices : 24
    Working Devices : 24
     Failed Devices : 0
      Spare Devices : 0

         Chunk Size : 512K

               Name : storage2:scratch  (local to host storage2)
               UUID : e5d2dce6:91d1d3b9:ae08f838:5e12132a
             Events : 0

        Number   Major   Minor   RaidDevice State
           0       8       16        0      active sync   /dev/sdb
           1       8       32        1      active sync   /dev/sdc
           2       8       64        2      active sync   /dev/sde
           3       8       48        3      active sync   /dev/sdd
           4       8       80        4      active sync   /dev/sdf
           5       8       96        5      active sync   /dev/sdg
           6       8      128        6      active sync   /dev/sdi
           7       8      112        7      active sync   /dev/sdh
           8       8      160        8      active sync   /dev/sdk
           9       8      144        9      active sync   /dev/sdj
          10       8      192       10      active sync   /dev/sdm
          11       8      176       11      active sync   /dev/sdl
          12       8      224       12      active sync   /dev/sdo
          13       8      208       13      active sync   /dev/sdn
          14      65        0       14      active sync   /dev/sdq
          15       8      240       15      active sync   /dev/sdp
          16      65       16       16      active sync   /dev/sdr
          17      65       32       17      active sync   /dev/sds
          18      65       48       18      active sync   /dev/sdt
          19      65       64       19      active sync   /dev/sdu
          20      65       80       20      active sync   /dev/sdv
          21      65       96       21      active sync   /dev/sdw
          22      65      112       22      active sync   /dev/sdx
          23      65      128       23      active sync   /dev/sdy

So first question is this: what does it take for a drive to be marked as
"failed" by md RAID? Is there some threshold I can set?

Second question: what's a better way of monitoring this proactively, rather
than just waiting for applications to fail and then digging into dmesg?

Recently I installed an excellent set of snmp plugins and MIBs for exposing
both md-raid and smartctl information via SNMP, which I got from
http://www.mad-hacking.net/software/index.xml
http://downloads.mad-hacking.net/software/

Here's the md RAID output (which really is just reformatting of info
from mdadm --detail)

  root@storage2:~# snmptable -c XXXXXXXX -v 2c storage2 MD-RAID-MIB::mdRaidTableSNMP table: MD-RAID-MIB::mdRaidTable

   mdRaidArrayIndex  mdRaidArrayDev mdRaidArrayVersion                     mdRaidArrayUUID mdRaidArrayLevel mdRaidArrayLayout mdRaidArrayChunkSize mdRaidArraySize mdRaidArrayDeviceSize mdRaidArrayHealthOK mdRaidArrayHasFailedComponents mdRaidArrayHasAvailableSpares mdRaidArrayTotalComponents mdRaidArrayActiveComponents mdRaidArrayWorkingComponents mdRaidArrayFailedComponents mdRaidArraySpareComponents
                  1 /dev/md/scratch                1.2 e5d2dce6:91d1d3b9:ae08f838:5e12132a            raid0               N/A                 512K     70326362112                   N/A                true                          false                         false                         24                          24                           24                           0                          0

And here's the output for SMART (which combines smartctl -i, -H and -A):

  root@storage2:~# snmptable -c XXXXXXXX -v 2c storage2 SMARTCTL-MIB::smartCtlTable
  SNMP table: SMARTCTL-MIB::smartCtlTable

   smartCtlDeviceIndex smartCtlDeviceDev smartCtlDeviceModelFamily smartCtlDeviceDeviceModel smartCtlDeviceSerialNumber        smartCtlDeviceUserCapacity smartCtlDeviceATAVersion smartCtlDeviceHealthOK smartCtlDeviceTemperatureCelsius smartCtlDeviceReallocatedSectorCt smartCtlDeviceCurrentPendingSector smartCtlDeviceOfflineUncorrectable smartCtlDeviceUDMACRCErrorCount smartCtlDeviceReadErrorRate smartCtlDeviceSeekErrorRate smartCtlDeviceHardwareECCRecovered
                     1          /dev/sda                                  ST1000DM003-9YN162                   Z1D0BQHF 1,000,204,886,016 bytes [1.00 TB]                        8                   true                               28                                 0                                  0                                  0                               0                         105                          30                                  ?
                     2          /dev/sdb                                  ST3000DM001-9YN166                   S1F01Z36 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               28                                 0                                  0                                  0                               0                         105                          31                                  ?
                     3          /dev/sdc                                  ST3000DM001-9YN166                   S1F01932 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               24                                 0                                  0                                  0                               0                         103                          31                                  ?
                     4          /dev/sdd                                  ST3000DM001-9YN166                   S1F04Y7G 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               26                                 0                                  0                                  0                               0                         104                          31                                  ?
                     5          /dev/sde                                  ST3000DM001-9YN166                   S1F00KF2 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               25                                 0                                  0                                  0                               0                         104                          31                                  ?
                     6          /dev/sdf                                  ST3000DM001-9YN166                   S1F01C0D 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               27                                 0                                  0                                  0                               0                         103                          31                                  ?
                     7          /dev/sdg                                  ST3000DM001-9YN166                   S1F01DFM 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               25                                 0                                  0                                  0                               0                         104                          31                                  ?
                     8          /dev/sdh                                  ST3000DM001-9YN166                   S1F054EP 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               27                                 0                                  0                                  0                               0                         105                          31                                  ?
                     9          /dev/sdi                                  ST3000DM001-9YN166                   S1F05304 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               25                                 0                                  0                                  0                               0                         105                          31                                  ?
                    10          /dev/sdj                                  ST3000DM001-9YN166                   S1F015X5 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               25                                 0                                  0                                  0                               0                         105                          31                                  ?
                    11          /dev/sdk                                  ST3000DM001-9YN166                   S1F046FB 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               27                                 0                                  0                                  0                               0                         103                          31                                  ?
                    12          /dev/sdl                                  ST3000DM001-9YN166                   S1F024DW 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               26                                 0                                  0                                  0                               0                         103                          31                                  ?
                    13          /dev/sdm                                  ST3000DM001-9YN166                   S1F04DKQ 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               25                                 0                                  0                                  0                               0                         104                          31                                  ?
                    14          /dev/sdn                                  ST3000DM001-9YN166                   S1F014NH 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               25                                 0                                  0                                  0                               0                         104                          31                                  ?
                    15          /dev/sdo                                  ST3000DM001-9YN166                   S1F049KM 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               26                                 0                                  0                                  0                               0                         105                          31                                  ?
                    16          /dev/sdp                                  ST3000DM001-9YN166                   S1F01D5A 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               26                                 0                                  0                                  0                               0                         103                          31                                  ?
                    17          /dev/sdq                                  ST3000DM001-9YN166                   S1F00L20 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               24                                 0                                  0                                  0                               0                         103                          31                                  ?
                    18          /dev/sdr                                  ST3000DM001-9YN166                   S1F07PN8 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               28                                 0                                  8                                  8                               0                          81                          31                                  ?
                    19          /dev/sds                                  ST3000DM001-9YN166                   S1F03PS8 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               25                                 0                                  0                                  0                               0                         104                          31                                  ?
                    20          /dev/sdt                                  ST3000DM001-9YN166                   S1F04SM4 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               25                                 0                                  0                                  0                               0                         103                          31                                  ?
                    21          /dev/sdu                                  ST3000DM001-9YN166                   S1F00MCQ 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               27                                 0                                  0                                  0                               0                         105                          31                                  ?
                    22          /dev/sdv                                  ST3000DM001-9YN166                   S1F020YG 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               28                                 0                                  0                                  0                               0                         104                          31                                  ?
                    23          /dev/sdw                                  ST3000DM001-9YN166                   S1F03NXP 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               26                                 0                                  0                                  0                               0                         103                          31                                  ?
                    24          /dev/sdx                                  ST3000DM001-9YN166                   S1F054Y7 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               26                                 0                                  0                                  0                               0                         104                          31                                  ?
                    25          /dev/sdy                                  ST3000DM001-9YN166                   S1F04A0Y 3,000,592,982,016 bytes [3.00 TB]                        8                   true                               27                                 0                                 40                                 40                               0                         105                          31                                  ?

All drives report smartCtlDeviceHealthOK = True, which derives from the
test "PASSED" result from smartctl -H:

  smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.0.0-16-server] (local build)
  Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED

The only anomoly I can see here is that sdr has reported 8 unrecoverable
errors - and also sdy has reported 40 unrecoverable errors!

So based on this information, I am going to return sdr and sdy to the
manufacturer for replacement.

But is there any better way that I can be notified quickly of I/O errors
and/or retries, for example counters being maintained in the kernel?

Thanks,

Brian.
