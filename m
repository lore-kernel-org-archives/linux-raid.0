From: Alex Izvorski <aizvorski@gmail.com>
Subject: raid5 high cpu usage during reads - oprofile results
Date: Sat, 25 Mar 2006 00:38:20 -0800
Message-ID: <1143275900.8573.116.camel@starfire>
References: <1143240438.8573.59.camel@starfire>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1143240438.8573.59.camel@starfire>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I profiled some raid5 reads using oprofile to try to track down the
suspiciously high cpu load I see.  This uses the same 8-disk SATA setup
as I had described earlier.  One of runs is on a 1MB chunk raid5, the
other on a 32MB chunk raid5.  As Neil suggested memcpy is a big part of
the cpu load.  The rest of it apprears to be in handle_stripe and
get_active_stripe - these three account for most of the load, with the
remainder fairly evenly distributed among a dozen other routines.  If
using a large chunk size, handle_stripe and get_active_stripe will
predominate (and result in some truly abnormal cpu loads).  I am
attaching annotated (from opannotate) source and assembly for raid5.c
from the second (32MB chunk) run.   The annotated results do not make
much sense to me, but I suspect that the exact line numbers etc may be
shifted slightly as usually happens with optimized builds.  I hope this
would be useful.

Regards,
--Alex 

P.S. I had originally mailed the oprofile results as attachments to the 
list, but I think they didn't go through.  I put them at:
 http://linuxraid.pastebin.com/621363 - oprofile annotated assembly
 http://linuxraid.pastebin.com/621364 - oprofile annotated source
Sorry if you get this email twice.


-----------------------------------------------------------------------
mdadm --create /dev/md0 --level=raid5 --chunk=1024 --raid-devices=8 \
 --size=10485760 /dev/sd[abcdefgh]1
echo "8192" > /sys/block/md0/md/stripe_cache_size
./test_aio -f /dev/md0 -T 10 -s 60G -r 8M -n 14
throughput 205MB/s, cpu load 40%

opreport --symbols --image-path=/lib/modules/2.6.15-gentoo-r7/kernel/ 
samples  %        image name app name   symbol name
91839    42.9501  vmlinux    vmlinux    memcpy
25946    12.1341  raid5.ko   raid5      handle_stripe
17732     8.2927  raid5.ko   raid5      get_active_stripe
5454      2.5507  vmlinux    vmlinux    blk_rq_map_sg
4850      2.2682  vmlinux    vmlinux    __delay
4726      2.2102  raid5.ko   raid5      raid5_compute_sector
4588      2.1457  raid5.ko   raid5      copy_data
4389      2.0526  raid5.ko   raid5      .text
4362      2.0400  raid5.ko   raid5      make_request
3688      1.7248  vmlinux    vmlinux    clear_page
3548      1.6593  raid5.ko   raid5      raid5_end_read_request
2594      1.2131  vmlinux    vmlinux    blk_recount_segments
1944      0.9091  vmlinux    vmlinux    generic_make_request
1627      0.7609  vmlinux    vmlinux    dma_map_sg
1555      0.7272  vmlinux    vmlinux    get_user_pages
1540      0.7202  libata.ko  libata     ata_bmdma_status
1464      0.6847  vmlinux    vmlinux    __make_request
1350      0.6314  vmlinux    vmlinux    follow_page
1098      0.5135  vmlinux    vmlinux    finish_wait
...(others under 0.5%)
-----------------------------------------------------------------------

mdadm --create /dev/md0 --level=raid5 --chunk=32678 --raid-devices=8 \
 --size=10485760 /dev/sd[abcdefgh]1
echo "16384" > /sys/block/md0/md/stripe_cache_size
./test_aio -f /dev/md0 -T 10 -s 60G -r 8M -n 14
throughput 207MB/s, cpu load 80%

opreport --symbols --image-path=/lib/modules/2.6.15-gentoo-r7/kernel/ 
samples  %        image name app name   symbol name
112441   28.2297  raid5.ko   raid5      get_active_stripe
86826    21.7988  vmlinux    vmlinux    memcpy
78688    19.7556  raid5.ko   raid5      handle_stripe
18796     4.7190  raid5.ko   raid5      .text
13301     3.3394  raid5.ko   raid5      raid5_compute_sector
8339      2.0936  raid5.ko   raid5      make_request
5881      1.4765  vmlinux    vmlinux    blk_rq_map_sg
5463      1.3716  raid5.ko   raid5      raid5_end_read_request
4269      1.0718  vmlinux    vmlinux    __delay
4131      1.0371  raid5.ko   raid5      copy_data
3531      0.8865  vmlinux    vmlinux    clear_page
2964      0.7441  vmlinux    vmlinux    blk_recount_segments
2617      0.6570  vmlinux    vmlinux    get_user_pages
2025      0.5084  vmlinux    vmlinux    dma_map_sg
...(others under 0.5%)
-----------------------------------------------------------------------



