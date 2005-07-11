From: Farkas Levente <lfarkas@bppiac.hu>
Subject: sofware raid5 oops
Date: Mon, 11 Jul 2005 10:13:47 +0200
Message-ID: <42D22A3B.1000608@bppiac.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000200090205010205040707"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000200090205010205040707
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

anybody has any useful tip about it?
yours.

-------- Original Message --------
hi,
after we switch our servers from centos-3 to centos-4 (aka. rhel-4) one
of our server always crash once a week without any oops. this happneds
with both the normal kernel-2.6.9-11.EL and
kernel-2.6.9-11.106.unsupported. after we change the motherboard, the
raid contorller and the cables too we still got it. finally we start
netdump and last but not least yesterday we got a crash log and a core
file. it seems there is a bug in the raid5 code of the kernel.
this is our backup server with 8 x 200GB hdd in a raid5 (for the data)
plus 2 x 40GB hdd in raid1 (for the system) with 3ware 8xxx raid
contorller, running. i attached the netdump log of the last crash.
how can i fix it?
yours.


-- 
   Levente                               "Si vis pacem para bellum!"

--------------000200090205010205040707
Content-Type: text/plain;
 name="log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="log"

RAID5 conf printout:
 --- rd:8 wd:8 fd:0
 disk 0, o:1, dev:sda1
 disk 1, o:1, dev:sdb1
 disk 2, o:1, dev:sdc1
 disk 3, o:1, dev:sdd1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdf1
 disk 6, o:1, dev:sdg1
 disk 7, o:1, dev:sdh1
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
00000000
*pde = 0f94a067
Oops: 0000 [#1]
Modules linked in: cifs nls_utf8 ncpfs nfsd exportfs lockd sunrpc parport_pc lp parport netconsole netdump i2c_dev i2c_core ipx dm_mod e1000 tg3 floppy ext3 jbd raid5 xor raid1 3w_xxxx sd_mod scsi_mod
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010246   (2.6.9-11.106.unsupported) 
EIP is at 0x0
eax: c1806138   ebx: c018961c   ecx: 00000016   edx: c035c7f4
esi: e7182200   edi: 00000001   ebp: c18fb380   esp: f7878f34
ds: 007b   es: 007b   ss: 0068
Process md2_raid5 (pid: 224, threadinfo=f7878000 task=f7872600)
Stack: f7b973c0 f8879a26  md_thread+0x20d/0x23a
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c030ce1a>] ret_from_fork+0x6/0x14
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02a183f>] md_thread+0x0/0x23a
 [<c01041d9>] kernel_thread_helper+0x5/0xb
Code:  Bad EIP value.

Pid: 224, comm:            md2_raid5
EIP: 0060:[<00000000>] CPU: 0
EIP is at 0x0
 EFLAGS: 00010246    Not tainted  (2.6.9-11.106.unsupported)
EAX: c1806138 EBX: c018961c ECX: 00000016 EDX: c035c7f4
ESI: e7182200 EDI: 00000001 EBP: c18fb380 DS: 007b ES: 007b
CR0: 8005003b CR2: ffffffd5 CR3: 0fd6b000 CR4: 000006d0
 [<f8879a26>] handle_stripe+0xfca/0x1207 [raid5]
 [<f887a7d5>] raid5d+0x197/0x2ab [raid5]
 [<c02a1a4c>] md_thread+0x20d/0x23a
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c030ce1a>] ret_from_fork+0x6/0x14
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02a183f>] md_thread+0x0/0x23a
 [<c01041d9>] kernel_thread_helper+0x5/0xb

                                               sibling
  task             PC      pid father child younger older
init          S C01458E9   920     1      0     2               (NOTLB)
f7f44eb0 00000086 00000055  xfrm_state_flush+0x2/0x289 tcp_poll+0x31/0x144
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
ntpd          S 000000D0  2516  2196      1          2219  2172 (NOTLB)
f0885eb0 00000082 00000246 000000d0 cf8553a0 000021cd 5197434f 00003abd 
       f697d2a0 f697d42c f6a0d580 7fffffff 00000000 f0885f74 c030b7e5 f69a5980 
       00000000 f0885f58 f69a5980 f106ed18 c017648e 00000246 f106b800 f0885f58 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c02aeeac>] datagram_poll+0x25/0xd1
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c01058d8>] sys_sigreturn+0x1ce/0x1f2
 [<c030cefb>] syscall_call+0x7/0xb
rpc.rquotad   S 00000000  3416  2219      1          2223  2196 (NOTLB)
f65a4f1c 00000082 00000001 00000000 f697ccd0 00030ee2 966e2a43 00000033 
       f69b1320 f69b14ac 00000000 7fffffff f65a4fa0 f0888ba0 c030b7e5 f106b580 
       f65a4fa0 f106e518 c02aeeac f6a7a780 c03806c0 00000145 f0888bb0 00000001 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c02aeeac>] datagram_poll+0x25/0xd1
 [<c02a8f2c>] sock_poll+0x12/0x14
 [<c0176db3>] do_pollfd+0x54/0x77
 [<c0176e63>] do_poll+0x8d/0xab
 [<c0177020>] sys_poll+0x19f/0x24f
 [<c0176461>] __pollwait+0x0/0x94
 [<c030cefb>] syscall_call+0x7/0xb
nfsd          S FF4DCFB0  2316  2223      1          2224  2219 (L-TLB)
f05fff10 00000046 00000002 ff4dcfb0 f69c4dd0 000013cc c85b7bd5 000037c8 
       f69b0d50 f69b0edc 03db8cae 03db8cae 0000000b c1993c00 c030b886 f5675f18 
       c035b0d0 03db8cae 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<f8ade6bb>] svc_recv+0x325/0x65b [sunrpc]
 [<c011b856>] default_wake_function+0x0/0xc
 [<c011b921>] __wake_up+0x6e/0xca
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012d587>] sigprocmask+0x140/0x1f4
 [<f8b2e44d>] nfsd+0x1ae/0x540 [nfsd]
 [<f8b2e29f>] nfsd+0x0/0x540 [nfsd]
 [<c01041d9>] kernel_thread_helper+0x5/0xb
