From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH RFC v2 2/8] md/raid5: add a member of r5pages for struct
 stripe_head
Date: Sat, 9 May 2020 14:40:45 +0800
Message-ID: <b7ce5578-61f6-a8a6-68da-7e357a1c44c9@huawei.com>
References: <20200421123952.49025-1-yuyufen@huawei.com>
 <20200421123952.49025-3-yuyufen@huawei.com>
 <CAPhsuW4GxrgnToy=7HowOmWKBOqySdY=-n1KO-fYV+Thof7mtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4GxrgnToy=7HowOmWKBOqySdY=-n1KO-fYV+Thof7mtw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids



On 2020/5/9 7:58, Song Liu wrote:
> On Tue, Apr 21, 2020 at 5:40 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
> [...]
>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>> ---
>> +
>> +/*
>> + * We want to 'compress' multiple buffers to one real page for
>> + * stripe_head when PAGE_SIZE is biggger than STRIPE_SIZE. If their
>> + * values are equal, no need to use this strategy. For now, it just
>> + * support raid level less than 5.
>> + */
> 
> I don't think "compress" is the right terminology here. It is more
> like "share" a page.
> Why not support raid6 here?
> 

Thanks a lot for your reviewing and suggestion.
Since it need to modify more existing code to support raid6, this series
have not do it. I will try to support raid6 in next version.

Thanks,
Yufen
