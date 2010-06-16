From: aragonx@dcsnow.com
Subject: How to boost performance
Date: Wed, 16 Jun 2010 18:23:36 -0400
Message-ID: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I have a software RAID on my server that I would like to get better
performance out of.  I routinely copy large files and/or groups of files
to and from this array over the network.  When I start, I get a reasonable
xfer rate of about 50MB/sec.  It gradually drops to around 20MB/sec after
say 1GB of data.  When looking on the server, the CPU usage is usually at
100% with md0_raid5 usually at the top of the hit list with flush being
right behind it.  Perhaps 30 - 40% of CPU time is spent on waits (this is
from memory though.  If is the critical piece of information, I'll get a
real number).

Before I start spewing server information, my question is this.  Is there
anything I can tweak to improve my performance?  It seems that the server
is CPU bound when I am transferring large amounts of data to or from it. 
Any suggestions will be considered.  Faster processor, switching to RAID
0, etc.  I'm hoping there is something I can do with the RAID software
though.  Maybe a different chunk size or different algorithm?

Now to the information:

# hdparm -t /dev/md0

/dev/md0:
 Timing buffered disk reads:  954 MB in  3.00 seconds = 317.83 MB/sec

# uname -a
Linux homeserv.local 2.6.32.11-99.fc12.x86_64 #1 SMP Mon Apr 5 19:59:38
UTC 2010 x86_64 x86_64 x86_64 GNU/Linux

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdf1[0] sdg1[4] sdd1[3] sdc1[2] sdb1[1]
      2930287616 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

# df -h /dev/md0
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              2.7T  724G  1.9T  28% /home/data

# free
             total       used       free     shared    buffers     cached
Mem:       8194940    5483640    2711300          0     171392    3131220
-/+ buffers/cache:    2181028    6013912
Swap:      4096532      50108    4046424

# mdadm -D /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Mon Jan 25 16:14:08 2010
     Raid Level : raid5
     Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
  Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jun 16 17:55:14 2010
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 18928390:76024ba7:d9fdb3bf:6408b6d2 (local to host
homeserv.local)
         Events : 0.54506

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       97        4      active sync   /dev/sdg1


# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 67
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 3
cpu MHz         : 3000.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good extd_apicid pni cx16 lahf_lm cmp_legacy
svm extapic cr8_legacy
bogomips        : 5999.16
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 67
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
stepping        : 3
cpu MHz         : 3000.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow rep_good extd_apicid pni cx16 lahf_lm cmp_legacy
svm extapic cr8_legacy
bogomips        : 5999.62
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

# dmidecode
Handle 0x003C, DMI type 17, 27 bytes
Memory Device
        Array Handle: 0x003A
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 72 bits
        Size: 2048 MB
        Form Factor: DIMM
        Set: None
        Locator: DIMM0
        Bank Locator: BANK0
        Type: DDR2
        Type Detail: Synchronous
        Speed: 400 MHz
        Manufacturer: Manufacturer00
        Serial Number: SerNum00
        Asset Tag: AssetTagNum0
        Part Number: ModulePartNumber00

---
Will Y.



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

