From: "Michael T. Babcock" <mbabcock@fibrespeed.net>
Subject: PROBLEM:
Date: Wed, 25 Sep 2002 14:13:53 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D91FCE1.1090107@fibrespeed.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ext3-users@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ext3 Journal oops & RAID-1 set losing sync.

(Sent to both EXT3 and Linux-RAID since both are in use and seem 
possibly relevant)

I have had a number of problems maintaining a software RAID-1 set on an 
IDE box I maintain; it seems that doing raidhotadd on the drive marked 
as invalid works each time though.  However, I've had both errors about 
trying to read past the end of the disk/partition and at least one oops 
relating to the ext3 journalling code.  I'm not sure either is related 
to the other, but not sure they're not either.  Any help / suggestions 
would be appreciated as this is a live system that is now being rebooted 
quite regularly ...

Output of ver_linux:
Linux {hostname} 2.4.18-vpn1.0 #5 Fri Jul 26 09:59:37 EDT 2002 i686 unknown
 
Gnu C                  2.96
Gnu make               3.79.1
util-linux             2.11n
mount                  2.11n
modutils               2.4.14
e2fsprogs              1.27
PPP                    2.4.1
isdn4k-utils           3.1pre1
Linux C Library        2.2.5
Dynamic linker (ldd)   2.2.5
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.3.3
Sh-utils               2.0.11
Modules Loaded         ipsec ppp_synctty ppp_async ppp_generic slhc 
8139too via-rhine binfmt_misc epca autofs mii ipt_REJECT ipt_LOG 
ipt_state ipt_MARK iptable_mangle ipt_MASQUERADE iptable_nat 
iptable_filter usb-uhci usbcore ext3 jbd

Recent log entries (not including oops):
Sep 25 10:46:51 gw kernel: journal_bmap_Rc2009e7d: journal block not 
found at offset 7185 on md (9,3)
Sep 25 10:46:51 gw kernel: Aborting journal on device md(9,3).
Sep 25 10:46:51 gw kernel: attempt to access beyond end of device
Sep 25 10:46:51 gw kernel: 09:03: rw=1, want=1625616132, limit=4192192
Sep 25 10:46:51 gw kernel: attempt to access beyond end of device
Sep 25 10:46:51 gw kernel: 09:03: rw=1, want=67108868, limit=4192192
Sep 25 10:46:51 gw kernel: attempt to access beyond end of device
Sep 25 10:46:51 gw kernel: 09:03: rw=1, want=1740123140, limit=4192192
Sep 25 10:46:51 gw kernel: attempt to access beyond end of device
Sep 25 10:46:51 gw kernel: 09:03: rw=1, want=1912610820, limit=4192192
Sep 25 10:46:51 gw kernel: attempt to access beyond end of device
Sep 25 10:46:51 gw kernel: 09:03: rw=1, want=536870916, limit=4192192
Sep 25 10:46:51 gw kernel: Assertion failure in 
__journal_remove_journal_head() at journal.c:1730: "buffer_jbd(bh)"

