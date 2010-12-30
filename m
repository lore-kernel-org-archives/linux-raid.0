From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: Why won't mdadm start several RAIDs that appear to be fine?
Date: Thu, 30 Dec 2010 16:20:58 -0700
Message-ID: <20101230232227.96C1CE30991@mail.futurelabusa.com>
References: <20101230082356.GC2986@bitwizard.nl>
 <4D1C470E.4080406@crc.id.au>
 <20101230094230.GE2986@bitwizard.nl>
 <4D1C616D.8030904@hardwarefreak.com>
 <4D1C73D4.6050600@anonymous.org.uk>
 <4D1C851B.3040304@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1C851B.3040304@hardwarefreak.com>
References: <20101230082356.GC2986@bitwizard.nl>
 <4D1C470E.4080406@crc.id.au>
 <20101230094230.GE2986@bitwizard.nl>
 <4D1C616D.8030904@hardwarefreak.com>
 <4D1C73D4.6050600@anonymous.org.uk>
 <4D1C851B.3040304@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When I rebooted my server yesterday, not all the RAIDs came up. There were no errors in the system log. All devices appear to be working correctly. There is no evidence of  hardware errors or data corruption.

To prevent mdadm from failing RAID drives, I removed the RAID entries from /etc/mdadm.conf, and I have a cron script that does things like

mdadm -A --no-degraded /dev/md5 --uuid 291655c3:b6c334ff:8dfe69a4:447f777b
mdadm: /dev/md5 assembled from 2 drives (out of 4), but not started.

The question is, why did mdadm assemble only 2 drives, when all 4 drives appear to be fine?  The same problem occurred for 4 RAIDs, each with similar geometry, and using the same 4 physical drives.

Here is the status of all 4 partitions that should have been assembled into /dev/md5:

[root@l1 ~]# mdadm -E /dev/sda5
/dev/sda5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 291655c3:b6c334ff:8dfe69a4:447f777b
           Name : l1.fu-lab.com:5  (local to host l1.fu-lab.com)
  Creation Time : Thu Sep 23 13:41:31 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 957214849 (456.44 GiB 490.09 GB)
     Array Size : 2871641088 (1369.31 GiB 1470.28 GB)
  Used Dev Size : 957213696 (456.44 GiB 490.09 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4088b63f:68d66426:a2abd280:28476493

    Update Time : Wed Dec 22 08:27:57 2010
       Checksum : 48e371ac - correct
         Events : 339

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
[root@l1 ~]# mdadm -E /dev/sdi5
/dev/sdi5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 291655c3:b6c334ff:8dfe69a4:447f777b
           Name : l1.fu-lab.com:5  (local to host l1.fu-lab.com)
  Creation Time : Thu Sep 23 13:41:31 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 957214849 (456.44 GiB 490.09 GB)
     Array Size : 2871641088 (1369.31 GiB 1470.28 GB)
  Used Dev Size : 957213696 (456.44 GiB 490.09 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bfc9fe39:c3e40f6a:7418831b:87e08f16

    Update Time : Wed Dec 22 08:27:57 2010
       Checksum : a4b2c7b7 - correct
         Events : 339

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)
[root@l1 ~]# mdadm -E /dev/sdj5
/dev/sdj5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 291655c3:b6c334ff:8dfe69a4:447f777b
           Name : l1.fu-lab.com:5  (local to host l1.fu-lab.com)
  Creation Time : Thu Sep 23 13:41:31 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 957214849 (456.44 GiB 490.09 GB)
     Array Size : 2871641088 (1369.31 GiB 1470.28 GB)
  Used Dev Size : 957213696 (456.44 GiB 490.09 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3e1f7e30:730c70c0:c2770470:8e40ea84

    Update Time : Wed Dec 22 08:27:57 2010
       Checksum : b46e043d - correct
         Events : 339

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)
[root@l1 ~]# mdadm -E /dev/sdk5
/dev/sdk5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 291655c3:b6c334ff:8dfe69a4:447f777b
           Name : l1.fu-lab.com:5  (local to host l1.fu-lab.com)
  Creation Time : Thu Sep 23 13:41:31 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 957214849 (456.44 GiB 490.09 GB)
     Array Size : 2871641088 (1369.31 GiB 1470.28 GB)
  Used Dev Size : 957213696 (456.44 GiB 490.09 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5acc120a:e7197136:7d7a29c2:971e410d

    Update Time : Wed Dec 22 08:27:57 2010
       Checksum : de7f9f92 - correct
         Events : 339

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)


I could try assembling the RAID with other command syntaxes (such as by listing all the partitions/devices manually). However, I see no reason why this should be necessary.

Also,

mdadm -V
mdadm - v3.1.2 - 10th March 2010

What is going on?

Thanks!

Jim

