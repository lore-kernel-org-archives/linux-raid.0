Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFE7263C66
	for <linux-raid@vger.kernel.org>; Tue,  8 Apr 2025 08:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744101142; cv=none; b=YFN6Nde9cfhivU2nd1S+TxeS3CntemzIqUoEVdP5Yxp5NPewEyq2DCIk2JNtFpure+dkgrgG/lhVN6jzWEzhaBljsAGzISSdj6aSct5kwco6fsVz3OwM0gQiVvmn1smxm00Q5imUxWDEJCViwkWl27njls6sn4LGc8oHm//l0Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744101142; c=relaxed/simple;
	bh=d8vG1EZwkHFaDOv77XUeMFlu3ERBPvvKU8bpnsknqPw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UR3MTJrzsorlrsJRjBdLg0Rh+plklEP8vyhslkQ6AwYoyYThDpJUqMWQxfb4Cuc2Rt8SpNkbcp9GJ/XAWJ7e3GnCX3CdtkXq9jkFV2OvVCZ9ampC+WWwNknUJudMiGPdhjxSul6mJ7oKFH7mwP1RfBQQF8aqXuZIf2H0nTp5x2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZWznx0ztgz4f3lgL
	for <linux-raid@vger.kernel.org>; Tue,  8 Apr 2025 16:31:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 168231A1AA4
	for <linux-raid@vger.kernel.org>; Tue,  8 Apr 2025 16:32:14 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH618N3_RnI8dyIw--.58319S3;
	Tue, 08 Apr 2025 16:32:14 +0800 (CST)
Subject: Re: [PATCH] md/raid1: Add check for missing source disk in
 process_checks()
To: Yu Kuai <yukuai1@huaweicloud.com>, Meir Elisha <meir.elisha@volumez.com>,
 Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250408074909.729471-1-meir.elisha@volumez.com>
 <10e5a340-a300-2937-76c1-74040a9a23fd@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <712ff6db-6b01-be95-a394-266be08a1d6e@huaweicloud.com>
Date: Tue, 8 Apr 2025 16:32:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <10e5a340-a300-2937-76c1-74040a9a23fd@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH618N3_RnI8dyIw--.58319S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GrWrWrWfWw4rWFWDtF13urg_yoW7tF1Dpa
	n7JrWvvry5Gr95Jr1DtFyUZFyrAr1UJa4DJr1kWa47Zrs8JrWYqFWUXryjgryDJrWrGw17
	Xw1DXrW7ZF17JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbhvttUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/08 16:28, Yu Kuai 写道:
> Hi,
> 
> 在 2025/04/08 15:49, Meir Elisha 写道:
>> During recovery/check operations, the process_checks function loops
>> through available disks to find a 'primary' source with successfully
>> read data.
>>
>> If no suitable source disk is found after checking all possibilities,
>> the 'primary' index will reach conf->raid_disks * 2. Add an explicit
>> check for this condition after the loop. If no source disk was found,
>> print an error message and return early to prevent further processing
>> without a valid primary source.
>>
>> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
>> ---
>> This was observed when forcefully disconnecting all iSCSI devices backing
>> a RAID1 array(using --failfast flag) during a check operation, causing
>> all reads within process_checks to fail. The resulting kernel oops shows:
>>
>>    BUG: kernel NULL pointer dereference, address: 0000000000000040
>>    RIP: 0010:process_checks+0x25e/0x5e0 [raid1]
>>    Code: ... <4c> 8b 53 40 ... // mov r10,[rbx+0x40]
>>    Call Trace:
>>     process_checks
>>     sync_request_write
>>     raid1d
>>     md_thread
>>     kthread
>>     ret_from_fork
>>
>>   drivers/md/raid1.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 0efc03cea24e..b6a52c137f53 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2296,6 +2296,12 @@ static void process_checks(struct r1bio *r1_bio)
>>               rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
>>               break;
>>           }
>> +
>> +    if (primary >= conf->raid_disks * 2) {
>> +        pr_err_ratelimited("md/raid1:%s: unable to find source 
>> disk\n", mdname(mddev));
>> +        return;
>> +    }
> 
> This means all reads failed, then I'm a bit confused why
> sync_request_write() doesn't return early?
> 
> end_sync_read
>   if (!bio->bi_status)
>    // uptodate is not set
>    set_bit(R1BIO_Uptodate, &r1_bio->state);
> 
> sync_request_write
>   if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>    if (!fix_sync_read_error(r1_bio))
>     // why not return here?
>     return;
> 
>   process_checks(r1_bio);
> 
> The answer is that fix_sync_read_error() is used for the case just one
> rdev is read, it just handle the bio from r1_bio->read_disk, and suppose 
> that just one rdev is read. And if rdev_set_badblocks() succeed,
> fix_sync_read_error() will clear R1BIO_Uptodate and bi_status and
> finally cause this problem.
> 
> While in this case, all member disks are read for check/repair, hence I
> think fix_sync_read_error() is not supposed to be called here, and
> better solution will be:
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index d422bab77580..dafda9095c73 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2346,10 +2346,15 @@ static void sync_request_write(struct mddev 
> *mddev, struct r1bio *r1_bio)
>          int disks = conf->raid_disks * 2;
>          struct bio *wbio;
> 
> -       if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
> -               /* ouch - failed to read all of that. */
> -               if (!fix_sync_read_error(r1_bio))
> +       if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
> +               /*
> +                * ouch - failed to read all of that. No need to fix 
> read error
> +                * for check or repair because read all member disks 
> failed.
> +                */
> +               if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
> +                   !fix_sync_read_error(r1_bio))
>                          return;
> +       }
> 
>          if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>                  process_checks(r1_bio);
Sorry that I forgot to release the r1bio, please check the following
patch:

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d422bab77580..1a04dc91a8aa 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2200,14 +2200,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
                                 if (!rdev_set_badblocks(rdev, sect, s, 0))
                                         abort = 1;
                         }
-                       if (abort) {
-                               conf->recovery_disabled =
-                                       mddev->recovery_disabled;
-                               set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-                               md_done_sync(mddev, r1_bio->sectors, 0);
-                               put_buf(r1_bio);
+                       if (abort)
                                 return 0;
-                       }
+
                         /* Try next page */
                         sectors -= s;
                         sect += s;
@@ -2346,10 +2341,20 @@ static void sync_request_write(struct mddev 
*mddev, struct r1bio *r1_bio)
         int disks = conf->raid_disks * 2;
         struct bio *wbio;

-       if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
-               /* ouch - failed to read all of that. */
-               if (!fix_sync_read_error(r1_bio))
+       if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
+               /*
+                * ouch - failed to read all of that. No need to fix 
read error
+                * for check or repair because all member disks are read.
+                */
+               if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
+                   !fix_sync_read_error(r1_bio)) {
+                       conf->recovery_disabled = mddev->recovery_disabled;
+                       set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+                       md_done_sync(mddev, r1_bio->sectors, 0);
+                       put_buf(r1_bio);
                         return;
+               }
+       }

         if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
                 process_checks(r1_bio);

Thanks,
Kuai
> 
> Thanks,
> Kuai
> 
>> +
>>       r1_bio->read_disk = primary;
>>       for (i = 0; i < conf->raid_disks * 2; i++) {
>>           int j = 0;
>>
> 
> .
> 

