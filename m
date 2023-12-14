Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75176E0
	for <linux-raid@vger.kernel.org>; Wed, 13 Dec 2023 17:34:50 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SrFJf2n8kz4f3lD2
	for <linux-raid@vger.kernel.org>; Thu, 14 Dec 2023 09:34:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5F7081A05A6
	for <linux-raid@vger.kernel.org>; Thu, 14 Dec 2023 09:34:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgDHyhCzW3plGNpXDg--.5483S3;
	Thu, 14 Dec 2023 09:34:45 +0800 (CST)
Subject: Re: RAID1 write-mostly+write-behind lockup bug, reproduced under
 6.7-rc5
To: Alexey Klimov <alexey.klimov@linaro.org>, linux-raid@vger.kernel.org
Cc: song@kernel.org, klimov.linux@gmail.com,
 Mathieu Poirier <mathieu.poirier@linaro.org>, "yukuai (C)"
 <yukuai3@huawei.com>
References: <CANgGJDrUELtNokv2T45RzaUr_8M8BYPr-AXJ2tpTk9umdK90+Q@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <da99b77d-61fc-b454-30b6-bf20d536277f@huaweicloud.com>
Date: Thu, 14 Dec 2023 09:34:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CANgGJDrUELtNokv2T45RzaUr_8M8BYPr-AXJ2tpTk9umdK90+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHyhCzW3plGNpXDg--.5483S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKr13Kw4xJryxXrW8tr1DJrb_yoW7ZrWfpF
	W3KanIyws2gr17XFWIyF1UX3yUJa17CFZxJF4xWw1xG3WkCFWxtF4xWFsakF4DZrZ3Ca1S
	qayDXr92gF1vyFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2023/12/14 7:48, Alexey Klimov 写道:
> Hi all,
> 
> After assembling raid1 consisting from two NVMe disks/partitions where
> one of the NVMes is slower than the other one using such command:
> mdadm --homehost=any --create --verbose --level=1 --metadata=1.2
> --raid-devices=2 /dev/md77 /dev/nvme2n1p9 --bitmap=internal
> --write-mostly --write-behind=8192 /dev/nvme1n1p2
> 
> I noticed some I/O freezing/lockup issues when doing distro builds
> using yocto. The idea of building write-mostly raid1 came from URL
> [0]. I suspected that massive and long IO operations led to that and
> while trying to narrow it down I can see that it doesn't survive
> through rebuilding linux kernel (just simple make -j33).
> 
> After enabling some lock checks in kernel and lockup detectors I think
> this is the main blocked task message:
> 
> [  984.138650] INFO: task kworker/u65:5:288 blocked for more than 491 seconds.
> [  984.138682]       Not tainted 6.7.0-rc5-00047-g5bd7ef53ffe5 #1
> [  984.138694] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  984.138702] task:kworker/u65:5   state:D stack:0     pid:288
> tgid:288   ppid:2      flags:0x00004000
> [  984.138728] Workqueue: writeback wb_workfn (flush-9:77)
> [  984.138760] Call Trace:
> [  984.138770]  <TASK>
> [  984.138785]  __schedule+0x3a5/0x1600
> [  984.138807]  ? schedule+0x99/0x120
> [  984.138818]  ? find_held_lock+0x2b/0x80
> [  984.138840]  schedule+0x48/0x120
> [  984.138851]  ? schedule+0x99/0x120
> [  984.138861]  wait_for_serialization+0xd2/0x110

This is waiting for issued IO to be done, from
raid1_end_write_request
  remove_serial
   raid1_rb_remove
   wake_up

So the first thing need clarification is that is there unfinished IO
from underlying disk? This is not easy, but perhaps you can try:

1) don't use the underlying disks by anyone else;
2) reporduce the problem, and then collect debugfs info for underlying
disks with following cmd:

find /sys/kernel/debug/block/sda/ -type f | xargs grep .

Thanks,
Kuai

