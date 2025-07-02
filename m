Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D253C30
	for <linux-raid@vger.kernel.org>; Wed,  2 Jul 2025 01:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751419201; cv=none; b=kP640Pr5ylhl+9ANKtNFu+i61YxjyibyaKR5gCS4Y/YxztTBlG0oAdZeBwQ+CyNPMEwNpTkRu0SAvQ1tUwEmZUMgXebnd672IACUjErvQtdIX1DsOK6idB4HS04hb1tolIXDG/F/Qyac1rObtR+zmAg1Lvi0LRTPiIVvV4vrXZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751419201; c=relaxed/simple;
	bh=2LNmEttM5R3B5mRdcVSpRkVHJ+JBQZKmUJ5vEr4xDVQ=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gCBJ7LC4vVIbBCjqdprw+9TQhLEro0VxSCc7PlwnoxHYPk3HwrU8a3+JjHEdBA9F8LRNYfMBweCfbvOWkMikrRUS25vgFK66f0r8+CHi3mvnzTGbYQM1HrjU4iGeAEIQT8EenV3eAJXRC4CEr1b4oT/xroI78tN2QN89csWFUOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bX2BP2k4SzKHMbG
	for <linux-raid@vger.kernel.org>; Wed,  2 Jul 2025 09:19:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id C5A3B1A19EF
	for <linux-raid@vger.kernel.org>; Wed,  2 Jul 2025 09:19:55 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP3 (Coremail) with SMTP id _Ch0CgB32SY7iWRoe8l7AQ--.38679S3;
	Wed, 02 Jul 2025 09:19:55 +0800 (CST)
Subject: Re: [PATCH v2] raid10: cleanup memleak at raid10_make_request
To: Nigel Croxon <ncroxon@redhat.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, yukuai1@huaweicloud.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <ae2830d3-5f71-4c32-9259-9ce2f952cf3d@redhat.com>
 <b7a5e548-3d67-42bd-8328-04987f4fa9b2@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ddf0796b-28eb-3c18-6e60-d63086a366d8@huaweicloud.com>
Date: Wed, 2 Jul 2025 09:19:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b7a5e548-3d67-42bd-8328-04987f4fa9b2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB32SY7iWRoe8l7AQ--.38679S3
X-Coremail-Antispam: 1UD129KBjvJXoWxtw1xuw4fCw43Ww1rKryUZFb_yoW7ZFyfpr
	4kKF9rurWrWws5Jw4UtFy3WFy8Jr4UAasrAr4rJa47Jr47AFyqqF4UXr10gF4DArWkGr1U
	Xr1DXrZFvr17XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbhvttUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/02 5:46, Nigel Croxon 写道:
> 
> 
> On 6/30/25 3:51 PM, Nigel Croxon wrote:
>> If raid10_read_request or raid10_write_request registers a new
>> request and the REQ_NOWAIT flag is set, the code does not
>> free the malloc from the mempool.
>>
>> unreferenced object 0xffff8884802c3200 (size 192):
>>    comm "fio", pid 9197, jiffies 4298078271
>>    hex dump (first 32 bytes):
>>      00 00 00 00 00 00 00 00 88 41 02 00 00 00 00 00  .........A......
>>      08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>    backtrace (crc c1a049a2):
>>      __kmalloc+0x2bb/0x450
>>      mempool_alloc+0x11b/0x320
>>      raid10_make_request+0x19e/0x650 [raid10]
>>      md_handle_request+0x3b3/0x9e0
>>      __submit_bio+0x394/0x560
>>      __submit_bio_noacct+0x145/0x530
>>      submit_bio_noacct_nocheck+0x682/0x830
>>      __blkdev_direct_IO_async+0x4dc/0x6b0
>>      blkdev_read_iter+0x1e5/0x3b0
>>      __io_read+0x230/0x1110
>>      io_read+0x13/0x30
>>      io_issue_sqe+0x134/0x1180
>>      io_submit_sqes+0x48c/0xe90
>>      __do_sys_io_uring_enter+0x574/0x8b0
>>      do_syscall_64+0x5c/0xe0
>>      entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>> ---
>>   drivers/md/raid10.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>

Patch looks good, please add a fix tag.

And BTW, which branch are you rebasing?

Thanks,
Kuai

>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.cl
>> index 975fba8bdf17..acedc0481f1d 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1181,8 +1181,10 @@ static void raid10_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>           }
>>       }
>>
>> -    if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors))
>> +    if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
>> +        raid_end_bio_io(r10_bio);
>>           return;
>> +    }
>>       rdev = read_balance(conf, r10_bio, &max_sectors);
>>       if (!rdev) {
>>           if (err_rdev) {
>> @@ -1369,8 +1371,10 @@ static void raid10_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>       }
>>
>>       sectors = r10_bio->sectors;
>> -    if (!regular_request_wait(mddev, conf, bio, sectors))
>> +    if (!regular_request_wait(mddev, conf, bio, sectors)) {
>> +        raid_end_bio_io(r10_bio);
>>           return;
>> +    }
>>       if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>>           (mddev->reshape_backwards
>>            ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
> 
> 
> V2 backed against the latest upstream.
> 
> 
> [PATCH v2] raid10: cleanup memleak at raid10_make_request
> 
> If raid10_read_request or raid10_write_request registers a new
> request and the REQ_NOWAIT flag is set, the code does not
> free the malloc from the mempool.
> 
> unreferenced object 0xffff8884802c3200 (size 192):
>    comm "fio", pid 9197, jiffies 4298078271
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 88 41 02 00 00 00 00 00  .........A......
>      08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace (crc c1a049a2):
>      __kmalloc+0x2bb/0x450
>      mempool_alloc+0x11b/0x320
>      raid10_make_request+0x19e/0x650 [raid10]
>      md_handle_request+0x3b3/0x9e0
>      __submit_bio+0x394/0x560
>      __submit_bio_noacct+0x145/0x530
>      submit_bio_noacct_nocheck+0x682/0x830
>      __blkdev_direct_IO_async+0x4dc/0x6b0
>      blkdev_read_iter+0x1e5/0x3b0
>      __io_read+0x230/0x1110
>      io_read+0x13/0x30
>      io_issue_sqe+0x134/0x1180
>      io_submit_sqes+0x48c/0xe90
>      __do_sys_io_uring_enter+0x574/0x8b0
>      do_syscall_64+0x5c/0xe0
>      entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> V2: rebuild against latest upstream.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   drivers/md/raid10.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b74780af4c22..798001ebb48c 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1182,8 +1182,10 @@ static void raid10_read_request(struct mddev 
> *mddev, struct bio *bio,
>           }
>       }
> 
> -    if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors))
> +    if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
> +        raid_end_bio_io(r10_bio);
>           return;
> +    }
>       rdev = read_balance(conf, r10_bio, &max_sectors);
>       if (!rdev) {
>           if (err_rdev) {
> @@ -1370,8 +1372,10 @@ static void raid10_write_request(struct mddev 
> *mddev, struct bio *bio,
>       }
> 
>       sectors = r10_bio->sectors;
> -    if (!regular_request_wait(mddev, conf, bio, sectors))
> +    if (!regular_request_wait(mddev, conf, bio, sectors)) {
> +        raid_end_bio_io(r10_bio);
>           return;
> +    }
>       if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>           (mddev->reshape_backwards
>            ? (bio->bi_iter.bi_sector < conf->reshape_safe &&