nfsd          S 000037C3  3472  2224      1          2225  2223 (L-TLB)
f1513f10 00000046 431bf158 000037c3 f78731a0 00001630 431bf158 000037c3 
       f6a21870 f6a219fc 03db2fe5 03db2fe5 0000000b f7f58400 c030b886 f1806f18 
       c035b0c0 03db2fe5 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5 schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<f8ade6bb>] svc_recv+0x325/0x65b [sunrpc]
 [<c011b856>] default_wake_function+0x0/0xc
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012d587>] sigprocmask+0x140/0x1f4
 [<f8b2e44d>] nfsd+0x1ae/0x540 [nfsd]
 [<f8b2e29f>] nfsd+0x0/0x540 [nfsd]
 kernel_thread_helper+0x5/0xb schedule_timeout+0x50/0x10c
 [<c02ae7c6>] skb_recv_datagram+0x15a/0x18f
 [<f8ade6bb>] svc_recv+0x325/0x65b [sunrpc]
 [<c011b856>] default_wake_function+0x0/0xc
 [<c01041d4>] kernel_thread_helper+0x0/0xb
 [<c011b856>] default_wake_function+0x0/0xc
 [<f894c6f7>] lockd+0x1ae/0x33f [lockd]
 [<f894c549>] lockd+0x0/0x33f [lockd]
 [<c01041d9>] kernel_thread_helper+0x5/0xb
rpciod        S C0129BCC  3752  2231      1          2232  2230 (L-TLB)
f5665f9c 00000046 f5665000 c0129bcc f69b0780 00000a63 99004822 00000033 
       f69c4dd0 f69c4f5c f5665000 00000000 f5665fb8 00000000 f8ada30b 00000000 
       f69c4dd0 c011ceaf f5665fd0 f5665fd0 f05fff10 c030ce1a f69b0d50 00000000 
 free_uid+0x15/0xac
 [<f8ada30b>] rpciod+0x556/0x74b [sunrpc]
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c030ce1a>] ret_from_fork+0x6/0x14
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<f8ad9db5>] rpciod+0x0/0x74b [sunrpc]
 [<c01041d9>] kernel_thread_helper+0x5/0xb
nfsd          S 00000000  2136  2232      1          2236  2231 (L-TLB)
f5675f10 00000046 f7f59864 00000000 f7f59864 00000886 cf330c8a 000037c8 
       f69c4800 f69c498c 03db8d21 03db8d21 0000000b f7f59800 c030b886 c035b0d0 
       f05fff18 03db8d21 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<f8ade6bb>] svc_recv+0x325/0x65b [sunrpc]
 [<c011b856>] default_wake_function+0x0/0xc
 [<f8adc82b>] svc_process+0x480/0x6cd [sunrpc]
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012d587>] sigprocmask+0x140/0x1f4
 [<f8b2e44d>] nfsd+0x1ae/0x540 [nfsd]
 [<f8b2e29f>] nfsd+0x0/0x540 [nfsd]
 [<c01041d9>] kernel_thread_helper+0x5/0xb
rpc.mountd    S C16A7000  3416  2236      1          2256  2232 (NOTLB)
f567eeb0 00000086 c01458e9 c16a7000 f697ccd0 0004c4da 9d1f8094 00000033 
       f69c5970 f69c5afc f6a0f480 7fffffff 00000000 f567ef74 c030b7e5 00000000 
       00df9100 00000246 f5664580 f567ef58 f1818598 c02d1fed f5663d00 f567ef58 
Call Trace:
 buffered_rmqueue+0x1c4/0x1e7
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c02d1fed>] tcp_poll+0x31/0x144
 [<c02aeeac>] datagram_poll+0x25/0xd1
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030b650>] __cond_resched+0x14/0x3b
 [<c030cefb>] syscall_call+0x7/0xb
rpc.idmapd    S 00003ABB  3288  2256      1          2316  2236 (NOTLB)
f088af1c 00000086 6792e02d 00003abb cf919770 00000f18 912b8daa 00003abc 
       f6a6d1a0 f6a6d32c 03d65077 03d65077 00000000 00001388 c030b886 f6bc7eb8 
       cf9a0da4 03d65077 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c018fd78>] ep_poll+0xb7/0x11e
 [<c011b856>] default_wake_function+0x0/0xc
 [<c018f041>] sys_epoll_wait+0x70/0x83
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
master        S C01458E9  2288  2316      1  2325    2331  2256 (NOTLB)
f65d4eb0 00000086 00000055 c01458e9 f08e80b0 000024bb 32f4d56a 00003ab7 
       f697ccd0 f697ce5c 03d6cd16 03d6cd16 00000000 f65d4f74 c030b886 c0439020 
       f04d0f54 03d6cd16 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c01458e9>] buffered_rmqueue+0x1c4/0x1e7
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c01243db>] sys_time+0xf/0x58
 [<c030cefb>] syscall_call+0x7/0xb
qmgr          S 00003AA6  2368  2325   2316          5271       (NOTLB)
f65d9eb0 00000086 aff835d3 00003aa6 f780a1b0 0000586b aff87065 00003aa6 
       f6a6d770 f6a6d8fc 03de71f1 03de71f1 00000000 f65d9f74 c030b886 c035b128 
       c035b128 03de71f1 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030b650>] __cond_resched+0x14/0x3b
 [<c01243db>] sys_time+0xf/0x58
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
gpm           S 00000034  2764  2331      1          2340  2316 (NOTLB)
f04cceb0 00000082 30984ef4 00000034 f780a1b0 00031940 309a3434 00000034 
       f78a60b0 f78a623c 0524d0d9 0524d0d9 00000000 f04ccf74 c030b886 c035b368 
       c035b368 0524d0d9 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c02aa01a>] sys_socketcall+0xde/0x1dd
 [<c01244b5>] sys_gettimeofday+0x53/0xac
 [<c030cefb>] syscall_call+0x7/0xb
