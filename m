From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v3 00/11] md/raid5: set STRIPE_SIZE as a configurable
 value
Date: Thu, 4 Jun 2020 21:17:21 +0800
Message-ID: <72b83f59-db43-6809-d975-4ec3c2c83cd4@huawei.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
 <f0ab9a2d-696b-b21f-faec-370cd7c3ed3a@cloud.ionos.com>
 <e373279d-9cc0-3a47-e6dd-887de0162d63@huawei.com>
 <71f662d7-9aee-a130-c41d-67a691514ef6@cloud.ionos.com>
 <555121b6-fe76-4827-7b8f-7a22ba04ed82@huawei.com>
 <9acfb512-88ee-b4b0-88d4-94841e72d31a@cloud.ionos.com>
 <CAPhsuW4UMDKhpGL71R6FY1-Q_u6On68ku4C=xp0UzSaEaCNGkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4UMDKhpGL71R6FY1-Q_u6On68ku4C=xp0UzSaEaCNGkg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids



On 2020/6/2 14:59, Song Liu wrote:
>> I do think the flexibility is not enough, if someone set stripe size to
>> 64KB by any chance,
>> people could complain the performance of raid5 really sucks if the io is
>> not big. And it is
>> not realistic to let people rebuild the module in case the io size is
>> changed, so it would be
>> more helpful if the stripe size can be changed dynamically without
>> recompile code.
> 
> Agreed that it is not ideal to recompile the kernel/module to change stripe
> size. It is also possible that multiple arrays in one system have different
> optimal stripe sizes. I guess it shouldn't be too complicated to make this
> configurable per array?
> 

Yeah. Thanks a lot for suggestion. I admit that the current implementation is really
not good. To make it more flexible and provide each stripe_size for raid arrays, I plan
to move stripe_size into r5conf and make it dynamically changeable by sysfs interface.

Thanks,
Yufen
