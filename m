From: Stephen Lee <splee@plexio.com>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: 03 Aug 2003 09:55:57 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1059929757.6751.60.camel@ralph.plexio.private>
References: <3F2D1FAC.9030905@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F2D1FAC.9030905@shaolinmicro.com>
To: Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 2003-08-03 at 07:43, David Chow wrote:
> Dear Neil,
> 
> A problem on hot adding a disk to an existing RAID array. I was 
> converting my root fs and other fs to md . While I am using the 
> failed-disk and move my data to the new degraded md device, after I hot 
> add a new disk to the md , it doesn't start rebuild. What it looks like 
> in the syslog is as follows (see belows). Looks like the recovery thread 
> dot woken up and finished right away... why? My kernel is 2.4.18-3smp 
> which is a RH7.3 vendor kernel. I'd experience on other 2.4.20 RH 
> kernels which had the same problem. My end up result is to use "mkraid 
> --force" to make it as a new array to enable the resync.  The 
> /proc/mdstat also looks wired which one drive is down "[_U]". In fact, 2 
> drives are actually healthy. I've trid mdadm -manage which produce the 
> same result. I've also tried to dd the partitions to all zero before add 
> but same result. Please give direction, as moving the root to somewhere 
> else and use mkraid to start with is really stupid (my opinion), 
> actually, I've no spare disk to that this time.
> 
> regards,
> David Chow
<snip>

> [root@www2 root]# cat /proc/mdstat
> Personalities : [raid1]
> read_ahead 1024 sectors
> md0 : active raid1 sdb1[1] sda1[0]
>       104320 blocks [2/2] [UU]
>      
> md1 : active raid1 sdb2[1] sda2[0]
>       1052160 blocks [2/2] [UU]
>      
> md2 : active raid1 sdb3[1]
>       3076352 blocks [2/1] [_U]
>      
> md3 : active raid1 sdb5[1]
>       1052160 blocks [2/1] [_U]
>      
> md4 : active raid1 sdb6[1]
>       12635008 blocks [2/1] [_U]
<snip>

Did you try:
mdadm /dev/md2 -a /dev/sda3
mdadm /dev/md3 -a /dev/sda5
mdadm /dev/md4 -a /dev/sda6

If this doesn't work then what are the exact error messages?

Stephen

