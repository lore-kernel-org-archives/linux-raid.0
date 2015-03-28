From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: no good deed goes unpunished...
Date: Sat, 28 Mar 2015 08:57:42 +0800
Message-ID: <5515FC86.7030402@fnarfbargle.com>
References: <20150327103301.16746hhb6t1sroel@webmail.uniserve.com> <CAAMCDef5ejTu4aoYxMRxaRPvV9kKO4qwzbo9jAuPnFDYDoHo0A@mail.gmail.com> <20150327173709.19022q59t5hxh4tx@webmail.uniserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150327173709.19022q59t5hxh4tx@webmail.uniserve.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Stevens <geek@uniserve.com>, Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

md12 has claimed sda2 and md10 has sdb&c. Try this

mdadm --stop /dev/md12
mdadm --stop /dev/md10
mdadm --assemble --force /dev/md13 /dev/sd[abc]2



On 28/03/15 08:37, Dave Stevens wrote:
> Quoting Roger Heflin <rogerheflin@gmail.com>:
>
>> I don't know what to make of it.
>>
>> Everyone will ask you for this info:
>> mdadm --examine /dev/sdc2              and the same output against
>> /dev/sdb2
>
> ok, like this:
>
> # cat /proc/mdstat
>
> Personalities :
>
> md12 : inactive   sda2[0](S)
>      732467520 blocks
>
> md10 : inactive sdc2[2](S) sdb2[1](S)
>      1464935040 blocks
>
> unused devices: <none>
>
>
> ------------------------------ reboot ----------------------
>
> # mdadm -A /dev/md13 /dev/sdb2 /dev/sdc2
>
> mdadm : /dev/md13 assembles from 1 drive - not enough to start the array
>
> # cat /proc/mdstat
>
> Personalities :
>
> md13 : inactive sdc2[2](S) sdb2[1](S)
>
>      1464935040 blocks
>
> unused devices : <none>
>
> # mkdir aa
>
> # mount /dev/md13 aa
>
> mount: /dev/md13: can't read superblock
>
>
> Dave
>
>
>
>
>>
>> On Fri, Mar 27, 2015 at 12:33 PM, Dave Stevens <geek@uniserve.com> wrote:
>>> From:   Roger Heflin <rogerheflin@gmail.com>
>>> To:     Dave Stevens <geek@uniserve.com>
>>> Cc:     Linux RAID <linux-raid@vger.kernel.org>
>>> Subject: Re: no good deed goes unpunished...
>>> Date:   Thu, 26 Mar 2015 19:04:45 -0500
>>> Sender: linux-raid-owner@vger.kernel.org
>>>
>>> you should probably do cat /proc/mdstat
>>>
>>> It is likely that the livecd may have already tried to assemble it,
>>> and that the busy is because it is already in use.
>>>
>>> If it is already assembled and you want to redo it first you will need
>>> to stop the assembled array to be able to redo it.
>>>
>>> so this is what I did while running the live distro:
>>>
>>> # cat /proc/mdstat
>>>
>>> Personalities :
>>>
>>> md12 : inactive   sda2[0](S)
>>>         732467520 blocks
>>>
>>> md10 : inactive sdc2[2](S) sdb2[1](S)
>>>         1464935040 blocks
>>>
>>> unused devices: <none>
>>>
>>>
>>> It seemed to me that matters were needlessly complicated by possible
>>> residual issues from my earlier unsuccessful attempts so I rebooted.
>>>
>>>
>>> ------------------------------ reboot ----------------------
>>>
>>> # mdadm -A /dev/md13 /dev/sdb2 /dev/sdc2
>>>
>>> mdadm : /dev/md13 assembles from 1 drive - not enough to start the array
>>>
>>> # cat /proc/mdstat
>>>
>>> Personalities :
>>>
>>> md13 : inactive sdc2[2](S) sdb2[1](S)
>>>
>>>         1464935040 blocks
>>>
>>> unused devices : <none>
>>>
>>> # mkdir aa
>>>
>>> # mount /dev/md13 aa
>>>
>>> mount: /dev/md13: can't read superblock
>>>
>>> So I still don't see what to do. Advice welcome.
>>>
>>> Dave
>>>
>>>
>>>
>>> --
>>> "As long as politics is the shadow cast on society by big business,
>>> the attenuation of the shadow will not change the substance."
>>>
>>> -- John Dewey
>>>
>>>
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>


-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
