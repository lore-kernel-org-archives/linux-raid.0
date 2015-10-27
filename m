From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Converting 4 disk RAID10 to RAID5
Date: Tue, 27 Oct 2015 17:32:01 +1100
Message-ID: <562F1A61.6010709@websitemanagers.com.au>
References: <562D8142.80507@websitemanagers.com.au>
 <562E345D.5030206@turmel.org> <562EBD58.2040306@websitemanagers.com.au>
 <562F1789.9080000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562F1789.9080000@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anugraha Sinha <asinha.mailinglist@gmail.com>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/10/15 17:19, Anugraha Sinha wrote:
> Dear Adam,
>
> On 10/27/2015 8:55 AM, Adam Goryachev wrote:
>>
>> mdadm --grow --bitmap=none /dev/md0
>> root@testraid:~# cat /proc/mdstat
>> Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
>> md0 : active raid5 vdf1[4] vdd1[3](S) vde1[2] vdc1[0]
>>        2093056 blocks super 1.2 level 5, 512k chunk, algorithm 5 [3/3]
>> [UUU]
>>
>> unused devices: <none>
>>
>> So, still 3 disk raid5 with one spare, but seems to be insync, so either
>> it was really quick (possible since they are small drives) or it didn't
>> need to do a sync??
>>
>> mdadm --grow --level=5 --raid-devices=4 /dev/md0
>> mdadm: Need to backup 3072K of critical section..
>>
>> cat /proc/mdstat
>> Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
>> md0 : active raid5 vdf1[4] vdd1[3] vde1[2] vdc1[0]
>>        2093056 blocks super 1.2 level 5, 512k chunk, algorithm 5 [4/4]
>> [UUUU]
>>            resync=DELAYED
>>
>> unused devices: <none>
>>
>> OK, so now how to make it resync?
>>
>> Here I'm stuck...
>> I've tried:
>> mdadm --misc /dev/md0 --action=check
>> mdadm --misc /dev/md0 --action=repair
>>
>> Nothing seems to be happening.
>>
>> BTW, I had the array mounted during my testing, as ideally that is what
>> I will do with the live machine. Worst case scenario (on the live
>> machine) I can afford to lose all the data, as it is only an extra
>> backup of the other backup machine, but it would mean a few TB's of data
>> across a slow WAN....
>>
>> Any suggestions on getting this to progress? Did I do something wrong?
>>
>> Thanks for the suggestion, it certainly looks promising so far.
>
> Why dont you stop your array once and do something like this?
> mdadm --stop /dev/md0
> mdadm --assemble /dev/md0 --run --force --update=resync /dev/vdf1 
> /dev/vdd1 /dev/vde1 vdc1
>
> This will restart your array with the required raid-level and also 
> start the resyncing process.

I got:
mdadm: Failed to restore critical section for reshape, sorry.
Possibly you needed to specify the --backup-file

Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
md0 : inactive vdd1[3](S) vdf1[4](S) vde1[2](S) vdc1[0](S)
       4186112 blocks super 1.2

unused devices: <none>

Related dmesg output:
[27217.316713] md: md0 stopped.
[27217.316727] md: unbind<vdc1>
[27217.316732] md: export_rdev(vdc1)
[27217.316769] md: unbind<vdf1>
[27217.316772] md: export_rdev(vdf1)
[27217.316789] md: unbind<vdd1>
[27217.316791] md: export_rdev(vdd1)
[27217.316806] md: unbind<vde1>
[27217.316809] md: export_rdev(vde1)
[27248.819955] md: md0 stopped.
[27248.855348] md: bind<vdc1>
[27248.868655] md: bind<vde1>
[27248.872681] md: bind<vdf1>
[27248.876477] md: bind<vdd1>

Any further suggestions?

I have no problem with doing the whole process offline, but I assume it 
will take a lot longer on the live machine (4TB drives), and didn't want 
to leave it unmounted for a long time.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
