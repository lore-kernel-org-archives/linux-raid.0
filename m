From: =?ISO-8859-1?Q?Bj=F6rn_Englund?= <be@smarteye.se>
Subject: raid6 failed due to loss of connection
Date: Fri, 19 Nov 2010 13:33:29 +0100
Message-ID: <4CE66E99.6050806@smarteye.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a raid 6 consisting of 10 drives, 2x5 sata disks. Each set of 5
behind a port multiplier. The port multipliers/disk/drivers are a bit
flaky sometimes and I need to pull the cable between the controller and
port multiplier to get the disks recognized sometimes.

Now after rebooting I can't assemble the array.
mdadm -A /dev/md12, reports that 5 disks are too few to assemble array.

One set of (5) disks says that everything is ok when checked with mdadm
-E, but the other set says that 5 disks are failed.

The first set of 5 disks report this:

/dev/sdax2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 557d7924:1c547f1c:d878c05d:5a37cfcd
           Name : 12
  Creation Time : Sun Oct 18 22:07:52 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953118176 (931.32 GiB 1000.00 GB)
     Array Size : 15624941568 (7450.55 GiB 7999.97 GB)
  Used Dev Size : 1953117696 (931.32 GiB 1000.00 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : ac9db196:fc239a13:2a44b03b:aa45055a

    Update Time : Thu Nov 18 13:17:25 2010
       Checksum : d65e4e57 - correct
         Events : 6

     Chunk Size : 256K

    Array Slot : 5 (failed, failed, failed, failed, failed, 5, 6, 7, 8,=
 9)
   Array State : _____Uuuuu 5 failed


other 5 disks report this:

/dev/sdt2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 557d7924:1c547f1c:d878c05d:5a37cfcd
           Name : 12
  Creation Time : Sun Oct 18 22:07:52 2009
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1953118176 (931.32 GiB 1000.00 GB)
     Array Size : 15624941568 (7450.55 GiB 7999.97 GB)
  Used Dev Size : 1953117696 (931.32 GiB 1000.00 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 2bc9f9dc:efcc4041:8a495b40:ad504353

    Update Time : Sat Nov  6 14:56:15 2010
       Checksum : 482b7858 - correct
         Events : 2

     Chunk Size : 256K

    Array Slot : 0 (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
   Array State : Uuuuuuuuuu


Should I try mdadm -A -f /dev/md12 or do I need to run a create command
to get the array up and running?

I'm in the process of copying the drives so I have a backup in case
something goes wrong with the assembling...


/Bj=F6rn
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