crond         S 000000FF  2616  2340      1  5980    2349  2331 (NOTLB)
f65dcf4c 00000082 00000000 000000ff cfdc0dd0 000025c3 16273dd1 00003abc 
       f0ba3970 f0ba3afc 03d71f46 03d71f46 0000ea6b fa09bac0 c030b886 c035b040 
       f8b57e98 03d71f46 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c012944e>] sys_nanosleep+0x103/0x1a1
 [<c030cefb>] syscall_call+0x7/0xb
smbd          S C035CA9C  1752  2349      1  2374    2353  2340 (NOTLB)
f04caeb0 00000086 000000d0 c035ca9c c01459c0 0001f6f4 b600904c 00003133 
       f0ba33a0 f0ba352c f04d1b80 7fffffff 00000000 f04caf74 c030b7e5 f0bbac98 
       c017648e 00000246 f0b43580 f04caf58 f0bba898 c02d1fed 00000000 00000000 
Call Trace:
 [<c01459c0>] __alloc_pages+0xb4/0x29d
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c02d1fed>] tcp_poll+0x31/0x144
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c01058d8>] sys_sigreturn+0x1ce/0x1f2
 [<c030cefb>] syscall_call+0x7/0xb
nmbd          S 00003ABB  2320  2353      1          2370  2349 (NOTLB)
f04d3eb0 00000086 78a3db2d 00003abb cffc18f0 0001365b 78ab8b56 00003abb 
       f0ba2dd0 f0ba2f5c 03d65194 03d65194 00000000 f04d3f74 c030b886 d11d6da4 
       c035ade8 03d65194 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c012d587>] sigprocmask+0x140/0x1f4
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
atd           S 00000000  2764  2370      1          2380  2353 (NOTLB)
f04d0f4c 00000082 f04d0f34 00000000 cffc18f0 0000260f c782e9a5 00003a7f 
       f0ba2230 f0ba23bc 03d6d34f 03d6d34f 0004940f fa09bac0 c030b886 f65d4eb8 
       c035b038 03d6d34f 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c012944e>] sys_nanosleep+0x103/0x1a1
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
smbd          S C0107DF7  3436  2374   2349                     (NOTLB)
f04cffb8 00000082 00000001 c0107df7 f0ba33a0 0006ccbc 8803dfb7 00000034 
       f6a6c600 f6a6c78c 00d1da3c 00cfc97c 00cfc7d0 f04cf000 c012f12b c030cefb 
       00d1da3c 00000000 08120880 00cfc97c 00cfc7d0 bfed9178 0000001d 0000007b 
Call Trace:
 [<c0107df7>] handle_IRQ_event+0x25/0x4f
 [<c012f12b>] sys_pause+0x14/0x1d
 [<c030cefb>] syscall_call+0x7/0xb
dbus-daemon-1 S 00000001  3040  2380      1          2381  2370 (NOTLB)
f65eef1c 00000086 c01459c0 00000001 f0b76bd0 000020ae b10881c6 00000035 
       f0ba2800 f0ba298c 00000000 7fffffff f65eefa0 f39a5ca0 c030b7e5 00000246 
       f0b4ca80 f65eefa0 f0b64d18 c0306e62 c03822c0 00000145 f39a5cb8 00000001 
Call Trace:
 [<c01459c0>] __alloc_pages+0xb4/0x29d
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c0306e62>] unix_poll+0x24/0xa3
 [<c02a8f2c>] sock_poll+0x12/0x14
 [<c0176db3>] do_pollfd+0x54/0x77
 [<c0176e63>] do_poll+0x8d/0xab
 [<c0177020>] sys_poll+0x19f/0x24f
 [<c0176461>] __pollwait+0x0/0x94
 [<c01244b5>] sys_gettimeofday+0x53/0xac
 [<c030cefb>] syscall_call+0x7/0xb
dbus-daemon-1 S 00000000  3096  2381      1          2390  2380 (NOTLB)
f04c8cac 00000086 00000000 00000000 00000000 00005927 9626398f 00000034 
       f0b771a0 f0b7732c 00000000 7fffffff f04c8d1c f7fe6080 c030b7e5 00000000 
       00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c02ae622>] wait_for_packet+0xca/0x114
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02ae7e2>] skb_recv_datagram+0x176/0x18f
 [<c02c5ef5>] netlink_recvmsg+0x54/0x1c1
 [<c02a86b6>] sock_recvmsg+0xef/0x10c
 [<c01458e9>] buffered_rmqueue+0x1c4/0x1e7
 [<c015661b>] anon_vma_prepare+0x1f/0x1bf
 [<c0151a41>] do_anonymous_page+0x215/0x27f
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c0151b00>] do_no_page+0x55/0x3bf
 [<c02a996c>] sys_recvfrom+0xa5/0xf5
 [<c015204a>] handle_mm_fault+0xd5/0x1fd
 [<c011924d>] do_page_fault+0x1ac/0x4dc
 [<c02aa0b5>] sys_socketcall+0x179/0x1dd
 [<c030cefb>] syscall_call+0x7/0xb
