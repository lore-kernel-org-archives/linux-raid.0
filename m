From: Ivan Vasilyev <ivan.vasilyev@gmail.com>
Subject: Re: md raid10 Oops on recent kernels
Date: Tue, 14 Aug 2012 22:56:59 +0400
Message-ID: <CANZ+j8dT9PhokMroU-8bMDQGCnYJsmEn807j2GeyOC3gQ9OiEA@mail.gmail.com>
References: <CANZ+j8dDLqe=30AFd7oJ9WjhTSTRfbkXPBfBdG3GH=7eHkUqeA@mail.gmail.com>
	<20120814105043.05c62805@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120814105043.05c62805@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/8/14 NeilBrown <neilb@suse.de>:
> On Mon, 13 Aug 2012 16:49:26 +0400 Ivan Vasilyev <ivan.vasilyev@gmail.com>
> wrote:
>
>>  ---[ end trace b86c49ca25a6cdb2 ]---
>> ----------
>
> It looks like the ->merge_bvec_fn is bad - the code is jumping to
> 0xffffffff00000001, which strongly suggests some function pointer is bad, and
> merge_bvec_fn is the only one in that area of code.
> However I cannot see how it could possibly get a bad value like that.
>
> There were changes to merge_bvec_fn handling in RAID10 in 3.4 which is when
> you say the problem appeared.  However I cannot see how direct IO would be
> affected any differently to normal IO.
>
> If I were to try to debug this I'd build a kernel and put a printk in
> __bio_add_page in fs/bio.c just before calling q->merge_bvec_fn to print a
> message if that value has the low bit set. (i.e. if (q->merge_bvec_fn & 1) ...).

Such printk is triggered right befire oops:

DEBUG q-> merge_bvec_fn=0xffffffffa011a1c3 queue_flags=0x40
queuedata=0xffff880058bf1520
backing_dev_info.congested_fn=0xffffffffa011d39a
BUG: unable to handle kernel paging request at ffffffff00000001

although address is different (so this means the bug does not occur
exactly on merge_bvec_fn() call?)

Checked again - this problem affects only directIO:

dd if=/dev/md/rtest_a count=10000 of=/dev/null
 => ok
dd if=/dev/md/rtest_a iflag=direct count=10000 of=/dev/null
 => oops (first since boot)


Linux version 3.6.0-rc1.git6.1.fc18 (via@liber) (gcc version 4.7.1
(Debian 4.7.1-2) ) #1 SMP Tue Aug 14 21:15:58 SAMT 2012
(in fact no patches from fedora included, just git snapshot)

code:
------------------------------
--- kernel.orig/fs/bio.c        2012-08-14 18:01:51.000000000 +0400
+++ kernel/fs/bio.c     2012-08-14 19:24:37.716746106 +0400
@@ -519,6 +519,10 @@
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);

+#define DBG_MBF(q)  if (((unsigned long int)(q->merge_bvec_fn)) & 1L) { \
+ printk("DEBUG q-> merge_bvec_fn=0x%pK queue_flags=0x%lx
queuedata=0x%pK  backing_dev_info.congested_fn=0x%pK \n", \
+  q->merge_bvec_fn, q->queue_flags, q->queuedata,
q->backing_dev_info.congested_fn); }
+
 static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
                          *page, unsigned int len, unsigned int offset,
                          unsigned short max_sectors)
@@ -560,6 +564,7 @@
                                        .bi_rw = bio->bi_rw,
                                };

