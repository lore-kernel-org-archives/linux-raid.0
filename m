From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Unable to handle kernel NULL pointer dereference with 2.4.27
Date: Tue, 30 Nov 2004 11:53:11 +1100
Message-ID: <16811.50295.566088.579804@cse.unsw.edu.au>
References: <87653oimzy.fsf@wide.bouthors.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Cyril Bouthors on Monday November 29
Sender: linux-raid-owner@vger.kernel.org
To: Cyril Bouthors <cyril@bouthors.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 29, cyril@bouthors.org wrote:
> Hi,
> 
> I'm having this error several times a month on a heavy loaded production NFS server with RAID0:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000020
>  printing eip:
> f884488e
> *pde = 00000000
> Oops: 0002
> CPU:    0
> EIP:    0010:[raid0:__insmod_raid0_O/lib/modules/2.4.27-1-686/kernel/drivers/md+-235378/96]    Not tainted
> EFLAGS: 00010202
> eax: f884d6a0   ebx: efd32600   ecx: 00000000   edx: 00000020
> esi: efd32600   edi: c2825f5c   ebp: 00001ee2   esp: c2825f1c
> ds: 0018   es: 0018   ss: 0018
> Process kswapd (pid: 4, stackpage=c2825000)
> Stack: efd32600 efd32600 c0153734 efd32600 efd32608 c015379d efd32600 f421cc28
>        c0150018 c3581408 c35817c0 c35817c8 00000000 c0153a24 c2825f5c 00015d9c
>        efd32428 f50ebdc8 000001d0 0000003c 00000015 c025d478 c0153bb4 00015d9c
> Call Trace:    [clear_inode+196/224] [dispose_list+77/176] [__get_lease+488/608] [prune_icache+100/464] [shrink_icache_memory+36/64]
>   [try_to_free_pages_zone+143/256] [kswapd_balance_pgdat+102/176] [kswapd_balance+40/64] [kswapd+152/185] [_stext+0/64] [arch_kernel_thread+46/64]
>   [kswapd+0/185]
> 
> Code: ff 0a 0f 94 c0 84 c0 75 44 ba ff ff ff ff 89 93 8c 01 00 00
>  <5>__alloc_pages: 0-order allocation failed (gfp=0xf0/0)
> 
> I'm running 2.4.27 compiled with Debian Sid options from the
> kernel-image-2.4.27-1-686 package.
> 
> Is this a bug in raid0.c ?

No.  The reference to raid0 is purely accidental - the offset into
raid0 that is mentioned is -235378 : a negative number !!!!

> 
> Is there a way to fix this?

I suspect that it is a filesystem problem.
I recommend reporting the problem to linux-kernel@vger.kernel.org and
mentioning what filesystem you are using.

NeilBrown

> 
> Thanks.
> -- 
> Cyril Bouthors
