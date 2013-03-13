From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD: Quickly return errors if too many devices have failed.
Date: Wed, 13 Mar 2013 12:29:24 -0500
Message-ID: <1363195764.24906.14.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

Neil,

I've noticed that when too many devices fail in a RAID arrary that
addtional I/O will hang, yielding an endless supply of:
Mar 12 11:52:53 bp-01 kernel: Buffer I/O error on device md1, logical block 3
Mar 12 11:52:53 bp-01 kernel: lost page write due to I/O error on md1
Mar 12 11:52:53 bp-01 kernel: sector=800 i=3           (null)           (null)  
         (null)           (null) 1
Mar 12 11:52:53 bp-01 kernel: ------------[ cut here ]------------
Mar 12 11:52:53 bp-01 kernel: WARNING: at drivers/md/raid5.c:354 init_stripe+0x2d4/0x370 [raid456]()
Mar 12 11:52:53 bp-01 kernel: Hardware name: PowerEdge R415
Mar 12 11:52:53 bp-01 kernel: Modules linked in: raid456 md_mod async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx sunrpc ipv6 dcdbas freq_table mperf kvm_amd kvm crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw fam15h_power k10temp amd64_edac_mod edac_core edac_mce_amd i2c_piix4 i2c_core bnx2 sg ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul pata_acpi ata_generic pata_atiixp ahci libahci mptsas mptscsih mptbase scsi_transport_sas bfa scsi_transport_fc scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
Mar 12 11:52:53 bp-01 kernel: Pid: 8604, comm: dd Not tainted 3.8.0 #8
Mar 12 11:52:53 bp-01 kernel: Call Trace:
Mar 12 11:52:53 bp-01 kernel: [<ffffffff81056dcf>] warn_slowpath_common+0x7f/0xc0
Mar 12 11:52:53 bp-01 kernel: [<ffffffff81056e2a>] warn_slowpath_null+0x1a/0x20
Mar 12 11:52:53 bp-01 kernel: [<ffffffffa040f854>] init_stripe+0x2d4/0x370 [raid456]
Mar 12 11:52:53 bp-01 kernel: [<ffffffffa040fc45>] get_active_stripe+0x355/0x3f0 [raid456]
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8107c050>] ? wake_up_bit+0x40/0x40
Mar 12 11:52:53 bp-01 kernel: [<ffffffffa0413c66>] make_request+0x1a6/0x430 [raid456]
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8107c050>] ? wake_up_bit+0x40/0x40
Mar 12 11:52:53 bp-01 kernel: [<ffffffffa03f0123>] md_make_request+0xd3/0x200 [md_mod]
Mar 12 11:52:53 bp-01 kernel: [<ffffffff81122cd5>] ? mempool_alloc_slab+0x15/0x20
Mar 12 11:52:53 bp-01 kernel: [<ffffffff81122e40>] ? mempool_alloc+0x60/0x170
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8124a8ba>] generic_make_request+0xca/0x100
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8124a969>] submit_bio+0x79/0x160
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b4825>] ? bio_alloc_bioset+0x65/0x120
Mar 12 11:52:53 bp-01 kernel: [<ffffffff815458b2>] ? _raw_spin_unlock_irqrestore+0x12/0x20
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811af318>] submit_bh+0x128/0x200
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b1dd0>] __block_write_full_page+0x1e0/0x330
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b06b0>] ? lock_buffer+0x30/0x30
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b5920>] ? I_BDEV+0x10/0x10
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b5920>] ? I_BDEV+0x10/0x10
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b2055>] block_write_full_page+0x15/0x20
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b6988>] blkdev_writepage+0x18/0x20
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8112a5f7>] __writepage+0x17/0x40
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8112b875>] write_cache_pages+0x245/0x520
Mar 12 11:52:53 bp-01 kernel: [<ffffffff810844c9>] ? __wake_up_common+0x59/0x90
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8112a5e0>] ? set_page_dirty+0x60/0x60
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8112bba1>] generic_writepages+0x51/0x80
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811bd8bf>] ? send_to_group+0x13f/0x200
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8112bbf0>] do_writepages+0x20/0x40
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811210f1>] __filemap_fdatawrite_range+0x51/0x60
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8112133f>] filemap_fdatawrite+0x1f/0x30
Mar 12 11:52:53 bp-01 kernel: [<ffffffff81121385>] filemap_write_and_wait+0x35/0x60
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b6ca1>] __sync_blockdev+0x21/0x40
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b6cd3>] sync_blockdev+0x13/0x20
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b6ed9>] __blkdev_put+0x69/0x1d0
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b7096>] blkdev_put+0x56/0x140
Mar 12 11:52:53 bp-01 kernel: [<ffffffff811b71a4>] blkdev_close+0x24/0x30
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8117f7bb>] __fput+0xbb/0x260
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8117f9ce>] ____fput+0xe/0x10
Mar 12 11:52:53 bp-01 kernel: [<ffffffff81077e5f>] task_work_run+0x8f/0xf0
Mar 12 11:52:53 bp-01 kernel: [<ffffffff81014a54>] do_notify_resume+0x84/0x90
Mar 12 11:52:53 bp-01 kernel: [<ffffffff8154e992>] int_signal+0x12/0x17
Mar 12 11:52:53 bp-01 kernel: ---[ end trace d71de83816e8d215 ]---

