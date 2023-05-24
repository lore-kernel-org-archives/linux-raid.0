Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1503DC77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 08:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbjEXI0z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 04:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240129AbjEXI0x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 04:26:53 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A50184
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 01:26:51 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QR46H0HR1z4f3pCc
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 16:26:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgBH9CFFym1kY4M7JQ--.57462S3;
        Wed, 24 May 2023 16:26:46 +0800 (CST)
Subject: Re: [PATCH tests 1/5] tests: add a new test to check if pluged bio is
 unlimited for raid10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
 <20230523133900.3149123-2-yukuai1@huaweicloud.com>
 <20230524095314.000007f9@linux.intel.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5fdfece6-6a45-7de7-7754-afc16d58145b@huaweicloud.com>
Date:   Wed, 24 May 2023 16:26:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230524095314.000007f9@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgBH9CFFym1kY4M7JQ--.57462S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw47Cry5GF1kJrW8CryDKFg_yoWrXry8pF
        WxGF4Ykr1xZ3W7AwnIq3W7XFyS9r48JFyUAr9Iyw12yrZxCryava4fKF4jk3y7urs3W345
        uF4YqayIkF1YyaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/05/24 15:53, Mariusz Tkaczyk Ð´µÀ:
> On Tue, 23 May 2023 21:38:56 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Pluged bio is unlimited means that all submitted bio will be pluged, and
>> those bio won't be issued to underlaying disks until blk_finish_plug() or
>> blk_flush_plug(). In this case, a lot memory will be used for
>> raid10_bio and io latency will be very bad.
>>
>> This test do some dirty pages writeback for raid10, where plug is used, and
>> check if device inflight counter exceed threshold.
>>
>> This problem is supposed to be fixed by [1].
> 
> The test here is for md, mdadm has nothing to do here. I'm not against it
> but please extract it to separate directory because like "md_tests".
> We need to start grouping tests.

Sorry I don't understand this, currently the test for md is here, I
don't see why need a seperate directory, is there a plan to move all
these tests into new directory?

>>
>> [1]
>> https://lore.kernel.org/linux-raid/20230420112946.2869956-9-yukuai1@huaweicloud.com/
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   tests/22raid10plug | 41 +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 41 insertions(+)
>>   create mode 100644 tests/22raid10plug
>>
>> diff --git a/tests/22raid10plug b/tests/22raid10plug
>> new file mode 100644
>> index 00000000..fde4ce80
>> --- /dev/null
>> +++ b/tests/22raid10plug
>> @@ -0,0 +1,41 @@
>> +devs="$dev0 $dev1 $dev2 $dev3 $dev4 $dev5"
>> +
>> +# test will fail if inflight is observed to be greater
>> +threshold=4096
>> +
>> +# create a simple raid10
>> +mdadm --create --run --level=raid10 --raid-disks 6 $md0 $devs
>> --bitmap=internal --assume-clean
> You don't need 6 drives, 4 is enough (unless I miss something).

Yes, 4 is enough.

>   
>> +if [ $? -ne 0 ]; then
>> +        die "create raid10 failed"
>> +fi
>> +
>> +old_background=`cat /proc/sys/vm/dirty_background_ratio`
>> +old=`cat /proc/sys/vm/dirty_ratio`
>> +
>> +# trigger background writeback
>> +echo 0 > /proc/sys/vm/dirty_background_ratio
>> +echo 60 > /proc/sys/vm/dirty_ratio
>> +
>> +# io pressure with buffer write
>> +fio -filename=$md0 -ioengine=libaio -rw=write -bs=4k -numjobs=1 -iodepth=128
>> -name=test -runtime=10 & +
>> +pid=$!
>> +
>> +sleep 2
>> +
>> +# check if inflight exceed threshold
>> +while true; do
>> +        tmp=`cat /sys/block/md0/inflight | awk '{printf("%d\n", $1 + $2);}'`
>> +        if [ $tmp -gt $threshold ]; then
>> +                die "inflight is greater than 4096"
> 
> The message here is not meaningful, what 4096 is? Please add comment describing
> why value above 4096 causes an error. We need to understand how the future
> changes in md may affect this setting (I think that there is a correlation
> between the value and MAX_PLUG_BIO).

MAX_PLUG_BIO is just limit for one task, I'm not sure if there will only
be one task issuing io, that why I choose a much larger value 4096.
> 
>> +                break
> 
> the break is dead condition because die has `exit` inside.

Yes, I found that while writing other tests, I'll use trap to make sure
everthing is cleaned up.

> 
>> +        elif [ $tmp -eq 0 ]; then
>> +                break
>> +        fi
> 
> I would prefer to make verification independent from user
> environment and md device inflight state. Simply, we should rely on fio. If
> there is a fio in background we should check if inflight doesn't exceeded
> expected value. we should finish when fio ends. You set runtime to 10, please
> think if we can make this shorter.

I'll change that check inflight when fio is in backgroud. But I don't
10s can be shorter, in my VM, it can take 1-5s to trigger the problem, I
was worried that 10s might not be enough for someone...

Thanks,
Kuai

> 
> Thanks,
> Mariusz
> 
>> +        sleep 0.1
>> +done
>> +
>> +kill -9 $pid
>> +mdadm -S $md0
>> +echo $old_background > /proc/sys/vm/dirty_background_ratio
>> +echo $old > /proc/sys/vm/dirty_ratio
> 
> .
> 

