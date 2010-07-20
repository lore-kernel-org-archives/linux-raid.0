From: Konstantin Svist <kostya@relevad.com>
Subject: Re: messed up changing chunk size
Date: Mon, 19 Jul 2010 21:28:24 -0700
Message-ID: <4C4525E8.2010702@relevad.com>
References: <4C439D19.4070906@gmail.com> <4C44939A.1060200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C44939A.1060200@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 07/19/2010 11:04 AM, Konstantin Svist wrote:
> Just noticed that I got this in /var/log/messages when I sized it down:
> Jul 18 12:00:44 slon kernel: md0: detected capacity change from 
> 900199022592 to 300066275328
> Jul 18 12:00:44 slon kernel: md0: unknown partition table
>
> And scraped from command line session:
>
> [root@slon ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[3] sda4[0] sdc1[2] sdb1[1]
>       879100608 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> [root@slon ~]# mdadm --grow -z 293033472 
> --backup-file=/root/grow_md0_size.bak /dev/md0
> mdadm: component size of /dev/md0 has been set to 293033472K
> [root@slon ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[3] sda4[0] sdc1[2] sdb1[1]
>       293033472 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>
> Looks like instead of setting the number of blocks per-drive (as per 
> the man page), the -z option set the number of total blocks for the 
> array, instead. Which means I'm very thoroughly screwed.
>
> Right now I'm trying to reshape back to the old chunk size and will 
> then try to resize the array back to the previous size. If the chunk 
> size change and array resize are both fully reversible -- and I don't 
> think I'm THAT lucky -- then I might be able to get some stuff back.
> Will see, I guess.

Can someone confirm that this command should work to revert the size?
mdadm --grow -z 879100608 --backup-file=/root/grow_md0_size_revert.bak 
/dev/md0