hald          S C035CA9C  2556  2390      1          2399  2381 (NOTLB)
f65e5f1c 00000086 000000d0 c035ca9c cffc01b0 00007310 e7657e44 00003abc 
       f0b76bd0 f0b76d5c 03d64a69 03d64a69 f65e5fa0 e71f7d00 c030b886 c035a8a8 
       c035a8a8 03d64a69 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c0176e63>] do_poll+0x8d/0xab
 [<c0177020>] sys_poll+0x19f/0x24f
 [<c0176461>] __pollwait+0x0/0x94
 [<c01244b5>] sys_gettimeofday+0x53/0xac
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
mingetty      S 00000001  3040  2399      1          2400  2390 (NOTLB)
f65e6e94 00000086 0000000a 00000001 f697c130 0001550a e18fa1a8 00000034 
       f6a6cbd0 f6a6cd5c f04d2000 7fffffff f04d2c64 fffffffb c030b7e5 00000000 
       ffffffff 00000000 f65e6ed8 f65e6ef8 00000000 f65e6f3c f7c69714 f65e6f74 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c01c2327>] inode_has_perm+0x4c/0x54
 [<c021f69b>] read_chan+0x319/0xa11
 [<c021ff55>] write_chan+0x1c2/0x1d5
 [<c011b856>] default_wake_function+0x0/0xc
 [<c011b856>] default_wake_function+0x0/0xc
 [<c02195ca>] tty_read+0x140/0x1ea
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
mingetty      S 00000034  3040  2400      1          2401  2399 (NOTLB)
f65e7e94 00000082 c4b810a2 00000034 f7f111a0 0003bf45 ecb0d76b 00000034 
       f0b77770 f0b778fc f39b6000 7fffffff f39b6c64 fffffffb c030b7e5 00000000 
       ffffffff 00000000 f65e7ed8 f65e7ef8 00000000 f65e7f3c f7c73d8c f65e7f74 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c01c2327>] inode_has_perm+0x4c/0x54
 [<c021f69b>] read_chan+0x319/0xa11
 [<c021ff55>] write_chan+0x1c2/0x1d5
 [<c011b856>] default_wake_function+0x0/0xc
 [<c011b856>] default_wake_function+0x0/0xc
 [<c02195ca>] tty_read+0x140/0x1ea
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
mingetty      S 00000001  3040  2401      1          2402  2400 (NOTLB)
f08c0e94 00000082 0000000a 00000001 f0b76030 0004849f cb166906 00000034 
       f0b76600 f0b7678c f08f3000 7fffffff f08f3c64 fffffffb c030b7e5 00000000 
       ffffffff 00000000 f08c0ed8 f08c0ef8 00000000 f08c0f3c f7c774ec f08c0f74 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c01c2327>] inode_has_perm+0x4c/0x54
 [<c021f69b>] read_chan+0x319/0xa11
 [<c021ff55>] write_chan+0x1c2/0x1d5
 [<c011b856>] default_wake_function+0x0/0xc
 [<c011b856>] default_wake_function+0x0/0xc
 [<c02195ca>] tty_read+0x140/0x1ea
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
mingetty      S 00000001  3040  2402      1          2403  2401 (NOTLB)
f08c3e94 00000086 0000000a 00000001 f69b18f0 00052d6d d66f7d73 00000034 
       f0b76030 f0b761bc f1550000 7fffffff f1550c64 fffffffb c030b7e5 00000000 
       ffffffff 00000000 f08c3ed8 f08c3ef8 00000000 f08c3f3c f7c80b64 f08c3f74 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c01c2327>] inode_has_perm+0x4c/0x54
 [<c021f69b>] read_chan+0x319/0xa11
 [<c021ff55>] write_chan+0x1c2/0x1d5
 [<c011b856>] default_wake_function+0x0/0xc
 [<c011b856>] default_wake_function+0x0/0xc
 [<c02195ca>] tty_read+0x140/0x1ea
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
mingetty      S 00000001  3040  2403      1          6851  2402 (NOTLB)
f08c6e94 00000082 0000000a 00000001 f6a6cbd0 0003ccd9 e18e4c9e 00000034 
       f08e97f0 f08e997c f1866000 7fffffff f1866c64 fffffffb c030b7e5 00000000 
       ffffffff 00000000 f08c6ed8 f08c6ef8 00000000 f08c6f3c f7c832c4 f08c6f74 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c01c2327>] inode_has_perm+0x4c/0x54
 [<c021f69b>] read_chan+0x319/0xa11
 [<c021ff55>] write_chan+0x1c2/0x1d5
 [<c011b856>] default_wake_function+0x0/0xc
 [<c011b856>] default_wake_function+0x0/0xc
 [<c02195ca>] tty_read+0x140/0x1ea
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
mingetty      S 00000001  3040  6851      1          5922  2403 (NOTLB)
f6999e94 00000082 0000000a 00000001 f7f11770 00027873 8e10f662 00000049 
       f69b18f0 f69b1a7c f695b000 7fffffff f695bc64 fffffffb c030b7e5 00000000 
       ffffffff 00000000 f6999ed8 f6999ef8 00000000 f6999f3c f69c6d8c f6999f74 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c01c2327>] inode_has_perm+0x4c/0x54
 [<c021f69b>] read_chan+0x319/0xa11
 [<c021ff55>] write_chan+0x1c2/0x1d5
 [<c011b856>] default_wake_function+0x0/0xc
 [<c011b856>] default_wake_function+0x0/0xc
 [<c02195ca>] tty_read+0x140/0x1ea
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
pickup        S 00000246  2824  5271   2316          7087  2325 (NOTLB)
d354ceb0 00000086 c127cfc0 00000246 cfeb97f0 0000428f 32f517f9 00003ab7 
       f08e80b0 f08e823c 03d76956 03d76956 00000000 d354cf74 c030b886 c037d940 
       c035b048 03d76956 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c01243db>] sys_time+0xf/0x58
 [<c030cefb>] syscall_call+0x7/0xb
