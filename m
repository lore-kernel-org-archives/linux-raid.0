From: Leon Woestenberg <leonw@mailcan.com>
Subject: raid5d oopses during hot-removal of disk (2.4.27)
Date: Fri, 10 Dec 2004 14:59:03 +0100
Message-ID: <1102687143.3987.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-63kHIDukvirynwSqNAud"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-63kHIDukvirynwSqNAud
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello all,

I am experiencing kernel "oops" errors in raid5d.

This is on a Linux 2.4.27 kernel, running RAID-5 across 4 SATA drives
using the Marvell Linux driver (not libata) which acts as a SCSI host.

The oopses occur when a disk is physically hot-removed from the system
and Software RAID finds the disk failed.

I have analyzed the error to occur inside a ITERATE_RDEV loop in
md_update_sb() in the drivers/md/md.c code.

Please note that concurrent to the Software RAID-5 marking the
disk as failed, another process is performing a
"scsi-remove-single-device" action.

I am suspecting that this *might* trigger the fault, but I have not
been able to confirm this. However, I hate guessing here.

I have included the oops, together with a text file in which I
described the steps (ksymoops et al) taken so far to pin-point
the occurence.

Could someone more knowledgeable about md/raid look at this pls,
and tell me how to proceed?

Regards,

Leon Woestenberg.







--=-63kHIDukvirynwSqNAud
Content-Disposition: attachment; filename=hot_removal_raid5d_oops.txt
Content-Type: text/plain; name=hot_removal_raid5d_oops.txt; charset=
Content-Transfer-Encoding: 7bit

