From: Zivago Lee <z@ziff.net>
Subject: Re: Raid array is not automatically detected.
Date: Fri, 13 Jul 2007 17:03:03 -0700
Message-ID: <1184371385.29034.7.camel@miyagip>
References: <4697E231.3070906@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4697E231.3070906@hp.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Christ <bryan.christ@hp.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2007-07-13 at 15:36 -0500, Bryan Christ wrote:
> My apologies if this is not the right place to ask this question. 
> Hopefully it is.
> 
> I created a RAID5 array with:
> 
> mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sda1 /dev/sdb1 
> /dev/sdc1 /dev/sdd1 /dev/sde1
> 
> mdadm -D /dev/md0 verifies the devices has a persistent super-block, but 
> upon reboot, /dev/md0 does not get automatically assembled (an hence is 
> not a installable/bootable device).
> 
> I have created several raid1 arrays and one raid5 array this way and 
> have never had this problem.  In all fairness, this is the first time I 
> have used mdadm for the job.  Usually, I boot to something like 
> SysRescueCD, used raidtools to create my array and then reboot with my 
> Slackware install CD.
> 
> Anyone know why this might be happening?

Are you trying to boot on this raid device?  I believe there is a
limitation as what raid type you can boot off of (IIRC. only raid0 and
raid1).

-- 
Zivago Lee <z@ziff.net>