mgetty        S C01459C0  2764  5922      1          6438  6851 (NOTLB)
e6214eb0 00000082 c035ca9c c01459c0 00000001 0001cb89 5cfc24c7 000038ed 
       f697c130 f697c2bc 03eec231 03eec231 00000000 e6214f74 c030b886 c035b350 
       c035b350 03eec231 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c01459c0>] __alloc_pages+0xb4/0x29d
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
crond         S F786F540  3024  5980   2340  5981               (NOTLB)
d157aee8 00000086 d157af74 f786f540 c01c2327 00010b87 7ce582b9 00003951 
       f78a77f0 f78a797c f3e0e0ac d157af10 d157af04 f3e0e02c c016fc5c 00000000 
       f78a77f0 c011ceaf d157af1c d157af1c 0001b1a6 b7fff000 f3dc2e58 00000000 
Call Trace:
 [<c01c2327>] inode_has_perm+0x4c/0x54
 [<c016fc5c>] pipe_wait+0x70/0xa9
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c016febc>] pipe_readv+0x227/0x2a2
 [<c016ff53>] pipe_read+0x1c/0x20
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
run-parts     S 00000004  2600  5981   5980  6437               (NOTLB)
d11b2f28 00000082 f08e1be0 00000004 cfd1d8f0 000076ab 28d43399 00003954 
       f69b0780 f69b090c f69b0824 fffffe00 f69b0780 00000000 c0123c14 00030002 
       d11b2fc4 bfe476d4 d0ff0030 d11b2000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
awk           S F08E1BE0  3192  6437   5981                     (NOTLB)
d0809ee8 00000086 d0809f74 f08e1be0 cff6c130 000082f3 2e8bea3b 000039ae 
       d0ff0030 d0ff01bc f3e0e414 d0809f10 d0809f04 f3e0e394 c016fc5c 00000000 
       d0ff0030 c011ceaf d0809f1c d0809f1c b7fff000 d0809fc4 d0acb918 00000000 
Call Trace:
 [<c016fc5c>] pipe_wait+0x70/0xa9
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c016febc>] pipe_readv+0x227/0x2a2
 [<c016ff53>] pipe_read+0x1c/0x20
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
atom          S 00000004  2576  6438      1  6850    6440  5922 (NOTLB)
d167bf28 00000086 f3e27a00 00000004 cfeb97f0 000117de 5c2feef4 00003957 
       d0ff0600 d0ff078c d0ff06a4 fffffe00 d0ff0600 00000000 c0123c14 00030002 
       d167bfc4 bfe4a6f4 cfe54600 d167b000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
backup_local- S 00000004  2764  6440      1  6808    6441  6438 (NOTLB)
d085cf28 00000086 f10c8e40 00000004 cfeb97f0 0000fad2 4914056f 00003954 
       d08657f0 d086597c d0865894 fffffe00 d08657f0 00000000 c0123c14 00030002 
       d085cfc4 bff2e5d4 cfdc0dd0 d085c000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
backup_remote S 00000004  2764  6441      1  6727    6443  6440 (NOTLB)
d67e7f28 00000086 f1867d40 00000004 cfeb9220 0000f6a0 3e9c21e1 00003954 
       d0b26dd0 d0b26f5c d0b26e74 fffffe00 d0b26dd0 00000000 c0123c14 00030002 
       d67e7fc4 bfe5a654 cfe55770 d67e7000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
backup_remote S 00000004  2600  6443      1  6623    6449  6441 (NOTLB)
cfc1af28 00000086 f6a07520 00000004 cfeb9220 0000f0be 354885d8 00003954 
       d0864c50 d0864ddc d0864cf4 fffffe00 d0864c50 00000000 c0123c14 00030002 
       cfc1afc4 bff04774 cf9191a0 cfc1a000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
hirdet        S 00000004  2576  6449      1  6821    6451  6443 (NOTLB)
d03f0f28 00000082 f0bbd180 00000004 cfeb97f0 000117c7 4b2384c2 00003954 
       d02d0700 d02d088c d02d07a4 fffffe00 d02d0700 00000000 c0123c14 00030002 
       d03f0fc4 bff984a4 cfeb97f0 d03f0000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
mailmkk       S 00000004  2764  6451      1  6849    6452  6449 (NOTLB)
cfc58f28 00000086 f0820e60 00000004 d0b27970 00012bfd d06721be 00003956 
       cfd1d8f0 cfd1da7c cfd1d994 fffffe00 cfd1d8f0 00000000 c0123c14 00030002 
       cfc58fc4 bfe3dfd4 cf919770 cfc58000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
novell        S 00003954  2576  6452      1  6830    6453  6451 (NOTLB)
cfd11f28 00000082 5138e6ed 00003954 f6a6d1a0 00010790 5138e6ed 00003954 
       cfd1d320 cfd1d4ac cfd1d3c4 fffffe00 cfd1d320 00000000 c0123c14 00030002 
       cfd11fc4 bff9f7a4 cffc18f0 cfd11000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
pallasz       S 00000004  2576  6453      1  6831    6454  6452 (NOTLB)
cfd32f28 00000082 f18674c0 00000004 cff6c130 00010786 595d5245 00003954 
       cfd1cd50 cfd1cedc cfd1cdf4 fffffe00 cfd1cd50 00000000 c0123c14 00030002 
       cfd32fc4 bfe45824 cffc0d50 cfd32000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
tempo2        S 00000004  2576  6454      1  6829    6455  6453 (NOTLB)
cfd4df28 00000086 f39a53c0 00000004 cff6c130 0001ce28 50de794b 00003954 
       cfd1c780 cfd1c90c cfd1c824 fffffe00 cfd1c780 00000000 c0123c14 00030002 
       00000000 c0265fe7 0423e7b8 cfd4d000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c0265fe7>] start_request+0x1a0/0x1c1
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
ubul          S 00000004  2576  6455      1  7002    6456  6454 (NOTLB)
cfd69f28 00000086 f39a54a0 00000004 cf9191a0 000187b2 a8415fc5 000039e6 
       cfd1c1b0 cfd1c33c cfd1c254 fffffe00 cfd1c1b0 00000000 c0123c14 00030002 
       cfd69fc4 bfe56314 cffc01b0 cfd69000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
