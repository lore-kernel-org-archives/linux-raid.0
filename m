From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Re: Preparation advice?
Date: Sun, 28 Nov 2004 08:36:33 -0500
Message-ID: <6d5bedd8041128053635740144@mail.gmail.com>
References: <6d5bedd8041126205255c0fe7d@mail.gmail.com>
	 <Pine.LNX.4.56.0411270837340.5805@lion.drogon.net>
	 <6d5bedd8041127082528ce68ec@mail.gmail.com>
	 <41A8C57A.1060803@dgreaves.com>
	 <6d5bedd8041127123945b8db48@mail.gmail.com>
	 <41A8EA54.6090708@dgreaves.com>
	 <6d5bedd8041127135230b95202@mail.gmail.com>
	 <41A91263.1010909@dgreaves.com>
	 <6d5bedd804112716277c31207c@mail.gmail.com>
	 <41A9B0D3.4070701@dgreaves.com>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41A9B0D3.4070701@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 Nov 2004 11:04:51 +0000, David Greaves <david@dgreaves.com> wrote:
> Ewan's running 2.4.27 and may have an inconsistency with mdadm counting
> the number of raid devices.
...
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Sat Nov 27 07:32:34 2004
>      Raid Level : raid5
>      Array Size : 735334656 (701.27 GiB 752.98 GB)
>     Device Size : 245111552 (233.76 GiB 250.99 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Nov 27 14:14:24 2004
>           State : dirty
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
...
> what does
>  cat /proc/mdstat
> say?

As noted above, I'm getting an "interesting" discrepancy between the 4
devices I specified in my create and the results from mdadm. The
device seems to be working fine after transferring and playing several
files, but I find the "failed devices" bit particularly concerning.
Haven't found any way to get mdadm to tell me which device it thinks
has failed.

As for the command above, I get:
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 hdd1[3] hdb1[2] sdd1[1] sdc1[0]
      735334656 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

Which is what I would have expected. Any ideas?
