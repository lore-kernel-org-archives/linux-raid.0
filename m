From: Christian Schmidt <charlie@digadd.de>
Subject: What exactly does echo check > /sys/block/mdX/md/sync_action do?
Date: Sun, 09 Jan 2011 23:48:05 +0100
Message-ID: <4D2A3B25.6050504@digadd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

As the subject says, I'm wondering what issuing the "check" command to a
raid array does.
The wiki says it starts a full read of the raid array. However I wonder
if all members, especially the parts of the drives containing the
redundancy information, will be read, and possibly the validity of the
redundancy data will be checked?

A possibly related question is: why did this member turn into "spare"
role? The system was fully functional and in daily use for about a year.
It was declared to be a four drive raid 5 with no spares. If I remember
level 5 correctly there is no single drive for the redundancy data to
avoid bottlenecks, right?

alpha md # mdadm --examine --verbose /dev/sdh2
/dev/sdh2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa8fb033:6312742f:0524501d:5aa24a28
           Name : sysresccd:1
  Creation Time : Sat Jul 17 02:57:27 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
     Array Size : 11714780160 (5586.04 GiB 5997.97 GB)
  Used Dev Size : 3904926720 (1862.01 GiB 1999.32 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 172eb49b:03e62242:614d7ed3:1fb25f65

    Update Time : Sun Jan  9 19:55:09 2011
       Checksum : a991f168 - correct
         Events : 34

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAA ('A' == active, '.' == missing)

Too bad that 1.2 superblocks don't contain the full array information
like 0.90 did.

Regards,
Christian
