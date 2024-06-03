Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07683126F0A
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 11:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415920; cv=none; b=pST3Fnfajpl4JIirf7YXvFuvZDOie29vw58iPZDznucZtLdl3tCb0eaFK0ZpSJRBK2zkulHXpdJod7ziFIBu0WjeQ1sG6kXJlKl9ABxbqfPogWek1KYMZ4BnI+cybr3tdqkximB7d7P7o17md6Mt4p1EKFoWo9wmmIGcfN5Q/9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415920; c=relaxed/simple;
	bh=UOE5fbTriYF4FxUls3VGHtFXlFTxXo0raVv9U1t0ovw=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TunTrNyl1JTmE4wIyEC1wCLZmPPfgCBlF2IfibFC9JUGRtDNEg0aaUYMNPCAPSr5UafnUwlJ5vLR2DHfqi54C9q2OfDtjznslzKZZDRHfZ289vML8G7q209joL56C+k1HLnXB/VVkEupNm0s/xAUODUEe0QEIyS171GuO9+oGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VtC0v1hhKz4f3pF9
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 19:58:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 45A5E1A018A
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 19:58:34 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g7nr11megnTOQ--.10660S3;
	Mon, 03 Jun 2024 19:58:33 +0800 (CST)
Subject: Re: [bug-report] Soft lockup when running Raid5 periodic check and
 light workload, kernel 6.8.7
To: Darius Ski <darius.ski@gmail.com>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <CAKt3ReLYgWE60Rk6C5=HmZet6=3qKhAwZ9VFAm6TCs=bhDUNfQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <54dc2542-5496-abd9-c01d-787559cdeed3@huaweicloud.com>
Date: Mon, 3 Jun 2024 19:58:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKt3ReLYgWE60Rk6C5=HmZet6=3qKhAwZ9VFAm6TCs=bhDUNfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g7nr11megnTOQ--.10660S3
X-Coremail-Antispam: 1UD129KBjvAXoWftrW3JFWxur18ZrWktr4rGrg_yoW8uw18Ao
	W5C3W7GF4kGwn0vF4Iv3Z8XrySvr1xAF42kFyUGr47uw4Ikw1xCa4rXr4Ivayrt3y5ZFW5
	XFn3uay7Gas7GF4kn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUU5R7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
	AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/06/03 19:09, Darius Ski 写道:
