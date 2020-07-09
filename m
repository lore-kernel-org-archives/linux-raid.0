From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v5 00/16] md/raid5: set STRIPE_SIZE as a configurable
 value
Date: Thu, 9 Jul 2020 21:27:42 +0800
Message-ID: <21aaf87f-157b-c37a-f16b-4e981268eeda@huawei.com>
References: <20200702120628.777303-1-yuyufen@huawei.com>
 <CAPhsuW7PgJV-bjaa8v=Zrhd0MqPmjew1dF-Qi0FP6i-809YAQg@mail.gmail.com>
 <0dd1ebed-2802-2bef-48f0-87bbdd2ee8e5@huawei.com>
 <CAPhsuW7m7qYGe3g2XyZNWZch4Wy0y2URNeUprKAm4si+nyBB8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW7m7qYGe3g2XyZNWZch4Wy0y2URNeUprKAm4si+nyBB8g@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids



On 2020/7/9 7:55, Song Liu wrote:
> On Wed, Jul 8, 2020 at 6:15 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
>>
>>
>> On 2020/7/3 7:00, Song Liu wrote:
>>> On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>>>
>>>> Hi, all
>>>>
>>>>    For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5
>>>>    will issue each bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64.
>>>>    However, filesystem usually issue bio in the unit of 4KB. Then, RAID5 may
>>>>    waste resource of disk bandwidth.
>>>>
>>>>    To solve the problem, this patchset try to set stripe_size as a configuare
>>>>    value. The default value is 4096. We will add a new sysfs entry and set it
>>>>    by writing a new value, likely:
>>>>
>>>>           echo 16384 > /sys/block/md1/md/stripe_size
>>>
>>> Higher level question: do we need to support page size that is NOT 4kB
>>> times power
>>> of 2? Meaning, do we need to support 12kB, 20kB, 24kB, etc. If we only
>>> supports, 4kB,
>>> 8kB, 16kB, 32kB, etc. some of the logic can be simpler.
>>
>> Yeah, I think we just support 4kb, 8kb, 16kb, 32kb... is enough.
>> But Sorry that I don't know what logic can be simpler in current implementation.
>> I mean it also need to allocate page, and record page offset.
> 
> I was thinking about replacing multiplication/division with bit
> operations (shift left/right).
> But I am not very sure how much that matters in modern ARM CPUs. Would you mind
> running some benchmarks with this?

To test multiplication/division and bit operation, I write a simple test case:

$ cat normal.c

int page_size = 65536;
int stripe_size = 32768; //32KB

int main(int argc, char *argv[])
{
         int i, j, count;
         int page, offset;

         if (argc != 2)
                 return -1;

         count = atol(argv[1]);

         for (i = 0; i < count; i++) {
                 for (j = 0; j < 4; j++) {
                         page = page_size / stripe_size;
                         offset = j * stripe_size;
                 }
         }
}

$ cat shift.c

int page_shift = 16; //64KB
int stripe_shift = 15; //32KB

int main(int argc, char *argv[])
{
         int i, j, count;
         int page, offset;

         if (argc != 2)
                 return -1;

         count = atol(argv[1]);

         for (i = 0; i < count; i++) {
                 for (j = 0; j < 4; j++) {
                         page = 1 << (page_shift - stripe_shift);
                         offset = j << stripe_shift;
                 }
         }
}

Test them on a arm64 server, the result show there is a minor
performance gap between multiplication/division and shift operation.

[root@localhost shift]# time ./normal 104857600

real    0m1.199s
user    0m1.198s
sys     0m0.000s

[root@localhost shift]# time ./shift 104857600

real    0m1.166s
user    0m1.166s
sys     0m0.000s

For our implementation, page address and page offset are just computed
when allocate stripe_size. After that, we just use the recorded value
in sh->dev[i].page and sh->dev[i].offset. So, I think current implementation
may not cause much overhead.
