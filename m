From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Strange Kernel Problem
Date: Thu, 29 May 2003 13:35:57 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16085.32797.864513.862357@notabene.cse.unsw.edu.au>
References: <5.1.1.6.2.20030528210447.04056b20@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maurice Hilarius on Wednesday May 28
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 28, maurice@harddata.com wrote:
> Does anyone recognize what is happening here?
> 
> Thoughts and suggestions appreciated..
> 

It would appear that generic_make_request has jumped to a function
pointer with is NULL.
The two possibilities are bh->b_end_io and q->make_request_fn

There would have been kernel log messages:
   attempt to access beyond end of device ....

in the first case, so I suspect q->make_request_fn, however unlikely
that might be.

What is the device underneath the raid array?

NeilBrown

> >Unable to handle kernel NULL pointer dereference at virtual address 00000000
> >printing eip:
> >00000000
> >*pde = 00000000
> >Oops: 0000
> >autofs e100 e1000 ipt_REJECT iptable_filter ip_tables keybdev mousedev hid 
> >input usb-uhci usbcore ext3 jbd raid5 xor raid1 3w-xxxx aic79xx sd_mod 
> >scsi_mod
> >CPU:    1
> >EIP:    0060:[<00000000>]    Not tainted
> >EFLAGS: 00010286
> >
> >EIP is at [unresolved] (2.4.20-9smp)
> >eax: c04467a0   ebx: f631ea98   ecx: 00000000   edx: 00000000
> >esi: f6347004   edi: 00000000   ebp: f885d8b0   esp: e2ea3ce0
> >ds: 0068   es: 0068   ss: 0068
> >Process ls (pid: 9720, stackpage=e2ea3000)
> >Stack: c01b4d0a c04467a0 00000000 f631ea98 e2ea3d08 00100010 f631ea98 f6347004
> >       d31ffc40 c54b6480 f885dc0b 00000000 f631ea98 00000060 c0149135 00000000
> >       f37b63c0 f631ea80 c1130c20 c1130c20 00000000 00020002 d31ffc40 00000008
> >Call Trace:   [<c01b4d0a>] generic_make_request [kernel] 0xda (0xe2ea3ce0))
> >[<f885dc0b>] raid1_make_request [raid1] 0xfb (0xe2ea3d08))
> >[<c0149135>] __alloc_pages [kernel] 0x95 (0xe2ea3d18))
> >[<c01fbc42>] md_make_request [kernel] 0x82 (0xe2ea3d48))
> >[<c01b4d0a>] generic_make_request [kernel] 0xda (0xe2ea3d5c))
> >[<c01b4db7>] submit_bh [kernel] 0x57 (0xe2ea3d84))
> >[<c01b4f16>] ll_rw_block [kernel] 0xf6 (0xe2ea3da0))
> >[<c0154f1c>] bread [kernel] 0x4c (0xe2ea3dc8))
> >[<f8881d3b>] ext3_get_inode_loc [ext3] 0xfb (0xe2ea3ddc))
> >[<f8881e0b>] ext3_read_inode [ext3] 0x1b (0xe2ea3e08))
> >[<c016b1d0>] alloc_inode [kernel] 0xc0 (0xe2ea3e20))
> >[<c016c67a>] get_new_inode [kernel] 0x17a (0xe2ea3e3c))
> >[<c016c8ba>] iget4 [kernel] 0x10a (0xe2ea3e64))
> >[<f88836ec>] ext3_lookup [ext3] 0x7c (0xe2ea3e8c))
> >[<c015f12c>] real_lookup [kernel] 0xec (0xe2ea3eac))
> >[<c015f75a>] link_path_walk [kernel] 0x45a (0xe2ea3ecc))
> >[<c015fca9>] path_lookup [kernel] 0x39 (0xe2ea3f0c))
> >[<c015fff9>] __user_walk [kernel] 0x49 (0xe2ea3f1c))
> >[<c015b1af>] vfs_lstat [kernel] 0x1f (0xe2ea3f38))
> >[<c015b80b>] sys_lstat64 [kernel] 0x1b (0xe2ea3f70))
> >[<c011c200>] do_page_fault [kernel] 0x0 (0xe2ea3fb0))
> >[<c01099c0>] error_code [kernel] 0x34 (0xe2ea3fb8))
> >[<c01098cf>] system_call [kernel] 0x33 (0xe2ea3fc0))
> 
> 
> With our best regards,
> 
> Maurice W. Hilarius       Telephone: 01-780-456-9771
> Hard Data Ltd.               FAX:       01-780-456-9772
> 11060 - 166 Avenue        mailto:maurice@harddata.com
> Edmonton, AB, Canada      http://www.harddata.com/
>     T5X 1Y3
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
