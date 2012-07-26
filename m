From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: RAID10 Performance
Date: Fri, 27 Jul 2012 00:16:03 +1000
Message-ID: <50115123.1020900@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I've got a system with the following config that I am trying to improve
performance on. Hopefully you can help guide me in the best direction
please.

1 x SSD (OS drive only)
3 x 2TB WDC WD2003FYYS-02W0B1

The three HDD's are configured in a single RAID10 (I configured as
RAID10 to easily support adding additional drives later, I realise/hope
it is currently equivalent to RAID1)
md0 : active raid10 sdb1[0] sdd1[2](S) sdc1[1]
      1953511936 blocks super 1.2 2 near-copies [2/2] [UU]

Which is then shared with DRBD to another identical system.
Then LVM is used to carve the redundant storage into virtual disks
Finally, iSCSI is used to export the virtual disks to the various
virtual machines running on other physical boxes.

When a single VM is accessing data, performance is more than acceptable
(max around 110M/s as reported by dd)

The two SAN machines have 1 Gb ethernet crossover between them, and 4 x
Gb bonded to the switch which connects to the physical machines running
the VM's (which have only a single Gb connection).

The issue is poor performance when more than one machine attempts to do
disk intensive activity at the same time (ie, when the anti virus scan
starts on all VM's at the same time, or during the backup window, etc).

During these times, performance can drop to 5M/s (reported by dd, or
calculated timings from windows VM etc). I'd like to:
a) improve overall performance when multiple VM's are r/w data to the drives
b) Hopefully set a minimum performance level for each VM (so one VM
can't starve the others).

I have adjusted some drbd related values, and significantly improved
performance there, not to say it is perfect yet).
I am currently using the deadline scheduler on the HDD's, but this
doesn't make much difference.
I have manually balanced IRQ's across the available CPU's (two bonded
ethernet on one, two bonded ethernet on second, SATA on third, and the
rest of the IRQ's on the fourth, it is a quad core CPU).

If I add the third (hot spare) disk into the RAID10 array, could I get
1.5x the total storage capacity, and improve performance by approx 30%?
If I add another two disks (on each server) could I extend the array to
2x total storage capacity, double performance, and still keep the hot spare?
If I add the third (hot spare) disk into the RAID10 array, could I get
1x the total storage capacity (ie, 3 disk RAID1) and improve read
performance?

Is there some other details I should provide, or knobs that I can tweak
to get better performance?

Additional data:
mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Mon Jun  4 23:31:20 2012
     Raid Level : raid10
     Array Size : 1953511936 (1863.01 GiB 2000.40 GB)
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
   Raid Devices : 2
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Fri Jul 27 00:07:21 2012
          State : active
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : near=2
     Chunk Size : 512K

           Name : san2:0  (local to host san2)
           UUID : b402c62b:2ae7eca3:89422456:2cd7c6f3
         Events : 82

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1

       2       8       49        -      spare   /dev/sdd1

cat /proc/drbd
version: 8.3.7 (api:88/proto:86-91)
srcversion: EE47D8BF18AC166BE219757
 0: cs:Connected ro:Primary/Secondary ds:UpToDate/UpToDate C r----
    ns:295435862 nr:0 dw:298389532 dr:1582870916 al:10877089 bm:53752
lo:2 pe:0 ua:0 ap:1 ep:1 wo:b oos:0

Running debian stable 2.6.32-5-amd64

top - 00:10:57 up 20 days, 18:41,  1 user,  load average: 0.25, 0.50, 0.61
Tasks: 340 total,   1 running, 339 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.1%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.0%hi,  0.0%si, 
0.0%st
Mem:   7903292k total,  7702696k used,   200596k free,  5871076k buffers
Swap:  3939320k total,        0k used,  3939320k free,  1266756k cached

(Note, CPU load peaks up to 12 during heavy IO load periods)

Thank you for any advice or assistance you can provide.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

