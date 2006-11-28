From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm RAID5 Grow
Date: Tue, 28 Nov 2006 18:56:03 -0500
Message-ID: <456CCC93.1080201@tmr.com>
References: <6652499.post@talk.nabble.com>	<17700.35743.152233.689956@cse.unsw.edu.au>	<4524FD70.6070609@mickg.net> <17701.504.201046.256698@cse.unsw.edu.au> <45257D7B.90401@mickg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45257D7B.90401@mickg.net>
Sender: linux-raid-owner@vger.kernel.org
To: mickg <mickg@mickg.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mickg wrote:
> Neil Brown wrote:
>> On Thursday October 5, mickg@mickg.net wrote:
>>> Neil Brown wrote:
>>>> On Wednesday October 4, mickg@mickg.net wrote:
>>>>> I have been trying to run: mdadm --grow /dev/md0 --raid-devices=6 
>>>>> --backup-file /backup_raid_grow
>>>>> I get:
>>>>> mdadm: Need to backup 1280K of critical section..
>>>>> mdadm: /dev/md0: Cannot get array details from sysfs
>>>> It shouldn't do that.... Can you   strace -o /tmp/trace -s 300 
>>>> mdadm --grow .....
>> ...
>>> open("/sys/block/md0/md/component_size", O_RDONLY) = -1 ENOENT (No 
>>> such file or directory)
>>
>> So it couldn't open .../component_size.  That was added prior to the
>> release of 2.6.16, and you are running 2.6.17.13 so the kernel
>> certainly supports it.  Most likely explanation is that /sys isn't 
>> mounted.
>> Do you have a "/sys"?
>> Is it mounted?
>> Can you "ls -l /sys/block/md0/md" ??
>>
>> Maybe you need to
>>   mkdir /sys
>>   mount -t sysfs sysfs /sys
>>
>> and try again.
>>
> Worked like a charm!
>
> Thank you!
>
> There is a
>   sysfs   /sys    sysfs   noauto 0 0
> line in /etc/fstab
> I am assuming noauto is the culprit?
>
> Should it be made to automount ?
>
> mickg 
I will belatedly add that experience shows that /proc and /sys are 
optional (and can in theory be mounted other places), in practice a lot 
of software depends on them being present and in the usual place.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