ksymoops:
Error (expand_objects): cannot stat(/lib/ext3.o) for ext3
ksymoops: No such file or directory
Error (expand_objects): cannot stat(/lib/jbd.o) for jbd
ksymoops: No such file or directory
Warning (compare_maps): mismatch on symbol partition_name  , ksyms_base 
says c01e0cf0, System.map says c014f3e0.  Ignoring ksyms_base entry
Warning (compare_maps): mismatch on symbol zeroes  , ipsec says 
d0a2bd00, /lib/modules/2.4.18-vpn1.0/kernel/net/ipsec/ipsec.o says 
d0a2bc00.  Ignoring /lib/modules/2.4.18-vpn1.0/kernel/net/ipsec/ipsec.o 
entry
Warning (map_ksym_to_module): cannot match loaded module ext3 to a 
unique module object.  Trace may not be reliable.
Sep 25 10:46:51 gw kernel: invalid operand: 0000
Sep 25 10:46:51 gw kernel: CPU:    0
Sep 25 10:46:51 gw kernel: EIP:    0010:[<d08181ce>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
Sep 25 10:46:52 gw kernel: EFLAGS: 00010246
Sep 25 10:46:52 gw kernel: eax: 0000005c   ebx: c9e4cb60   ecx: 
c027c7e0   edx: 00000216
Sep 25 10:46:52 gw kernel: esi: cf698ca0   edi: 0000000a   ebp: 
00000000   esp: cf875e54
Sep 25 10:46:52 gw kernel: ds: 0018   es: 0018   ss: 0018
Sep 25 10:46:52 gw kernel: Process kjournald (pid: 182, stackpage=cf875000)
Sep 25 10:46:52 gw kernel: Stack: d0819e60 d0818a98 d08188bf 000006c2 
d0818ab6 c9e4cb60 cf698ca0 d0818279
Sep 25 10:46:52 gw kernel:        c9e4cb60 c9e4cb60 d0814804 cf698ca0 
00000000 00000f94 c9da206c 00000000
Sep 25 10:46:52 gw kernel:        ceaa69e0 cf698ca0 08000000 c02fb800 
c02fb7c0 c02fb800 c02fb7c0 ca165b60
Sep 25 10:46:52 gw kernel: Call Trace: [<d0819e60>] [<d0818a98>] 
[<d08188bf>] [<d0818ab6>] [<d0818279>]
Sep 25 10:46:52 gw kernel:    [<d0814804>] [<c010844d>] [<c010846c>] 
[<c010a498>] [<c0105a2e>] [<c01126b6>]
Sep 25 10:46:52 gw kernel:    [<d08169d6>] [<d08168b0>] [<c0105726>] 
[<d08168d0>]
Sep 25 10:46:52 gw kernel: Code: 0f 0b 83 c4 14 39 1e 74 23 68 c5 8a 81 
d0 68 c3 06 00 00 68

 >>EIP; d08181ce <[jbd]__journal_remove_journal_head+7e/e0>   <=====
Trace; d0819e60 <[jbd].rodata.end+1a91/4cb9>
Trace; d0818a98 <[jbd].rodata.end+6c9/4cb9>
Trace; d08188bf <[jbd].rodata.end+4f0/4cb9>
Trace; d0818ab6 <[jbd].rodata.end+6e7/4cb9>
Trace; d0818279 <[jbd]journal_unlock_journal_head+49/60>
Trace; d0814804 <[jbd]journal_commit_transaction+854/e6a>
Trace; c010844d <do_IRQ+6d/b0>
Trace; c010846c <do_IRQ+8c/b0>
Trace; c010a498 <call_do_IRQ+5/d>
Trace; c0105a2e <__switch_to+3e/d0>
Trace; c01126b6 <schedule+2c6/2f0>
Trace; d08169d6 <[jbd]kjournald+106/1a0>
Trace; d08168b0 <[jbd]commit_timeout+0/10>
Trace; c0105726 <kernel_thread+26/30>
Trace; d08168d0 <[jbd]kjournald+0/1a0>
Code;  d08181ce <[jbd]__journal_remove_journal_head+7e/e0>
00000000 <_EIP>:
Code;  d08181ce <[jbd]__journal_remove_journal_head+7e/e0>   <=====
   0:   0f 0b                     ud2a      <=====
Code;  d08181d0 <[jbd]__journal_remove_journal_head+80/e0>
   2:   83 c4 14                  add    $0x14,%esp
Code;  d08181d3 <[jbd]__journal_remove_journal_head+83/e0>
   5:   39 1e                     cmp    %ebx,(%esi)
Code;  d08181d5 <[jbd]__journal_remove_journal_head+85/e0>
   7:   74 23                     je     2c <_EIP+0x2c> d08181fa 
<[jbd]__journal_remove_journal_head+aa/e0>
Code;  d08181d7 <[jbd]__journal_remove_journal_head+87/e0>
   9:   68 c5 8a 81 d0            push   $0xd0818ac5
Code;  d08181dc <[jbd]__journal_remove_journal_head+8c/e0>
   e:   68 c3 06 00 00            push   $0x6c3
Code;  d08181e1 <[jbd]__journal_remove_journal_head+91/e0>
  13:   68 00 00 00 00            push   $0x0


4 warnings and 2 errors issued.  Results may not be reliable.

-- 
Michael T. Babcock
C.T.O., FibreSpeed Ltd.
http://www.fibrespeed.net/~mbabcock


