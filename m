From: Sarah Newman <srn@prgmr.com>
Subject: Re: [general question] rare silent data corruption when writing data
Date: Mon, 11 May 2020 12:42:32 -0700
Message-ID: <de121a93-7a32-31ac-de34-a91817e25cf3@prgmr.com>
References: <b0e91faf-3a14-3ac9-3c31-6989154791c1@yandex.pl>
 <CAAMCDef6hKJsPw3738KJ0vEEwnVKB-QpTMJ6aSeybse-4h+y6Q@mail.gmail.com>
 <24244.30530.155404.154787@quad.stoffel.home>
 <adccabc0-529f-e0a9-538f-1e5b784269e4@yandex.pl>
 <CAJCQCtRWvsKwwoZejERq=_OLXEa3JQd5RJ65tCz=X=Sp1xtRMQ@mail.gmail.com>
 <cd93b47a-7d77-5491-9632-0cea1f34bbe4@prgmr.com>
 <532aaee8-7140-fc30-c376-dbea880186c7@prgmr.com>
 <397960a1-9757-7de7-cba7-a9778d13254d@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <397960a1-9757-7de7-cba7-a9778d13254d@yandex.pl>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>, Chris Murphy <lists@colorremedies.com>
Cc: John Stoffel <john@stoffel.org>, Roger Heflin <rogerheflin@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/11/20 2:41 AM, Michal Soltys wrote:
> On 5/10/20 9:12 PM, Sarah Newman wrote:
>> On 5/10/20 12:05 PM, Sarah Newman wrote:
>>> On 5/7/20 8:44 PM, Chris Murphy wrote:
>>>>
>>>> I would change very little until you track this down, if the goal is
>>>> to track it down and get it fixed.
>>>>
>>>> I'm not sure if LVM thinp is supported with LVM raid still, which if
>>>> it's not supported yet then I can understand using mdadm raid5 instead
>>>> of LVM raid5.
>>>
>>>
>>> My apologies if this ideas was considered and discarded already, but the bug being hard to reproduce right after reboot and the error being exactly 
>>> the size of a page sounds like a memory use after free bug or similar.
>>>
>>> A debug kernel build with one or more of these options may find the problem:
>>>
>>> CONFIG_DEBUG_PAGEALLOC
>>> CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT
>>> CONFIG_PAGE_POISONING + page_poison=1
>>> CONFIG_KASAN
>>>
>>> --Sarah
>>
>> And on further reflection you may as well add these:
>>
>> CONFIG_DEBUG_OBJECTS
>> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT
>> CONFIG_CRASH_DUMP (kdump)
>>
>> + anything else available. Basically turn debugging on all the way.
>>
>> If you can reproduce reliably with these, then you can try the latest kernel with the same options and have some confidence the problem was 
>> legitimately fixed.
>>
> 
> After compiling the kernel with above options enabled - and if this is the underlying issue as you suspect - will it just pop in dmesg if I hit this 
> bug, or do I need some extra tools/preparation/etc. ?
> 

I'm pretty sure that you can get everything you need from either dmesg or sysfs/debugfs. Be prepared for an oops or panic.

--Sarah
