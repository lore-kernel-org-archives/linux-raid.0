From: Anugraha Sinha <asinha.mailinglist@gmail.com>
Subject: Re: Converting 4 disk RAID10 to RAID5
Date: Tue, 27 Oct 2015 15:19:53 +0900
Message-ID: <562F1789.9080000@gmail.com>
References: <562D8142.80507@websitemanagers.com.au>
 <562E345D.5030206@turmel.org> <562EBD58.2040306@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562EBD58.2040306@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Adam,

On 10/27/2015 8:55 AM, Adam Goryachev wrote:
>
> mdadm --grow --bitmap=none /dev/md0
> root@testraid:~# cat /proc/mdstat
> Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
> md0 : active raid5 vdf1[4] vdd1[3](S) vde1[2] vdc1[0]
>        2093056 blocks super 1.2 level 5, 512k chunk, algorithm 5 [3/3]
> [UUU]
>
> unused devices: <none>
>
> So, still 3 disk raid5 with one spare, but seems to be insync, so either
> it was really quick (possible since they are small drives) or it didn't
> need to do a sync??
>
> mdadm --grow --level=5 --raid-devices=4 /dev/md0
> mdadm: Need to backup 3072K of critical section..
>
> cat /proc/mdstat
> Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
> md0 : active raid5 vdf1[4] vdd1[3] vde1[2] vdc1[0]
>        2093056 blocks super 1.2 level 5, 512k chunk, algorithm 5 [4/4]
> [UUUU]
>            resync=DELAYED
>
> unused devices: <none>
>
> OK, so now how to make it resync?
>
> Here I'm stuck...
> I've tried:
> mdadm --misc /dev/md0 --action=check
> mdadm --misc /dev/md0 --action=repair
>
> Nothing seems to be happening.
>
> BTW, I had the array mounted during my testing, as ideally that is what
> I will do with the live machine. Worst case scenario (on the live
> machine) I can afford to lose all the data, as it is only an extra
> backup of the other backup machine, but it would mean a few TB's of data
> across a slow WAN....
>
> Any suggestions on getting this to progress? Did I do something wrong?
>
> Thanks for the suggestion, it certainly looks promising so far.

Why dont you stop your array once and do something like this?
mdadm --stop /dev/md0
mdadm --assemble /dev/md0 --run --force --update=resync /dev/vdf1 
/dev/vdd1 /dev/vde1 vdc1

This will restart your array with the required raid-level and also start 
the resyncing process.

Regards
Anugraha
