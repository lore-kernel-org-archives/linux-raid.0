Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AC2C7EE23
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 09:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbjEXJHQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 05:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240201AbjEXJHN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 05:07:13 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C4B12B
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 02:07:12 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QR50r0f6pz4f402w
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 17:07:08 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgCnUyG7021kUWc9JQ--.13542S3;
        Wed, 24 May 2023 17:07:08 +0800 (CST)
Subject: Re: [PATCH tests 4/5] tests: add a regression test for raid10
 deadlock
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
 <20230523133900.3149123-5-yukuai1@huaweicloud.com>
 <20230524104828.000070bf@linux.intel.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <96ce6522-944c-3058-4d9c-b59381383223@huaweicloud.com>
Date:   Wed, 24 May 2023 17:07:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230524104828.000070bf@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgCnUyG7021kUWc9JQ--.13542S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw47GFW3Zw45CFykCw15Jwb_yoW5ZF17pa
        yUGFW5KrW8W3W7Zw13G3WUCFySqa1kJr47C34aqw4ayr9F9rn7Zan7Kr45uFZ7Zr4UKw1k
        u3Z0vFWfKr1jkFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUF9a9DU
        UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/05/24 16:48, Mariusz Tkaczyk Ð´µÀ:
> On Tue, 23 May 2023 21:38:59 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> The deadlock is described in [1], it's fixed first by [2], however,
>> it turns out this commit will trigger other problems[3], hence this
>> commit will be reverted and the deadlock is supposed to be fixed by [1].
>>
>> [1]
>> https://lore.kernel.org/linux-raid/20230322064122.2384589-5-yukuai1@huaweicloud.com/
>> [2]
>> https://lore.kernel.org/linux-raid/20220621031129.24778-1-guoqing.jiang@linux.dev/
>> [3]
>> https://lore.kernel.org/linux-raid/20230322064122.2384589-2-yukuai1@huaweicloud.com/
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   tests/24raid10deadlock              | 85 +++++++++++++++++++++++++++++
>>   tests/24raid10deadlock.inject_error |  0
>>   2 files changed, 85 insertions(+)
>>   create mode 100644 tests/24raid10deadlock
>>   create mode 100644 tests/24raid10deadlock.inject_error
>>
>> diff --git a/tests/24raid10deadlock b/tests/24raid10deadlock
>> new file mode 100644
>> index 00000000..27869840
>> --- /dev/null
>> +++ b/tests/24raid10deadlock
>> @@ -0,0 +1,85 @@
>> +devs="$dev0 $dev1 $dev2 $dev3"
>> +runtime=120
>> +pid=""
>> +
>> +set_up_injection()
>> +{
>> +	echo -1 > /sys/kernel/debug/fail_make_request/times
>> +	echo 1 > /sys/kernel/debug/fail_make_request/probability
>> +	echo 0 > /sys/kernel/debug/fail_make_request/verbose
>> +	echo 1 > /sys/block/${1##*/}/make-it-fail
>> +}
>> +
>> +clean_up_injection()
>> +{
>> +	echo 0 > /sys/block/${1##*/}/make-it-fail
>> +	echo 0 > /sys/kernel/debug/fail_make_request/times
>> +	echo 0 > /sys/kernel/debug/fail_make_request/probability
>> +	echo 2 > /sys/kernel/debug/fail_make_request/verbose
>> +}
>> +
>> +test_rdev()
>> +{
>> +	while true; do
>> +		mdadm -f $md0 $1 &> /dev/null
>> +		mdadm -r $md0 $1 &> /dev/null
>> +		mdadm --zero-superblock $1 &> /dev/null
>> +		mdadm -a $md0 $1 &> /dev/null
>> +		sleep $2
>> +	done
>> +}
>> +
>> +test_write_action()
>> +{
>> +	while true; do
>> +		echo frozen > /sys/block/md0/md/sync_action
>> +		echo idle > /sys/block/md0/md/sync_action
>> +		sleep 0.1
>> +	done
>> +}
>> +
>> +set_up_test()
>> +{
>> +	fio -h &> /dev/null || die "fio not found"
>> +
>> +	# create a simple raid10
>> +	mdadm -Cv -R -n 4 -l10 $md0 $devs || die "create raid10 failed"
>> +}
>> +
>> +clean_up_test()
>> +{
>> +	clean_up_injection $dev0
>> +	kill -9 $pid
>> +	pkill -9 fio
>> +
>> +	sleep 1
>> +
>> +	if ! mdadm -S $md0; then
>> +		die "can't stop array, deadlock is probably triggered"
>> +	fi
> 
> stop may fail from different reasons I see it as too big to be marker of
> "deadlock". I know that --stop still fails because md is unable to clear sysfs
> attrs in expected time (or a least it was a problem few years ago). Is there a
> better way to check that? I would prefer, different less complicated action to
> exclude false positives.
> 
> In my IMSM environment I still see that md stop stress test is failing
> sporadically (1/100).

Yes, this make sense, perhaps I'll try to detect if related task is
stuck in D state.

Thanks,
Kuai
> 
> Thanks,
> Mariusz
> 
> .
> 

