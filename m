From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: kernel race with mdadm monitor
Date: Thu, 10 Feb 2005 14:28:16 +0100
Message-ID: <cufnea$ivd$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm running Linux 2.4.27 i686 single-processor from debian's
kernel-source-2.4.27 and mdadm 1.9.0 in monitor mode:
/sbin/mdadm -F -i /var/run/mdadm.pid -m raid -f -s

While stopping a raid1 (raidstop /dev/md8) it seems there
occured some race. I don't know if this is a known issue,
if so, sorry for the long report :)

The oops:

md: marking sb clean...
md: updating md8 RAID superblock on device
md: hde1 [events: 0000000a]<6>(write) hde1's sb offset: 195358336
Unable to handle kernel NULL pointer dereference at virtual address 000003d8
 printing eip:
c024be53
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<c024be53>]    Not tainted
EFLAGS: 00010286
eax: c1c149ac   ebx: f7da5634   ecx: c0308d1e   edx: f738e974
esi: 00000000   edi: 00000000   ebp: f738e974   esp: f5539f18
ds: 0018   es: 0018   ss: 0018
Process mdadm (pid: 1731, stackpage=f5539000)
Stack: c1c149c0 0ba4ee80 c0157b37 f63e1206 f7da5634 c1c149c0 c0308d1f 0ba4ee80 
       c0252f0b f738e974 c1c149ac 0ba4ee80 00000000 00000000 f738e974 c1c149ac 
       000001ec c015766d f738e974 c1c149ac f5539f74 f738e98c 00000000 00000007 
Call Trace:    [<c0157b37>] [<c0252f0b>] [<c015766d>] [<c013e2f3>] [<c0108bcb>]

Code: 8b 87 d8 03 00 00 89 44 24 0c 8b 87 d4 03 00 00 89 2c 24 89 
 <6>md: md8 stopped.
md: unbind<hde1,0>
md: export_rdev(hde1)

The whole thing passed through ksymoops:

ksymoops 2.4.9 on i686 2.4.27.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.27/ (default)
     -m /boot/System.map-2.4.27 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Unable to handle kernel NULL pointer dereference at virtual address 000003d8
c024be53
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<c024be53>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010286
eax: c1c149ac   ebx: f7da5634   ecx: c0308d1e   edx: f738e974
esi: 00000000   edi: 00000000   ebp: f738e974   esp: f5539f18
ds: 0018   es: 0018   ss: 0018
Process mdadm (pid: 1731, stackpage=f5539000)
Stack: c1c149c0 0ba4ee80 c0157b37 f63e1206 f7da5634 c1c149c0 c0308d1f 0ba4ee80 
       c0252f0b f738e974 c1c149ac 0ba4ee80 00000000 00000000 f738e974 c1c149ac 
       000001ec c015766d f738e974 c1c149ac f5539f74 f738e98c 00000000 00000007 
Call Trace:    [<c0157b37>] [<c0252f0b>] [<c015766d>] [<c013e2f3>] [<c0108bcb>]
Code: 8b 87 d8 03 00 00 89 44 24 0c 8b 87 d4 03 00 00 89 2c 24 89 


>>EIP; c024be53 <raid1_status+13/a0>   <=====

>>eax; c1c149ac <_end+1832a48/3a58b0fc>
>>ebx; f7da5634 <_end+379c36d0/3a58b0fc>
>>ecx; c0308d1e <cpdext+32e3e/3a8e0>
>>edx; f738e974 <_end+36faca10/3a58b0fc>
>>ebp; f738e974 <_end+36faca10/3a58b0fc>
>>esp; f5539f18 <_end+35157fb4/3a58b0fc>

Trace; c0157b37 <seq_printf+37/60>
Trace; c0252f0b <md_seq_show+15b/2d0>
Trace; c015766d <seq_read+1cd/2c0>
Trace; c013e2f3 <sys_read+a3/140>
Trace; c0108bcb <system_call+33/38>

Code;  c024be53 <raid1_status+13/a0>
00000000 <_EIP>:
Code;  c024be53 <raid1_status+13/a0>   <=====
   0:   8b 87 d8 03 00 00         mov    0x3d8(%edi),%eax   <=====
Code;  c024be59 <raid1_status+19/a0>
   6:   89 44 24 0c               mov    %eax,0xc(%esp)
Code;  c024be5d <raid1_status+1d/a0>
   a:   8b 87 d4 03 00 00         mov    0x3d4(%edi),%eax
Code;  c024be63 <raid1_status+23/a0>
  10:   89 2c 24                  mov    %ebp,(%esp)
Code;  c024be66 <raid1_status+26/a0>
  13:   89 00                     mov    %eax,(%eax)


1 warning issued.  Results may not be reliable.


regards,
   Mario
-- 
Whenever you design a better fool-proof software,
the genetic pool will always design a better fool.

