From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v3] md: improve io stats accounting
Date: Fri, 3 Jul 2020 10:58:51 +0200
Message-ID: <6e99d7a2-9048-1265-533f-cb9493181b22@cloud.ionos.com>
References: <20200702142926.4419-1-artur.paszkiewicz@intel.com>
 <CAPhsuW5eMPMH1HcMXi67Ci0rbWhVyiuLodVZB_oaGbrR7abTJQ@mail.gmail.com>
 <aea49756-c6f6-a4a3-3e23-9928e0878c80@cloud.ionos.com>
 <cf1b6354-3c97-a2e3-2f7b-d5c15205bb6a@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cf1b6354-3c97-a2e3-2f7b-d5c15205bb6a@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 7/3/20 10:50 AM, Artur Paszkiewicz wrote:
> On 7/3/20 10:33 AM, Guoqing Jiang wrote:
>> On 7/2/20 11:25 PM, Song Liu wrote:
>>> I run quick test with this. Seems it only adds proper statistics to
>>> raid5 array, but
>>> not to raid0 array. Is this expected?
> Oh, sorry about that. Of course it should work.
>
>> Because bio_endio is not called, and it is same for linear and faulty.
>> I think we have to  clone bio for them ..., then it is better to do the
>> job in the personality layer.
> It's not that bad actually. The issue is simply because those
> personalities change the original bio's bi_disk and then
> bio_end_io_acct() uses a different gendisk. So I think we can either use
> disk_{start,end}_io_acct() instead of bio_{start,end}_io_acct(), or
> change bio->bi_disk back to mddev->gendisk before calling
> bio_end_io_acct(). I prefer the first option. What do you think?

I am fine with either of them, though currently the only caller of
disk_start_io_acct is bio_start_io_acct :-)

Thanks,
Guoqing