zeusz         S 00003954  2576  6456      1  6818    6705  6455 (NOTLB)
cfd85f28 00000086 4aaa25cb 00003954 cfdc13a0 0000fca6 4aaa25cb 00003954 
       cfdc1970 cfdc1afc cfdc1a14 fffffe00 cfdc1970 00000000 c0123c14 00030002 
       cfd85fc4 bfe2fbd4 cffc1320 cfd85000 00000001 00000004 ffffffff 00000000 
Call Trace:
 [<c0123c14>] do_wait+0x25a/0x435
 [<c011b856>] default_wake_function+0x0/0xc
 [<c012ef43>] sys_rt_sigaction+0xdd/0xf2
 [<c011b856>] default_wake_function+0x0/0xc
 [<c0123e82>] sys_wait4+0x27/0x2a
 [<c0123e98>] sys_waitpid+0x13/0x17
 [<c030cefb>] syscall_call+0x7/0xb
rdiff-backup  R running  1920  6623   6443  6838               (NOTLB)
ncpmount      S 00003AB6  3112  6705      1          6770  6456 (NOTLB)
cff28eb0 00000086 7798132f 00003ab6 cf854dd0 000009e6 7798132f 00003ab6 
       cff6d870 cff6d9fc cfded480 7fffffff 00000000 cff28f74 c030b7e5 cf9f5780 
       00000000 cff28f58 cf9f5780 cfa54c98 c017648e 00000246 00000246 d05aa800 
 schedule_timeout+0x50/0x10c schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c02ab707>] sk_wait_data+0x87/0xbb
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02d465a>] tcp_recvmsg+0x379/0x651
 [<c02abe91>] sock_common_recvmsg+0x30/0x46
 [<c02a86b6>] sock_recvmsg+0xef/0x10c
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c011adc1>] recalc_task_prio+0x128/0x133
 [<c030ad9f>] schedule+0x43f/0x552
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02a86fd>] kernel_recvmsg+0x2a/0x31
 [<f8b9cde5>] cifs_demultiplex_thread+0x11e/0x99c [cifs]
 [<f8b9ccc7>] cifs_demultiplex_thread+0x0/0x99c [cifs]
 [<c01041d9>] kernel_thread_helper+0x5/0xb
ncpmount      S 000000D0  3112  6810      1          6826  6812 (NOTLB)
d3275eb0 00000082 00000246 000000d0 cffc0d50 0000097d 77981cac 00003ab6 
       cf854dd0 cf854f5c cfee8e80 7fffffff 00000000 d3275f74 c030b7e5 cfb1fa80 
       00000000 d3275f58 cfb1fa80 cf8cdd18 c017648e 00000246 00000246 d05aa080 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c0175723>] sys_fcntl64+0x6c/0x7d
 [<c017572d>] sys_fcntl64+0x76/0x7d
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
cifsd         S 00003AAD  2340  6811      1          6812  6799 (L-TLB)
d11d6d9c 00000046 8947e102 00003aad cf919770 000005f0 2e399238 00003abc 
       cfdc13a0 cfdc152c 03d651c8 03d651c8 00000000 d11d6e14 c030b886 c035ade8 
       f04d3eb8 03d651c8 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c02ab707>] sk_wait_data+0x87/0xbb
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02ae889>] skb_copy_datagram_iovec+0x53/0x1e5
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02d465a>] tcp_recvmsg+0x379/0x651
 [<c02abe91>] sock_common_recvmsg+0x30/0x46
 [<c02a86b6>] sock_recvmsg+0xef/0x10c
 [<c0107df7>] handle_IRQ_event+0x25/0x4f
 [<f885b35e>] scsi_delete_timer+0xc/0x48 [scsi_mod]
 [<c011adc1>] recalc_task_prio+0x128/0x133
 [<c030ad9f>] schedule+0x43f/0x552
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02a86fd>] kernel_recvmsg+0x2a/0x31
 [<f8b9cde5>] cifs_demultiplex_thread+0x11e/0x99c [cifs]
 [<f8b9ccc7>] cifs_demultiplex_thread+0x0/0x99c [cifs]
 [<c01041d9>] kernel_thread_helper+0x5/0xb
cifsd         S 00003ABC  2604  6812      1          6810  6811 (L-TLB)
d1233d9c 00000046 843db3c4 00003abc cf8553a0 00000d31 5baec11c 00003abd 
       cff6d2a0 cff6d42c 03d66592 03d66592 00000000 d1233e14 c030b886 c035ae88 
       f6952eb8 03d66592 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c02ab707>] sk_wait_data+0x87/0xbb
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02ae889>] skb_copy_datagram_iovec+0x53/0x1e5
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02d465a>] tcp_recvmsg+0x379/0x651
 [<c02abe91>] sock_common_recvmsg+0x30/0x46
 [<c02a86b6>] sock_recvmsg+0xef/0x10c
 [<c011b72b>] scheduler_tick+0x37f/0x4aa
 [<c0129210>] do_timer+0x49/0xb5
 [<c010cde3>] timer_interrupt+0x9c/0x181
 [<c0107df7>] handle_IRQ_event+0x25/0x4f
 [<c0144396>] mempool_alloc+0x7b/0x1f9
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c02a86fd>] kernel_recvmsg+0x2a/0x31
 [<f8b9cde5>] cifs_demultiplex_thread+0x11e/0x99c [cifs]
 [<f8b9ccc7>] cifs_demultiplex_thread+0x0/0x99c [cifs]
 [<c01041d9>] kernel_thread_helper+0x5/0xb
