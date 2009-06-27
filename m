From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: Strange issue with async_xor
Date: Sat, 27 Jun 2009 15:14:22 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07A31D40@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07A31CA0@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07A31CA0@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>, linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

What I noticed is when  dma_map_page() function called in do_async_xor()
it causing **src_list getting corrupted. Look like d-cache flush is
causing some issue.
Thanks,
Marri


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tirumala Reddy
Marri
Sent: Friday, June 26, 2009 11:35 AM
To: linux-raid@vger.kernel.org
Cc: Dan Williams
Subject: Strange issue with async_xor

All,
  I am using not open sourced(will open source it in future)ADMA driver
for PowerPC procerror.  I tried to upgrade to newer kernel to get all
latest MD and async changes. I see  some arguments are messed up between
do_async_xor() and ppc4xx_adma_prep_dma_mq_xor(). From the code I see
same number of arguments. But when I step through debugger src_cnt & len
arguments got corrupted. Is anything changed with async_xor() or
dmaengine.c ?
I Looked at Dan williams driver and everything looks ok. Any ideas ?

Regards,
Marri


(gdb)  bt
#0  ppc460ex_adma_prep_dma_mq_xor (chan=0xdd61c4a4, dst=0x5af7, src=0x0,
src_cnt=492167168, len=3714768144, flags=3) at
drivers/dma/ppc460ex-adma.c:3113
#1  0xc01196e4 in async_xor (dest=<value optimized out>,
src_list=0xdd6addbc, offset=<value optimized out>, src_cnt=3, len=4096, 
    flags=ASYNC_TX_XOR_ZERO_DST, depend_tx=0x0, cb_fn=0xc01e42a8
<ops_complete_compute>, cb_param=0xd8986000) at
crypto/async_tx/async_xor.c:93
#2  0xc01e4bac in ops_run_compute5 (sh=<value optimized out>) at
drivers/md/raid5.c:641
#3  0xc01e6240 in raid_run_ops (sh=0xd8986000, ops_request=2) at
drivers/md/raid5.c:1147
#4  0xc01e6734 in handle_stripe5 (sh=0xd8986000) at
drivers/md/raid5.c:2945
#5  0xc01e786c in handle_stripe (sh=0xdd61c4a4, tmp_page=0x5af7) at
drivers/md/raid5.c:3233
#6  0xc01e8a44 in raid5d (mddev=0xdd74e800) at drivers/md/raid5.c:4082
#7  0xc01f4908 in md_thread (arg=<value optimized out>) at
drivers/md/md.c:5295
#8  0xc00386c8 in kthread (_create=<value optimized out>) at
kernel/kthread.c:83
#9  0xc000da8c in kernel_thread ()
Backtrace stopped: previous frame inner to this frame (corrupt stack?)
(gdb) p *src_list
No symbol "src_list" in current context.
(gdb) f 1
#1  0xc01196e4 in async_xor (dest=<value optimized out>,
src_list=0xdd6addbc, offset=<value optimized out>, src_cnt=3, len=4096, 
    flags=ASYNC_TX_XOR_ZERO_DST, depend_tx=0x0, cb_fn=0xc01e42a8
<ops_complete_compute>, cb_param=0xd8986000) at
crypto/async_tx/async_xor.c:93
93                      tx = dma->device_prep_dma_xor(chan, dma_dest,
&dma_src[src_off],
(gdb) p *src_list
$13 = (struct page *) 0xe
(gdb)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
