From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Why can't I re-add my drive after partition shrink?
Date: Mon, 17 Jul 2017 00:15:47 -0500
Message-ID: <8d3e1264-2f0a-6ee9-52b5-edddc1e6f185@gmail.com>
References: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com>
 <87tw2f2425.fsf@notabene.neil.brown.name>
 <0341a04d-9aa5-7665-d9ff-527fe9fc8238@gmail.com>
 <87pod0ypmh.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87pod0ypmh.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/16/2017 05:37 PM, NeilBrown wrote:
> On Fri, Jul 14 2017, Ram Ramesh wrote:
>
>> On 07/13/2017 08:35 PM, NeilBrown wrote:
>>> <snip
>>> Please report output of "mdadm --examine" on both a device that is active
>>> in the array, and the device that you are trying to add.
>>> Also "mdadm --examine-bitmap" of a device that is active in the array.
>>>
>>> NeilBrown
>>>
>>>> I researched as much as I could on the net and came up with nothing
>>>> except some one saying that mdadm keeps something at the end of the disk
>>>> regardless of what it says about "Used Dev Size." Is it possible to move
>>>> this info so that I could re-add?
>>>>
>>>> Ramesh
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Neil,
>>
>>     Since the problem, I did not want to leave my md in degraded state.
>> So, I added my drive back and paid the penalty for rebuilding. I have
>> other disks that need to be resized and *can get you want*. Please let
>> me know if that is what you meant. If  you wanted the current info after
>> successfully rebuilding the array after a regular add, it is below.
> I only requested the information because it might help fix, or explain,
> your difficulty.  If you don't currently have a difficulty, then I don't
> need to look at any details.
>
> Thanks,
> NeilBrown

Thanks for your time. Yes, I still have the problem as I need to shrink 
other 5 disks in the array and I like to re-add rather than add and 
rebuild each time.

The host with the array is currently busy, and I will get this info 
tomorrow  when I attempt the process on my next hard drive.

Ramesh

