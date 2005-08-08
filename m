From: Claas Hilbrecht <claas+maillinglists.linux-raid@jucs-kramkiste.de>
Subject: How to recover a multiple raid5 disk failure with mdadm?
Date: Mon, 08 Aug 2005 09:18:27 +0200
Message-ID: <D3BE8E19A516A6F7F3B10332@[192.168.1.22]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm running a 4 disk software raid5 array with linux 2.6.12.1. Each disk is 
a 80 GB IDE master disk on a single used IDE bus (no slave drives). So far 
the array runs great but a few weeks ago one disk (hdk) in the array 
failed. After looking at the connectors I refit the connector to the drive 
(it seems to be a weak connection). The resync begin as the system is 
rebooted. But in the middle off the resync a second drive (hdg) had a 
problem. There are a couple of block unreadable *sick*. The array went down 
and it seems that all data is lost. This is not a real problem since the 
array is only used for a personal VDR.

But I thought this would be a good time to start to fiddle with the raid to 
see if there is a chance to rescue some data. I first start making a backup 
of each drive with "dd if=/dev/hde | gzip -1 > hde.gz". After googling 
around for I while I found 
<http://www.tldp.org/HOWTO/Software-RAID-HOWTO-8.html#ss8.1> but the 
instructions there won't work. I even tried to recreate the array as 
suggested on different mailling list. The last try I've done used 
mdadm-2.0-devel-2 with the patch from 14.07.2005 
(<http://www.opensubscriber.com/message/linux-raid@vger.kernel.org/1737664.html>) 
from this mailling list. Sometimes I was able to recreate the array but if 
I try to mount the array it seems that there is no valid ext3 filesystem 
within.

So here is the list of events that caused the raid failure:

1) hdk went down due to a connector problem.
2) power off machine and refit connector.
3) power on and resync starts
4) hdg fails with some unreadble sectors (as according to kern.log)
5) md0 went down.

Is there anything else I can do to rescue the data? I assume you need more 
"input" but I don't think its a good idea to post even more logs in the 
list, so please ask if something is missing.

The output below is from mdadm-2.0-devel-2 examine. What I don't understand 
is that there is difference in the "Spare Devices".

---***---
/dev/hde1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 89d60b87:f4132b59:c073bd02:53de0ef9
  Creation Time : Tue Dec 28 12:24:48 2004
     Raid Level : raid5
    Device Size : 80043136 (76.34 GiB 81.96 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sat Jul 23 20:23:19 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : c5646fe8 - expected c6586ef4
         Events : 0.4340017

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3      33        1        3      active sync   /dev/hde1

   0     0       0        0    524288      spare
   1 3670016   65536    65536    393216      spare
   2     0       0    131072    589824      spare
   3 2162688   65536    196608    393216      spare
   4 3735552   65536    262144        0      spare
---***---

---***---
/dev/hdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7b631138:ca5ac82b:95f1b9df:25e26bff
  Creation Time : Fri Aug  5 11:55:02 2005
     Raid Level : raid5
    Device Size : 80043136 (76.34 GiB 81.96 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Aug  5 11:55:02 2005
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 35699ae6 - correct
         Events : 0.1

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1      34        1        1      active sync   /dev/hdg1

   0     0      33        1        0      active sync   /dev/hde1
   1     1      34        1        1      active sync   /dev/hdg1
   2     2      56        1        2      active sync   /dev/hdi1
   3     3       0        0        3      faulty
---***---
/dev/hdi1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 89d60b87:f4132b59:c073bd02:53de0ef9
  Creation Time : Tue Dec 28 12:24:48 2004
     Raid Level : raid5
    Device Size : 80043136 (76.34 GiB 81.96 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sat Jul 23 20:23:19 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : c564701b - correct
         Events : 0.4340017

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1      56        1        1      active sync   /dev/hdi1

   0     0       0        0        0      removed
   1     1      56        1        1      active sync   /dev/hdi1
   2     2      34        1        2      active sync   /dev/hdg1
   3     3      33        1        3      active sync   /dev/hde1
   4     4      57        1        4      spare   /dev/hdk1
---***---

---***---
/dev/hdk1:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 89d60b87:f4132b59:c073bd02:53de0ef9
  Creation Time : Tue Dec 28 12:24:48 2004
     Raid Level : raid5
    Device Size : 80043136 (76.34 GiB 81.96 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sat Jul 23 20:23:19 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : c5646ffc - correct
         Events : 0.4340017

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     4      57        1        4      spare   /dev/hdk1

   0     0       0        0        0      removed
   1     1      56        1        1      active sync   /dev/hdi1
   2     2       0        0        2      faulty removed
   3     3      33        1        3      active sync   /dev/hde1
   4     4      57        1        4      spare   /dev/hdk1
---***---

-- 
 Claas Hilbrecht
 http://www.jucs-kramkiste.de

