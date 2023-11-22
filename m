Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058BDF4
	for <linux-raid@vger.kernel.org>; Wed, 22 Nov 2023 03:51:38 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Sb02Y5vRwz4f3kFL
	for <linux-raid@vger.kernel.org>; Wed, 22 Nov 2023 19:51:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 78D701A0472
	for <linux-raid@vger.kernel.org>; Wed, 22 Nov 2023 19:51:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHShBF611lHMR_Bg--.59433S3;
	Wed, 22 Nov 2023 19:51:35 +0800 (CST)
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Yu Kuai <yukuai1@huaweicloud.com>,
 Alexander Lyakas <alex.bolshoy@gmail.com>, song@kernel.org,
 linux-raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
 <935a3e51-ff76-d9f1-be2c-745f3b1e15b8@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a30ef124-5d34-d7f9-3742-42cdbd939b76@huaweicloud.com>
Date: Wed, 22 Nov 2023 19:51:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <935a3e51-ff76-d9f1-be2c-745f3b1e15b8@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHShBF611lHMR_Bg--.59433S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4UXw1xZr1fJw4rZFyUGFg_yoWrXry5pF
	W0qa4YyayDJrs7W3W8t3Z2ga4Fyws7C3y3Gr15GFy7Zrn8CryIvayDWa1Fgry3trs5AF4j
	qw45K3y3ZF90q3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbrMaU
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2023/11/22 19:36, Yu Kuai 写道:
> Hi,
> 
> 在 2023/11/22 17:42, Alexander Lyakas 写道:
>> Hello Song Liu,
>>
>> We had a raid6 with 6 drives, all drives marked as In_sync. At some
>> point drive in slot 5 (last drive) was marked as Faulty, due to
>> timeout IO error. Superblocks of all other drives got updated with
>> event count higher by 1. However, the Faulty drive was still not
>> ejected from the array by remove_and_add_spares(), probably because it
>> still had nr_pending. This situation was going on for 20 minutes, and
> 
> I think this is important, what kind of driver are you using for the
> array? 20 minutes should be enough to let block layer timeout handle to
> finish all the IO. Did you try to remove this disk manually?
> 
>> the Faulty drive was still not being removed from the array. But array
>> continued serving writes, skipping the Faulty drive as designed.
>>
>> After about 20 minutes, the machine got rebooted due to some other 
>> reason.
> 
> md_new_event is called from do_md_stop(), which means if this array
> stopped, then event counter from other drives will be higher by 2, and
> this problem won't exist anymore. So, I guess you array doesn't stopped
> normally during reboot, and your case really is the same as crashes
> while updating super_block.
> 
> There is a simple way to avoid your problem, just add event counter by
> 2 in md_error().

Sorry that I relized that this is not a proper way to avoid the problem,
this will cause that if system crashes while updating super_block,
assemble will fail.

Thanks,
Kuai

> 
> Thanks,
> Kuai
>>
>> After reboot, the array got assembled, and the event counter
>> difference was 1 between the problematic drive and all other drives.
>> Even count on all drives was 2834681, but on the problematic drive it
>> was 2834680. As a result, mdadm considered the problematic drive as
>> up-to-date, due to this code in mdadm[1]. Kernel also accepted such
>> difference of 1, as can be seen in super_1_validate() [2].
>>
>> In addition, the array was marked as dirty, so RESYNC of the array
>> started. For raid6, to my understanding, resync re-calculates parity
>> blocks based on data blocks. But many data blocks on the problematic
>> drive were not up to date, because this drive was marked as Faulty for
>> 20 minutes and writes to it were skipped. As a result, REYNC made the
>> parity blocks to match the not-up-to-date data blocks from the
>> problematic drive. Data on the array became unusable.
>>
>> Many years ago, I asked Neil why event count difference of 1 was
>> allowed. He responded that this was to address the case when the
>> machine crashes in the middle of superblock writes, so some superblock
>> writes succeeded and some failed. In such case, allowing event count
>> difference of 1 is legitimate.
>>
>> Can you please comment of whether this behavior seems correct, in
>> light of the scenario above?
>>
>> Thanks,
>> Alex.
>>
>> [1]
>> int event_margin = 1; /* always allow a difference of '1'
>>         * like the kernel does
>>         */
>> ...
>> /* Require event counter to be same as, or just less than,
>> * most recent.  If it is bigger, it must be a stray spare and
>> * should be ignored.
>> */
>> if (devices[j].i.events+event_margin >=
>>      devices[most_recent].i.events &&
>>      devices[j].i.events <=
>>      devices[most_recent].i.events
>> ) {
>> devices[j].uptodate = 1;
>>
>> [2]
>> } else if (mddev->pers == NULL) {
>> /* Insist of good event counter while assembling, except for
>> * spares (which don't need an event count) */
>> ++ev1;
>> if (rdev->desc_nr >= 0 &&
>>      rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
>>      (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX ||
>>       le16_to_cpu(sb->dev_roles[rdev->desc_nr]) == MD_DISK_ROLE_JOURNAL))
>> if (ev1 < mddev->events)
>> return -EINVAL;
>>
>>
>> .
>>
> 
> .
> 

