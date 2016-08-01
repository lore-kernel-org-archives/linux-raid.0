From: Bill Hudacek <bill.hudacek@gmail.com>
Subject: Re: xosview
Date: Mon, 01 Aug 2016 14:50:40 -0400
Message-ID: <579F9A00.6000906@gmail.com>
References: <ffd06b83-0692-d5a4-1daa-126abf53edfa@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ffd06b83-0692-d5a4-1daa-126abf53edfa@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Anthony Youngman wrote on 07/29/2016 12:52 PM:
> So if people wouldn't mind, could you email your mdstat files?
> Preferably on the list so people can see what has and has not been sent
> - obviously I'd like standard setups like raid10, raid5, raid6, both
> named and numbered. And if people have them, mdstats showing broken
> arrays, rebuilds, complicated setups with lvm, etc.
>

RAID 6 across 5 disks, of which 1 is a spare (in external cabinet), 
and two disks in RAID-1 (for OS, inside the tower):

 > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid6 sdc1[0] sdf1[3] sdd1[1] sdg1[4](S) sde1[2]
       3071737856 blocks super 1.2 level 6, 1024k chunk, algorithm 2 
[4/4] [UUUU]
       bitmap: 0/12 pages [0KB], 65536KB chunk

md126 : active raid1 sdb1[1] sda1[0]
       2099136 blocks super 1.0 [2/2] [UU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

md127 : active raid1 sdb2[1] sda2[0]
       234921984 blocks super 1.2 [2/2] [UU]
       bitmap: 1/2 pages [4KB], 65536KB chunk

unused devices: <none>

I don't have any failure mdstat output saved, sorry...

-- 
/Bill