rdiff-backup  D CFF83D20  1700  6818   6456                     (NOTLB)
cff83d58 00000082 00000010 cff83d20 cf8553a0 000fca76 5bf0288f 00003abd 
       cffc1320 cffc14ac 03d684d6 cff83000 cff83dac c18f1580 f8baa34b cf404380 
       00000000 00000000 f1380f80 0000d1b2 0000000f 00000000 cffc1320 c011ceaf 
Call Trace:
 autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<f88ca027>] char2uni+0xe/0x1f [nls_utf8]
 __cond_resched+0x14/0x3b
 [<f8ba6d9b>] cifs_revalidate+0x1a6/0x2d6 [cifs]
 [<f8ba2553>] cifs_d_revalidate+0xb/0x35 [cifs]
 [<c017136b>] do_lookup+0x70/0x8f
 [<c0171db7>] link_path_walk+0xa2d/0xd8c
 [<c0172391>] path_lookup+0xff/0x12f
 [<c01724d5>] __user_walk+0x21/0x51
 [<c016ca23>] vfs_lstat+0x11/0x37
 [<c016d018>] sys_lstat64+0xf/0x23
 [<c01281b0>] ptrace_setsiginfo+0x1be/0x1c0
 [<c010884e>] do_IRQ+0x239/0x242
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
rdiff-backup  R running  1476  6821   6449                     (NOTLB)
ncpmount      S 000000D0  3112  6826      1                6810 (NOTLB)
d0eb9eb0 00000082 00000246 000000d0 cfdc0230 000008ad 85dcc468 00003a71 
       cfeb8c50 cfeb8ddc cf516980 7fffffff 00000000 d0eb9f74 c030b7e5 cf516d80 
       00000000 d0eb9f58 cf516d80 cfa1d798 c017648e 00000246 00000246 cff66800 
 schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c0175723>] sys_fcntl64+0x6c/0x7d
 [<c017572d>] sys_fcntl64+0x76/0x7d
 [<c030cefb>] syscall_call+0x7/0xb
rdiff-backup  R running  1172  6829   6454                     (NOTLB)
rdiff-backup  D 00003ABD  1912  6830   6452                     (NOTLB)
cffd1eec 00000086 588b9723 00003abd f697c700 0000019a 588b9ad8 00003abd 
       cffc18f0 cffc1a7c f7fd6e00 cffd1f18 f7fd6ea4 002130fc f889e7a8 00000000 
       00000000 cffc18f0 c011ceaf cffd1f24 cffd1f24 00000000 f7fd6efc 00000003 
Call Trace:
 autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<f88985e9>] journal_stop+0x37b/0x42f [jbd]
 [<f88986b9>] journal_force_commit+0x1c/0x21 [jbd] direct_strncpy_from_user+0x3e/0x5d
 [<c01412b1>] filemap_fdatawrite+0xf/0x13
 [<c0163aec>] sys_fsync+0x95/0xd6
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
rdiff-backup  R running  1628  6831   6453                     (NOTLB)
ssh           S 00003ABD  2428  6836   6727                     (NOTLB)
dfa9aeb0 00000082 49cc20c5 00003abd cfe55770 000003ca 49cc2d68 00003abd 
       cf854230 cf8543bc cf2d7680 7fffffff 00000000 dfa9af74 c030b7e5 cf9ea698 
       c017648e 00000246 ce6cb580 dfa9af58 cf9ea698 c02d1fed 00000000 00000082 
 schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c02d1fed>] tcp_poll+0x31/0x144
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
ssh           S C035CA9C  2544  6838   6623                     (NOTLB)
e7f4eeb0 00000082 000000d0 c035ca9c cf919770 0000123e 5a529d9a 00003a82 
       cfdc0230 cfdc03bc cda89880 7fffffff 00000000 e7f4ef74 c030b7e5 cf9eac98 
       c017648e 00000246 cdf0fa80 e7f4ef58 cf9eac98 c02d1fed 000007b0 00000082 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c02d1fed>] tcp_poll+0x31/0x144
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
rdiff-backup  S F0820E60  1836  6849   6451  6867               (NOTLB)
cf8eaee8 00000086 cf8eaf74 f0820e60 cffc18f0 0003b947 f0afe825 00003abc 
       cf919770 cf9198fc cff9e5c8 cf8eaf10 cf8eaf04 cff9e548 c016fc5c 00000000 
       cf919770 c011ceaf cf8eaf1c cf8eaf1c 00000000 f6e06034 00000001 00000000 
Call Trace:
 [<c016fc5c>] pipe_wait+0x70/0xa9
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c016febc>] pipe_readv+0x227/0x2a2
 [<c016ff53>] pipe_read+0x1c/0x20
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
rdiff-backup  R running  2120  6850   6438  6869               (NOTLB)
ssh           S C035CA9C  2340  6867   6849                     (NOTLB)
e6f9eeb0 00000082 000000d0 c035ca9c cffc18f0 000047cb f0f80be1 00003abc 
       cf918bd0 cf918d5c ccc19c80 7fffffff 00000000 e6f9ef74 c030b7e5 cf9ea898 
       c017648e 00000246 ce6cb080 e6f9ef58 cf9ea898 c02d1fed 000003d8 00000082 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c02d1fed>] tcp_poll+0x31/0x144
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
ssh           S 0000395D  2648  6869   6850                     (NOTLB)
c32e5eb0 00000086 2095eedb 0000395d cfe54600 000051e3 20960484 0000395d 
       cfeb80b0 cfeb823c c59eda80 7fffffff 00000000 c32e5f74 c030b7e5 cda78318 
       c017648e 00000246 f0b43080 c32e5f58 cda78318 c02d1fed 00000000 00000082 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c02d1fed>] tcp_poll+0x31/0x144
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
rdiff-backup  S F39A54A0  2008  7002   6455  7003               (NOTLB)
f57c8ee8 00000082 f57c8f74 f39a54a0 cf8553a0 000002dd 5a3b5875 00003abd 
       cffc01b0 cffc033c f7cab77c f57c8f10 f57c8f04 f7cab6fc c016fc5c 00000000 
       cffc01b0 c011ceaf f57c8f1c f57c8f1c 00000000 00000000 f5393a18 00000000 
