From: Ari Pollak <ari@debian.org>
Subject: Invalid argument when creating a RAID-0 array
Date: Sat, 14 Jun 2003 10:53:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EEB36DA.6050407@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[Please CC me on replies]

I am currently trying to create a RAID-0 array using 5 SCSI drives with 
raidtools2 on Debian but it is failing. Any input would be appreciated. 
When I run 'mkraid /dev/md0', I get the following:

$ sudo mkraid /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sdb1, 4190400kB, raid superblock at 4190336kB
disk 1: /dev/sdc1, 4190400kB, raid superblock at 4190336kB
disk 2: /dev/sdd1, 4190400kB, raid superblock at 4190336kB
disk 3: /dev/sde1, 4180722kB, raid superblock at 4180608kB
disk 4: /dev/sdf1, 4190400kB, raid superblock at 4190336kB
/dev/md0: Invalid argument

Doing an strace of it gives the following reason for the Invalid argument:

open("/dev/md0", O_RDWR)                = 4
ioctl(4, 0x800c0930, 0xeffff7d8)        = -1 EINVAL (Invalid argument)
dup(2)                                  = 5
nfssvc(0x5)                             = 2
fstat64(5, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 2), ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
= 0x7001e000
_llseek(5, 0, 0xeffff4a0, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
write(5, "/dev/md0: Invalid argument\n", 27/dev/md0: Invalid argument
) = 27


Contents of my /etc/raidtab:
raiddev /dev/md0
         raid-level      0
         nr-raid-disks   5
         persistent-superblock 1
         chunk-size     4
         device          /dev/sdb1
         raid-disk       0
         device          /dev/sdc1
         raid-disk       1
         device          /dev/sdd1
         raid-disk       2
         device          /dev/sde1
         raid-disk       3
         device          /dev/sdf1
         raid-disk       4


Contents of /proc/mdstat:
Personalities : [raid0]
read_ahead not set
unused devices: <none>

kernel messages after running mkraid:
md: bind<sdb1,1>
md: bind<sdc1,2>
md: bind<sdd1,3>
md: bind<sde1,4>
md: bind<sdf1,5>
md: sdf1's event counter: 00000000
md: sde1's event counter: 00000000
md: sdd1's event counter: 00000000
md: sdc1's event counter: 00000000
md: sdb1's event counter: 00000000
too small chunk_size: 4096 < 8192
md: md0 stopped.
md: unbind<sdf1,4>
md: export_rdev(sdf1)
md: unbind<sde1,3>
md: export_rdev(sde1)
md: unbind<sdd1,2>
md: export_rdev(sdd1)
md: unbind<sdc1,1>
md: export_rdev(sdc1)
md: unbind<sdb1,0>
md: export_rdev(sdb1)


