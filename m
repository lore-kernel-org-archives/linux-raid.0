From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v3 00/11] md/raid5: set STRIPE_SIZE as a configurable
 value
Date: Fri, 29 May 2020 17:32:48 +0800
Message-ID: <e0947530-003b-5090-70f3-4f6d02219033@huawei.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
 <CAPhsuW7hVgM7yiaBg0Pkaci4NStEdyduCp1+yMf9aguKfm4jKQ@mail.gmail.com>
 <CAPhsuW7DOdPTWX5MNRJULvojFrCQF9_zNH+_ZwkQs4Qug9CpdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW7DOdPTWX5MNRJULvojFrCQF9_zNH+_ZwkQs4Qug9CpdQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids



On 2020/5/28 22:28, Song Liu wrote:
> On Thu, May 28, 2020 at 7:10 AM Song Liu <song@kernel.org> wrote:
>>
>> On Wed, May 27, 2020 at 6:20 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>>
>>> Hi, all
>>>
>>>   For now, STRIPE_SIZE is equal to the value of PAGE_SIZE. That means, RAID5 will
>>>   issus echo bio to disk at least 64KB when PAGE_SIZE is 64KB in arm64. However,
>>>   filesystem usually issue bio in the unit of 4KB. Then, RAID5 will waste resource
>>>   of disk bandwidth.
>>>
>>
>> Thanks for the patch set.
>>
>> Since this is a big change, I am planning to process this set after
>> upcoming merge window.
>> Please let me know if you need it urgently.

I agree with your plan.

> 
> I haven't thought about this in detail yet: how about compatibility?
> Say we create an
> array with STRIPE_SIZE of 4kB, does it work well after we upgrade kernel to have
> STRIPE_SIZE of 8kB?

Each time upgrade kernel, we need to reboot system to make it effective.
And, system will allocate new stripe_head and buffers base on the new STRIPE_SIZE.
Then everything will be ok and go on running.

STRIPE_SIZE decides each io size issued to array disk and its buffers size in
stripe_head. But each time restart system, we will allocate new buffer and
stripe_head based on the new STRIPE_SIZE. It is no matter what the value before.
So, I think changing STRIPE_SIZE is not problem for upgrade kernel.

Thanks,
Yufen
