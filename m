From: Loic Prylli <loic.prylli@ens-lyon.fr>
Subject: systematic oops on disk failure with raid1 on SMP/serial-console
Date: Tue, 10 Jun 2003 21:30:21 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030610193021.GA2665@ens-lyon.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

After installing raid1 support, I have tried using raidsetfaulty to see what
will happen, and I got an oops, details of dmesg and ksymoops are at the
end. This is on 2.4.20.

The race causing the oops seems to only happen when using a serial console
for me, (to reproduce eventually add "console=ttyS[01] console=tty0" on your
boot line), and it probably also happen only on SMP (did not test UP).

It looks like an old problem related to a race in setting rdev->faulty after
reading it in md_update_sb called by the raid1d thread (woken by
raid1_error), but rdev->sb has already been freed when being accessed. The
problem seems to hve occured several times on the mailing-list:

http://marc.theaimsgroup.com/?l=linux-raid&m=105240743922448&w=2

http://marc.theaimsgroup.com/?l=linux-raid&m=103484083325406&w=2

There is an more than one year old analysis of the problem with a proposal
of a patch, not sure if there has been any modification since, or if it is a
different instance of the race:

http://marc.theaimsgroup.com/?l=linux-raid&m=101252481423282&w=2
Analysis:
http://marc.theaimsgroup.com/?l=linux-raid&m=101405686718917&w=2
Patch:
http://marc.theaimsgroup.com/?l=linux-raid&m=101405687018967&w=2


Here is my own fix to avoid this problem in a way that does not depend of
the raid level, altough more work seems needed to clean the ->faulty
handling.


--- 1.33/drivers/md/md.c	Tue Aug  6 16:42:18 2002
+++ edited/drivers/md/md.c	Tue Jun 10 21:04:30 2003
@@ -1034,13 +1034,13 @@
 	err = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		printk(KERN_INFO "md: ");
-		if (rdev->faulty)
+		if (rdev->faulty || disk_faulty(rdev->mddev->sb->disks + rdev->desc_nr))
 			printk("(skipping faulty ");
 		if (rdev->alias_device)
 			printk("(skipping alias ");
 
 		printk("%s ", partition_name(rdev->dev));
-		if (!rdev->faulty && !rdev->alias_device) {
+		if (!rdev->faulty && !rdev->alias_device && !disk_faulty(rdev->mddev->sb->disks + rdev->desc_nr)) {
 			printk("[events: %08lx]",
 				(unsigned long)rdev->sb->events_lo);
 			err += write_disk_sb(rdev);

Loic

PS: the oops details

md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000 KB/sec) for reconstruction.
md: using 124k window, over a total of 10223616 blocks.
raid1: Disk failure on scsi/host1/bus0/target2/lun0/part3, disabling device. 
	Operation continuing on 1 devices
md: updating md0 RAID superblock on device
md: scsi/host1/bus0/target2/lun0/part3 [events: 00000024]<6>(write) scsi/host1/bus0/target2/lun0/part3's sb offset: 10225280
Unable to handle kernel NULL pointer dereference<6>md: md_do_sync() got signal ... exiting
 at virtual address 00000000
 printing eip:
f88b2440
*pde = 00104001
*pte = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<f88b2440>]    Tainted: P 
EFLAGS: 00010246
eax: f7336400   ebx: 00000823   ecx: 00000400   edx: f71d3480
esi: 00000000   edi: f6fd1000   ebp: f6fc3f3c   esp: f6fc3f28
ds: 0018   es: 0018   ss: 0018
Process raid1d (pid: 592, stackpage=f6fc3000)
Stack: f71d3480 f71d3500 f7673480 00000000 f7336400 f6fc3f68 f88b2711 f71d3480 
       f88b723f 00000024 f7673480 f6fc3fd8 f6fc3fec f7673494 00000064 00000000 
       f6fc3f9c f9b2f9f1 f7673480 f6fc2000 f6fc3fd8 f6fc3fec f6fc3f9c c011ec6c 
Call Trace:    [<f88b2711>] [<f88b723f>] [<f9b2f9f1>] [<c011ec6c>] [<f88b5372>]
  [<c01073c8>]

Code: f3 a5 8b 45 fc 8b 4d f8 f0 0f ab 48 18 8b 45 fc e8 fb c5 88 
 
ksymmops give:

Trace; f88b2711 <[md]md_update_sb+165/1cc>
Trace; f88b723f <[md].rodata.start+8df/20df>
Trace; f9b2f9f1 <[raid1]raid1d+1d/470>
Trace; c011ec6c <__run_task_queue+60/13c>
Trace; f88b5372 <[md]md_thread+15e/1c8>
Trace; c01073c8 <kernel_thread+28/1d4>

Code;  f88b2440 <[md]write_disk_sb+164/1c0>
00000000 <_EIP>:
Code;  f88b2440 <[md]write_disk_sb+164/1c0>   <=====
   0:   f3 a5                     repz movsl %ds:(%esi),%es:(%edi)   <=====
Code;  f88b2442 <[md]write_disk_sb+166/1c0>
   2:   8b 45 fc                  mov    0xfffffffc(%ebp),%eax
Code;  f88b2445 <[md]write_disk_sb+169/1c0>
   5:   8b 4d f8                  mov    0xfffffff8(%ebp),%ecx
Code;  f88b2448 <[md]write_disk_sb+16c/1c0>
   8:   f0 0f ab 48 18            lock bts %ecx,0x18(%eax)
Code;  f88b244d <[md]write_disk_sb+171/1c0>
   d:   8b 45 fc                  mov    0xfffffffc(%ebp),%eax
Code;  f88b2450 <[md]write_disk_sb+174/1c0>
  10:   e8 fb c5 88 00            call   88c610 <_EIP+0x88c610> f913ea50 <[gm].bss.end+70a931/10f9ee1>



