From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: quick Q re raid reconstruction
Date: Thu, 01 Dec 2005 22:53:13 +1100
Message-ID: <438EE429.2030903@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have (had) a 4 disk RAID5 /dev/sd[abcd]1.

sda went bad (really, bad sectors) and is being replaced, hope
to get a replacement tomorrow.

While the array was degraded (but running) sdd failed (controller
trouble) and was marked as failed. The array went down (naturally).
I am rather sure that sdd is healthy - see examine below.

Right now /dev/sd[bcd] are seen as sd[abc] until I install the
missing disk.

I wish to bring the array up (degraded). Whatever I do mdadm
refuses to do so
	mdadm --assemble --force /dev/sd{a,b,c}1
should it recognise the array as degraded but good and start it?

Q1) What is the correct command to bring these three up as
    degraded?

Q2) When I get the fourth disk, how do I bring the array up
    ensuring that the good disks (sd[bcd]) are marked as such
    and the fresh one (sda) is reconstructed (rather than one
    of the good ones).

In the past in cases where I trusted all four to be good (again,
controller trouble would fail multiple disks) I would just --build
on top of the array and a would not care which one is being
reconstructed.


I assume that the below data does not reflect modified superblocks
due to the attempted --force because the date reflects the failure
event.

# mdadm --examine /dev/sd*1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 54069710:f9f9ab5b:ae89479a:d7c1852e
  Creation Time : Tue Sep 13 00:42:04 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Nov 27 15:29:01 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 16d99bd5 - correct
         Events : 0.492477

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/.static/dev/sdb1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/.static/dev/sdb1
   2     2      22        1        2      active sync   /dev/.static/dev/hdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      faulty   /dev/.static/dev/sda1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 54069710:f9f9ab5b:ae89479a:d7c1852e
  Creation Time : Tue Sep 13 00:42:04 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Nov 27 15:29:01 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 16d99bd5 - correct
         Events : 0.492477

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     2      22        1        2      active sync   /dev/.static/dev/hdc1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/.static/dev/sdb1
   2     2      22        1        2      active sync   /dev/.static/dev/hdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      faulty   /dev/.static/dev/sda1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 54069710:f9f9ab5b:ae89479a:d7c1852e
  Creation Time : Tue Sep 13 00:42:04 2005
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Nov 27 15:29:01 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 16d99c17 - correct
         Events : 0.492477

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     5      22       65        5      spare   /dev/.static/dev/hdd1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/.static/dev/sdb1
   2     2      22        1        2      active sync   /dev/.static/dev/hdc1
   3     3       0        0        3      faulty removed
   4     4       8        1        4      faulty   /dev/.static/dev/sda1

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
