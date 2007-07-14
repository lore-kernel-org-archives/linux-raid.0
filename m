From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid array is not automatically detected.
Date: Sat, 14 Jul 2007 09:51:56 -0400
Message-ID: <4698D4FC.2060100@tmr.com>
References: <4697E231.3070906@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4697E231.3070906@hp.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Christ <bryan.christ@hp.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryan Christ wrote:
> My apologies if this is not the right place to ask this question. 
> Hopefully it is.
>
> I created a RAID5 array with:
>
> mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sda1 /dev/sdb1 
> /dev/sdc1 /dev/sdd1 /dev/sde1
>
> mdadm -D /dev/md0 verifies the devices has a persistent super-block, 
> but upon reboot, /dev/md0 does not get automatically assembled (an 
> hence is not a installable/bootable device).
>
> I have created several raid1 arrays and one raid5 array this way and 
> have never had this problem.  In all fairness, this is the first time 
> I have used mdadm for the job.  Usually, I boot to something like 
> SysRescueCD, used raidtools to create my array and then reboot with my 
> Slackware install CD.
>
> Anyone know why this might be happening? 

Old type arrays are assembled due to having the proper partition type, 
0xfd "Linux auto RAID" and are assembled by the kernel. All others are 
assembled by mdadm running out of initrd or similar, and failures there 
result from not having a proper config file in the initrd image.

IIRC raidtools does set the array partitions to the auto-assemble 
partition type. Hope that points you in the right direction. Running
    "fdisk -l"
as root will let you see all the partitions, types, etc, for everything 
on your system.

I may be wrong, I thought auto-assemble only worked with type 0 or 1.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