+                                DBG_MBF(q)
                                if (q->merge_bvec_fn(q, &bvm, prev) <
prev->bv_len) {
                                        prev->bv_len -= len;
                                        return 0;
@@ -613,6 +618,8 @@
                 * merge_bvec_fn() returns number of bytes it can accept
                 * at this offset
                 */
+
+               DBG_MBF(q)
                if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
                        bvec->bv_page = NULL;
                        bvec->bv_len = 0;
------------------------------


oops:
------------------------------
DEBUG q-> merge_bvec_fn=0xffffffffa011a1c3 queue_flags=0x40
queuedata=0xffff880058bf1520
backing_dev_info.congested_fn=0xffffffffa011d39a
BUG: unable to handle kernel paging request at ffffffff00000001
IP: [<ffffffff00000001>] 0xffffffff00000000
PGD 160e067 PUD 0
Oops: 0010 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc
ipv6 crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64
aes_generic ablk_helper cryptd microcode psmouse pcspkr serio_raw
evdev cirrus processor ttm thermal_sys hwmon virtio_balloon
drm_kms_helper drm button syscopyarea sysfillrect intel_agp sysimgblt
intel_gtt agpgart i2c_piix4 i2c_core ext4 crc16 jbd2 mbcache dm_mod
raid10 sr_mod cdrom ata_generic pata_acpi virtio_blk virtio_net floppy
ata_piix uhci_hcd libata ehci_hcd virtio_pci scsi_mod virtio_ring
virtio
CPU 0
Pid: 2242, comm: dd Not tainted 3.6.0-rc1.git6.1.fc18 #1 Bochs Bochs
RIP: 0010:[<ffffffff00000001>]  [<ffffffff00000001>] 0xffffffff00000000
RSP: 0018:ffff88005c2fd9b8  EFLAGS: 00010292
RAX: 0000000000100000 RBX: ffff880058ec8240 RCX: ffff88005b530578
RDX: ffffc90001857040 RSI: ffff88005c2fd9c8 RDI: ffff880058aaa418
RBP: 0000000000000000 R08: ffffc90001857040 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000100000 R12: 0000000000000000
R13: ffff880000000000 R14: 0000000000000200 R15: ffffea000155ba80
FS:  00007fc5b67b7700(0000) GS:ffff88005f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff00000001 CR3: 00000000583f8000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dd (pid: 2242, threadinfo ffff88005c2fc000, task ffff880058f5c000)
Stack:
 ffff88005c2fda48 ffff88005c2fdb98 ffff8800579e8480 0000000000000400
 ffff880000000000 0000000000000000 ffff88005c2fd9f8 ffff88005c2fdb98
 ffff880058d00000 ffff88005c2fdb30 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8113e627>] ? bio_add_page+0x49/0x50
 [<ffffffff81141854>] ? dio_bio_add_page+0x1b/0x53
 [<ffffffff811418e9>] ? dio_send_cur_page+0x5d/0xb8
 [<ffffffff8114239b>] ? do_blockdev_direct_IO+0x8c7/0xa7a
 [<ffffffff81140394>] ? blkdev_max_block+0x30/0x30
 [<ffffffff8114259e>] ? __blockdev_direct_IO+0x50/0x52
 [<ffffffff81140394>] ? blkdev_max_block+0x30/0x30
 [<ffffffff8113f705>] ? blkdev_direct_IO+0x52/0x54
 [<ffffffff81140394>] ? blkdev_max_block+0x30/0x30
 [<ffffffff810cfe17>] ? generic_file_aio_read+0xec/0x5ef
 [<ffffffff810f5a8f>] ? page_add_new_anon_rmap+0x92/0xa5
 [<ffffffff810ead0b>] ? set_pte_at+0x9/0xd
 [<ffffffff810ede85>] ? handle_pte_fault+0x6f0/0x741
 [<ffffffff8111576e>] ? do_sync_read+0x6e/0xab
 [<ffffffff81115f47>] ? vfs_read+0x98/0xfa
 [<ffffffff81115fe7>] ? sys_read+0x3e/0x6b
 [<ffffffff813ab9bd>] ? system_call_fastpath+0x1a/0x1f
Code:  Bad RIP value.
RIP  [<ffffffff00000001>] 0xffffffff00000000
 RSP <ffff88005c2fd9b8>
CR2: ffffffff00000001
---[ end trace 4261c96a920a2a62 ]---
------------------------------
