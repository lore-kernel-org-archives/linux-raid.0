From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Re: Resizing RAID-1 arrays - some possible bugs and problems
Date: Sat, 08 Jul 2006 09:10:07 +1200
Message-ID: <44AECDAF.3080608@reub.net>
References: <44AE644C.9090408@reub.net> <Pine.LNX.4.64.0607071451370.14371@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0607071451370.14371@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids



On 8/07/2006 6:52 a.m., Justin Piszcz wrote:
> Reuben,
> 
> What chunk size did you use?
> 
> I can't even get mine to get past this part:
> 
> p34:~# mdadm /dev/md3 --grow --raid-disks=7
> mdadm: Need to backup 15360K of critical section..
> mdadm: Cannot set device size/shape for /dev/md3: No space left on device
> 
> Justin.
> 

Just whatever the system selected for the chunk size, ie I didn't specify it 
myself ;)

[root@tornado cisco]# cat /proc/mdstat
Personalities : [raid1]

md0 : active raid1 sdc2[0] sda2[1]
       24410688 blocks [2/2] [UU]
       bitmap: 0/187 pages [0KB], 64KB chunk

md1 : active raid1 sdc3[0] sda3[1]
       19542944 blocks [2/2] [UU]
       bitmap: 0/150 pages [0KB], 64KB chunk

md2 : active raid1 sdc5[0] sda5[1]
       4891648 blocks [2/2] [UU]
       bitmap: 2/150 pages [8KB], 16KB chunk

I was working on md1 when I filed the email earlier.

I wonder if the chunk size is left as-is after a --grow, and if this is optimal 
or not or if this could lead to issues...

reuben

