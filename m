From: Tim Small <tim@semantico.com>
Subject: Oops on 2.4.26 (rmap)
Date: Fri, 23 Jul 2004 11:16:57 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4100E599.7000602@semantico.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm running software raid5 and raid1 on 2.4.26, with four scsi disks, 
and got an Oops this morning whilst carrying out some operations prior 
to low-level formatting a SCSI drive.  The machine is a dual Xeon.  This 
box isn't in production yet, so please let me know if there are any 
test, or tweaks I can try...

Cheers,

Tim.

These are the commands [and state] in cronological order.

[md marks sda4 (member of md4) as failed, due to read/write error]
# dd if=/dev/sda4 of=/dev/null
[this completes with no errors]
# mdadm --manage /dev/md4 -r /dev/sda4
mdadm: hot removed /dev/sda4
# mdadm --manage /dev/md4 -a /dev/sda4
mdadm: hot added /dev/sda4
almond:root/# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md1 : active raid1 sdc1[2] sdb1[1] sda1[0]
      96256 blocks [3/3] [UUU]

md2 : active raid1 sdc2[2] sdb2[1] sda2[0]
      2931776 blocks [3/3] [UUU]

md3 : active raid5 sdc3[2] sdb3[1] sda3[0]
      5863552 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md4 : active raid5 sda4[3] sdc4[2] sdb4[1]
      131732864 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]
      [>....................]  recovery =  0.1% (80352/65866432) 
finish=27.2min speed=40176K/sec

[at this point I decide to low-level format the drive before putting it 
back into operation - so I fail the drive before the rebuild is complete]

almond:root/# mdadm --manage /dev/md4 -f /dev/sda4
mdadm: set /dev/sda4 faulty in /dev/md4
almond:root/# mdadm --manage /dev/md4 -r /dev/sda4
mdadm: hot removed /dev/sda4
[and take the drive out of the other md devices so that I can low-level 
format it]
almond:root/# for i in 1 2 3 ; do mdadm --manage /dev/md${i} -f 
/dev/sda${i} && mdadm --manage /dev/md${i} -r /dev/sda${i} ; done
mdadm: set /dev/sda1 faulty in /dev/md1
mdadm: hot removed /dev/sda1
mdadm: set /dev/sda2 faulty in /dev/md2
mdadm: hot removed /dev/sda2
mdadm: set /dev/sda3 faulty in /dev/md3
mdadm: hot removed /dev/sda3
[This is when the following oops happened - I've included a bit of the 
surrounding dmesg output]


Here is the RAID status at the end of the commands:

almond:root/# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md1 : active raid1 sdc1[2] sdb1[1]
      96256 blocks [3/2] [_UU]

md2 : active raid1 sdc2[2] sdb2[1]
      2931776 blocks [3/2] [_UU]

md3 : active raid5 sdc3[2] sdb3[1]
      5863552 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]

md4 : active raid5 sdc4[2] sdb4[1]
      131732864 blocks level 5, 64k chunk, algorithm 2 [3/2] [_UU]

unused devices: <none>



 disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
md: unbind<sda1,2>
md: export_rdev(sda1)
md: updating md1 RAID superblock on device
md: sdc1 [events: 0000005d]<6>(write) sdc1's sb offset: 96256
md: sdb1 [events: 0000005d]<6>(write) sdb1's sb offset: 96256
raid1: Disk failure on sda2, disabling device.
        Operation continuing on 2 devices
md: updating md2 RAID superblock on device
md: sdc2 [events: 0000005a]<6>(write) sdc2's sb offset: 2931776
md: sdb2 [events: 0000005a]<6>(write) sdb2's sb offset: 2931776
md: trying to remove sda2 from md2 ...
RAID1 conf printout:
 --- wd:2 rd:3 nd:3
 disk 0, s:0, o:0, n:0 rd:0 us:1 dev:sda2
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb2
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc2
 disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
RAID1 conf printout:
 --- wd:2 rd:3 nd:2
 disk 0, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb2
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc2
 disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