> Hi all,
> 
> we have 5 device RAID5 array of SSD disks and yesterday ( during
> Debian monthly cron mdadm/checkarray check ) experienced lockup under
> light writes from our FileWrServer.
> Array HW was fine before, during and after, just the resync, our app
> threads were locked up completely.
> The system completed such check during first Sunday of April and had
> no troubles reading/writing 20+ terabytes of data during system prep.
> 
> cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
> md0 : active raid5 nvme8n1p1[5] nvme7n1p1[3] nvme0n1p1[0] nvme4n1p1[2]
> nvme2n1p1[1]
>        120022794240 blocks super 1.2 level 5, 64k chunk, algorithm 2
> [5/5] [UUUUU]
>        bitmap: 18/224 pages [72KB], 65536KB chunk
> 
> [Sun Jun  2 16:38:36 2024] INFO: task md0_raid5:1545 blocked for more
> than 120 seconds.
> [Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:38:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:38:36 2024] task:md0_raid5       state:D stack:0
> pid:1545  tgid:1545  ppid:2      flags:0x00004000
> [Sun Jun  2 16:38:36 2024] Call Trace:
> [Sun Jun  2 16:38:36 2024]  <TASK>
> [Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:38:36 2024]  raid5d+0x466/0x670
> [Sun Jun  2 16:38:36 2024]  ? __schedule+0x372/0x9a0
> [Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:38:36 2024]  ? super_90_load.part.0+0x340/0x340
> [Sun Jun  2 16:38:36 2024]  md_thread+0x94/0x120
> [Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:38:36 2024]  kthread+0xc3/0xf0
> [Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:38:36 2024]  ret_from_fork+0x2d/0x50
> [Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:38:36 2024]  ret_from_fork_asm+0x11/0x20
> [Sun Jun  2 16:38:36 2024]  </TASK>
> [Sun Jun  2 16:38:36 2024] INFO: task jbd2/md0p1-8:1963 blocked for
> more than 120 seconds.
> [Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:38:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:38:36 2024] task:jbd2/md0p1-8    state:D stack:0
> pid:1963  tgid:1963  ppid:2      flags:0x00004000
> [Sun Jun  2 16:38:36 2024] Call Trace:
> [Sun Jun  2 16:38:36 2024]  <TASK>
> [Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:38:36 2024]  ? __queue_work+0x19f/0x3b0
> [Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:38:36 2024]  md_write_start+0x10d/0x200
> [Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:38:36 2024]  raid5_make_request+0x8f/0x1220
> [Sun Jun  2 16:38:36 2024]  ? xas_store+0x2de/0x610
> [Sun Jun  2 16:38:36 2024]  ? xas_load+0x2c/0x40
> [Sun Jun  2 16:38:36 2024]  ? sched_feat_write+0x150/0x150
> [Sun Jun  2 16:38:36 2024]  ? alloc_buffer_head+0x1a/0x60
> [Sun Jun  2 16:38:36 2024]  ? filemap_get_entry+0x53/0x100
> [Sun Jun  2 16:38:36 2024]  md_handle_request+0x132/0x210
> [Sun Jun  2 16:38:36 2024]  ? __bio_split_to_limits+0x8c/0x250
> [Sun Jun  2 16:38:36 2024]  ? bio_split_to_limits+0x3d/0x60
> [Sun Jun  2 16:38:36 2024]  __submit_bio+0x46/0xd0
> [Sun Jun  2 16:38:36 2024]  submit_bio_noacct_nocheck+0x11b/0x330
> [Sun Jun  2 16:38:36 2024]  jbd2_journal_commit_transaction+0xc7a/0x1930
> [Sun Jun  2 16:38:36 2024]  ? __schedule+0x372/0x9a0
> [Sun Jun  2 16:38:36 2024]  kjournald2+0x95/0x220
> [Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:38:36 2024]  ? jbd2_fc_wait_bufs+0x90/0x90
> [Sun Jun  2 16:38:36 2024]  kthread+0xc3/0xf0
> [Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:38:36 2024]  ret_from_fork+0x2d/0x50
> [Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:38:36 2024]  ret_from_fork_asm+0x11/0x20
> [Sun Jun  2 16:38:36 2024]  </TASK>
> [Sun Jun  2 16:38:36 2024] INFO: task FileWrServerEve:2020854 blocked
> for more than 120 seconds.
> [Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:38:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:38:36 2024] task:FileWrServerEve state:D stack:0
> pid:2020854 tgid:2020739 ppid:1      flags:0x00000002
> [Sun Jun  2 16:38:36 2024] Call Trace:
> [Sun Jun  2 16:38:36 2024]  <TASK>
> [Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:38:36 2024]  ? ext4_getblk+0xb7/0x2c0
> [Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:38:36 2024]  io_schedule+0x42/0x70
> [Sun Jun  2 16:38:36 2024]  bit_wait_io+0xd/0x60
> [Sun Jun  2 16:38:36 2024]  __wait_on_bit+0x48/0x140
> [Sun Jun  2 16:38:36 2024]  ? bit_wait+0x60/0x60
> [Sun Jun  2 16:38:36 2024]  out_of_line_wait_on_bit+0x81/0x90
> [Sun Jun  2 16:38:36 2024]  ? pick_next_task_stop+0x70/0x70
> [Sun Jun  2 16:38:36 2024]  do_get_write_access+0x235/0x3a0
> [Sun Jun  2 16:38:36 2024]  jbd2_journal_get_write_access+0x88/0xb0
> [Sun Jun  2 16:38:36 2024]  __ext4_journal_get_write_access+0x3e/0x160
> [Sun Jun  2 16:38:36 2024]  __ext4_new_inode+0x5a3/0x1730
> [Sun Jun  2 16:38:36 2024]  ext4_create+0xe9/0x1a0
> [Sun Jun  2 16:38:36 2024]  path_openat+0xdca/0x1080
> [Sun Jun  2 16:38:36 2024]  do_filp_open+0xa1/0x130
> [Sun Jun  2 16:38:36 2024]  do_sys_openat2+0x74/0xa0
> [Sun Jun  2 16:38:36 2024]  __x64_sys_openat+0x5c/0x70
> [Sun Jun  2 16:38:36 2024]  do_syscall_64+0x3a/0xc0
> [Sun Jun  2 16:38:36 2024]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [Sun Jun  2 16:38:36 2024] RIP: 0033:0x7f6b89289f80
> [Sun Jun  2 16:38:36 2024] RSP: 002b:00007f6b5962d540 EFLAGS: 00000293
> ORIG_RAX: 0000000000000101
> [Sun Jun  2 16:38:36 2024] RAX: ffffffffffffffda RBX: 00000000000000c1
> RCX: 00007f6b89289f80
> [Sun Jun  2 16:38:36 2024] RDX: 00000000000000c1 RSI: 00007f6a6c5d1ee0
> RDI: 00000000ffffff9c
> [Sun Jun  2 16:38:36 2024] RBP: 00007f6a6c5d1ee0 R08: 0000000000000000
> R09: 00000000fb82ea15
> [Sun Jun  2 16:38:36 2024] R10: 00000000000081a4 R11: 0000000000000293
> R12: 00000000000081a4
> [Sun Jun  2 16:38:36 2024] R13: 00000000000000c1 R14: 00007f6a6c5d1ee0
> R15: 00007f6b80ec9080
> [Sun Jun  2 16:38:36 2024]  </TASK>
> [Sun Jun  2 16:38:36 2024] INFO: task md0_resync:716263 blocked for
> more than 120 seconds.
> [Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:38:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:38:36 2024] task:md0_resync      state:D stack:0
> pid:716263 tgid:716263 ppid:2      flags:0x00004000
> [Sun Jun  2 16:38:36 2024] Call Trace:
> [Sun Jun  2 16:38:36 2024]  <TASK>
> [Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:38:36 2024]  raid5_get_active_stripe+0x1f9/0x4c0
> [Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:38:36 2024]  raid5_sync_request+0x34f/0x370
> [Sun Jun  2 16:38:36 2024]  ? is_mddev_idle+0xe7/0x150
> [Sun Jun  2 16:38:36 2024]  md_do_sync+0x668/0xfa0
> [Sun Jun  2 16:38:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:38:36 2024]  ? super_90_load.part.0+0x340/0x340
> [Sun Jun  2 16:38:36 2024]  md_thread+0x94/0x120
> [Sun Jun  2 16:38:36 2024]  kthread+0xc3/0xf0
> [Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:38:36 2024]  ret_from_fork+0x2d/0x50
> [Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:38:36 2024]  ret_from_fork_asm+0x11/0x20
> [Sun Jun  2 16:38:36 2024]  </TASK>
> [Sun Jun  2 16:38:36 2024] INFO: task kworker/u385:4:1561579 blocked
> for more than 120 seconds.
> [Sun Jun  2 16:38:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:38:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:38:36 2024] task:kworker/u385:4  state:D stack:0
> pid:1561579 tgid:1561579 ppid:2      flags:0x00004000
> [Sun Jun  2 16:38:36 2024] Workqueue: writeback wb_workfn (flush-9:0)
> [Sun Jun  2 16:38:36 2024] Call Trace:
> [Sun Jun  2 16:38:36 2024]  <TASK>
> [Sun Jun  2 16:38:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:38:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:38:36 2024]  io_schedule+0x42/0x70
> [Sun Jun  2 16:38:36 2024]  bit_wait_io+0xd/0x60
> [Sun Jun  2 16:38:36 2024]  __wait_on_bit+0x48/0x140
> [Sun Jun  2 16:38:36 2024]  ? bit_wait+0x60/0x60
> [Sun Jun  2 16:38:36 2024]  out_of_line_wait_on_bit+0x81/0x90
> [Sun Jun  2 16:38:36 2024]  ? pick_next_task_stop+0x70/0x70
> [Sun Jun  2 16:38:36 2024]  do_get_write_access+0x235/0x3a0
> [Sun Jun  2 16:38:36 2024]  jbd2_journal_get_write_access+0x88/0xb0
> [Sun Jun  2 16:38:36 2024]  __ext4_journal_get_write_access+0x3e/0x160
> [Sun Jun  2 16:38:36 2024]  ext4_mb_mark_context+0x93/0x390
> [Sun Jun  2 16:38:36 2024]  ext4_mb_mark_diskspace_used+0xba/0x190
> [Sun Jun  2 16:38:36 2024]  ext4_mb_new_blocks+0x13f/0xdc0
> [Sun Jun  2 16:38:36 2024]  ? ext4_find_extent+0x330/0x420
> [Sun Jun  2 16:38:36 2024]  ? ext4_find_extent+0x3bf/0x420
> [Sun Jun  2 16:38:36 2024]  ? release_pages+0x141/0x3b0
> [Sun Jun  2 16:38:36 2024]  ext4_ext_map_blocks+0x35b/0x1790
> [Sun Jun  2 16:38:36 2024]  ? release_pages+0x141/0x3b0
> [Sun Jun  2 16:38:36 2024]  ? filemap_get_folios_tag+0x6c/0x1b0
> [Sun Jun  2 16:38:36 2024]  ? mpage_prepare_extent_to_map+0x439/0x470
> [Sun Jun  2 16:38:36 2024]  ext4_map_blocks+0x164/0x5d0
> [Sun Jun  2 16:38:36 2024]  ext4_do_writepages+0x694/0xba0
> [Sun Jun  2 16:38:36 2024]  ? iommu_map_sg+0x113/0x1b0
> [Sun Jun  2 16:38:36 2024]  ext4_writepages+0x87/0x120
> [Sun Jun  2 16:38:36 2024]  do_writepages+0xac/0x160
> [Sun Jun  2 16:38:36 2024]  ? wb_calc_thresh+0x41/0x50
> [Sun Jun  2 16:38:36 2024]  __writeback_single_inode+0x39/0x2b0
> [Sun Jun  2 16:38:36 2024]  writeback_sb_inodes+0x1ab/0x430
> [Sun Jun  2 16:38:36 2024]  __writeback_inodes_wb+0x4c/0xe0
> [Sun Jun  2 16:38:36 2024]  wb_writeback+0x1fd/0x250
> [Sun Jun  2 16:38:36 2024]  wb_workfn+0x23d/0x400
> [Sun Jun  2 16:38:36 2024]  process_one_work+0x13f/0x2c0
> [Sun Jun  2 16:38:36 2024]  worker_thread+0x26d/0x390
> [Sun Jun  2 16:38:36 2024]  ? rescuer_thread+0x380/0x380
> [Sun Jun  2 16:38:36 2024]  kthread+0xc3/0xf0
> [Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:38:36 2024]  ret_from_fork+0x2d/0x50
> [Sun Jun  2 16:38:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:38:36 2024]  ret_from_fork_asm+0x11/0x20
> [Sun Jun  2 16:38:36 2024]  </TASK>
> [Sun Jun  2 16:40:36 2024] INFO: task md0_raid5:1545 blocked for more
> than 241 seconds.
> [Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:40:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:40:36 2024] task:md0_raid5       state:D stack:0
> pid:1545  tgid:1545  ppid:2      flags:0x00004000
> [Sun Jun  2 16:40:36 2024] Call Trace:
> [Sun Jun  2 16:40:36 2024]  <TASK>
> [Sun Jun  2 16:40:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:40:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:40:36 2024]  raid5d+0x466/0x670
> [Sun Jun  2 16:40:36 2024]  ? __schedule+0x372/0x9a0
> [Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:40:36 2024]  ? super_90_load.part.0+0x340/0x340
> [Sun Jun  2 16:40:36 2024]  md_thread+0x94/0x120
> [Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:40:36 2024]  kthread+0xc3/0xf0
> [Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:40:36 2024]  ret_from_fork+0x2d/0x50
> [Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:40:36 2024]  ret_from_fork_asm+0x11/0x20
> [Sun Jun  2 16:40:36 2024]  </TASK>
> [Sun Jun  2 16:40:36 2024] INFO: task jbd2/md0p1-8:1963 blocked for
> more than 241 seconds.
> [Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:40:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:40:36 2024] task:jbd2/md0p1-8    state:D stack:0
> pid:1963  tgid:1963  ppid:2      flags:0x00004000
> [Sun Jun  2 16:40:36 2024] Call Trace:
> [Sun Jun  2 16:40:36 2024]  <TASK>
> [Sun Jun  2 16:40:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:40:36 2024]  ? __queue_work+0x19f/0x3b0
> [Sun Jun  2 16:40:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:40:36 2024]  md_write_start+0x10d/0x200
> [Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:40:36 2024]  raid5_make_request+0x8f/0x1220
> [Sun Jun  2 16:40:36 2024]  ? xas_store+0x2de/0x610
> [Sun Jun  2 16:40:36 2024]  ? xas_load+0x2c/0x40
> [Sun Jun  2 16:40:36 2024]  ? sched_feat_write+0x150/0x150
> [Sun Jun  2 16:40:36 2024]  ? alloc_buffer_head+0x1a/0x60
> [Sun Jun  2 16:40:36 2024]  ? filemap_get_entry+0x53/0x100
> [Sun Jun  2 16:40:36 2024]  md_handle_request+0x132/0x210
> [Sun Jun  2 16:40:36 2024]  ? __bio_split_to_limits+0x8c/0x250
> [Sun Jun  2 16:40:36 2024]  ? bio_split_to_limits+0x3d/0x60
> [Sun Jun  2 16:40:36 2024]  __submit_bio+0x46/0xd0
> [Sun Jun  2 16:40:36 2024]  submit_bio_noacct_nocheck+0x11b/0x330
> [Sun Jun  2 16:40:36 2024]  jbd2_journal_commit_transaction+0xc7a/0x1930
> [Sun Jun  2 16:40:36 2024]  ? __schedule+0x372/0x9a0
> [Sun Jun  2 16:40:36 2024]  kjournald2+0x95/0x220
> [Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:40:36 2024]  ? jbd2_fc_wait_bufs+0x90/0x90
> [Sun Jun  2 16:40:36 2024]  kthread+0xc3/0xf0
> [Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:40:36 2024]  ret_from_fork+0x2d/0x50
> [Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:40:36 2024]  ret_from_fork_asm+0x11/0x20
> [Sun Jun  2 16:40:36 2024]  </TASK>
> [Sun Jun  2 16:40:36 2024] INFO: task FileWrServerEve:2020854 blocked
> for more than 241 seconds.
> [Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:40:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:40:36 2024] task:FileWrServerEve state:D stack:0
> pid:2020854 tgid:2020739 ppid:1      flags:0x00000002
> [Sun Jun  2 16:40:36 2024] Call Trace:
> [Sun Jun  2 16:40:36 2024]  <TASK>
> [Sun Jun  2 16:40:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:40:36 2024]  ? ext4_getblk+0xb7/0x2c0
> [Sun Jun  2 16:40:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:40:36 2024]  io_schedule+0x42/0x70
> [Sun Jun  2 16:40:36 2024]  bit_wait_io+0xd/0x60
> [Sun Jun  2 16:40:36 2024]  __wait_on_bit+0x48/0x140
> [Sun Jun  2 16:40:36 2024]  ? bit_wait+0x60/0x60
> [Sun Jun  2 16:40:36 2024]  out_of_line_wait_on_bit+0x81/0x90
> [Sun Jun  2 16:40:36 2024]  ? pick_next_task_stop+0x70/0x70
> [Sun Jun  2 16:40:36 2024]  do_get_write_access+0x235/0x3a0
> [Sun Jun  2 16:40:36 2024]  jbd2_journal_get_write_access+0x88/0xb0
> [Sun Jun  2 16:40:36 2024]  __ext4_journal_get_write_access+0x3e/0x160
> [Sun Jun  2 16:40:36 2024]  __ext4_new_inode+0x5a3/0x1730
> [Sun Jun  2 16:40:36 2024]  ext4_create+0xe9/0x1a0
> [Sun Jun  2 16:40:36 2024]  path_openat+0xdca/0x1080
> [Sun Jun  2 16:40:36 2024]  do_filp_open+0xa1/0x130
> [Sun Jun  2 16:40:36 2024]  do_sys_openat2+0x74/0xa0
> [Sun Jun  2 16:40:36 2024]  __x64_sys_openat+0x5c/0x70
> [Sun Jun  2 16:40:36 2024]  do_syscall_64+0x3a/0xc0
> [Sun Jun  2 16:40:36 2024]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [Sun Jun  2 16:40:36 2024] RIP: 0033:0x7f6b89289f80
> [Sun Jun  2 16:40:36 2024] RSP: 002b:00007f6b5962d540 EFLAGS: 00000293
> ORIG_RAX: 0000000000000101
> [Sun Jun  2 16:40:36 2024] RAX: ffffffffffffffda RBX: 00000000000000c1
> RCX: 00007f6b89289f80
> [Sun Jun  2 16:40:36 2024] RDX: 00000000000000c1 RSI: 00007f6a6c5d1ee0
> RDI: 00000000ffffff9c
> [Sun Jun  2 16:40:36 2024] RBP: 00007f6a6c5d1ee0 R08: 0000000000000000
> R09: 00000000fb82ea15
> [Sun Jun  2 16:40:36 2024] R10: 00000000000081a4 R11: 0000000000000293
> R12: 00000000000081a4
> [Sun Jun  2 16:40:36 2024] R13: 00000000000000c1 R14: 00007f6a6c5d1ee0
> R15: 00007f6b80ec9080
> [Sun Jun  2 16:40:36 2024]  </TASK>
> [Sun Jun  2 16:40:36 2024] INFO: task md0_resync:716263 blocked for
> more than 241 seconds.
> [Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:40:36 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:40:36 2024] task:md0_resync      state:D stack:0
> pid:716263 tgid:716263 ppid:2      flags:0x00004000
> [Sun Jun  2 16:40:36 2024] Call Trace:
> [Sun Jun  2 16:40:36 2024]  <TASK>
> [Sun Jun  2 16:40:36 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:40:36 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:40:36 2024]  raid5_get_active_stripe+0x1f9/0x4c0
> [Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:40:36 2024]  raid5_sync_request+0x34f/0x370
> [Sun Jun  2 16:40:36 2024]  ? is_mddev_idle+0xe7/0x150
> [Sun Jun  2 16:40:36 2024]  md_do_sync+0x668/0xfa0
> [Sun Jun  2 16:40:36 2024]  ? cpuacct_stats_show+0x120/0x120
> [Sun Jun  2 16:40:36 2024]  ? super_90_load.part.0+0x340/0x340
> [Sun Jun  2 16:40:36 2024]  md_thread+0x94/0x120
> [Sun Jun  2 16:40:36 2024]  kthread+0xc3/0xf0
> [Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:40:36 2024]  ret_from_fork+0x2d/0x50
> [Sun Jun  2 16:40:36 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:40:36 2024]  ret_from_fork_asm+0x11/0x20
> [Sun Jun  2 16:40:36 2024]  </TASK>
> [Sun Jun  2 16:40:36 2024] INFO: task kworker/u385:4:1561579 blocked
> for more than 241 seconds.
> [Sun Jun  2 16:40:36 2024]       Not tainted 6.8.7-custom #1
> [Sun Jun  2 16:40:37 2024] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sun Jun  2 16:40:37 2024] task:kworker/u385:4  state:D stack:0
> pid:1561579 tgid:1561579 ppid:2      flags:0x00004000
> [Sun Jun  2 16:40:37 2024] Workqueue: writeback wb_workfn (flush-9:0)
> [Sun Jun  2 16:40:37 2024] Call Trace:
> [Sun Jun  2 16:40:37 2024]  <TASK>
> [Sun Jun  2 16:40:37 2024]  __schedule+0x36a/0x9a0
> [Sun Jun  2 16:40:37 2024]  schedule+0x27/0xc0
> [Sun Jun  2 16:40:37 2024]  io_schedule+0x42/0x70
> [Sun Jun  2 16:40:37 2024]  bit_wait_io+0xd/0x60
> [Sun Jun  2 16:40:37 2024]  __wait_on_bit+0x48/0x140
> [Sun Jun  2 16:40:37 2024]  ? bit_wait+0x60/0x60
> [Sun Jun  2 16:40:37 2024]  out_of_line_wait_on_bit+0x81/0x90
> [Sun Jun  2 16:40:37 2024]  ? pick_next_task_stop+0x70/0x70
> [Sun Jun  2 16:40:37 2024]  do_get_write_access+0x235/0x3a0
> [Sun Jun  2 16:40:37 2024]  jbd2_journal_get_write_access+0x88/0xb0
> [Sun Jun  2 16:40:37 2024]  __ext4_journal_get_write_access+0x3e/0x160
> [Sun Jun  2 16:40:37 2024]  ext4_mb_mark_context+0x93/0x390
> [Sun Jun  2 16:40:37 2024]  ext4_mb_mark_diskspace_used+0xba/0x190
> [Sun Jun  2 16:40:37 2024]  ext4_mb_new_blocks+0x13f/0xdc0
> [Sun Jun  2 16:40:37 2024]  ? ext4_find_extent+0x330/0x420
> [Sun Jun  2 16:40:37 2024]  ? ext4_find_extent+0x3bf/0x420
> [Sun Jun  2 16:40:37 2024]  ? release_pages+0x141/0x3b0
> [Sun Jun  2 16:40:37 2024]  ext4_ext_map_blocks+0x35b/0x1790
> [Sun Jun  2 16:40:37 2024]  ? release_pages+0x141/0x3b0
> [Sun Jun  2 16:40:37 2024]  ? filemap_get_folios_tag+0x6c/0x1b0
> [Sun Jun  2 16:40:37 2024]  ? mpage_prepare_extent_to_map+0x439/0x470
> [Sun Jun  2 16:40:37 2024]  ext4_map_blocks+0x164/0x5d0
> [Sun Jun  2 16:40:37 2024]  ext4_do_writepages+0x694/0xba0
> [Sun Jun  2 16:40:37 2024]  ? iommu_map_sg+0x113/0x1b0
> [Sun Jun  2 16:40:37 2024]  ext4_writepages+0x87/0x120
> [Sun Jun  2 16:40:37 2024]  do_writepages+0xac/0x160
> [Sun Jun  2 16:40:37 2024]  ? wb_calc_thresh+0x41/0x50
> [Sun Jun  2 16:40:37 2024]  __writeback_single_inode+0x39/0x2b0
> [Sun Jun  2 16:40:37 2024]  writeback_sb_inodes+0x1ab/0x430
> [Sun Jun  2 16:40:37 2024]  __writeback_inodes_wb+0x4c/0xe0
> [Sun Jun  2 16:40:37 2024]  wb_writeback+0x1fd/0x250
> [Sun Jun  2 16:40:37 2024]  wb_workfn+0x23d/0x400
> [Sun Jun  2 16:40:37 2024]  process_one_work+0x13f/0x2c0
> [Sun Jun  2 16:40:37 2024]  worker_thread+0x26d/0x390
> [Sun Jun  2 16:40:37 2024]  ? rescuer_thread+0x380/0x380
> [Sun Jun  2 16:40:37 2024]  kthread+0xc3/0xf0
> [Sun Jun  2 16:40:37 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:40:37 2024]  ret_from_fork+0x2d/0x50
> [Sun Jun  2 16:40:37 2024]  ? kthread_complete_and_exit+0x20/0x20
> [Sun Jun  2 16:40:37 2024]  ret_from_fork_asm+0x11/0x20
> [Sun Jun  2 16:40:37 2024]  </TASK>
> [Sun Jun  2 16:40:37 2024] Future hung task reports are suppressed,
> see sysctl kernel.hung_task_warnings
> 
> Anyone got insights at what happened here? The write workload from our
> app is minor during Sundays, maybe several files per minute and
> several megabytes in size.

This looks like reported problem:

https://lore.kernel.org/all/3bb2549f-846a-4179-9e23-407235a06753@axis.com/
https://lore.kernel.org/all/20240123005700.9302-1-dan@danm.net/

And the fix patch is(merged in v6.10-rc1):

https://lore.kernel.org/all/20240322081005.1112401-1-yukuai1@huaweicloud.com/

Thanks,
Kuai

> 
> Best regards,
> Darius Ski.
> 
> P.S. Running custom build of 6.8.7 and from quick glance in mailing
> list did not see anything similar, sorry if it's dublicate and/or
> solved already.
> 
> .
> 

