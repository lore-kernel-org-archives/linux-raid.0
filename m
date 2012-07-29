From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: problem hot-adding spare / internal bitmap problem?
Date: Sun, 29 Jul 2012 18:48:16 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207291845320.27169@uplift.swm.pp.se>
References: <alpine.DEB.2.00.1207290601000.27169@uplift.swm.pp.se> <CAGRgLy4VEa5b0bJ8g__HaZaVWdEsA75mg2Mg3Rp3K8cTutTxwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4VEa5b0bJ8g__HaZaVWdEsA75mg2Mg3Rp3K8cTutTxwg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 29 Jul 2012, Alexander Lyakas wrote:

> Once you confirmed these, grab mdadm 3.2.4 or the following commit: 
> 6ef8905 super1: make aread/awrite always use an aligned buffer.

I found their proposed update to 3.2.5 at:

https://launchpad.net/ubuntu/+source/mdadm/3.2.5-1ubuntu0.1/+build/3682539

I have downloaded it, but it seems it cannot remove the bitmap file now:

swmike@ub:~/mdadm$ sudo mdadm -V
mdadm - v3.2.5 - 18th May 2012
swmike@ub:~/mdadm$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
[raid1] [raid10]
md0 : active raid6 sdj[15](S) sdk[13] sdg[11] sdh[14] sdi[10] sde[12] sdd[9] sdc[2] sdb[6] sdf[7]
       13674601024 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
       [============>........]  check = 60.4% (1180025928/1953514432) finish=1760.2min speed=7323K/sec
       bitmap: 0/466 pages [0KB], 2048KB chunk, file: /boot/md0-bitmap

unused devices: <none>
swmike@ub:~/mdadm$ sudo mdadm --grow /dev/md0 --bitmap=none
mdadm: failed to remove bitmap /boot/md0-bitmap

Is that because there is a check in progress?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
