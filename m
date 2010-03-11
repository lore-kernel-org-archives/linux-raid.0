From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Fwd: Re: possible bus loading problem during resync
Date: Thu, 11 Mar 2010 11:16:49 -0700
Message-ID: <4B993391.4060103@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



-------- Original Message --------
Subject: Re: possible bus loading problem during resync
Date: Wed, 10 Mar 2010 23:23:23 -0700
=46rom: Timothy D. Lenz <tlenz@vorgon.com>
To: Goswin von Brederlow <goswin-v-b@web.de>



On 3/10/2010 10:53 PM, Goswin von Brederlow wrote:
> Asdo<asdo@shiftmail.org>  writes:
>
>> Kristleifur Da=F0ason wrote:
>>> On Tue, Mar 9, 2010 at 6:31 AM, Timothy D. Lenz<tlenz@vorgon.com>  =
wrote:
>>>
>>>> I'm working on 2 systems that are mainly for running vdr. I've had=
 these
>>>> running somewhat for awhile with raid. But a couple nights ago as =
I was
>>>> quitting for the night, I noticed one of the computers drive light=
 staying
>>>> on. I had just made some changes to xine and didn't know if someth=
ing had
>>>> crashed. Turned on the TV and found the video was freezing for 10-=
20secs
>>>> every 10-20secs. Logging in using putty and winscp I found it very=
 sluggish
>>>> to respond.Starting top I found it was doing the regular array che=
ck/resync.......
>>>> --
>>>>
>>>
>>>
>>> Sorry about the incredibly brief answer: Not to dismiss other issue=
s,
>>> but that behavior seems like exactly what I've seen when a disk has
>>> been failing.
>>>
>>
>> If that is true, how does that happen, the driver is hung? But anywa=
y,
>> how can such things happen when there is more than one CPU-core?
>
> A drive produces an error, the whole controler hangs and resets all
> ports, all drives have to finish being reset before any IO can contin=
ue.
> Hapens easily enough.
>
>> try disabling NCQ by echo 1>  /sys/block/sdX/device/queue_depth for
>> all drives. After doing this, at most 1 request can be issued to one
>> drive until the drive has serviced such request.
>>
>> After doing this, firstly I'd say the sluggishness should disappear,
>> at least on SSH when not touching the disks. And then you can look
>> with "iostat -x 1": probably the bad drive will have a service time
>> (svctm) or await much worse than the others.
>>
>> Just guesses, correct me if I'm wrong
>
> What I would start with is check the resync/check speed of the raid a=
nd
> kernel messages. If it is running at high speed and there are no kern=
el
> messages about IO errors then it is probably just a case of the IO
> subsystem being busy. I got similar sluggish behaviour when I increas=
ed
> the stripe cache to 16384 for a reshape.
>
> If there are no hardware problems on the disks causing this then try
> setting the max speed for the resync lower. That way the resync will
> leave pauses where other IO and bus activity can happen. The raid sho=
uld
> slow down automatically if there is normal IO pending but in my
> experience that doesn't always work.
>
> MfG
>          Goswin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


=46ound these 3 entries in /var/log/kern.log.1:

Mar  7 00:57:01 LLLx64-32 kernel: md: data-check of RAID array md0
Mar  7 00:57:01 LLLx64-32 kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Mar  7 00:57:01 LLLx64-32 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for data-check.
Mar  7 00:57:01 LLLx64-32 kernel: md: using 128k window, over a total o=
f
24418688 blocks.
Mar  7 00:57:01 LLLx64-32 kernel: md: delaying data-check of md1 until
md0 has finished (they share one or more physical units)
Mar  7 00:57:01 LLLx64-32 kernel: md: delaying data-check of md2 until
md1 has finished (they share one or more physical units)
Mar  7 00:57:01 LLLx64-32 kernel: md: delaying data-check of md1 until
md0 has finished (they share one or more physical units)
---------------------------------------------------------------------
Mar  7 01:02:50 LLLx64-32 kernel: md: md0: data-check done.
Mar  7 01:02:50 LLLx64-32 kernel: md: delaying data-check of md2 until
md1 has finished (they share one or more physical units)
Mar  7 01:02:50 LLLx64-32 kernel: md: data-check of RAID array md1
Mar  7 01:02:50 LLLx64-32 kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Mar  7 01:02:50 LLLx64-32 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for data-check.
Mar  7 01:02:50 LLLx64-32 kernel: md: using 128k window, over a total o=
f
4891712 blocks.
Mar  7 01:03:50 LLLx64-32 kernel: md: md1: data-check done.
Mar  7 01:03:50 LLLx64-32 kernel: md: data-check of RAID array md2
Mar  7 01:03:50 LLLx64-32 kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Mar  7 01:03:50 LLLx64-32 kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for data-check.
Mar  7 01:03:50 LLLx64-32 kernel: md: using 128k window, over a total o=
f
459073344 blocks.
---------------------------------------------------------------------
Mar  7 02:47:43 LLLx64-32 kernel: md: md2: data-check done.

kern.log.1 ended at Mar  7 06:25:03

There was no ref to "raid" or "md" in /var/log/kern.log
I don't see any raid logs
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
