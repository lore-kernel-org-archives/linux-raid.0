From: Eurijk <eurijk@zefga.net>
Subject: Re: Raid 5 on 2.5.50/2.5.51, dirty array, kernel panic
Date: Thu, 12 Dec 2002 00:08:20 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021212000820.5ceca83b.eurijk@zefga.net>
References: <20021210233443.48053fe3.eurijk@zefga.net>
	<3DF7847D.1050606@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3DF7847D.1050606@mvista.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Please run the dump through ksymoops -m System.map.  Without this, its 
> quite difficult to tell where the failure occured.

I appear unable to link ksymoops :(, perhaps I can do something similar by hand... (see below)

Let me know, Thanks

-eurijk!

=== BREAK ===

eip c0289977              => c0289960 t make_request
EIP:	0060:[<c0289977>] => c0289880 t raid5_unplug_device

Call Trace Function Reference:
[<c014c90b>] c014c8a0 t bvec_alloc
[<c0249adc>] c02499c0 T generic_make_request
[<c0249b9d>] c0249b60 T submit_bio
[<c0149359>] c0149300 t __bread_slow
[<c01495c8>] c0149590 T __bread

[<c017d9d3>] c017d920 t ext2_fill_super
[<c01deeef>] c01deed0 T sprintf
[<c014dce5>] c014dcc0 T sb_set_blocksize
[<c014d613>] c014d400 T get_sb_bdev
[<c0160eec>] c0160e50 T alloc_vfsmnt
[<c017e46f>] c017e440 t ext2_get_sb

[<c017d920>] c017d920 t ext2_fill_super
[<c014d86f>] c014d810 T do_kern_mount
[<c0162125>] c0162090 t do_add_mount
[<c0162440>] c01622e0 T do_mount
[<c01e0ffc>] c01e0fb0 T copy_from_user
[<c0162828>] c0162760 T sys_mount

[<c010524b>] c01051e0 T prepare_namespace
[<c010507f>] c0105040 t init
[<c0105040>] c0105040 t init
[<c0107249>] c0107244 t kernel_thread_helper

=== BREAK ===

Unable to handle kernel NULL pointer dereference at virtual address 00000088 printing eip:
c0289977
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0060:[<c0289977>]    Not tainted
EFLAGS: 00010292
eax: f7d3a200   ebx: f7cfd660   ecx: c19e9680   edx: 00000000
esi: 00000002   edi: 00000000   ebp: f7fb09e0   esp: f7f9fd58
ds: 0068   es: 0068   ss: 0068
Process swapper (pid: 1, threadinfo=f7f9e000 task=f7f9c040)
Stack: f7f9fd54 f7f9fd78 00000000 00000000 f7fb09e0 00000000 00000000 00000010
       c014c90b f7ffee40 00000010 f7cfd660 00000002 f7d3a2a8 f7fb09e0 c0249adc
       f7d3a2a8 f7fb09e0 00000010 00000001 f7f9fdac 00000000 f7ff87f0 00000000
Call trace: [<c014c90b>] [<c0249adc>] [<c0249b9d>] [<c0149359>] [<c01495c8>]
[<c017d9d3>] [<c01deeef>] [<c014dce5>] [<c014d613>] [<c0160eec>] [<c017e46f>]
[<c017d920>] [<c014d86f>] [<c0162125>] [<c0162440>] [<c01e0ffc>] [<c0162828>]
[<c010524b>] [<c010507f>] [<c0105040>] [<c0107249>]
Code: 8b 87 88 00 00 00 89 44 24 20 48 89 44 24 1c 8b 55 00 8b 45
 <0>Kernel panic: Attempted to kill init!

