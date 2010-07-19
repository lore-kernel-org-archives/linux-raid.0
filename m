From: Konstantin Svist <fry.kun@gmail.com>
Subject: Re: messed up changing chunk size
Date: Mon, 19 Jul 2010 11:04:10 -0700
Message-ID: <4C44939A.1060200@gmail.com>
References: <4C439D19.4070906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C439D19.4070906@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  On 07/18/2010 05:32 PM, Konstantin Svist wrote:
>  I've been playing around with RAID config and may have finally messed 
> it up.
>
> Initially, I created the array with 3 300G drives:
> # mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 
> /dev/sda4 /dev/sdb1 /dev/sdc1
> # mkfs.ext4 -v -m 0.01 -E stride=16,stripe-width=32 /dev/md0
>
> It's been working nicely so far, and I decided to add a 4th 300G drive:
> # mdadm --grow --raid-devices=4 --backup-file=/root/grow_md0.bak /dev/md0
>
> That finished overnight, while I looked around and found that chunk 
> size of 512 should work better. I unmounted the FS and ran
> # mdadm --grow -c 512 --backup-file=/root/grow_md0_rechunk.bak /dev/md0
> mdadm: component size 293033536K is not a multiple of chunksize 512K
>
> so I sized it down a bit:
> # mdadm --grow -z 293033472 --backup-file=/root/grow_md0_size.bak 
> /dev/md0
>
> and then back to resizing chunks:
> mdadm --grow -c 512 --backup-file=/root/grow_md0_rechunk.bak /dev/md0
>
> It's running right now:
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[3] sda4[0] sdc1[2] sdb1[1]
>       293033472 blocks super 0.91 level 5, 64k chunk, algorithm 2 
> [4/4] [UUUU]
>       [====>................]  reshape = 22.7% (66540032/293033472) 
> finish=947.3min speed=3984K/sec
>
>
> But just now I tried to mount the filesystem and it's failing:
> EXT4-fs (md0): bad geometry: block count 146516768 exceeds size of 
> device (73258368 blocks)
>
> Here's the question, then: am I royally screwed or is my data still 
> there? How do I recover?
>
>
>
> Yes, in retrospect I should've probably checked around whether this 
> process has been successful for others.. but that's why they say 
> hindsight is 20/20
>


Just noticed that I got this in /var/log/messages when I sized it down:
Jul 18 12:00:44 slon kernel: md0: detected capacity change from 
900199022592 to 300066275328
Jul 18 12:00:44 slon kernel: md0: unknown partition table

And scraped from command line session:

[root@slon ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[3] sda4[0] sdc1[2] sdb1[1]
       879100608 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
[root@slon ~]# mdadm --grow -z 293033472 
--backup-file=/root/grow_md0_size.bak /dev/md0
mdadm: component size of /dev/md0 has been set to 293033472K
[root@slon ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[3] sda4[0] sdc1[2] sdb1[1]
       293033472 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

Looks like instead of setting the number of blocks per-drive (as per the 
man page), the -z option set the number of total blocks for the array, 
instead. Which means I'm very thoroughly screwed.

Right now I'm trying to reshape back to the old chunk size and will then 
try to resize the array back to the previous size. If the chunk size 
change and array resize are both fully reversible -- and I don't think 
I'm THAT lucky -- then I might be able to get some stuff back.
Will see, I guess.


