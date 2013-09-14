From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Weirdness with DDF arrays (mdadm 3.3)
Date: Sat, 14 Sep 2013 17:25:55 +0200
Message-ID: <CAC9WiBiD4b9gKoEBCvWEOSbBtq72hZ-QFpbGpsEOinDWSatffw@mail.gmail.com>
References: <CAC9WiBgJX4VH7-cNMVcqPL-9UpsH03Z7cRKvLUOSUogkiQpx7Q@mail.gmail.com>
	<52346FB1.2020205@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52346FB1.2020205@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Martin,

On Sat, Sep 14, 2013 at 4:16 PM, Martin Wilck <mwilck@arcor.de> wrote:
> Hi Francis, hi Neil,
>
>> Still testing MD arrays using DDF metadata and find another possible issues :)
>>
>> I'm creating a new DDF array containing 2 disks. After that
>> /proc/mdstat looks correct:
>>
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md124 : active raid1 loop0[1] loop1[0]
>>       84416 blocks super external:/md125/0 [2/2] [UU]
>>
>> md125 : inactive loop1[1](S) loop0[0](S)
>>       65536 blocks super external:ddf
>>
>> Now I'm stopping the array and restart it by incrementaly adding the 2 disks:
>> # mdadm --stop /dev/md124
>> # mdadm --stop /dev/md125
>> # mdadm -IRs /dev/loop0
>
> This is wrong, because -IRs "wills can the mapfile for arrays that are
> being incrementally assembled snd will try to start any that are not
> already started".
>
> mdadm -IRs will first add /dev/loop0, then see that there is an
> incomplete array, and start it.
>
>> # mdadm -IRs /dev/loop1
>
> Now you add /dev/loop1, but as the array is already started, it will be
> added as a spare. That's what you see below.

Ah you're right, sorry for the noise, however I still doesn't
understand my last point, please see the end of the email.

>
> However, there is room for improvement here. The array hasn't been
> written to, so even if it is started, it should be possible to re-add
> the second disk cleanly.
>
> Looking into that.
>

thanks

> Martin
>
>
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md124 : active (auto-read-only) raid1 loop1[2] loop0[0]
>>       84416 blocks super external:/md125/0 [2/1] [_U]
>>
>> md125 : inactive loop1[1](S) loop0[0](S)
>>       65536 blocks super external:ddf
>>
>> Parsing mdstat content tells me disk "loop1" have a role number equal
>> to 2 which is greater than 1 indicating that "loop1" is a spare disk
>> and the "[_U]" below indicates "loop1" is down".
>>
>> Why is "loop1" down now ?
>>
>> I decided to still use the md device by creating a new partition on it:
>> # fdisk /dev/md124
>> ...
>> Calling ioctl() to re-read partition table.
>> Syncing disks.
>>
>> Now inspecting /proc/mdstat:
>>
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md124 : active raid1 loop1[2] loop0[0]
>>       84416 blocks super external:/md125/0 [2/2] [UU]
>>
>> md125 : inactive loop1[1](S) loop0[0](S)
>>       65536 blocks super external:ddf
>>
>> which looks even weirder: "loop1[2]" indicates that the disk is a
>> spare one whereas "[UU]" tells me the opposite.
>>
>> Could you tell me if I'm wrong in my interpretation or what's going wrong ?

What about the loop1 in spare and [UU] indicating that loop1 is used ?


Thanks
-- 
Francis
