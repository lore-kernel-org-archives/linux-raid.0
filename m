Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACD778C80
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 11:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717412968; cv=none; b=HvUo+p1tYBXm/29kvIum6NxawpBJG4N8QOTya/kOq2zRcS31LOORUivzkV7aGJ/0aHcfxCgrJN1TrV+fFOX/bZkn9X3mEmWDo10V5mMeicsRh3wcdH73HyNQsXRT+creNsgEuKvCEBxSpmM5w+0S6YFSkC6H0h+lzKCyfil3lkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717412968; c=relaxed/simple;
	bh=n+ikI4M9xCkUSRTN9pYAzdU5c+c/jNmrwPQ/Vi70rwE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=NXuaNiXKxvQk4L5eLJNXilL9qmHxjS7vUbMNksdALiphKHtPU0HOw1Lj7+dmKv4THIx2aOivTVDIOa4KNmriUB3OFBQ73OEJJ7zJvUbWnptf3alD5/YuyG5nkU3xnyotqUPiYMjejRoxMc4w9dImiT9GMIMCdiqcywmATnR8eJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nxjsbd/J; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nxjsbd/J"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2c19baaf564so3271758a91.0
        for <linux-raid@vger.kernel.org>; Mon, 03 Jun 2024 04:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717412966; x=1718017766; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FDPnB31i+3AEqi6oXU/0y7uNDoMDtP4JGSGA3nTWvpk=;
        b=Nxjsbd/JeeWQeFNbaiciPLNrClob6DDp1BLUFjlA0pldZRUqdXfyuEpEXNccZuieOi
         vUSNA4UdknWA0wYMwAy+eqO7QfhJ5N5DqkD9KGrKB6TbOfuNpqNjMjrT8/Apj61qQYl7
         nctghkOD7qsTZEukXqyyg2LLI7dgudb6UBMAwMPorMHKvwXitajEdbqctDUGey6bNuea
         wNho/wKcO5juUs3R6de3cgjOyg8KKHjU8T0AUZXsycN7LJL9RZyj1w3kMfF/fkYPk3+d
         Qthu4xcId3vZq3bUdBMmSRLe8HpYTinIi9qgfYygDYw7QktBR3rw6h8o43o0DYU7nuXr
         pqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717412966; x=1718017766;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FDPnB31i+3AEqi6oXU/0y7uNDoMDtP4JGSGA3nTWvpk=;
        b=Jy72+y9du3JzvR4DwmlWhtrSWKEe5asD7UOa4SxSr3ih1xHyJUZTSsTKZ4k0N2XS6S
         7OPECU1uLQPaJEAoh7rd3hZhfRyS4s9+gKxaJ//9OERM9c0Vq0aFJJCKSWnl07o36tyO
         DYBshEHzCHZ5tUNgdVxBJyjIbXoR5dlLB+QQnqdG19u4yGzarqtfdgH/dB8UHNIGWAvD
         mBlvOoF6jmC5HZevZ9C0k/tjj/HzH4aobu13CYgFMKFL8NfjSJ3YgBe8PaNggENNBABb
         m2ZM3e0joc2GdAzvGVgaSew0Q7lPsTiQNHpsgRw0gZphLb9AGPXMvGigDiTaXR17Un/V
         9Hnw==
X-Gm-Message-State: AOJu0YzrpAKOZGDvddxc83IiWImV/Fh3c2sSVzoLp7K2um9ImHl6EYsN
	MUZIbtF0PHLoZ7DC5qCdW5L83r9F6sNS55t0bEhqoXcJjPM5PsxnYz3xmmUZ1xJNpiO/xWg4icj
	8gd5/X/yxnVssWZHkB2fQw/zATdkYa9qm
X-Google-Smtp-Source: AGHT+IHkTNwUJ5VFeZDjjc07CjYLDu9X8vRoL1SNI2fczTPIlv6qZYgqGqOiMcOgF8SHnsqNl3E2AGwdkG4vj9djlCs=
X-Received: by 2002:a17:90b:1943:b0:2ad:e004:76e6 with SMTP id
 98e67ed59e1d1-2c1dc56d957mr7399800a91.7.1717412965744; Mon, 03 Jun 2024
 04:09:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Darius Ski <darius.ski@gmail.com>
