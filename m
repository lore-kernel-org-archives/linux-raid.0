From: Andy Arvai <arvai@scripps.edu>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 11:49:42 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304031949.LAA28555@astra.scripps.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Shouldn't /proc/mdstat have [UUUUU] instead of [_UUUU]? Perhaps
this is running in degraded mode. Also, you have 'algorithm 0',
whereas my raid5 has 'algorithm 2', which is the left-symmetric
parity algorithm.

Andy 

> cat /proc/mdstat gives: 
> 
> Personalities : [raid0] [raid5] 
> read_ahead 1024 sectors
> md0 : active raid5 hdk1[4] hdi1[3] hdg1[2] hde1[1] hdc1[0]
> 	468872704 blocks level 5, 128k chunk, algorithm 0 [5/5] [_UUUU]
> unused devices: <none>



