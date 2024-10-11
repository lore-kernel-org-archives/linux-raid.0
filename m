Received: from mail1.babiel.com (mail1.babiel.com [46.243.123.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D817C209F4D
	for <linux-raid@vger.kernel.org>; Fri, 11 Oct 2024 07:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.243.123.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728632303; cv=none; b=m5htrUsAUt3JawRNJwupOS28IjKiG31i6WlwRDmzo5g+7Z+KvlU8t5Kz7nDXRxAdYy8+7KLTz6luIiZ96jcHKSsqPqZ3Gbps+rhACEacfDZb2lPHdzXRMv/36cBm2rrwztw7ZMMrCTMAuLxgXC6EZKg1Kq4pegX/GpYwVY3ZR+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728632303; c=relaxed/simple;
	bh=r1bfvCnQPokIo9MVskKKU/JKsSK26GOfEXjaS9w3rU4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SGb+p21Zlh2H1FXBEEGTCOiQ+YJ0RsADDoh8dR+PRjhFgf7eH9fXoz9jbRmcYrzVSvuVxcklgXUe75du0Il3Gl03A+v7pzqrxl0+LBz2/3e/191DLaKS4ptXTyrevvCcaV+DaIXWX8iWxTfl1PmBo80/T8dJ7gCT/wTngXG5RlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=babiel.com; spf=pass smtp.mailfrom=babiel.com; dkim=pass (2048-bit key) header.d=babiel.com header.i=@babiel.com header.b=lpX64NIx; arc=none smtp.client-ip=46.243.123.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=babiel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=babiel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=babiel.com header.i=@babiel.com header.b="lpX64NIx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=babiel.com;
	s=e5bbe4109aec1b47; t=1728632293;
	bh=r1bfvCnQPokIo9MVskKKU/JKsSK26GOfEXjaS9w3rU4=;
	h=From:To:Subject:Date:From;
	b=lpX64NIx7O4jHLSt4m44To8vbGUbKl3FYP1yzU7NCEi2s7eNJxHiPrp/C484dsLS0
	 xQlGGKiqMYB4+n++xFbEAvOxljAMbykWQu8FIK8kUq+adYoJN2H2VxbsbJhDZgtANP
	 T8kX/iDskLdW6WVsFOh39hLEsJKHrlE61noh/uocm2sYGPdSS/Ix+9c9zgVxU3EfUY
	 BAPxR1Chlvxw7aB75q36j0UPtZDimViK35tZL0QcmofwzDHmaQWk+h3LXfKb2my2m2
	 PLBWCuvHXAI+wGZCuPKEQLpHSamDUH282flV6Ty5x0w69fLVx/WPDuV2fphkRhwXu7
	 3+ZzyfMZyW6Gg==
Received: from localhost (localhost [127.0.0.1])
	by mail1.babiel.com (Postfix) with ESMTP id 09738124CD8
	for <linux-raid@vger.kernel.org>; Fri, 11 Oct 2024 09:38:13 +0200 (CEST)
X-Virus-Scanned: Debian amavis at mail.babiel.com
Received: from mail1.babiel.com ([127.0.0.1])
 by localhost (mail.babiel.com [127.0.0.1]) (amavis, port 10024) with ESMTP
 id rLyH9VO3GMUp for <linux-raid@vger.kernel.org>;
 Fri, 11 Oct 2024 09:38:12 +0200 (CEST)
Received: from mail.babiel.com (unknown [46.243.120.67])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail1.babiel.com (Postfix) with ESMTPS id DB36E124BDE
	for <linux-raid@vger.kernel.org>; Fri, 11 Oct 2024 09:38:12 +0200 (CEST)
Received: from s016010.office.babiel.com (192.168.16.10) by
 s016011.office.babiel.com (192.168.16.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 11 Oct 2024 09:38:12 +0200
Received: from s016010.office.babiel.com ([192.168.16.10]) by
 s016010.office.babiel.com ([192.168.16.10]) with mapi id 15.02.1544.011; Fri,
 11 Oct 2024 09:38:09 +0200
From: =?Windows-1252?Q?Sch=E4fing=2C_Rufus_Maurice?= <r.schaefing@babiel.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC: =?Windows-1252?Q?Sch=E4fing=2C_Rufus_Maurice?= <r.schaefing@babiel.com>,
	"Wortmann, Marc" <m.wortmann@babiel.com>, "Falk, Felix" <f.falk@babiel.com>
Subject: Frequent hangups with raid6
Thread-Topic: Frequent hangups with raid6
Thread-Index: AQHbG6+aa4yMMEh10UCUR0OSQlJSGg==
Date: Fri, 11 Oct 2024 07:38:09 +0000
Message-ID: <9949588935d7467f96a8d6cc15b8bca0@babiel.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Dear Hackers,
we have a system that is experiencing sort of regular hangups and would lik=
e some help with it because we are at our wit's end. We can trace this issu=
e back at least a couple of months, maybe up to a year, so it has survived =
some kernel versions (beginning with at least 6.7 series, maybe including 6=
.1).

We come to this list because as far as we can tell the hanging tasks get st=
uck in either FS or RAID related operations.

The system is one of our backup servers (running "6.10.12-zabbly+ #debian12=
 SMP PREEMPT_DYNAMIC"). It has four RAIDs:
> md124 : active raid1 sdu3[2] sdv3[0]
>       467157824 blocks super 1.2 [2/2] [UU]
>       bitmap: 4/4 pages [16KB], 65536KB chunk
>=20
> md125 : active raid1 sdv2[0] sdu2[2]
>       1046528 blocks super 1.2 [2/2] [UU]
>      =20
> md126 : active raid6 sdn[2] sdl[10] sdm[6] sdc[4] sdd[0] sdq[13] sdg[5] s=
do[8] sdr[7] sdk[11] sdp[12] sds[3] sdj[14] sdi[9] sdh[1]
>       203134716928 blocks super 1.2 level 6, 512k chunk, algorithm 2 [15/=
15] [UUUUUUUUUUUUUUU]
>       bitmap: 18/117 pages [72KB], 65536KB chunk
>=20
> md127 : active raid6 sdt[0] sdw[1] sdz[4] sdac[7] sdab[6] sdae[9] sdad[8]=
 sdy[3] sdaa[5] sdx[2] sdf[11] sde[10] sdb[12] sda[13]
>       210938351616 blocks super 1.2 level 6, 512k chunk, algorithm 2 [14/=
14] [UUUUUUUUUUUUUU]
>       bitmap: 4/131 pages [16KB], 65536KB chunk

md124 and md125 are used for /boot and / respectively and in our case not c=
ausing problems. We see the problems with md126 and md127.

On top of these two we run LVM:
>  PV         VG  Fmt  Attr PSize   PFree =20
>  /dev/md126 vg1 lvm2 a--  189.18t      0=20
>  /dev/md127 vg1 lvm2 a--  196.45t <19.64t

>  LV             VG  Attr       LSize   Pool Origin Data%  Meta%  Move Log=
 Cpy%Sync Convert
>  backup-barman  vg1 -wi-ao----  67.00t                                   =
                =20
>  backup-s015021 vg1 -wi-ao----  21.00t                                   =
                =20
>  backup-s016012 vg1 -wi-ao----   2.00t                                   =
                =20
>  lv_backup      vg1 -wi-ao---- 255.00t                                   =
                =20
>  office_backup  vg1 -wi-ao----  21.00t=20

Processes trying to access filesystems in these LVs just hang up. Interesti=
ngly Reading from the block-device itself doesn't seem to fail (for example=
 `hexdump -C /dev/mapper/vg1-backup=96barman` appears to work, maybe that's=
 served from cache though?).

When the system is in the hanging state, we see close to 100% of CPU time s=
pent in io-wait. Lots of tasks are in 'D' state and the kernel log gets fil=
led with call traces. The only way we found to recover from this is, unfort=
unately, a hard reset. Remounting or unmounting the affected filesystems al=
so just hangs.

The call traces from many userspace processes look like they are waiting on=
 their turn to perform I/O (we wrote a small tool to extract call traces fr=
om syslogs and convertthem to JSON for easier processing, hence the unusual=
 formatting):
> {
>   "trace": [
>     " __schedule+0x3e6/0x14c0",
>     " schedule+0x27/0x110",
>     " io_schedule+0x4c/0x80",
>     " folio_wait_bit_common+0x138/0x310",
>     " folio_wait_bit+0x18/0x30",
>     " folio_wait_writeback+0x2b/0xa0",
>     " writeback_iter+0xe0/0x2d0",
>     " iomap_writepages+0x73/0x9a0",
>     " xfs_vm_writepages+0x6d/0xa0 [xfs]",
>     " do_writepages+0x7b/0x270",
>     " filemap_fdatawrite_wbc+0x6e/0xa0",
>     " __filemap_fdatawrite_range+0x6d/0xa0",
>     " file_write_and_wait_range+0x5d/0xc0",
>     " xfs_file_fsync+0x5b/0x2c0 [xfs]",
>     " vfs_fsync_range+0x48/0xa0",
>     " __x64_sys_fsync+0x3c/0x70",
>     " x64_sys_call+0x22d0/0x24a0",
>     " do_syscall_64+0x70/0x130",
>     " entry_SYSCALL_64_after_hwframe+0x76/0x7e"
>   ],
>   "procs": [
>     "pg_receivewal"
>   ]
> }

> {
>   "trace": [
>     " __schedule+0x3e6/0x14c0",
>     " schedule+0x27/0x110",
>     " schedule_preempt_disabled+0x15/0x30",
>     " rwsem_down_read_slowpath+0x261/0x490",
>     " down_read+0x48/0xc0",
>     " xfs_ilock+0x64/0x140 [xfs]",
>     " xfs_ilock_attr_map_shared+0x2a/0x60 [xfs]",
>     " xfs_attr_get+0xb1/0x110 [xfs]",
>     " xfs_xattr_get+0x83/0xd0 [xfs]",
>     " __vfs_getxattr+0x81/0xd0",
>     " get_vfs_caps_from_disk+0x8b/0x1f0",
>     " audit_copy_inode+0xc3/0x100",
>     " __audit_inode+0x295/0x3f0",
>     " filename_lookup+0x18b/0x1f0",
>     " vfs_statx+0x95/0x1d0",
>     " vfs_fstatat+0xaa/0xe0",
>     " __do_sys_newfstatat+0x44/0x90",
>     " __x64_sys_newfstatat+0x1c/0x30",
>     " x64_sys_call+0xe27/0x24a0",
>     " do_syscall_64+0x70/0x130",
>     " entry_SYSCALL_64_after_hwframe+0x76/0x7e"
>   ],
>   "procs": [
>     "lsof"
>   ]
> }

> {
>   "trace": [
>     " __schedule+0x3e6/0x14c0",
>     " schedule+0x27/0x110",
>     " schedule_preempt_disabled+0x15/0x30",
>     " rwsem_down_write_slowpath+0x2bf/0x5d0",
>     " down_write+0x5b/0x80",
>     " path_openat+0x366/0x1290",
>     " do_filp_open+0xc0/0x170",
>     " do_sys_openat2+0xb3/0xe0",
>     " __x64_sys_openat+0x6c/0xa0",
>     " x64_sys_call+0xfae/0x24a0",
>     " do_syscall_64+0x70/0x130",
>     " entry_SYSCALL_64_after_hwframe+0x76/0x7e"
>   ],
>   "procs": [
>     "bacula-dir",
>     "barman",
>     "touch"
>   ]
> }

> {
>   "trace": [
>     " __schedule+0x3e6/0x14c0",
>     " schedule+0x27/0x110",
>     " wait_transaction_locked+0x8b/0xe0",
>     " add_transaction_credits+0x1c8/0x330",
>     " start_this_handle+0xff/0x520",
>     " jbd2__journal_start+0x107/0x1f0",
>     " __ext4_journal_start_sb+0x154/0x1c0",
>     " __ext4_new_inode+0xd21/0x1640",
>     " ext4_create+0x113/0x200",
>     " path_openat+0xfcd/0x1290",
>     " do_filp_open+0xc0/0x170",
>     " do_sys_openat2+0xb3/0xe0",
>     " __x64_sys_openat+0x6c/0xa0",
>     " x64_sys_call+0xfae/0x24a0",
>     " do_syscall_64+0x70/0x130",
>     " entry_SYSCALL_64_after_hwframe+0x76/0x7e"
>   ],
>   "procs": [
>     "bacula-sd",
>     "rsync"
>   ]
> }

> {
>   "trace": [
>     " __schedule+0x3e6/0x14c0",
>     " schedule+0x27/0x110",
>     " wb_wait_for_completion+0x89/0xc0",
>     " sync_inodes_sb+0xd6/0x2c0",
>     " sync_inodes_one_sb+0x1b/0x30",
>     " iterate_supers+0x6f/0xe0",
>     " ksys_sync+0x42/0xb0",
>     " __do_sys_sync+0xe/0x20",
>     " x64_sys_call+0x1fb3/0x24a0",
>     " do_syscall_64+0x70/0x130",
>     " entry_SYSCALL_64_after_hwframe+0x76/0x7e"
>   ],
>   "procs": [
>     "(sd-sync)"
>   ]
> }

This is just a condensed version so this mail doesn't get super cluttered. =
We can also provide raw syslogs and more traces, if necessary. There are mo=
re userspace processes hanging with different traces but these traces mostl=
y differ in the syscall they start in.

In addition to the userspace processes we have three kernel tasks that get =
stuck:
> {
>   "trace": [
>     " __schedule+0x3e6/0x14c0",
>     " schedule+0x27/0x110",
>     " jbd2_journal_wait_updates+0x71/0xf0",
>     " jbd2_journal_commit_transaction+0x25b/0x1930",
>     " kjournald2+0xaa/0x280",
>     " kthread+0xe1/0x110",
>     " ret_from_fork+0x44/0x70",
>     " ret_from_fork_asm+0x1a/0x30"
>   ],
>   "procs": [
>     "jbd2/dm-0-8"
>   ]
> }

> {
>   "trace": [
>     "Workqueue: writeback wb_workfn (flush-252:5)",
>     " __schedule+0x3e6/0x14c0",
>     " schedule+0x27/0x110",
>     " io_schedule+0x4c/0x80",
>     " folio_wait_bit_common+0x138/0x310",
>     " __folio_lock+0x17/0x30",
>     " writeback_iter+0x1ee/0x2d0",
>     " iomap_writepages+0x73/0x9a0",
>     " xfs_vm_writepages+0x6d/0xa0 [xfs]",
>     " do_writepages+0x7b/0x270",
>     " __writeback_single_inode+0x44/0x360",
>     " writeback_sb_inodes+0x24a/0x550",
>     " __writeback_inodes_wb+0x54/0x100",
>     " wb_writeback+0x1a0/0x320",
>     " wb_workfn+0x2ab/0x3f0",
>     " process_one_work+0x176/0x3c0",
>     " worker_thread+0x2cc/0x400",
>     " kthread+0xe1/0x110",
>     " ret_from_fork+0x44/0x70",
>     " ret_from_fork_asm+0x1a/0x30"
>   ],
>   "procs": [
>     "kworker/u386:11"
>   ]
> }

> {
>   "trace": [
>     "Workqueue: writeback wb_workfn (flush-252:0)",
>     " __schedule+0x3e6/0x14c0",
>     " schedule+0x27/0x110",
>     " md_bitmap_startwrite+0x160/0x1d0",
>     " __add_stripe_bio+0x213/0x260 [raid456]",
>     " raid5_make_request+0x397/0x12e0 [raid456]",
>     " md_handle_request+0x15a/0x280",
>     " md_submit_bio+0x63/0xb0",
>     " __submit_bio+0x192/0x250",
>     " submit_bio_noacct_nocheck+0x1a3/0x3c0",
>     " submit_bio_noacct+0x1d6/0x5d0",
>     " submit_bio+0xb1/0x110",
>     " ext4_bio_write_folio+0x270/0x680",
>     " mpage_submit_folio+0x7d/0xa0",
>     " mpage_prepare_extent_to_map+0x1f2/0x540",
>     " ext4_do_writepages+0x22d/0xcd0",
>     " ext4_writepages+0xbb/0x190",
>     " do_writepages+0x7b/0x270",
>     " __writeback_single_inode+0x44/0x360",
>     " writeback_sb_inodes+0x24a/0x550",
>     " __writeback_inodes_wb+0x54/0x100",
>     " wb_writeback+0x1a0/0x320",
>     " wb_workfn+0x2ab/0x3f0",
>     " process_one_work+0x176/0x3c0",
>     " worker_thread+0x2cc/0x400",
>     " kthread+0xe1/0x110",
>     " ret_from_fork+0x44/0x70",
>     " ret_from_fork_asm+0x1a/0x30"
>   ],
>   "procs": [
>     "kworker/u386:4"
>   ]
> }

So we have an EXT-journal worker that looks like it's trying to commit the =
journal and a writeback worker (`kworker/u386:11`) that also looks like it'=
s waiting its turn.

The one task standing out is `kworker/u386:4`: It's the only task we see hi=
tting the RAID layer, waiting in `md_bitmap_startwrite`.

At first we assumed this was an issue with EXT4 (lv_backup) until we saw th=
at we get the same hangups with XFS (backup-barman). Then we saw the hangup=
s in the RAID layer and started looking in that direction. We found some th=
reads on this ML describing very similar workloads, symptoms and traces.

Something unusual about this issue is that it appears to be somewhat reliab=
le - we see it happening most often around the first weekend of the month (=
our Debian runs a RAID scan every first sunday, but the issue can appear ev=
en before the RAID scan). We have tried shifting our workloads away from th=
at time but it still appeared.

Unfortunaly up until now we have not succeeded in triggering the hangups ma=
nually by, for example, using `fio` trying different write-patterns (lots o=
f small files, buffered/unbuffered, high throughput, etc..).

Of course we can provide additional information as needed (configuration, p=
rocfs, etc.). We will also capture a kdump next time this issue comes up fo=
r us.

I have sent this mail from our team's shared account and added myself as we=
ll as some colleagues in CC.

Kind regards - Rufus Sch=E4fing=
