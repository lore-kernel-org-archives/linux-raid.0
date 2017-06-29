From: Avi Kivity <avi@scylladb.com>
Subject: Re: raid0 vs. mkfs
Date: Thu, 29 Jun 2017 18:36:19 +0300
Message-ID: <9a513fa3-8b5e-fb64-8b4f-c86dcb38f6f4@scylladb.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
 <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
 <87inr880au.fsf@notabene.neil.brown.name>
 <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
 <87d1he7zv9.fsf@notabene.neil.brown.name>
 <33bb250a-4dfd-0acc-9958-30fdac10918c@scylladb.com>
 <ccf447df-e7b5-0a08-7753-67ee4ad574ef@suse.de>
 <20161207165933.isq64dbkxye772nz@kernel.org>
 <c384d070-457c-cfee-e35f-53b9195ace10@suse.de>
 <eeae1d04-8c92-c511-8977-5124735646c4@scylladb.com>
 <9a46c760-904a-8318-b06c-0cf19e0651dc@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9a46c760-904a-8318-b06c-0cf19e0651dc@suse.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids



On 06/29/2017 06:31 PM, Coly Li wrote:
> On 2017/6/29 下午11:15, Avi Kivity wrote:
>>
>> On 12/08/2016 06:44 PM, Coly Li wrote:
>>> On 2016/12/8 上午12:59, Shaohua Li wrote:
>>>> On Wed, Dec 07, 2016 at 07:50:33PM +0800, Coly Li wrote:
>>> [snip]
>>>> Thanks for doing this, Coly! For raid0, this totally makes sense. The
>>>> raid0
>>>> zones make things a little complicated though. I just had a brief
>>>> look of your
>>>> proposed patch, which looks really complicated. I'd suggest something
>>>> like
>>>> this:
>>>> 1. split the bio according to zone boundary.
>>>> 2. handle the splitted bio. since the bio is within zone range,
>>>> calculating
>>>> the start and end sector for each rdev should be easy.
>>>>
>>> Hi Shaohua,
>>>
>>> Thanks for your suggestion! I try to modify the code by your suggestion,
>>> it is even more hard to make the code that way ...
>>>
>>> Because even split bios for each zone, all the corner cases still exist
>>> and should be taken care in every zoon. The code will be more
>>> complicated.
>>>
>> Hi Coly,
>>
>> Did you manage to complete this patch? We are seeing its effect, not
>> only with mkfs, but also with fstrim(8).
> Hi Avi,
>
> Shaohua makes another much better patch, which is merged into mainline
> kernel in v4.12-rc2.
>
> The commit is '29efc390b946 ("md/md0: optimize raid0 discard handling")'.
>
> Hope this is informative.
>

Thanks a lot, that's great news.


