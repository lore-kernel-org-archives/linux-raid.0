From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] mdraid: fix read/write bytes accounting
Date: Thu, 25 Jun 2020 11:13:39 +0200
Message-ID: <236cffb5-ab4a-0559-6f37-321347895189@cloud.ionos.com>
References: <20200605201953.11098-1-jeffm@suse.com>
 <ed552b4b-b19a-cc85-05f4-0a0dc0d6fac2@intel.com>
 <fb3b18e6-9dda-6633-e25e-a141718f630b@cloud.ionos.com>
 <ac89af6c-1610-61b5-d275-304e6e54947f@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac89af6c-1610-61b5-d275-304e6e54947f@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, jeffm@suse.com, linux-raid@vger.kernel.org, song@kernel.org
Cc: nfbrown@suse.com, colyli@suse.com
List-Id: linux-raid.ids



On 6/23/20 6:48 PM, Artur Paszkiewicz wrote:
> On 6/23/20 4:21 PM, Guoqing Jiang wrote:
>> Hi Artur,
>>
>> On 6/8/20 9:13 AM, Artur Paszkiewicz wrote:
>>> On 6/5/20 10:19 PM, jeffm@suse.com wrote:
>>>> The i/o accounting published in /proc/diskstats for mdraid is currently
>>>> broken.  md_make_request does the accounting for every bio passed but
>>>> when a bio needs to be split, all the split bios are also submitted
>>>> through md_make_request, resulting in multiple accounting.
>>> Hi Jeff,
>>>
>>> I sent a patch a few days ago which should fix this issue. Can you check
>>> it out?
>>>
>>> https://marc.info/?l=linux-raid&m=159102814820539
>> I need to account some extra statistics for bio such as latency and size,
>> so it is kind of relies on your patch, then I read the code again.
>>
>> And besides my previous comment. I think you don't need clone bio for all
>> personalities. For md-multipath, raid1 and raid10, you can track the start
>> time by add it to those structures (multipath_bh, r1bio and r10bio), then
>> one extra copy could be avoided.
>>
>> What do you think?
> You're right, cloning can be avoided for those personalities. I wanted
> to keep it clean and centralized in the generic md code. I think we
> should have a common completion callback and some common request
> structure for all md personalities, like struct md_io which I'm using in
> my patch.How about we add it to the existing stucts like r1bio etc. and
> use that for io accounting, and clone the bio with the struct otherwise?
> Or maybe remove the cloning from the personalities and instead make the
> bio cloned in md_make_request available to them? Does this make sense?

Centralization definitely has it's advantage, but given the difference
among personalities, not sure it is possible or make sense to clone bio
in common md layer.

For raid1/10, we at least need to care about barrier and read balance
before clone bio, and I would prefer to not change current mechanism
since it is really a big modification from my understanding.

Thanks,
Guoqing
