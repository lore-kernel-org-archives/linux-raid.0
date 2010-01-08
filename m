From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [HELP]Have you solved "2.6.23.1: mdadm/raid5 hung/d-state"
 problem?
Date: Fri, 8 Jan 2010 10:48:47 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1001081047010.18176@p34.internal.lan>
References: <389deec71001072129r71ef27bened0b68b641a4e782@mail.gmail.com>  <alpine.DEB.2.00.1001080624001.3241@p34.internal.lan> <389deec71001080746g3227f2bcwab0fa2f8ff0c925c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec71001080746g3227f2bcwab0fa2f8ff0c925c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

If I did not reply then I either did not apply the patch, it did not solve 
the problem or I upgraded to a newer kernel, I honestly do not remember.

But if you read through the thread, Neil noted that it has been fixed in 
the patches here:
http://lkml.indiana.edu/hypermail/linux/kernel/0711.0/1092.html

Justin.

On Fri, 8 Jan 2010, hank peng wrote:

> 2010/1/8 Justin Piszcz <jpiszcz@lucidpixels.com>:
>> Hi,
>>
>> Run the latest kernel, (2.6.32.x) and try it out, see if it fixes the
>> problem, 2.6.23.1 is very old.
>>
>
> I planed to try 2.6.31.6, but it is better if it can be fixed under
> 2.6.23 because our product is tested under this version of kernel for
> a long time.
> Who knows what else problem will be caused if we upgraded kernel.
> Have you applied this patch and have a try?
>> Justin.
>>
>> On Fri, 8 Jan 2010, hank peng wrote:
>>
>>> Hi:
>>> I encountered a serious problem about RAID5 in kernel 2.6.23 which you
>>> have posted in linux-raid mailing
>>> list:http://lkml.indiana.edu/hypermail/linux/kernel/0711.0/0992.html
>>> I wonder whether you have solved the problem after applying the patch
>>> provided by Dan Williams?
>>>
>>>
>>>
>>> --
>>> The simplest is not all best but the best is surely the simplest!
>>>
>>
>
>
>
> -- 
> The simplest is not all best but the best is surely the simplest!
>
