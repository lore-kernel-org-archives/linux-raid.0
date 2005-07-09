From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Re[2]: Bugreport mdadm-2.0-devel-1
Date: Sat, 9 Jul 2005 11:33:46 +1000
Message-ID: <17103.10618.547298.274604@cse.unsw.edu.au>
References: <1684363827.20050706121331@netvision.net.il>
	<17100.29413.164442.415932@cse.unsw.edu.au>
	<1892534227.20050707043013@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maxim Kozover on Thursday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Maxim Kozover <maximkoz@netvision.net.il>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 7, maximkoz@netvision.net.il wrote:
> Hi Neil!
> Thanks much for your help, array creation using devel-2 just works,
> however, the array can't be assembled again after it's stopped:(

Hmm, yeh, nor it can :-(

I'm not sure when I'll have time to look at this (I'm on leave at the
moment with family visiting and such) but I'll definitely get back to
you by Thursday if not before.

Thanks,

NeilBrown

> 
> # mdadm --zero-superblock -e 1 /dev/sdb
> # mdadm --zero-superblock -e 1 /dev/sdc
> # /bin/rm -rf /bitmap
> # mdadm -C /dev/md0 -e 1 --bitmap /bitmap -l 1 -n 2 /dev/sdb /dev/sdc
> mdadm: array /dev/md0 started.
> # more /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdc[1] sdb[0]
>       33554424 blocks [2/2] [UU]
>       [>....................]  resync =  0.6% (206400/33554424) finish=16.1min s
> peed=34400K/sec
>       bitmap: 4096/4096 pages [16384KB], 4KB chunk, file: /bitmap
> 
> unused devices: <none>
> # mdadm -S /dev/md0
> # more /proc/mdstat
> Personalities : [raid1]
> unused devices: <none>
> # mdadm -A /dev/md0 -e 1 --bitmap /bitmap /dev/sdb /dev/sdc
> mdadm: device 1 in /dev/md0 has wrong state in superblock, but /dev/sdc seems ok
> mdadm: failed to add /dev/sdc to /dev/md0: Invalid argument
> mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
> mdadm: /dev/md0 assembled from 0 drives - not enough to start the array.
> (even if you stop the array after resync completes, it doesn't matter
> as expected).