Nov 29 17:02:07 localhost kernel: MV88SX50XX [0,1]: device disconnected
Nov 29 17:02:07 localhost kernel: MV88SX50XX [0,1]: channel removed
Nov 29 17:02:07 localhost kernel: MV88SX50XX [0,1]: channel removed
Nov 29 17:02:08 localhost raidman[27949]: marvell.c[233]: Disk 1 with SCSI ID 1 was hot-removed 
Nov 29 17:02:08 localhost raidman[27949]: raidman.c[308]: disk 1 (/dev/sdb) is being removed from the array. 
Nov 29 17:02:08 localhost kernel: raid5: Disk failure on sdb1, disabling device. Operation continuing on 3 devices
Nov 29 17:02:08 localhost kernel: raid5: Disk failure on sdb1, disabling device. Operation continuing on 3 devices
Nov 29 17:02:08 localhost kernel: md: updating md1 RAID superblock on device
Nov 29 17:02:08 localhost kernel: md: updating md1 RAID superblock on device
Nov 29 17:02:08 localhost kernel: md: sdd1 [events: 00000003]<6>(write) sdd1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel: md: sdd1 [events: 00000003]<6>(write) sdd1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel: md: sdc1 [events: 00000003]<6>(write) sdc1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel: md: sdc1 [events: 00000003]<6>(write) sdc1's sb offset: 117186048
Nov 29 17:02:08 localhost raidman[27949]: raidman.c[1247]: /dev/sdb1 marked faulty. 
Nov 29 17:02:08 localhost kernel: md: trying to remove sdb1 from md1 ... 
Nov 29 17:02:08 localhost kernel: md: trying to remove sdb1 from md1 ... 
Nov 29 17:02:08 localhost kernel: RAID5 conf printout:
Nov 29 17:02:08 localhost kernel: RAID5 conf printout:
Nov 29 17:02:08 localhost kernel:  --- rd:4 wd:3 fd:1
Nov 29 17:02:08 localhost kernel:  --- rd:4 wd:3 fd:1
Nov 29 17:02:08 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 29 17:02:08 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 29 17:02:08 localhost kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:sdb1
Nov 29 17:02:08 localhost kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:sdb1
Nov 29 17:02:08 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
Nov 29 17:02:08 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
Nov 29 17:02:08 localhost raidman[27949]: marvell.c[375]: scsi remove-single-device 0 1 1 0 
Nov 29 17:02:08 localhost kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
Nov 29 17:02:08 localhost kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
Nov 29 17:02:08 localhost kernel: RAID5 conf printout:
Nov 29 17:02:08 localhost kernel: RAID5 conf printout:
Nov 29 17:02:08 localhost kernel:  --- rd:4 wd:3 fd:1
Nov 29 17:02:08 localhost kernel:  --- rd:4 wd:3 fd:1
Nov 29 17:02:08 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 29 17:02:08 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 29 17:02:08 localhost kernel:  disk 1, s:0, o:0, n:1 rd:1 us:0 dev:[dev 00:00]
Nov 29 17:02:08 localhost kernel:  disk 1, s:0, o:0, n:1 rd:1 us:0 dev:[dev 00:00]
Nov 29 17:02:08 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
Nov 29 17:02:08 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
Nov 29 17:02:08 localhost kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
Nov 29 17:02:08 localhost kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
Nov 29 17:02:08 localhost kernel: md: unbind<sdb1,3>
Nov 29 17:02:08 localhost kernel: md: unbind<sdb1,3>
Nov 29 17:02:08 localhost kernel: md: export_rdev(sdb1)
Nov 29 17:02:08 localhost kernel: md: export_rdev(sdb1)
Nov 29 17:02:08 localhost kernel: md: updating md1 RAID superblock on device
Nov 29 17:02:08 localhost kernel: md: updating md1 RAID superblock on device
Nov 29 17:02:08 localhost kernel: md: sdd1 [events: 00000004]<6>(write) sdd1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel: md: sdd1 [events: 00000004]<6>(write) sdd1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel: md: (skipping faulty (skipping alias [dev 00:00] )
Nov 29 17:02:08 localhost kernel: md: (skipping faulty (skipping alias [dev 00:00] )
Nov 29 17:02:08 localhost kernel: Unable to handle kernel paging request at virtual address f80d002e
Nov 29 17:02:08 localhost kernel: Unable to handle kernel paging request at virtual address f80d002e
Nov 29 17:02:08 localhost kernel:  printing eip:
Nov 29 17:02:08 localhost kernel:  printing eip:
Nov 29 17:02:08 localhost kernel: c029a3b5
Nov 29 17:02:08 localhost kernel: c029a3b5
Nov 29 17:02:08 localhost kernel: *pde = 00000000
Nov 29 17:02:08 localhost kernel: *pde = 00000000
Nov 29 17:02:08 localhost kernel: Oops: 0000
Nov 29 17:02:08 localhost kernel: Oops: 0000
Nov 29 17:02:08 localhost kernel: CPU:    0
Nov 29 17:02:08 localhost kernel: CPU:    0
Nov 29 17:02:08 localhost kernel: EIP:    0010:[<c029a3b5>]    Not tainted
Nov 29 17:02:08 localhost kernel: EIP:    0010:[<c029a3b5>]    Not tainted
Nov 29 17:02:08 localhost kernel: EFLAGS: 00010282
Nov 29 17:02:08 localhost kernel: EFLAGS: 00010282
Nov 29 17:02:08 localhost kernel: eax: 00000002   ebx: df82e058   ecx: 00000001   edx: c0373138
Nov 29 17:02:08 localhost kernel: eax: 00000002   ebx: df82e058   ecx: 00000001   edx: c0373138
Nov 29 17:02:08 localhost kernel: esi: f80d002a   edi: d84b3098   ebp: d3d2ff6c   esp: d3d2ff4c
Nov 29 17:02:08 localhost kernel: esi: f80d002a   edi: d84b3098   ebp: d3d2ff6c   esp: d3d2ff4c
Nov 29 17:02:08 localhost kernel: ds: 0018   es: 0018   ss: 0018
Nov 29 17:02:08 localhost kernel: ds: 0018   es: 0018   ss: 0018
Nov 29 17:02:08 localhost kernel: Process raid5d (pid: 27988, stackpage=d3d2f000)
Nov 29 17:02:08 localhost kernel: Process raid5d (pid: 27988, stackpage=d3d2f000)
Nov 29 17:02:08 localhost kernel: Stack: c0351aa5 dae473b6 00000296 00000064 00000000 d3d2e65c db26f400 d3d2e000 
Nov 29 17:02:08 localhost kernel: Stack: c0351aa5 dae473b6 00000296 00000064 00000000 d3d2e65c db26f400 d3d2e000 
Nov 29 17:02:08 localhost kernel:        d3d2ff9c e08af2be d84b3084 dfdbc81c 00000282 db26f760 dfdbc87c 00000000 
Nov 29 17:02:08 localhost kernel:        d3d2ff9c e08af2be d84b3084 dfdbc81c 00000282 db26f760 dfdbc87c 00000000 
Nov 29 17:02:08 localhost kernel:        00000018 d3d2e65c d4426a04 d3d2e000 d3d2ffec c029d59e db26f400 e08b0830 
Nov 29 17:02:08 localhost kernel:        00000018 d3d2e65c d4426a04 d3d2e000 d3d2ffec c029d59e db26f400 e08b0830 
Nov 29 17:02:08 localhost kernel: Call Trace:    [<e08af2be>] [<c029d59e>] [<e08b0830>] [<c010771e>] [<c029d3f0>]
Nov 29 17:02:08 localhost kernel: Call Trace:    [<e08af2be>] [<c029d59e>] [<e08b0830>] [<c010771e>] [<c029d3f0>]
Nov 29 17:02:08 localhost kernel: 
Nov 29 17:02:08 localhost kernel: 
Nov 29 17:02:08 localhost kernel: Code: 39 7e 04 75 86 8b 5d f0 85 db 74 22 ff 4d ec 74 11 c7 04 24 
Nov 29 17:02:08 localhost kernel: Code: 39 7e 04 75 86 8b 5d f0 85 db 74 22 ff 4d ec 74 11 c7 04 24 
Nov 29 17:02:08 localhost kernel:  <6>md: sdc1 [events: 00000004]<6>(write) sdc1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel:  <6>md: sdc1 [events: 00000004]<6>(write) sdc1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel: md: recovery thread got woken up ...
Nov 29 17:02:08 localhost kernel: md: recovery thread got woken up ...
Nov 29 17:02:08 localhost kernel: md1: no spare disk to reconstruct array! -- continuing in degraded mode
Nov 29 17:02:08 localhost kernel: md1: no spare disk to reconstruct array! -- continuing in degraded mode
Nov 29 17:02:08 localhost kernel: md: recovery thread finished ...
Nov 29 17:02:08 localhost kernel: md: recovery thread finished ...
Nov 29 17:02:08 localhost kernel: md: sda1 [events: 00000004]<6>(write) sda1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel: md: sda1 [events: 00000004]<6>(write) sda1's sb offset: 117186048

--=-63kHIDukvirynwSqNAud
Content-Disposition: attachment; filename=kernel_raid5d_crash_analysis.txt
Content-Type: text/plain; name=kernel_raid5d_crash_analysis.txt; charset=
Content-Transfer-Encoding: 7bit

Linux "raid5d" crash analysis

1-12-2004  Leon Woestenberg <leon.woestenberg@axon.nl>

This is an analysis of the failure of the "raid5d" component.

Two crashes are known, and their failure (or "oops") kernel
messages have been captured. They occur on disk hot removal.

** at the time of writing, the last oops occured in the current
compiled instance of the kernel **

** this analysis discusses the second (currently last) crash **

The crashes are alike.

Unable to handle kernel paging request at virtual address f80d002e

register eip points to c029a3b5

From the System.map file:

  c029a1d0 t sync_sbs
  c029a270 T md_update_sb
  c029a4c0 t md_import_device

so we can deduce it occured inside the md_update_sb() function. This
corresponds with the kernel messages surrounding the "oops".

----------------------------------------------------------------------------------------------------
Nov 29 17:02:08 localhost kernel: md: sdd1 [events: 00000004]<6>(write) sdd1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel: md: (skipping faulty (skipping alias [dev 00:00] )
----------------------------------------------------------------------------------------------------
Nov 29 17:02:08 localhost kernel: Unable to handle kernel paging request at virtual address f80d002e
Nov 29 17:02:08 localhost kernel: Unable to handle kernel paging request at virtual address f80d002e
Nov 29 17:02:08 localhost kernel:  printing eip:
Nov 29 17:02:08 localhost kernel:  printing eip:
Nov 29 17:02:08 localhost kernel: c029a3b5
Nov 29 17:02:08 localhost kernel: c029a3b5
Nov 29 17:02:08 localhost kernel: *pde = 00000000
Nov 29 17:02:08 localhost kernel: *pde = 00000000
Nov 29 17:02:08 localhost kernel: Oops: 0000
Nov 29 17:02:08 localhost kernel: Oops: 0000
Nov 29 17:02:08 localhost kernel: CPU:    0
Nov 29 17:02:08 localhost kernel: CPU:    0
Nov 29 17:02:08 localhost kernel: EIP:    0010:[<c029a3b5>]    Not tainted
Nov 29 17:02:08 localhost kernel: EIP:    0010:[<c029a3b5>]    Not tainted
Nov 29 17:02:08 localhost kernel: EFLAGS: 00010282
Nov 29 17:02:08 localhost kernel: EFLAGS: 00010282
Nov 29 17:02:08 localhost kernel: eax: 00000002   ebx: df82e058   ecx: 00000001   edx: c0373138
Nov 29 17:02:08 localhost kernel: eax: 00000002   ebx: df82e058   ecx: 00000001   edx: c0373138
Nov 29 17:02:08 localhost kernel: esi: f80d002a   edi: d84b3098   ebp: d3d2ff6c   esp: d3d2ff4c
Nov 29 17:02:08 localhost kernel: esi: f80d002a   edi: d84b3098   ebp: d3d2ff6c   esp: d3d2ff4c
Nov 29 17:02:08 localhost kernel: ds: 0018   es: 0018   ss: 0018
Nov 29 17:02:08 localhost kernel: ds: 0018   es: 0018   ss: 0018
Nov 29 17:02:08 localhost kernel: Process raid5d (pid: 27988, stackpage=d3d2f000)
Nov 29 17:02:08 localhost kernel: Process raid5d (pid: 27988, stackpage=d3d2f000)
Nov 29 17:02:08 localhost kernel: Stack: c0351aa5 dae473b6 00000296 00000064 00000000 d3d2e65c db26f400 d3d2e000 
Nov 29 17:02:08 localhost kernel: Stack: c0351aa5 dae473b6 00000296 00000064 00000000 d3d2e65c db26f400 d3d2e000 
Nov 29 17:02:08 localhost kernel:        d3d2ff9c e08af2be d84b3084 dfdbc81c 00000282 db26f760 dfdbc87c 00000000 
Nov 29 17:02:08 localhost kernel:        d3d2ff9c e08af2be d84b3084 dfdbc81c 00000282 db26f760 dfdbc87c 00000000 
Nov 29 17:02:08 localhost kernel:        00000018 d3d2e65c d4426a04 d3d2e000 d3d2ffec c029d59e db26f400 e08b0830 
Nov 29 17:02:08 localhost kernel:        00000018 d3d2e65c d4426a04 d3d2e000 d3d2ffec c029d59e db26f400 e08b0830 
Nov 29 17:02:08 localhost kernel: Call Trace:    [<e08af2be>] [<c029d59e>] [<e08b0830>] [<c010771e>] [<c029d3f0>]
Nov 29 17:02:08 localhost kernel: Call Trace:    [<e08af2be>] [<c029d59e>] [<e08b0830>] [<c010771e>] [<c029d3f0>]
Nov 29 17:02:08 localhost kernel: 
Nov 29 17:02:08 localhost kernel: 
Nov 29 17:02:08 localhost kernel: Code: 39 7e 04 75 86 8b 5d f0 85 db 74 22 ff 4d ec 74 11 c7 04 24 
Nov 29 17:02:08 localhost kernel: Code: 39 7e 04 75 86 8b 5d f0 85 db 74 22 ff 4d ec 74 11 c7 04 24
-------------------------------------------------------------------------------------------------------
Nov 29 17:02:08 localhost kernel:  <6>md: sdc1 [events: 00000004]<6>(write) sdc1's sb offset: 117186048
Nov 29 17:02:08 localhost kernel:  <6>md: sdc1 [events: 00000004]<6>(write) sdc1's sb offset: 117186048
-------------------------------------------------------------------------------------------------------


Now, ksymoops helps us find where exactly the fault occured:
(BTW, ksymoops 2.4.10 segfaulted on me -- did not check why - Leon Woestenberg)

[root@localhost ksymoops-2.4.9]# ksymoops -m /boot/System.map < /home/leon/hot_removal_raid5d_oops.txt

>>EIP; c029a3b5 <md_update_sb+145/250>   <=====
>>EIP; c029a3b5 <md_update_sb+145/250>   <=====
 
>>ebx; df82e058 <_end+1f3c9dac/203f1db4>
>>edx; c0373138 <log_wait+0/10>
>>ebx; df82e058 <_end+1f3c9dac/203f1db4>
>>edx; c0373138 <log_wait+0/10>
>>edi; d84b3098 <_end+1804edec/203f1db4>
>>ebp; d3d2ff6c <_end+138cbcc0/203f1db4>
>>esp; d3d2ff4c <_end+138cbca0/203f1db4>
>>edi; d84b3098 <_end+1804edec/203f1db4>
>>ebp; d3d2ff6c <_end+138cbcc0/203f1db4>
>>esp; d3d2ff4c <_end+138cbca0/203f1db4>
 
Trace; e08af2be <[raid5]raid5d+1ee/200>
Trace; c029d59e <md_thread+1ae/2b0>
Trace; e08b0830 <[raid5].text.end+7d/8dd>
Trace; c010771e <arch_kernel_thread+2e/40>
Trace; c029d3f0 <md_thread+0/2b0>
Trace; e08af2be <[raid5]raid5d+1ee/200>
Trace; c029d59e <md_thread+1ae/2b0>
Trace; e08b0830 <[raid5].text.end+7d/8dd>
Trace; c010771e <arch_kernel_thread+2e/40>
Trace; c029d3f0 <md_thread+0/2b0>
 
Code;  c029a3b5 <md_update_sb+145/250>
00000000 <_EIP>:
Code;  c029a3b5 <md_update_sb+145/250>   <=====
   0:   39 7e 04                  cmp    %edi,0x4(%esi)   <=====
Code;  c029a3b8 <md_update_sb+148/250>
   3:   75 86                     jne    ffffff8b <_EIP+0xffffff8b>
Code;  c029a3ba <md_update_sb+14a/250>
   5:   8b 5d f0                  mov    0xfffffff0(%ebp),%ebx
Code;  c029a3bd <md_update_sb+14d/250>
   8:   85 db                     test   %ebx,%ebx
Code;  c029a3bf <md_update_sb+14f/250>
   a:   74 22                     je     2e <_EIP+0x2e>
Code;  c029a3c1 <md_update_sb+151/250>
   c:   ff 4d ec                  decl   0xffffffec(%ebp)
Code;  c029a3c4 <md_update_sb+154/250>
   f:   74 11                     je     22 <_EIP+0x22>
Code;  c029a3c6 <md_update_sb+156/250>
  11:   c7 04 24 00 00 00 00      movl   $0x0,(%esp,1)
 
Nov 29 17:02:08 localhost kernel: Code: 39 7e 04 75 86 8b 5d f0 85 db 74 22 ff 4d ec 74 11 c7 04 24

The compare instruction seems to cmp %edi against 4 bytes into a structure pointed to
by %esi.

Let's dissassemble that part a bit:

[root@localhost linux]# pwd
/usr/src/linux
[root@localhost linux]# objdump -d ./vmlinux | less


----------
c029a340:       c7 04 24 75 1a 35 c0    movl   $0xc0351a75,(%esp,1)
c029a347:       e8 24 6c e8 ff          call   c0120f70 <printk>
c029a34c:       8b 43 3c                mov    0x3c(%ebx),%eax
c029a34f:       85 c0                   test   %eax,%eax
c029a351:       0f 85 f1 00 00 00       jne    c029a448 <md_update_sb+0x1d8>
c029a357:       8b 43 38                mov    0x38(%ebx),%eax
c029a35a:       85 c0                   test   %eax,%eax
c029a35c:       0f 85 d5 00 00 00       jne    c029a437 <md_update_sb+0x1c7>
c029a362:       8b 43 3c                mov    0x3c(%ebx),%eax
c029a365:       85 c0                   test   %eax,%eax
c029a367:       75 12                   jne    c029a37b <md_update_sb+0x10b>
c029a369:       8b 43 2c                mov    0x2c(%ebx),%eax
c029a36c:       05 80 0f 00 00          add    $0xf80,%eax
c029a371:       f6 40 10 01             testb  $0x1,0x10(%eax)
c029a375:       0f 85 9b 00 00 00       jne    c029a416 <md_update_sb+0x1a6>
c029a37b:       0f b7 43 18             movzwl 0x18(%ebx),%eax
c029a37f:       89 04 24                mov    %eax,(%esp,1)
c029a382:       e8 89 e8 ff ff          call   c0298c10 <partition_name>
c029a387:       89 44 24 04             mov    %eax,0x4(%esp,1)
c029a38b:       c7 04 24 04 97 34 c0    movl   $0xc0349704,(%esp,1)
c029a392:       e8 d9 6b e8 ff          call   c0120f70 <printk>
c029a397:       8b 43 3c                mov    0x3c(%ebx),%eax
c029a39a:       85 c0                   test   %eax,%eax
c029a39c:       75 07                   jne    c029a3a5 <md_update_sb+0x135>
c029a39e:       8b 43 38                mov    0x38(%ebx),%eax
c029a3a1:       85 c0                   test   %eax,%eax
c029a3a3:       74 4b                   je     c029a3f0 <md_update_sb+0x180>
c029a3a5:       c7 04 24 a5 1a 35 c0    movl   $0xc0351aa5,(%esp,1)
c029a3ac:       e8 bf 6b e8 ff          call   c0120f70 <printk>
c029a3b1:       89 f3                   mov    %esi,%ebx
c029a3b3:       8b 36                   mov    (%esi),%esi
c029a3b5:       39 7e 04                cmp    %edi,0x4(%esi) <====================
c029a3b8:       75 86                   jne    c029a340 <md_update_sb+0xd0>
----------

I have marked the offending instruction with an arrow. The compare sits in the
loop condition, probably in the ITERATE_RDEV macro we see surrounding the loop
when we look at the matching C code (drivers/md/md.o):

-------------------
        ITERATE_RDEV(mddev,rdev,tmp) {
                printk(KERN_INFO "md: ");
                if (rdev->faulty)
                        printk("(skipping faulty ");
                if (rdev->alias_device)
                        printk("(skipping alias ");
                if (!rdev->faulty && disk_faulty(&rdev->sb->this_disk)) {
                        printk("(skipping new-faulty %s )\n",
                               partition_name(rdev->dev));
                        continue;
                }
                printk("%s ", partition_name(rdev->dev));
                if (!rdev->faulty && !rdev->alias_device) {
                        printk("[events: %08lx]",
                                (unsigned long)rdev->sb->events_lo);
                        err += write_disk_sb(rdev);
                } else
                        printk(")\n");
        }
------------------------

The macro sits in less /usr/src/linux/include/linux/raid/md_k.h:

#define ITERATE_RDEV_GENERIC(head,field,rdev,tmp)                       \
                                                                        \
        for (tmp = head.next;                                           \
                rdev = md_list_entry(tmp, mdk_rdev_t, field),           \
                        tmp = tmp->next, tmp->prev != &head             \
                ; )
/*
 * iterates through the 'same array disks' ringlist
 */
#define ITERATE_RDEV(mddev,rdev,tmp)                                    \
        ITERATE_RDEV_GENERIC((mddev)->disks,same_set,rdev,tmp)

These macro's expand to this:

tmp = (mddev)->disks.next;

for (tmp = head.next;
     rdev = md_list_entry(tmp, mdk_rdev_t, same_set), tmp = tmp->next, tmp->prev != &head
     ;)     
 
struct mdk_rdev_s
{
        struct md_list_head same_set;   /* RAID devices within the same set */
        struct md_list_head all;        /* all RAID devices */
        struct md_list_head pending;    /* undetected RAID devices */
                                                                                                                                             
        kdev_t dev;                     /* Device number */
        kdev_t old_dev;                 /*  "" when it was last imported */
        unsigned long size;             /* Device size (in blocks) */
        mddev_t *mddev;                 /* RAID array if running */
        unsigned long last_events;      /* IO event timestamp */
                                                                                                                                             
        struct block_device *bdev;      /* block device handle */
                                                                                                                                             
        mdp_super_t *sb;
        struct page *sb_page;
        unsigned long sb_offset;
                                                                                                                                             
        int alias_device;               /* device alias to the same disk */
        int faulty;                     /* if faulty do not issue IO requests */
        int desc_nr;                    /* descriptor index in the superblock */
};

A md_list_head is simply a list_head:
                                                                                                                                             
md_compatible.h:121:
#define md_list_head list_head

struct list_head {
        struct list_head *next, *prev;
};

--=-63kHIDukvirynwSqNAud--