> [  984.138880]  ? destroy_sched_domains_rcu+0x30/0x30
> [  984.138897]  raid1_make_request+0x838/0xdb0
> [  984.138913]  ? raid1_make_request+0x1e5/0xdb0
> [  984.138935]  ? lock_release+0x136/0x270
> [  984.138947]  ? lock_is_held_type+0xbe/0x110
> [  984.138963]  ? md_handle_request+0x1b/0x490
> [  984.138978]  md_handle_request+0x1b5/0x490
> [  984.138990]  ? md_handle_request+0x1b/0x490
> [  984.139001]  ? lock_is_held_type+0xbe/0x110
> [  984.139019]  __submit_bio+0x6f/0xb0
> [  984.139038]  submit_bio_noacct_nocheck+0x134/0x380
> ...
> and:
>                          Showing all locks held in the system:
> [  615.502946] 1 lock held by khungtaskd/214:
> [  615.502952]  #0: ffffffff824bd240 (rcu_read_lock){....}-{1:2}, at:
> debug_show_all_locks+0x2e/0x1e0
> [  615.502982] 5 locks held by kworker/u65:5/288:
> [  615.502989]  #0: ffff888101393538
> ((wq_completion)writeback){+.+.}-{0:0}, at:
> process_one_work+0x15c/0x480
> [  615.503012]  #1: ffff88810d08be60
> ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at:
> process_one_work+0x15c/0x480
> [  615.503034]  #2: ffff88810d7250e0
> (&type->s_umount_key#25){++++}-{3:3}, at:
> super_trylock_shared+0x21/0x70
> [  615.503060]  #3: ffff88810d720b98
> (&sbi->s_writepages_rwsem){++++}-{0:0}, at: do_writepages+0xbe/0x190
> [  615.503084]  #4: ffff88810d7223f0
> (&journal->j_checkpoint_mutex){+.+.}-{3:3}, at:
> jbd2_log_do_checkpoint+0x29a/0x300
> [  615.503111] no locks held by systemd-journal/605.
> [  615.503126] 1 lock held by sudo/6735:
> [  615.503139] 4 locks held by cli-update-thre/177767:
> [  615.503145]  #0: ffff888174e208c8 (&f->f_pos_lock){+.+.}-{3:3}, at:
> __fdget_pos+0x4b/0x70
> [  615.503169]  #1: ffff88810d725410 (sb_writers#8){.+.+}-{0:0}, at:
> ksys_write+0x6a/0xf0
> [  615.503192]  #2: ffff8886e6285938
> (&sb->s_type->i_mutex_key#11){++++}-{3:3}, at:
> ext4_buffered_write_iter+0x45/0x110
> [  615.503215]  #3: ffff88810d7223f0
> (&journal->j_checkpoint_mutex){+.+.}-{3:3}, at:
> jbd2_log_do_checkpoint+0x29a/0x300
> [  615.503242] 3 locks held by py3-cmd/186209:
> [  615.503247]  #0: ffff88810d725410 (sb_writers#8){.+.+}-{0:0}, at:
> path_openat+0x683/0xb00
> [  615.503271]  #1: ffff888750d40400
> (&type->i_mutex_dir_key#6){++++}-{3:3}, at: path_openat+0x273/0xb00
> [  615.503296]  #2: ffff88810d7223f0
> (&journal->j_checkpoint_mutex){+.+.}-{3:3}, at:
> jbd2_log_do_checkpoint+0x29a/0x300
> 
> I will attach the full dmesg.
> 
> 1. This was also observed in 6.6 debian disto kernel and I just
> reproduced it under 6.7-rc5. I think under 6.6 kernel the blocked
> tasks logs were the same or similar.
> 2. It has simple ext4 and after emergency reboot fsck is able to
> repair the filesystem.
> 3. Disks worked fine when were not used in software raid1 and other
> distributions using other non-raid partitions don't experience any
> freezes or lockups. I don't think that this is hw fault.
> 4. This system also has raid1 (not write-mostly, just simple raid1)
> and raid10 devices that work fine with the same workloads.
> 
> I can test patches or specific commits if you have any suggestions and
> I can try to collect more debug data. Or maybe some sysfs files can
> tuned to test if there are some conditions when lockup isn't
> happening? If required I can also backup and re-assemble it as simple
> raid1, for instance, and check the same workloads.
> 
> Thanks,
> Alexey Klimov
> 
> [0]: https://raid.wiki.kernel.org/index.php/Write-mostly
> 

