From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Mon, 4 Aug 2003 10:38:52 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16173.43804.617586.906225@gargle.gargle.HOWL>
References: <3F2D1FAC.9030905@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Chow on Sunday August 3
To: David Chow <davidchow@shaolinmicro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday August 3, davidchow@shaolinmicro.com wrote:
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

I'm afraid I've got no idea what would be causing this.  
I can only suggest you try a plain 2.4.21 kernel and if the problem
persists we can add some extra printk's to find out what is happening.

NeilBrown

> 
> regards,
> David Chow
> 
> Aug  4 06:25:32 www2 kernel: RAID1 conf printout:
> Aug  4 06:25:33 www2 kernel:  --- wd:1 rd:2 nd:3
> Aug  4 06:25:33 www2 kernel:  disk 0, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb3
> Aug  4 06:25:33 www2 kernel:  disk 2, s:1, o:0, n:2 rd:2 us:1 dev:sda3
> Aug  4 06:25:33 www2 kernel:  disk 3, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 4, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 5, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 6, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 7, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 8, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 9, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 10, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 11, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 12, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 13, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 14, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 15, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 16, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 17, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 18, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 19, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 20, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 21, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 22, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 23, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 24, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 25, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel:  disk 26, s:0, o:0, n:0 rd:0 us:0 dev:[dev 
> 00:00]
> Aug  4 06:25:33 www2 kernel: md: updating md2 RAID superblock on device
> Aug  4 06:25:33 www2 kernel: md: sda3 [events: 0000000f]<6>(write) 
> sda3's sb offset: 3076352
> Aug  4 06:25:33 www2 kernel: md: sdb3 [events: 0000000f]<6>(write) 
> sdb3's sb offset: 3076352
> Aug  4 06:25:33 www2 kernel: md: recovery thread got woken up ...
> Aug  4 06:25:33 www2 kernel: md: recovery thread finished ...
> 
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
>      
> unused devices: <none>
> [root@www2 root]# raidhotadd /dev/md2 /dev/sda3
> [root@www2 root]# cat /proc/mdstat
> Personalities : [raid1]
> read_ahead 1024 sectors
> md0 : active raid1 sdb1[1] sda1[0]
>       104320 blocks [2/2] [UU]
>      
> md1 : active raid1 sdb2[1] sda2[0]
>       1052160 blocks [2/2] [UU]
>      
> md2 : active raid1 sda3[2] sdb3[1]
>       3076352 blocks [2/1] [_U]
>      
> md3 : active raid1 sdb5[1]
>       1052160 blocks [2/1] [_U]
>      
> md4 : active raid1 sdb6[1]
>       12635008 blocks [2/1] [_U]
>      
> unused devices: <none>
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
