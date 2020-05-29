From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v3 00/11] md/raid5: set STRIPE_SIZE as a configurable
 value
Date: Fri, 29 May 2020 14:22:30 +0200
Message-ID: <71f662d7-9aee-a130-c41d-67a691514ef6@cloud.ionos.com>
References: <20200527131933.34400-1-yuyufen@huawei.com>
 <f0ab9a2d-696b-b21f-faec-370cd7c3ed3a@cloud.ionos.com>
 <e373279d-9cc0-3a47-e6dd-887de0162d63@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e373279d-9cc0-3a47-e6dd-887de0162d63@huawei.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, neilb@suse.com, colyli@suse.de, xni@redhat.com, houtao1@huawei.com
List-Id: linux-raid.ids

On 5/29/20 1:49 PM, Yufen Yu wrote:
>> The 4k rand write performance drops from 100MB/S to 15MB/S?! How 
>> about other
>> io sizes? Say 16k, 64K and 256K etc, it would be more convincing if 
>> 64KB stripe
>> has better performance than 4KB stripe overall.
>>
>
> Maybe I have not explain clearly. Here, the fio test result shows that 
> 4KB
> STRIPE_SIZE is not always have better performance. If applications 
> request
> IO size mostly are bigger than 4KB, likely 1MB in test, set 
> STRIPE_SIZE with
> a bigger value can get better performance.
>
> So, we try to provide a configurable STRIPE_SIZE, rather than fix 
> STRIPE_SIZE as 4096. 

Which means if you set stripe size to 64KB then you should guarantee the 
io size should
always bigger then 1MB, right? Given that, I don't think it makes lots 
of sense.

Anyway, just my $0.02.

Thanks,
Guoqing
