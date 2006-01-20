From: Mario =?UTF-8?B?RMO2cmluZw==?= <mario@dedenet.de>
Subject: array broken or mdadm issue?
Date: Fri, 20 Jan 2006 11:09:05 +0100
Message-ID: <20060120110905.44c505c5@snibbles.dedenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello :)

The command "mdadm -Q /dev/md0" returns the following:

/dev/md0: 228.34GiB raid10 4 devices, 0 spares. Use mdadm --detail for
more detail.
/dev/md0: device 0 in 2 device undetected raid0 /dev/.tmp.md4.  Use
mdadm --examine for more detail.


What is /dev/.tmp.md4 ?
If I delete it and rerun the command above, it gets created again.


Here is some additional info:

# mdadm -Q /dev/md1
/dev/md1: 95.88MiB raid1 4 devices, 0 spares. Use mdadm --detail for
more detail.



# mdadm -Q /dev/.tmp.md4
/dev/.tmp.md4: is an md device which is not active



# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10]
md1 : active raid1 hdh1[3] hdg1[2] hdf1[1] hde1[0]
      98176 blocks [4/4] [UUUU]

md0 : active raid10 hdh3[3] hdg3[2] hdf3[1] hde3[0]
      239436160 blocks 64K chunks 2 near-copies [4/4] [UUUU]

unused devices: <none>



# mdadm --misc --examine /dev/md0
/dev/md0:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a6f921c5:84cf1916:4981aad5:dd540810
  Creation Time : Sun Oct 30 20:33:07 2005
     Raid Level : raid0
    Device Size : 0
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 4

    Update Time : Sun Oct 30 20:33:07 2005
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 82947d3c - correct
         Events : 0.1

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       9        0        0      active sync   /dev/md/0

   0     0       9        0        0      active sync   /dev/md/0
   1     1       9        1        1      active sync   /dev/md/1



Should I be concerned about that? :)
What does it mean anyways? And which device is undetected?

And why does "mdadm --misc --examine /dev/md0" prints "raid level:
raid0" even though it is a raid10?

I use mdadm-2.1, but have tried mdadm-2.2 as well.

Thanks in advance for any help.

Bye,
Mario.

