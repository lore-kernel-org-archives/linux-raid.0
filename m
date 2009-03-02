From: saeed bishara <saeed.bishara@gmail.com>
Subject: Net DMA crash when using the mv_xor driver
Date: Mon, 2 Mar 2009 18:27:24 +0200
Message-ID: <c70ff3ad0903020827s421a52bak964df6dd013722f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, Nicolas Pitre <nico@cam.org>
List-Id: linux-raid.ids

Hi Dan,
    The log below show a kernel crash when using the mv_xor dma engine
and enabling the NET_DMA, the test that I run is iperf as server.
after doing some experiences, I found that the reason is because this
engine doesn't support requests less than 16 bytes, the driver returns
NULL when the request len is too short.
is this the right thing do when the prepare function needs to reject a request?
if yes, then I think we have some issue in the NET DMA or dmaengine layers.

I'm using version 2.6.29-rc5
here is the log:

mv_xor mv_xor.0: mv_xor_prep_dma_memcpy dest: 7cf5000 src 7b30604 len:
8 flags: 2
mv_xor mv_xor.0: intr cause 3
mv_xor mv_xor.0: mv_xor_device_clear_eoc_cause, val 0x00000002
mv_xor mv_xor.0: __mv_xor_slot_cleanup 395
mv_xor mv_xor.0: current_desc 79c9340
mv_xor mv_xor.0: mv_xor_clean_completed_slots 355
mv_xor mv_xor.0: mv_xor_clean_slot 372: desc c79ef880 flags 2
mv_xor mv_xor.0: mv_xor_free_slots 254 slot c79ef880
mv_xor mv_xor.0: mv_xor_prep_dma_memcpy dest: 7cf55bc src 7b31858 len:
892 flags: 2
mv_xor mv_xor.0: mv_xor_prep_dma_memcpy sw_desc c79ef980 async_tx c79ef9b4
mv_xor mv_xor.0: mv_xor_tx_submit sw_desc c79ef980: async_tx c79ef9b4
mv_xor mv_xor.0: mv_xor_start_new_chain 269: sw_desc c79ef980
mv_xor mv_xor.0:  activate chan.
mv_xor mv_xor.0: intr cause 3
mv_xor mv_xor.0: mv_xor_device_clear_eoc_cause, val 0x00000002
mv_xor mv_xor.0: __mv_xor_slot_cleanup 395
mv_xor mv_xor.0: current_desc 79c9380
mv_xor mv_xor.0: mv_xor_clean_completed_slots 355
mv_xor mv_xor.0: mv_xor_clean_slot 372: desc c79ef980 flags 2
mv_xor mv_xor.0: mv_xor_free_slots 254 slot c79ef980
kernel BUG at arch/arm/mm/dma-mapping.c:495!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7b68000
[00000000] *pgd=07b2e031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.29-rc5-00225-g0b30bf2-dirty #287)
PC is at __bug+0x20/0x2c
LR is at preempt_schedule+0x48/0x68
pc : [<c002a8c0>]    lr : [<c02ad2e0>]    psr: 60000013
sp : c7b5bbd0  ip : c7b5bb10  fp : c7b5bbdc
r10: c79a94b8  r9 : fffffff7  r8 : c79c4b20
r7 : 00000001  r6 : c03bcd34  r5 : 07b01858  r4 : 726f6261
r3 : 00000000  r2 : c7b5a000  r1 : c7a78b60  r0 : 00000030
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: a005317f  Table: 07b68000  DAC: 00000015
Process iperf (pid: 289, stack limit = 0xc7b5a268)
Stack: (0xc7b5bbd0 to 0xc7b5c000)
bbc0:                                     c7b5bbec c7b5bbe0 c002cb50 c002a8b0
bbe0: c7b5bc24 c7b5bbf0 c0213308 c002cadc c02b19ac c02b1924 c7b46180 fffffff7
bc00: c7b5bef8 000fecd8 00000001 000005b4 c79a9540 c7b01858 c7b5bc64 c7b5bc28
bc20: c0213844 c02132b8 fffffff7 00000000 c7b5bef0 c79a94b8 c7b5a000 000005b4
bc40: 000005b4 00000000 000005b4 00000930 c79cf300 0001f6d0 c7b5bcac c7b5bc68
bc60: c023dcfc c0213780 000005b4 c7b5bed4 c7b5bef0 c7b5bef0 c79a94b8 c79cf300
bc80: 000005b4 c7b78440 c79cf300 000005b4 00000000 00000930 00000000 0001f6d0
bca0: c7b5bd0c c7b5bcb0 c0256550 c023dca8 000005b4 c79a9540 c7b5bed4 c7b786d4
bcc0: 00000001 c7a78000 00000000 c7b5a000 00000000 00000000 7fffffff 00000000
bce0: 00000000 c038d240 00000000 c7b5bed4 c7b5bd94 c7a78000 00020000 c7b5bed4
bd00: c7b5bd44 c7b5bd10 c02228ac c0255f6c 00000000 00000000 c7b5bd24 c016a010
bd20: c0391140 00000000 00000001 00000000 00000000 c7417160 c7b5be4c c7b5bd48
bd40: c0220bd0 c0222874 00000000 dd9dc080 00989646 c7a78b60 00000000 00000001
bd60: ffffffff 00000000 00000000 00000000 00000000 00000000 c7a78000 c7b5bd88
bd80: 00000000 00000000 00000001 c7a78000 c005b82c c7b5bd94 c7b5bd94 00000000
bda0: c7b5bddc c7b5bdb0 c7b5bde0 c02b1714 c7b5bdec 20000093 c7b46180 c7b59e54
bdc0: c7b59e24 00000000 00000001 c7b59e30 c7b5bdec c7b5bde0 c0040e2c c0040c58
bde0: c7b5be1c c7b5bdf0 00000000 00020000 c7417160 c7b59e30 00000000 c7b5bed4
be00: c7b5be2c c7b5be10 c00a71f8 c02b1714 c7b5befc 00020000 c7b5bef8 00000066
be20: c7b5be4c 00000000 00020000 41ad5008 c7417160 c7b5be54 c7b5a000 00000000
be40: c7b5bf24 c7b5be50 c0221b18 c0220b1c c0397cbc 00000001 c7b5bea4 c7b5be68
be60: c0068c40 c00682a4 00000000 00000000 00000000 0001c000 c7b46180 00000b06
be80: c7b5bec4 00000000 00000000 00000000 00000001 c002718c c7b5bf44 c7b5bea8
bea0: c00699cc c0068b24 00000000 c7a78000 c7b5becc 00000001 00000001 c016a86c
bec0: c7b5bf04 c7b5bed0 c02b15c4 c005fad0 00100077 c7b5be54 00000080 c7b5bef0
bee0: 00000001 00000000 00000000 00004388 41af5008 00000000 00000001 fffffff7
bf00: 00000000 0000000a 41ad4520 00000066 c002718c 00900066 c7b5bf3c c7b5bf28
bf20: c0221b90 c0221aa0 00000000 00000000 c7b5bf74 c7b5bf40 c0222028 c0221b80
bf40: c006a3fc c0069900 00000004 41ad5008 00020000 00000000 c0064068 00000001
bf60: 0003d578 0003d578 c7b5bfa4 c7b5bf78 c002c8cc c0221eb0 0003d960 00000000
bf80: 0003dac8 0003d578 000000f0 c002718c c7b5a000 009000f0 00000000 c7b5bfa8
bfa0: c0026960 c002c74c 0003d578 0003d578 0000000a 41ad3f60 41ad4578 00000002
bfc0: 0003d578 0003d578 41ad4520 401bd164 00000001 401aca74 0003d480 0003d468
bfe0: 00000000 41ad3f5c 401b1960 401b23c4 80000010 0000000a 004d4031 004d4431
Backtrace:
[<c002a8a0>] (__bug+0x0/0x2c) from [<c002cb50>] (dma_cache_maint+0x84/0xb4)
[<c002cacc>] (dma_cache_maint+0x0/0xb4) from [<c0213308>]
(dma_async_memcpy_buf_to_pg+0x60/0x10c)
[<c02132a8>] (dma_async_memcpy_buf_to_pg+0x0/0x10c) from [<c0213844>]
(dma_memcpy_to_iovec+0xd4/0x134)
[<c0213770>] (dma_memcpy_to_iovec+0x0/0x134) from [<c023dcfc>]
(dma_skb_copy_datagram_iovec+0x64/0x1d0)
[<c023dc98>] (dma_skb_copy_datagram_iovec+0x0/0x1d0) from [<c0256550>]
(tcp_recvmsg+0x5f4/0xb44)
[<c0255f5c>] (tcp_recvmsg+0x0/0xb44) from [<c02228ac>]
(sock_common_recvmsg+0x48/0x5c)
[<c0222864>] (sock_common_recvmsg+0x0/0x5c) from [<c0220bd0>]
(sock_recvmsg+0xc4/0xe4)
 r6:c7417160 r5:00000000 r4:00000000
[<c0220b0c>] (sock_recvmsg+0x0/0xe4) from [<c0221b18>] (sys_recvfrom+0x88/0xe0)
[<c0221a90>] (sys_recvfrom+0x0/0xe0) from [<c0221b90>] (sys_recv+0x20/0x28)
[<c0221b70>] (sys_recv+0x0/0x28) from [<c0222028>] (sys_socketcall+0x188/0x208)
[<c0221ea0>] (sys_socketcall+0x0/0x208) from [<c002c8cc>]
(sys_oabi_socketcall+0x190/0x1a0)
 r5:0003d578 r4:0003d578
[<c002c73c>] (sys_oabi_socketcall+0x0/0x1a0) from [<c0026960>]
(ret_fast_syscall+0x0/0x2c)
Code: e1a01000 e59f000c eb006ed9 e3a03000 (e5833000)
---[ end trace 6fe986738d85c960 ]---
