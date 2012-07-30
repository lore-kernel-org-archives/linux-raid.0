From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: problem hot-adding spare / internal bitmap problem?
Date: Mon, 30 Jul 2012 07:49:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207300747350.27169@uplift.swm.pp.se>
References: <alpine.DEB.2.00.1207290601000.27169@uplift.swm.pp.se> <CAGRgLy4VEa5b0bJ8g__HaZaVWdEsA75mg2Mg3Rp3K8cTutTxwg@mail.gmail.com> <alpine.DEB.2.00.1207291845320.27169@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1207291845320.27169@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 29 Jul 2012, Mikael Abrahamsson wrote:

> Is that because there is a check in progress?

It seems it was:

[145714.150155] md: md0: data-check done.
[145738.648201] md0: bitmap file is out of date (0 < 4893404) -- forcing full recovery
[145738.648209] created bitmap (15 pages) for device md0
[145738.648223] md0: bitmap file is out of date, doing full recovery
[145738.665780] md0: bitmap initialized from disk: read 1/1 pages, set 29809 of 29809 bits
swmike@ub:~/mdadm$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active raid6 sdj[15](S) sdk[13] sdg[11] sdh[14] sdi[10] sde[12] sdd[9] sdc[2] sdb[6] sdf[7]
       13674601024 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
       bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>

I now successfully added sdj as spare and removed the bitmap file and 
enabled internal bitmap.

Thanks for the answer. Now I'm going to find out how to communicate with 
the mdadm package maintainer(s) in ubuntu and inform them that the 
proposed fixed package indeed does help with this issue.

Thanks!

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
