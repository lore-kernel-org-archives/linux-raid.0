From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Filesystem corruption MD (imsm) Raid0 via 2 SSD's + discard
Date: Fri, 22 May 2015 18:17:32 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1505221812270.28754@praktifix.dwd.de>
References: <alpine.LRH.2.11.1505201918570.4751@praktifix.dwd.de> <20150521013213.536deed0@natsu> <20150521090845.7e228e46@notabene.brown> <alpine.LRH.2.11.1505210636230.9060@praktifix.dwd.de> <20150521171425.32e6bf23@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150521171425.32e6bf23@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Thu, 21 May 2015, NeilBrown wrote:

> On Thu, 21 May 2015 06:44:27 +0000 (UTC) Holger Kiehl <Holger.Kiehl@dwd.de>
> wrote:
>
>> On Thu, 21 May 2015, NeilBrown wrote:
>>
>>> On Thu, 21 May 2015 01:32:13 +0500 Roman Mamedov <rm@romanrm.net> wrote:
>>>
>>>> On Wed, 20 May 2015 20:12:31 +0000 (UTC)
>>>> Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>>>>
>>>>> The kernel I was running when I discovered the
>>>>> problem was 4.0.2 from kernel.org. However, after reinstalling from DVD
>>>>> I updated to Fedora's lattest kernel, which was 3.19.? (I do not remember
>>>>> the last numbers). So that kernel seems also effected, but I assume it
>>>>> contains many 'fixes' from 4.0.x. As filesystem I use ext4, distribution
>>>>> is Fedora 21 and hardware is: Xeon E3-1275, 16GB ECC Ram.
>>>>>
>>>>> My system seems to be now running stable for some days with kernel.org
>>>>> kernel 4.0.3 and with discard DISABLED. But I am still unsure what could
>>>>> be the real cause.
>>>>
>>>> It is a bug in the 4.0.2 kernel, fixed in 4.0.3.
>>>>
>>>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=785672
>>>> https://bbs.archlinux.org/viewtopic.php?id=197400
>>>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable/+/d2dc317d564a46dfc683978a2e5a4f91434e9711
>>>>
>>>>
>>>
>>> I suspect that is a different bug.
>>> I think this one is
>>>  https://bugzilla.kernel.org/show_bug.cgi?id=98501
>>>
>> Should there not be a big fat warning going around telling users to disable
>> discard on Raid 0 until this is fixed? This breaks the filesystem completely
>> and I believe there is absolutly no way one can get back the data.
>
> Probably.  Would you like to do that?
>
>>
>> Is this fixed in 4.0.4? And which kernels are effected? There could be many
>> people running systems that have not noticed this and don't know in what
>> dangerous situation they are when they delete data.
>
> The patch was only added to my tree today.  I will send to Linus tomorrow so
> it should appear in the next -rc.
> Any -stable kernel released since mid-April probably has the bug.  It was
> caused by
> commit 47d68979cc968535cb87f3e5f2e6a3533ea48fbd
>
> Once the fix gets into Linus' tree, it should get into subsequent -stable releases.
>
> The fix is here:
>
> http://git.neil.brown.name/?p=md.git;a=commitdiff;h=a81157768a00e8cf8a7b43b5ea5cac931262374f
>
> commit id should remain unchanged.
>
I would like to confirm that with this patch and discard enabled, I no longer
see any corruption.

Many thanks for the quick fix!

Regards,
Holger
