From: stef@chronozon.artofdns.com (Stef Telford)
Subject: Re: 2.5.62 oops and Raid-5
Date: Mon, 17 Feb 2003 19:19:30 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030218001930.AFB21457CC@chronozon.artofdns.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au, stef@chronozon.artofdns.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ah, silly me, should have done that in the first place.
apologies.


----

Unable to handle kernel NULL pointer dereference at virtual address 00000000
 00000000
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0060:[<00000000>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010046
eax: 00000000   ebx: cfd904ac   ecx: cfd905d0   edx: 00000000
esi: cffe8880   edi: cfd90584   ebp: c12ba000   esp: c12bbf4c
ds: 007b   es: 007b   ss: 0068
Stack: c0267f47 cfd904ac cfd90588 c012c403 cfd904ac cffe8884 c12ba000 cfd904ac
       c0267f50 cffe8884 cffe8880 c1299fa8 cffe888c c012c078 cffe8880 c12bbfa0
       00000000 00000000 c12ba000 c12ba000 c12ba000 00000001 00000000 c0119fd0
Call Trace: [<c0267f47>]  [<c012c403>]  [<c0267f50>]  [<c012c078>]  [<c0119fd0>]  [<c0119fd0>]  [<c012beb0>]  [<c0108d39>]
Code:  Bad EIP value.
 
 
>>EIP; 00000000 Before first symbol
 
>>ebx; cfd904ac <__crc_isapnp_read_dword+199265/34390f>
>>ecx; cfd905d0 <__crc_isapnp_read_dword+199389/34390f>
>>esi; cffe8880 <__crc_ip_cmsg_recv+6ff9f/15d343>
>>edi; cfd90584 <__crc_isapnp_read_dword+19933d/34390f>
>>ebp; c12ba000 <__crc_memcpy_tokerneliovec+5bf78/23058d>
>>esp; c12bbf4c <__crc_memcpy_tokerneliovec+5dec4/23058d>
 
Trace; c0267f47 <generic_unplug_device+77/80>
Trace; c012c403 <run_workqueue+73/e0>
Trace; c0267f50 <blk_unplug_work+0/10>
Trace; c012c078 <worker_thread+1c8/200>
Trace; c0119fd0 <default_wake_function+0/20>
Trace; c0119fd0 <default_wake_function+0/20>
Trace; c012beb0 <worker_thread+0/200>
Trace; c0108d39 <kernel_thread_helper+5/c>


----
