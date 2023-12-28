Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC446FD6
	for <linux-raid@vger.kernel.org>; Thu, 28 Dec 2023 12:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4T16kS4TJZz4f3jHY
	for <linux-raid@vger.kernel.org>; Thu, 28 Dec 2023 20:09:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 167B01A0897
	for <linux-raid@vger.kernel.org>; Thu, 28 Dec 2023 20:09:26 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgC3uA50ZY1l4ap0Ew--.36376S3;
	Thu, 28 Dec 2023 20:09:25 +0800 (CST)
Subject: Re: RAID1 write-mostly+write-behind lockup bug, reproduced under
 6.7-rc5
To: Alexey Klimov <alexey.klimov@linaro.org>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, klimov.linux@gmail.com,
 Mathieu Poirier <mathieu.poirier@linaro.org>, "yukuai (C)"
 <yukuai3@huawei.com>
References: <CANgGJDrUELtNokv2T45RzaUr_8M8BYPr-AXJ2tpTk9umdK90+Q@mail.gmail.com>
 <da99b77d-61fc-b454-30b6-bf20d536277f@huaweicloud.com>
 <CANgGJDpsrjbTPDtt7xhDEfx0uheHLo98QsNSFa7Pqbghri4mfg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0d4558cb-0836-e0dd-d100-a1fa11cec74b@huaweicloud.com>
Date: Thu, 28 Dec 2023 20:09:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CANgGJDpsrjbTPDtt7xhDEfx0uheHLo98QsNSFa7Pqbghri4mfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgC3uA50ZY1l4ap0Ew--.36376S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXr45ur48uFyxGr1rGr47XFb_yoWrGry7pr
	W5t3Wayws7Wr1xWasFvrn7XFyjka1kArZxJrnxX34rKrn0kF1ftr4xKrs0vF12vrs3Cw4I
	vrs8Wr9rur1vyw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2023/12/28 12:19, Alexey Klimov 写道:
> On Thu, 14 Dec 2023 at 01:34, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/12/14 7:48, Alexey Klimov 写道:
>>> Hi all,
>>>
>>> After assembling raid1 consisting from two NVMe disks/partitions where
>>> one of the NVMes is slower than the other one using such command:
>>> mdadm --homehost=any --create --verbose --level=1 --metadata=1.2
>>> --raid-devices=2 /dev/md77 /dev/nvme2n1p9 --bitmap=internal
>>> --write-mostly --write-behind=8192 /dev/nvme1n1p2
>>>
>>> I noticed some I/O freezing/lockup issues when doing distro builds
>>> using yocto. The idea of building write-mostly raid1 came from URL
>>> [0]. I suspected that massive and long IO operations led to that and
>>> while trying to narrow it down I can see that it doesn't survive
>>> through rebuilding linux kernel (just simple make -j33).
>>>
>>> After enabling some lock checks in kernel and lockup detectors I think
>>> this is the main blocked task message:
>>>
>>> [  984.138650] INFO: task kworker/u65:5:288 blocked for more than 491 seconds.
>>> [  984.138682]       Not tainted 6.7.0-rc5-00047-g5bd7ef53ffe5 #1
>>> [  984.138694] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>> disables this message.
>>> [  984.138702] task:kworker/u65:5   state:D stack:0     pid:288
>>> tgid:288   ppid:2      flags:0x00004000
>>> [  984.138728] Workqueue: writeback wb_workfn (flush-9:77)
>>> [  984.138760] Call Trace:
>>> [  984.138770]  <TASK>
>>> [  984.138785]  __schedule+0x3a5/0x1600
>>> [  984.138807]  ? schedule+0x99/0x120
>>> [  984.138818]  ? find_held_lock+0x2b/0x80
>>> [  984.138840]  schedule+0x48/0x120
>>> [  984.138851]  ? schedule+0x99/0x120
>>> [  984.138861]  wait_for_serialization+0xd2/0x110
>>
>> This is waiting for issued IO to be done, from
>> raid1_end_write_request
>>    remove_serial
>>     raid1_rb_remove
>>     wake_up
> 
> Yep, looks like this.
> 
>> So the first thing need clarification is that is there unfinished IO
>> from underlying disk? This is not easy, but perhaps you can try:
>>
>> 1) don't use the underlying disks by anyone else;
>> 2) reporduce the problem, and then collect debugfs info for underlying
>> disks with following cmd:
>>
>> find /sys/kernel/debug/block/sda/ -type f | xargs grep .
> 
> I collected this and attaching to this email.
> When I collected this debug data I also noticed the following inflight counters:
> root@tux:/sys/devices/virtual/block/md77# cat inflight
>         0       65
> root@tux:/sys/devices/virtual/block/md77# cat slaves/nvme1n1p2/inflight
>         0        0
> root@tux:/sys/devices/virtual/block/md77# cat slaves/nvme2n1p9/inflight
>         0        0
> 
> So I guess on the md or raid1 level there are 65 write requests that
> didn't finish but nothing from underlying physical devices, right?

Actually, IOs stuck in wait_for_serialization() are accounted by
inflight from md77.

However, since there are no IO from nvme disks, looks like something is
wrong with write behind.

> 
> Apart from that. When the lockup/freeze happens I can mount other
> partitions on the corresponding nvme devices and create files there.
> nvme-cli util also don't show any issues AFAICS.
> 
> When I manually set backlog file to zero:
> echo 0 > /sys/devices/virtual/block/md77/md/bitmap/backlog
> the lockup is no longer reproducible.

Of course, this disables write behind, which also indicates something
is wrong with write behind.

I'm trying to review related code, however, this might be difficult,
can you discribe how do you reporduce this problem in detailed steps?
and I will try to reporduce this. If I still can't, can you apply a
debug patch and recompile the kernel to test?

Thanks,
Kuai

> 
> Let me know what other debug data I can collect.
> 
> Thanks,
> Alexey
> 