Are other people seeing this, or is this an artifact of the way I am killing
devices ('echo offline > /sys/block/$dev/device/state')?

I would prefer to get immediate errors if nothing can be done to satisfy the
request and I've been thinking of something like the attached patch.  The
patch below is incomplete.  It does not take into account any reshaping that
is going on, nor does it try to figure out if a mirror set in RAID10 has died;
but I hope it gets the basic idea across.

Is this a good way to handle this situation, or am I missing something?

 brassow

<no comments: POC>

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>


Index: linux-upstream/drivers/md/raid1.c
===================================================================
--- linux-upstream.orig/drivers/md/raid1.c
+++ linux-upstream/drivers/md/raid1.c
@@ -210,6 +210,17 @@ static void put_buf(struct r1bio *r1_bio
 	lower_barrier(conf);
 }
 
+static int has_failed(struct r1conf *conf) {
+	struct mddev *mddev = conf->mddev;
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev)
+		if (likely(!test_bit(Faulty, &rdev->flags)))
+			return 0;
+
+	return 1;
+}
+
 static void reschedule_retry(struct r1bio *r1_bio)
 {
 	unsigned long flags;
@@ -1007,6 +1018,11 @@ static void make_request(struct mddev *m
 	int sectors_handled;
 	int max_sectors;
 
+	if (has_failed(conf)) {
+		bio_endio(bio, -EIO);
+		return;
+	}
+
 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -270,6 +270,18 @@ static void put_buf(struct r10bio *r10_b
 	lower_barrier(conf);
 }
 
+static int has_failed(struct r10conf *conf) {
+	struct mddev *mddev = conf->mddev;
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev)
+		if (likely(!test_bit(Faulty, &rdev->flags)))
+			return 0;
+
+	return 1;
+
+}
+
 static void reschedule_retry(struct r10bio *r10_bio)
 {
 	unsigned long flags;
@@ -1159,6 +1171,11 @@ static void make_request(struct mddev *m
 	int max_sectors;
 	int sectors;
 
+	if (has_failed(conf)) {
+		bio_endio(bio, -EIO);
+		return;
+	}
+
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
Index: linux-upstream/drivers/md/raid5.c
===================================================================
--- linux-upstream.orig/drivers/md/raid5.c
+++ linux-upstream/drivers/md/raid5.c
@@ -4241,6 +4241,11 @@ static void make_request(struct mddev *m
 	const int rw = bio_data_dir(bi);
 	int remaining;
 
+	if (has_failed(conf)) {
+		bio_endio(bi, -EIO);
+		return;
+	}
+
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bi);
 		return;


