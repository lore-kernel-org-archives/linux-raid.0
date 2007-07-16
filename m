From: Bryan Christ <bryan.christ@hp.com>
Subject: Re: Raid array is not automatically detected.
Date: Mon, 16 Jul 2007 09:19:33 -0500
Message-ID: <469B7E75.3030907@hp.com>
References: <4697E231.3070906@hp.com> <4698D4FC.2060100@tmr.com> <Pine.LNX.4.64.0707140952440.31528@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707140952440.31528@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I do have the type set to 0xfd.  Others have said that auto-assemble 
only works on RAID 0 and 1, but just as Justin mentioned, I too have 
another box with RAID5 that gets auto assembled by the kernel (also no 
initrd).  I expected the same behavior when I built this array--again 
using mdadm instead of raidtools.

Justin Piszcz wrote:
> 
> 
> On Sat, 14 Jul 2007, Bill Davidsen wrote:
> 
>> Bryan Christ wrote:
>>> My apologies if this is not the right place to ask this question. 
>>> Hopefully it is.
>>>
>>> I created a RAID5 array with:
>>>
>>> mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sda1 
>>> /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>>
>>> mdadm -D /dev/md0 verifies the devices has a persistent super-block, 
>>> but upon reboot, /dev/md0 does not get automatically assembled (an 
>>> hence is not a installable/bootable device).
>>>
>>> I have created several raid1 arrays and one raid5 array this way and 
>>> have never had this problem.  In all fairness, this is the first time 
>>> I have used mdadm for the job.  Usually, I boot to something like 
>>> SysRescueCD, used raidtools to create my array and then reboot with 
>>> my Slackware install CD.
>>>
>>> Anyone know why this might be happening? 
>>
>> Old type arrays are assembled due to having the proper partition type, 
>> 0xfd "Linux auto RAID" and are assembled by the kernel. All others are 
>> assembled by mdadm running out of initrd or similar, and failures 
>> there result from not having a proper config file in the initrd image.
>>
>> IIRC raidtools does set the array partitions to the auto-assemble 
>> partition type. Hope that points you in the right direction. Running
>>   "fdisk -l"
>> as root will let you see all the partitions, types, etc, for 
>> everything on your system.
>>
>> I may be wrong, I thought auto-assemble only worked with type 0 or 1.
>>
>> -- 
>> bill davidsen <davidsen@tmr.com>
>> CTO TMR Associates, Inc
>> Doing interesting things with small computers since 1979
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> I use auto-assemble (in conjunction with Debian's own startup scripts) 
> and for my root RAID1 device,swap and /boot, it is automatically taken 
> care of by the kernel.  For RAID5, it seems to work the same:
> 
> [   58.919378] RAID5 conf printout:
> [   58.919418]  --- rd:10 wd:10
> [   58.919457]  disk 0, o:1, dev:sdc1
> [   58.919498]  disk 1, o:1, dev:sdd1
> [   58.919539]  disk 2, o:1, dev:sde1
> [   58.919579]  disk 3, o:1, dev:sdf1
> [   58.919619]  disk 4, o:1, dev:sdg1
> [   58.919659]  disk 5, o:1, dev:sdh1
> [   58.919719]  disk 6, o:1, dev:sdi1
> [   58.919759]  disk 7, o:1, dev:sdj1
> [   58.919799]  disk 8, o:1, dev:sdk1
> [   58.919839]  disk 9, o:1, dev:sdl1
> 
> Justin.
