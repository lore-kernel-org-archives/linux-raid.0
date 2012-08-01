From: Skip Coombe <skipcoombe@gmail.com>
Subject: Re: persistent removed MD referrence on reboot
Date: Wed, 1 Aug 2012 08:27:43 -0400
Message-ID: <CAO7BsSnPq3iFPbCkmYM-vUxY5bZeuJx9=BMNF6mRDH=iL7BoXQ@mail.gmail.com>
References: <CAO7BsSnu+CZMeQ=YNUKDOCQGF9FYjCTV37rhkBiW1JGAVexxuQ@mail.gmail.com>
	<50173458.40505@websitemanagers.com.au>
	<CAO7BsSnMTAWRjxFcq2AS1QGbudy82HVGYFTB395cKTdnfD2bVw@mail.gmail.com>
	<5018BA32.8000801@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5018BA32.8000801@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: linbloke <linbloke@fastmail.fm>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you Adam and linbloke.

I ran "sudo mdadm --manage --stop /dev/md127" to clear out /proc/mdstat

Then "sudo mdadm --zero-superblock /dev/sdc1" twice; no return info on
the first one,
but the second had a response similar to "No superblock found".

Rebooted and the phantom raid device is gone.

Skip

On Wed, Aug 1, 2012 at 1:10 AM, linbloke <linbloke@fastmail.fm> wrote:
>
> On 1/08/12 11:43 AM, Skip Coombe wrote:
>>
>> Thanks for the quick response.
>>
>> I did "dd -if=/dev/zero -of=/dev/sdc" and modified the the partition to
>> 83.
>>
>> Today I followed your advice to investigate initrd. I deleted all the
>> ARRAY specs from /etc/mdadm/mdadm.conf (they were
>> from the time of installing 12-4, including the md2 ARRAY), wrote the
>> new initrd, and rebooted.
>
>
> I think Adam led you to the right path. Your reference to 12-4 leads me to
> guess that you're running Ubuntu 12.04? For me on these systems, I would do
> the following:
>
> - zero superblocks:
>
> sudo mdadm --zero-superblock /dev/sdc1
>
> running that commands multiple times until they return "No superblock
> found" or similar message. Once you get that response, there are no mdadm
> superblocks remaining.
>
> - update /etc/mdadm/mdadm.conf to remove references to old md arrays.
> - update initramfs:
>
> update-initramfs -u
>
>
>
> From there you should be able to reboot and find only those arrays
> specified in mdadm.conf (also arrays auto-built by the kernel from devices
> with partitions of type fd). If you're still not getting the expected
> outcome, pls send the output of "parted -l" and /etc/mdadm/mdadm.conf, uname
> -a, mdadm -V
>
> HTH
>
> j
>
>
>> The reference to md2 went away, but now I see
>> ======================
>> $ cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md127 : inactive sdc[1](S)
>>        488385560 blocks super 1.2
>>
>> unused devices:<none>
>> ======================
>>
>> I will repeat after "rm -rf /etc/mdadm" from the initrd dir tree. If
>> that does not work I will probably just reinstall 12-4. I hate to do
>> all the config again, but I've burned too many hours on this already.
>> There are no superblocks left so I hope to get a clean start.
>>
>> n.b. md127 seems to be the default array, but still sdc is identified.
>> There must be more info buried in the initrd.
>>
>> Thanks for the good advice, but I am still missing something.
>>
>> Skip
>>
>> On Mon, Jul 30, 2012 at 9:26 PM, Adam Goryachev
>> <adam@websitemanagers.com.au>  wrote:
>>>
>>> On 07/31/2012 11:02 AM, Skip Coombe wrote:
>>>>
>>>> I have an md entry referring to a badly removed RAID1 device (by me)
>>>> after
>>>> the associated device crashed (can't afford a replacement drive at this
>>>> time).
>>>> Despite attempts to remove the reference, after a reboot I see:
>>>>
>>>> ================================
>>>> $ cat /proc/mdstat
>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>>>> [raid4]
>>>> [raid10]
>>>> md2 : inactive sdc[1](S)
>>>>         488385560 blocks super 1.2
>>>>
>>>> unused devices:<none>
>>>> ================================
>>>>
>>>> I am trying to repurpose the good drive as a not-RAID device. I have
>>>> done
>>>> sudo mdadm --zero-superblock /dev/sdc
>>>> and
>>>> sudo mdadm --zero-superblock --force /dev/sdc
>>>> and even low level formatted /dev/sdc
>>>
>>> What do you mean "low level formatted"? Have you done a
>>> dd if=/dev/zero of=/dev/sdc
>>>
>>>> ================================
>>>> $ ls /etc/mdadm/mdadm.conf
>>>> ls: cannot access /etc/mdadm/mdadm.conf: No such file or directory
>>>> ================================
>>>
>>> Did you update the initrd file? This file probably contains a copy of
>>> the
>>> mdadm.conf
>>>
>>> Also, did you modify the partition type, from fd to 83
>>> I would suggest running the above dd command, which will erase ALL
>>> traces of
>>> anything, including any data on the drive (so back it up elsewhere
>>> first).
>>>
>>> Most likely, the md code looks at a couple of different places on the
>>> drive
>>> for the md information, so when you run the zero-superblock, it is only
>>> erasing one of the possible locations. See man mdadm, especially the
>>> --metadata section.
>>>
>>> Regards,
>>> Adam
>>
>>
>>



--
Skip Coombe
skip.coombe@gmail.com
919.442.VLSI