Call Trace:
 [<c016fc5c>] pipe_wait+0x70/0xa9
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c011ceaf>] autoremove_wake_function+0x0/0x2d
 [<c016febc>] pipe_readv+0x227/0x2a2
 [<c016ff53>] pipe_read+0x1c/0x20
 [<c01620b2>] vfs_read+0xb6/0xe2
 [<c01622c5>] sys_read+0x3c/0x62
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
ssh           S 00003ABD  2604  7003   7002                     (NOTLB)
c63f8eb0 00000082 5a3b2f32 00003abd cffc01b0 00000500 5a3b3bd2 00003abd 
       cfe54030 cfe541bc cfaf5d80 7fffffff 00000000 c63f8f74 c030b7e5 e9770598 
       c017648e 00000246 cf886a80 c63f8f58 e9770598 c02d1fed 000003d8 00000082 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c02d1fed>] tcp_poll+0x31/0x144
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
proxymap      S 00000246  2276  7087   2316          7088  5271 (NOTLB)
e155feb0 00000082 c10841a0 00000246 cf9191a0 00001ef1 3982b7ea 00003aa6 
       cfa0c680 cfa0c80c ce771480 7fffffff 00000000 e155ff74 c030b7e5 00000001 
       f0524380 00000000 e155ff58 f0524380 f0528718 c017648e 00000246 cff66300 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
trivial-rewri S 00000246  2276  7088   2316          7128  7087 (NOTLB)
f0e43eb0 00000082 c105f3e0 00000246 f08e8c50 00000896 3e4abd9a 00003aa6 
       cfa0cc50 cfa0cddc cddada80 7fffffff 00000000 f0e43f74 c030b7e5 00000001 
       f6946c80 00000000 f0e43f58 f6946c80 f051c118 c017648e 00000246 f0b4c300 
Call Trace:
 [<c030b7e5>] schedule_timeout+0x50/0x10c
 [<c017648e>] __pollwait+0x2d/0x94
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
smtpd         S 00003AA6  2196  7128   2316          7129  7088 (NOTLB)
d2e70eb0 00000082 3ed0320a 00003aa6 f780a1b0 000136ff 3ed291b3 00003aa6 
       f08e8680 f08e880c 03d64c63 03d64c63 00000000 d2e70f74 c030b886 cb2eeeb8 
       f6966f54 03d64c63 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c01243db>] sys_time+0xf/0x58
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
cleanup       S 00000246  2276  7129   2316          7130  7128 (NOTLB)
cb2eeeb0 00000082 c1376f40 00000246 cffc01b0 0000558e 3ed5b624 00003aa6 
       f08e8c50 f08e8ddc 03d64c64 03d64c64 00000000 cb2eef74 c030b886 f7f28f4c 
       d2e70eb8 03d64c64 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c01243db>] sys_time+0xf/0x58
 [<c030cefb>] syscall_call+0x7/0xb
 [<c030007b>] xfrm_state_flush+0x2/0x289
local         S 00003AA6  2364  7130   2316                7129 (NOTLB)
eb6a9eb0 00000086 affc3a08 00003aa6 cf854230 0000532f affc3a08 00003aa6 
       d0b26800 d0b2698c 03d653d1 03d653d1 00000000 eb6a9f74 c030b886 c035adf8 
       c035adf8 03d653d1 1d244b3c 00000000 00000005 c031a0b5 c031c25c 000000a8 
Call Trace:
 [<c030b886>] schedule_timeout+0xf1/0x10c
 [<c0129336>] process_timeout+0x0/0x5
 [<c01768e1>] do_select+0x347/0x378
 [<c0176461>] __pollwait+0x0/0x94
 [<c0176c05>] sys_select+0x2e0/0x43a
 [<c01243db>] sys_time+0xf/0x58
 [<c030cefb>] syscall_call+0x7/0xb
Mem-info:
DMA per-cpu:
cpu 0 hot: low 2, high 6, batch 1
cpu 0 cold: low 0, high 2, batch 1
Normal per-cpu:
cpu 0 hot: low 32, high 96, batch 16
cpu 0 cold: low 0, high 32, batch 16
HighMem per-cpu:
cpu 0 hot: low 16, high 48, batch 8
cpu 0 cold: low 0, high 16, batch 8

Free pages:      331372kB (256kB HighMem)
Active:62682 inactive:102899 dirty:25948 writeback:0 unstable:0 free:82843 slab:5921 mapped:29439 pagetables:474
DMA free:1276kB min:16kB low:32kB high:48kB active:3884kB inactive:7156kB present:16384kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
Normal free:329840kB min:936kB low:1872kB high:2808kB active:175308kB inactive:349000kB present:901120kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
HighMem free:256kB min:128kB low:256kB high:384kB active:71536kB inactive:55440kB present:131072kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
DMA: 213*4kB 47*8kB 1*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1276kB
Normal: 0*4kB 19006*8kB 8122*16kB 1377*32kB 47*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 329840kB
HighMem: 0*4kB 0*8kB 0*16kB 4*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 256kB
Swap cache: add 40, delete 40, find 0/0, race 0+0
Free swap:       2108440kB
262144 pages of RAM
32768 pages of HIGHMEM
3192 reserved pages
56867 pages shared
0 pages swap cached



--------------000200090205010205040707--