Date: Mon, 3 Jun 2024 14:09:16 +0300
Message-ID: <CAKt3ReLYgWE60Rk6C5=HmZet6=3qKhAwZ9VFAm6TCs=bhDUNfQ@mail.gmail.com>
Subject: [bug-report] Soft lockup when running Raid5 periodic check and light
 workload, kernel 6.8.7
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

we have 5 device RAID5 array of SSD disks and yesterday ( during
Debian monthly cron mdadm/checkarray check ) experienced lockup under
light writes from our FileWrServer.
Array HW was fine before, during and after, just the resync, our app
threads were locked up completely.
The system completed such check during first Sunday of April and had
no troubles reading/writing 20+ terabytes of data during system prep.

cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 nvme8n1p1[5] nvme7n1p1[3] nvme0n1p1[0] nvme4n1p1[2]
nvme2n1p1[1]
      120022794240 blocks super 1.2 level 5, 64k chunk, algorithm 2
[5/5] [UUUUU]
      bitmap: 18/224 pages [72KB], 65536KB chunk

[Sun Jun  2 16:38:36 2024] INFO: task md0_raid5:1545 blocked for more
than 120 seconds.
[Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:38:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:38:36 2024] task:md0_raid5       state:D stack:0
pid:1545  tgid:1545  ppid:2      flags:0x00004000
[Sun Jun  2 16:38:36 2024] Call Trace:
[Sun Jun  2 16:38:36 2024]  <TASK>
[Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:38:36 2024]  raid5d+0x466/0x670
[Sun Jun  2 16:38:36 2024]  ? __schedule+0x372/0x9a0
[Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:38:36 2024]  ? super_90_load.part.0+0x340/0x340
[Sun Jun  2 16:38:36 2024]  md_thread+0x94/0x120
[Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:38:36 2024]  kthread+0xc3/0xf0
[Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:38:36 2024]  ret_from_fork+0x2d/0x50
[Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:38:36 2024]  ret_from_fork_asm+0x11/0x20
[Sun Jun  2 16:38:36 2024]  </TASK>
[Sun Jun  2 16:38:36 2024] INFO: task jbd2/md0p1-8:1963 blocked for
more than 120 seconds.
[Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:38:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:38:36 2024] task:jbd2/md0p1-8    state:D stack:0
pid:1963  tgid:1963  ppid:2      flags:0x00004000
[Sun Jun  2 16:38:36 2024] Call Trace:
[Sun Jun  2 16:38:36 2024]  <TASK>
[Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:38:36 2024]  ? __queue_work+0x19f/0x3b0
[Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:38:36 2024]  md_write_start+0x10d/0x200
[Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:38:36 2024]  raid5_make_request+0x8f/0x1220
[Sun Jun  2 16:38:36 2024]  ? xas_store+0x2de/0x610
[Sun Jun  2 16:38:36 2024]  ? xas_load+0x2c/0x40
[Sun Jun  2 16:38:36 2024]  ? sched_feat_write+0x150/0x150
[Sun Jun  2 16:38:36 2024]  ? alloc_buffer_head+0x1a/0x60
[Sun Jun  2 16:38:36 2024]  ? filemap_get_entry+0x53/0x100
[Sun Jun  2 16:38:36 2024]  md_handle_request+0x132/0x210
[Sun Jun  2 16:38:36 2024]  ? __bio_split_to_limits+0x8c/0x250
[Sun Jun  2 16:38:36 2024]  ? bio_split_to_limits+0x3d/0x60
[Sun Jun  2 16:38:36 2024]  __submit_bio+0x46/0xd0
[Sun Jun  2 16:38:36 2024]  submit_bio_noacct_nocheck+0x11b/0x330
[Sun Jun  2 16:38:36 2024]  jbd2_journal_commit_transaction+0xc7a/0x1930
[Sun Jun  2 16:38:36 2024]  ? __schedule+0x372/0x9a0
[Sun Jun  2 16:38:36 2024]  kjournald2+0x95/0x220
[Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:38:36 2024]  ? jbd2_fc_wait_bufs+0x90/0x90
[Sun Jun  2 16:38:36 2024]  kthread+0xc3/0xf0
[Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:38:36 2024]  ret_from_fork+0x2d/0x50
[Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:38:36 2024]  ret_from_fork_asm+0x11/0x20
[Sun Jun  2 16:38:36 2024]  </TASK>
[Sun Jun  2 16:38:36 2024] INFO: task FileWrServerEve:2020854 blocked
for more than 120 seconds.
[Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:38:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:38:36 2024] task:FileWrServerEve state:D stack:0
pid:2020854 tgid:2020739 ppid:1      flags:0x00000002
[Sun Jun  2 16:38:36 2024] Call Trace:
[Sun Jun  2 16:38:36 2024]  <TASK>
[Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:38:36 2024]  ? ext4_getblk+0xb7/0x2c0
[Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:38:36 2024]  io_schedule+0x42/0x70
[Sun Jun  2 16:38:36 2024]  bit_wait_io+0xd/0x60
[Sun Jun  2 16:38:36 2024]  __wait_on_bit+0x48/0x140
[Sun Jun  2 16:38:36 2024]  ? bit_wait+0x60/0x60
[Sun Jun  2 16:38:36 2024]  out_of_line_wait_on_bit+0x81/0x90
[Sun Jun  2 16:38:36 2024]  ? pick_next_task_stop+0x70/0x70
[Sun Jun  2 16:38:36 2024]  do_get_write_access+0x235/0x3a0
[Sun Jun  2 16:38:36 2024]  jbd2_journal_get_write_access+0x88/0xb0
[Sun Jun  2 16:38:36 2024]  __ext4_journal_get_write_access+0x3e/0x160
[Sun Jun  2 16:38:36 2024]  __ext4_new_inode+0x5a3/0x1730
[Sun Jun  2 16:38:36 2024]  ext4_create+0xe9/0x1a0
[Sun Jun  2 16:38:36 2024]  path_openat+0xdca/0x1080
[Sun Jun  2 16:38:36 2024]  do_filp_open+0xa1/0x130
[Sun Jun  2 16:38:36 2024]  do_sys_openat2+0x74/0xa0
[Sun Jun  2 16:38:36 2024]  __x64_sys_openat+0x5c/0x70
[Sun Jun  2 16:38:36 2024]  do_syscall_64+0x3a/0xc0
[Sun Jun  2 16:38:36 2024]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[Sun Jun  2 16:38:36 2024] RIP: 0033:0x7f6b89289f80
[Sun Jun  2 16:38:36 2024] RSP: 002b:00007f6b5962d540 EFLAGS: 00000293
ORIG_RAX: 0000000000000101
[Sun Jun  2 16:38:36 2024] RAX: ffffffffffffffda RBX: 00000000000000c1
RCX: 00007f6b89289f80
[Sun Jun  2 16:38:36 2024] RDX: 00000000000000c1 RSI: 00007f6a6c5d1ee0
RDI: 00000000ffffff9c
[Sun Jun  2 16:38:36 2024] RBP: 00007f6a6c5d1ee0 R08: 0000000000000000
R09: 00000000fb82ea15
[Sun Jun  2 16:38:36 2024] R10: 00000000000081a4 R11: 0000000000000293
R12: 00000000000081a4
[Sun Jun  2 16:38:36 2024] R13: 00000000000000c1 R14: 00007f6a6c5d1ee0
R15: 00007f6b80ec9080
[Sun Jun  2 16:38:36 2024]  </TASK>
[Sun Jun  2 16:38:36 2024] INFO: task md0_resync:716263 blocked for
more than 120 seconds.
[Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:38:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:38:36 2024] task:md0_resync      state:D stack:0
pid:716263 tgid:716263 ppid:2      flags:0x00004000
[Sun Jun  2 16:38:36 2024] Call Trace:
[Sun Jun  2 16:38:36 2024]  <TASK>
[Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:38:36 2024]  raid5_get_active_stripe+0x1f9/0x4c0
[Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:38:36 2024]  raid5_sync_request+0x34f/0x370
[Sun Jun  2 16:38:36 2024]  ? is_mddev_idle+0xe7/0x150
[Sun Jun  2 16:38:36 2024]  md_do_sync+0x668/0xfa0
[Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:38:36 2024]  ? super_90_load.part.0+0x340/0x340
[Sun Jun  2 16:38:36 2024]  md_thread+0x94/0x120
[Sun Jun  2 16:38:36 2024]  kthread+0xc3/0xf0
[Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:38:36 2024]  ret_from_fork+0x2d/0x50
[Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:38:36 2024]  ret_from_fork_asm+0x11/0x20
[Sun Jun  2 16:38:36 2024]  </TASK>
[Sun Jun  2 16:38:36 2024] INFO: task kworker/u385:4:1561579 blocked
for more than 120 seconds.
[Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:38:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:38:36 2024] task:kworker/u385:4  state:D stack:0
pid:1561579 tgid:1561579 ppid:2      flags:0x00004000
[Sun Jun  2 16:38:36 2024] Workqueue: writeback wb_workfn (flush-9:0)
[Sun Jun  2 16:38:36 2024] Call Trace:
[Sun Jun  2 16:38:36 2024]  <TASK>
[Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:38:36 2024]  io_schedule+0x42/0x70
[Sun Jun  2 16:38:36 2024]  bit_wait_io+0xd/0x60
[Sun Jun  2 16:38:36 2024]  __wait_on_bit+0x48/0x140
[Sun Jun  2 16:38:36 2024]  ? bit_wait+0x60/0x60
[Sun Jun  2 16:38:36 2024]  out_of_line_wait_on_bit+0x81/0x90
[Sun Jun  2 16:38:36 2024]  ? pick_next_task_stop+0x70/0x70
[Sun Jun  2 16:38:36 2024]  do_get_write_access+0x235/0x3a0
[Sun Jun  2 16:38:36 2024]  jbd2_journal_get_write_access+0x88/0xb0
[Sun Jun  2 16:38:36 2024]  __ext4_journal_get_write_access+0x3e/0x160
[Sun Jun  2 16:38:36 2024]  ext4_mb_mark_context+0x93/0x390
[Sun Jun  2 16:38:36 2024]  ext4_mb_mark_diskspace_used+0xba/0x190
[Sun Jun  2 16:38:36 2024]  ext4_mb_new_blocks+0x13f/0xdc0
[Sun Jun  2 16:38:36 2024]  ? ext4_find_extent+0x330/0x420
[Sun Jun  2 16:38:36 2024]  ? ext4_find_extent+0x3bf/0x420
[Sun Jun  2 16:38:36 2024]  ? release_pages+0x141/0x3b0
[Sun Jun  2 16:38:36 2024]  ext4_ext_map_blocks+0x35b/0x1790
[Sun Jun  2 16:38:36 2024]  ? release_pages+0x141/0x3b0
[Sun Jun  2 16:38:36 2024]  ? filemap_get_folios_tag+0x6c/0x1b0
[Sun Jun  2 16:38:36 2024]  ? mpage_prepare_extent_to_map+0x439/0x470
[Sun Jun  2 16:38:36 2024]  ext4_map_blocks+0x164/0x5d0
[Sun Jun  2 16:38:36 2024]  ext4_do_writepages+0x694/0xba0
[Sun Jun  2 16:38:36 2024]  ? iommu_map_sg+0x113/0x1b0
[Sun Jun  2 16:38:36 2024]  ext4_writepages+0x87/0x120
[Sun Jun  2 16:38:36 2024]  do_writepages+0xac/0x160
[Sun Jun  2 16:38:36 2024]  ? wb_calc_thresh+0x41/0x50
[Sun Jun  2 16:38:36 2024]  __writeback_single_inode+0x39/0x2b0
[Sun Jun  2 16:38:36 2024]  writeback_sb_inodes+0x1ab/0x430
[Sun Jun  2 16:38:36 2024]  __writeback_inodes_wb+0x4c/0xe0
[Sun Jun  2 16:38:36 2024]  wb_writeback+0x1fd/0x250
[Sun Jun  2 16:38:36 2024]  wb_workfn+0x23d/0x400
[Sun Jun  2 16:38:36 2024]  process_one_work+0x13f/0x2c0
[Sun Jun  2 16:38:36 2024]  worker_thread+0x26d/0x390
[Sun Jun  2 16:38:36 2024]  ? rescuer_thread+0x380/0x380
[Sun Jun  2 16:38:36 2024]  kthread+0xc3/0xf0
[Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:38:36 2024]  ret_from_fork+0x2d/0x50
[Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:38:36 2024]  ret_from_fork_asm+0x11/0x20
[Sun Jun  2 16:38:36 2024]  </TASK>
[Sun Jun  2 16:40:36 2024] INFO: task md0_raid5:1545 blocked for more
than 241 seconds.
[Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:40:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:40:36 2024] task:md0_raid5       state:D stack:0
pid:1545  tgid:1545  ppid:2      flags:0x00004000
[Sun Jun  2 16:40:36 2024] Call Trace:
[Sun Jun  2 16:40:36 2024]  <TASK>
[Sun Jun  2 16:40:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:40:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:40:36 2024]  raid5d+0x466/0x670
[Sun Jun  2 16:40:36 2024]  ? __schedule+0x372/0x9a0
[Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:40:36 2024]  ? super_90_load.part.0+0x340/0x340
[Sun Jun  2 16:40:36 2024]  md_thread+0x94/0x120
[Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:40:36 2024]  kthread+0xc3/0xf0
[Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:40:36 2024]  ret_from_fork+0x2d/0x50
[Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:40:36 2024]  ret_from_fork_asm+0x11/0x20
[Sun Jun  2 16:40:36 2024]  </TASK>
[Sun Jun  2 16:40:36 2024] INFO: task jbd2/md0p1-8:1963 blocked for
more than 241 seconds.
[Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:40:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:40:36 2024] task:jbd2/md0p1-8    state:D stack:0
pid:1963  tgid:1963  ppid:2      flags:0x00004000
[Sun Jun  2 16:40:36 2024] Call Trace:
[Sun Jun  2 16:40:36 2024]  <TASK>
[Sun Jun  2 16:40:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:40:36 2024]  ? __queue_work+0x19f/0x3b0
[Sun Jun  2 16:40:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:40:36 2024]  md_write_start+0x10d/0x200
[Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:40:36 2024]  raid5_make_request+0x8f/0x1220
[Sun Jun  2 16:40:36 2024]  ? xas_store+0x2de/0x610
[Sun Jun  2 16:40:36 2024]  ? xas_load+0x2c/0x40
[Sun Jun  2 16:40:36 2024]  ? sched_feat_write+0x150/0x150
[Sun Jun  2 16:40:36 2024]  ? alloc_buffer_head+0x1a/0x60
[Sun Jun  2 16:40:36 2024]  ? filemap_get_entry+0x53/0x100
[Sun Jun  2 16:40:36 2024]  md_handle_request+0x132/0x210
[Sun Jun  2 16:40:36 2024]  ? __bio_split_to_limits+0x8c/0x250
[Sun Jun  2 16:40:36 2024]  ? bio_split_to_limits+0x3d/0x60
[Sun Jun  2 16:40:36 2024]  __submit_bio+0x46/0xd0
[Sun Jun  2 16:40:36 2024]  submit_bio_noacct_nocheck+0x11b/0x330
[Sun Jun  2 16:40:36 2024]  jbd2_journal_commit_transaction+0xc7a/0x1930
[Sun Jun  2 16:40:36 2024]  ? __schedule+0x372/0x9a0
[Sun Jun  2 16:40:36 2024]  kjournald2+0x95/0x220
[Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:40:36 2024]  ? jbd2_fc_wait_bufs+0x90/0x90
[Sun Jun  2 16:40:36 2024]  kthread+0xc3/0xf0
[Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:40:36 2024]  ret_from_fork+0x2d/0x50
[Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:40:36 2024]  ret_from_fork_asm+0x11/0x20
[Sun Jun  2 16:40:36 2024]  </TASK>
[Sun Jun  2 16:40:36 2024] INFO: task FileWrServerEve:2020854 blocked
for more than 241 seconds.
[Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:40:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:40:36 2024] task:FileWrServerEve state:D stack:0
pid:2020854 tgid:2020739 ppid:1      flags:0x00000002
[Sun Jun  2 16:40:36 2024] Call Trace:
[Sun Jun  2 16:40:36 2024]  <TASK>
[Sun Jun  2 16:40:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:40:36 2024]  ? ext4_getblk+0xb7/0x2c0
[Sun Jun  2 16:40:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:40:36 2024]  io_schedule+0x42/0x70
[Sun Jun  2 16:40:36 2024]  bit_wait_io+0xd/0x60
[Sun Jun  2 16:40:36 2024]  __wait_on_bit+0x48/0x140
[Sun Jun  2 16:40:36 2024]  ? bit_wait+0x60/0x60
[Sun Jun  2 16:40:36 2024]  out_of_line_wait_on_bit+0x81/0x90
[Sun Jun  2 16:40:36 2024]  ? pick_next_task_stop+0x70/0x70
[Sun Jun  2 16:40:36 2024]  do_get_write_access+0x235/0x3a0
[Sun Jun  2 16:40:36 2024]  jbd2_journal_get_write_access+0x88/0xb0
[Sun Jun  2 16:40:36 2024]  __ext4_journal_get_write_access+0x3e/0x160
[Sun Jun  2 16:40:36 2024]  __ext4_new_inode+0x5a3/0x1730
[Sun Jun  2 16:40:36 2024]  ext4_create+0xe9/0x1a0
[Sun Jun  2 16:40:36 2024]  path_openat+0xdca/0x1080
[Sun Jun  2 16:40:36 2024]  do_filp_open+0xa1/0x130
[Sun Jun  2 16:40:36 2024]  do_sys_openat2+0x74/0xa0
[Sun Jun  2 16:40:36 2024]  __x64_sys_openat+0x5c/0x70
[Sun Jun  2 16:40:36 2024]  do_syscall_64+0x3a/0xc0
[Sun Jun  2 16:40:36 2024]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[Sun Jun  2 16:40:36 2024] RIP: 0033:0x7f6b89289f80
[Sun Jun  2 16:40:36 2024] RSP: 002b:00007f6b5962d540 EFLAGS: 00000293
ORIG_RAX: 0000000000000101
[Sun Jun  2 16:40:36 2024] RAX: ffffffffffffffda RBX: 00000000000000c1
RCX: 00007f6b89289f80
[Sun Jun  2 16:40:36 2024] RDX: 00000000000000c1 RSI: 00007f6a6c5d1ee0
RDI: 00000000ffffff9c
[Sun Jun  2 16:40:36 2024] RBP: 00007f6a6c5d1ee0 R08: 0000000000000000
R09: 00000000fb82ea15
[Sun Jun  2 16:40:36 2024] R10: 00000000000081a4 R11: 0000000000000293
R12: 00000000000081a4
[Sun Jun  2 16:40:36 2024] R13: 00000000000000c1 R14: 00007f6a6c5d1ee0
R15: 00007f6b80ec9080
[Sun Jun  2 16:40:36 2024]  </TASK>
[Sun Jun  2 16:40:36 2024] INFO: task md0_resync:716263 blocked for
more than 241 seconds.
[Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:40:36 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:40:36 2024] task:md0_resync      state:D stack:0
pid:716263 tgid:716263 ppid:2      flags:0x00004000
[Sun Jun  2 16:40:36 2024] Call Trace:
[Sun Jun  2 16:40:36 2024]  <TASK>
[Sun Jun  2 16:40:36 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:40:36 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:40:36 2024]  raid5_get_active_stripe+0x1f9/0x4c0
[Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:40:36 2024]  raid5_sync_request+0x34f/0x370
[Sun Jun  2 16:40:36 2024]  ? is_mddev_idle+0xe7/0x150
[Sun Jun  2 16:40:36 2024]  md_do_sync+0x668/0xfa0
[Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
[Sun Jun  2 16:40:36 2024]  ? super_90_load.part.0+0x340/0x340
[Sun Jun  2 16:40:36 2024]  md_thread+0x94/0x120
[Sun Jun  2 16:40:36 2024]  kthread+0xc3/0xf0
[Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:40:36 2024]  ret_from_fork+0x2d/0x50
[Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:40:36 2024]  ret_from_fork_asm+0x11/0x20
[Sun Jun  2 16:40:36 2024]  </TASK>
[Sun Jun  2 16:40:36 2024] INFO: task kworker/u385:4:1561579 blocked
for more than 241 seconds.
[Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
[Sun Jun  2 16:40:37 2024] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sun Jun  2 16:40:37 2024] task:kworker/u385:4  state:D stack:0
pid:1561579 tgid:1561579 ppid:2      flags:0x00004000
[Sun Jun  2 16:40:37 2024] Workqueue: writeback wb_workfn (flush-9:0)
[Sun Jun  2 16:40:37 2024] Call Trace:
[Sun Jun  2 16:40:37 2024]  <TASK>
[Sun Jun  2 16:40:37 2024]  __schedule+0x36a/0x9a0
[Sun Jun  2 16:40:37 2024]  schedule+0x27/0xc0
[Sun Jun  2 16:40:37 2024]  io_schedule+0x42/0x70
[Sun Jun  2 16:40:37 2024]  bit_wait_io+0xd/0x60
[Sun Jun  2 16:40:37 2024]  __wait_on_bit+0x48/0x140
[Sun Jun  2 16:40:37 2024]  ? bit_wait+0x60/0x60
[Sun Jun  2 16:40:37 2024]  out_of_line_wait_on_bit+0x81/0x90
[Sun Jun  2 16:40:37 2024]  ? pick_next_task_stop+0x70/0x70
[Sun Jun  2 16:40:37 2024]  do_get_write_access+0x235/0x3a0
[Sun Jun  2 16:40:37 2024]  jbd2_journal_get_write_access+0x88/0xb0
[Sun Jun  2 16:40:37 2024]  __ext4_journal_get_write_access+0x3e/0x160
[Sun Jun  2 16:40:37 2024]  ext4_mb_mark_context+0x93/0x390
[Sun Jun  2 16:40:37 2024]  ext4_mb_mark_diskspace_used+0xba/0x190
[Sun Jun  2 16:40:37 2024]  ext4_mb_new_blocks+0x13f/0xdc0
[Sun Jun  2 16:40:37 2024]  ? ext4_find_extent+0x330/0x420
[Sun Jun  2 16:40:37 2024]  ? ext4_find_extent+0x3bf/0x420
[Sun Jun  2 16:40:37 2024]  ? release_pages+0x141/0x3b0
[Sun Jun  2 16:40:37 2024]  ext4_ext_map_blocks+0x35b/0x1790
[Sun Jun  2 16:40:37 2024]  ? release_pages+0x141/0x3b0
[Sun Jun  2 16:40:37 2024]  ? filemap_get_folios_tag+0x6c/0x1b0
[Sun Jun  2 16:40:37 2024]  ? mpage_prepare_extent_to_map+0x439/0x470
[Sun Jun  2 16:40:37 2024]  ext4_map_blocks+0x164/0x5d0
[Sun Jun  2 16:40:37 2024]  ext4_do_writepages+0x694/0xba0
[Sun Jun  2 16:40:37 2024]  ? iommu_map_sg+0x113/0x1b0
[Sun Jun  2 16:40:37 2024]  ext4_writepages+0x87/0x120
[Sun Jun  2 16:40:37 2024]  do_writepages+0xac/0x160
[Sun Jun  2 16:40:37 2024]  ? wb_calc_thresh+0x41/0x50
[Sun Jun  2 16:40:37 2024]  __writeback_single_inode+0x39/0x2b0
[Sun Jun  2 16:40:37 2024]  writeback_sb_inodes+0x1ab/0x430
[Sun Jun  2 16:40:37 2024]  __writeback_inodes_wb+0x4c/0xe0
[Sun Jun  2 16:40:37 2024]  wb_writeback+0x1fd/0x250
[Sun Jun  2 16:40:37 2024]  wb_workfn+0x23d/0x400
[Sun Jun  2 16:40:37 2024]  process_one_work+0x13f/0x2c0
[Sun Jun  2 16:40:37 2024]  worker_thread+0x26d/0x390
[Sun Jun  2 16:40:37 2024]  ? rescuer_thread+0x380/0x380
[Sun Jun  2 16:40:37 2024]  kthread+0xc3/0xf0
[Sun Jun  2 16:40:37 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:40:37 2024]  ret_from_fork+0x2d/0x50
[Sun Jun  2 16:40:37 2024]  ? kthread_complete_and_exit+0x20/0x20
[Sun Jun  2 16:40:37 2024]  ret_from_fork_asm+0x11/0x20
[Sun Jun  2 16:40:37 2024]  </TASK>
[Sun Jun  2 16:40:37 2024] Future hung task reports are suppressed,
see sysctl kernel.hung_task_warnings

Anyone got insights at what happened here? The write workload from our
app is minor during Sundays, maybe several files per minute and
several megabytes in size.

Best regards,
Darius Ski.

P.S. Running custom build of 6.8.7 and from quick glance in mailing
list did not see anything similar, sorry if it's dublicate and/or
solved already.
