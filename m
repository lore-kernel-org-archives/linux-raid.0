From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Mon, 10 Jul 2006 18:30:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607101830130.2603@p34.internal.lan>
References: <Pine.LNX.4.64.0607070830450.2648@p34.internal.lan>
 <Pine.LNX.4.64.0607070845280.2648@p34.internal.lan>
 <Pine.LNX.4.64.0607070849140.3010@p34.internal.lan>
 <Pine.LNX.4.64.0607071037190.5153@p34.internal.lan> <17582.55703.209583.446356@cse.unsw.edu.au>
 <Pine.LNX.4.64.0607101747160.2603@p34.internal.lan>
 <Pine.LNX.4.61.0607110026030.5420@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0607110026030.5420@yvahk01.tjqt.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 11 Jul 2006, Jan Engelhardt wrote:

>> md3 : active raid5 sdc1[7] sde1[6] sdd1[5] hdk1[2] hdi1[4] hde1[3] hdc1[1]
>> hda1[0]
>>      2344252416 blocks super 0.91 level 5, 512k chunk, algorithm 2 [8/8]
>> [UUUUUUUU]
>>      [>....................]  reshape =  0.2% (1099280/390708736)
>> finish=1031.7min speed=6293K/sec
>>
>> It is working, thanks!
>>
> Hm, what's superblock 0.91? It is not mentioned in mdadm.8.
>
>
> Jan Engelhardt
> -- 
>

Not sure, the block version perhaps?

I am using:

$ mdadm -V
mdadm - v2.5 -  26 May 2006

Debian Etch.

Justin.
