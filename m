From: Bryan Christ <bryan.christ@hp.com>
Subject: Re: Raid array is not automatically detected.
Date: Fri, 13 Jul 2007 21:09:07 -0500
Message-ID: <46983043.6070804@hp.com>
References: <4697E231.3070906@hp.com> <1184371385.29034.7.camel@miyagip>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1184371385.29034.7.camel@miyagip>
Sender: linux-raid-owner@vger.kernel.org
To: Zivago Lee <z@ziff.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like for it to be the boot device.  I have setup a raid5 mdraid 
array before and it was automatically accessible as /dev/md0 after every 
reboot.  In this peculiar case, I am having to assemble the array 
manually before I can access it...

mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1

Unless I do the above, I cannot access /dev/md0.  I've never had this 
happen before.  Usually a cursory glance through dmesg will show that 
the array was detected, but not so in this case.

Zivago Lee wrote:
> On Fri, 2007-07-13 at 15:36 -0500, Bryan Christ wrote:
>> My apologies if this is not the right place to ask this question. 
>> Hopefully it is.
>>
>> I created a RAID5 array with:
>>
>> mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sda1 /dev/sdb1 
>> /dev/sdc1 /dev/sdd1 /dev/sde1
>>
>> mdadm -D /dev/md0 verifies the devices has a persistent super-block, but 
>> upon reboot, /dev/md0 does not get automatically assembled (an hence is 
>> not a installable/bootable device).
>>
>> I have created several raid1 arrays and one raid5 array this way and 
>> have never had this problem.  In all fairness, this is the first time I 
>> have used mdadm for the job.  Usually, I boot to something like 
>> SysRescueCD, used raidtools to create my array and then reboot with my 
>> Slackware install CD.
>>
>> Anyone know why this might be happening?
> 
> Are you trying to boot on this raid device?  I believe there is a
> limitation as what raid type you can boot off of (IIRC. only raid0 and
> raid1).
> 