md: unbind<sda2,2>
md: export_rdev(sda2)
md: updating md2 RAID superblock on device
md: sdc2 [events: 0000005b]<6>(write) sdc2's sb offset: 2931776
md: <1>Unable to handle kernel NULL pointer dereference at virtual 
address 00000f90

md: <1>Unable to handle kernel NULL pointer dereference at virtual 
address 00000f90
c02f1cd1
*pde = 00000000
Oops: 0000
CPU:    1
EIP:    0010:[<c02f1cd1>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010202
eax: 00000f80   ebx: c2c64f80   ecx: c03e17d4   edx: 00000078
esi: c2c64f80   edi: c44aac94   ebp: c44aac80   esp: f775df60
ds: 0018   es: 0018   ss: 0018
Process raid1d (pid: 16, stackpage=f775d000)
Stack: c03bf75c 0000005a 00000000 00000064 00000000 c44aac80 c466cb00 
f775dfd0
       c466cb08 c02e919c c44aac80 c44ba03c c03df3e0 f775c000 0000001b 
c44aac80
       f775c000 c466cb00 f775dfd0 c466cb08 c02f4d30 c465f000 c03bf4f2 
c0435fd0
Call Trace:    [<c02e919c>] [<c02f4d30>] [<c010582e>] [<c02f4c00>]
Code: f6 40 10 01 0f 85 9c 00 00 00 0f b7 43 18 89 04 24 e8 99 e8


 >>EIP; c02f1cd1 <md_update_sb+f1/240>   <=====

 >>ebx; c2c64f80 <_end+278edd4/38498eb4>
 >>ecx; c03e17d4 <console_sem+0/14>
 >>esi; c2c64f80 <_end+278edd4/38498eb4>
 >>edi; c44aac94 <_end+3fd4ae8/38498eb4>
 >>ebp; c44aac80 <_end+3fd4ad4/38498eb4>
 >>esp; f775df60 <_end+37287db4/38498eb4>

Trace; c02e919c <raid1d+35c/370>
Trace; c02f4d30 <md_thread+130/1c0>
Trace; c010582e <arch_kernel_thread+2e/40>
Trace; c02f4c00 <md_thread+0/1c0>

Code;  c02f1cd1 <md_update_sb+f1/240>
00000000 <_EIP>:
Code;  c02f1cd1 <md_update_sb+f1/240>   <=====
   0:   f6 40 10 01               testb  $0x1,0x10(%eax)   <=====
Code;  c02f1cd5 <md_update_sb+f5/240>
   4:   0f 85 9c 00 00 00         jne    a6 <_EIP+0xa6>
Code;  c02f1cdb <md_update_sb+fb/240>
   a:   0f b7 43 18               movzwl 0x18(%ebx),%eax
Code;  c02f1cdf <md_update_sb+ff/240>
   e:   89 04 24                  mov    %eax,(%esp,1)
Code;  c02f1ce2 <md_update_sb+102/240>
  11:   e8 99 e8 00 00            call   e8af <_EIP+0xe8af>
raid5: Disk failure on sda3, disabling device. Operation continuing on 2 
devices
md: updating md3 RAID superblock on device
md: sdc3 [events: 0000005d]<6>(write) sdc3's sb offset: 2931776
md: sdb3 [events: 0000005d]<6>(write) sdb3's sb offset: 2931776
md: (skipping faulty sda3 )
md: trying to remove sda3 from md3 ...
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:0, n:0 rd:0 us:1 dev:sda3
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb3
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc3
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb3
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc3
md: unbind<sda3,2>
md: export_rdev(sda3)
md: updating md3 RAID superblock on device
md: sdc3 [events: 0000005e]<6>(write) sdc3's sb offset: 2931776
md: sdb3 [events: 0000005e]<6>(write) sdb3's sb offset: 2931776
md1: no spare disk to reconstruct array! -- continuing in degraded mode
md2: no spare disk to reconstruct array! -- continuing in degraded mode
md3: no spare disk to reconstruct array! -- continuing in degraded mode
md4: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: recovery thread got woken up ...
md1: no spare disk to reconstruct array! -- continuing in degraded mode
md2: no spare disk to reconstruct array! -- continuing in degraded mode
md3: no spare disk to reconstruct array! -- continuing in degraded mode
md4: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...

