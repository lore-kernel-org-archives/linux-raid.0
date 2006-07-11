From: Petr Vyskocil <petr@anime.cz>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Tue, 11 Jul 2006 11:05:59 +0200
Message-ID: <e8vplt$fgv$1@sea.gmane.org>
References: <Pine.LNX.4.64.0607070830450.2648@p34.internal.lan> <Pine.LNX.4.64.0607070845280.2648@p34.internal.lan> <Pine.LNX.4.64.0607070849140.3010@p34.internal.lan> <Pine.LNX.4.64.0607071037190.5153@p34.internal.lan> <17582.55703.209583.446356@cse.unsw.edu.au> <Pine.LNX.4.64.0607101747160.2603@p34.internal.lan> <Pine.LNX.4.61.0607110026030.5420@yvahk01.tjqt.qr> <Pine.LNX.4.64.0607101830130.2603@p34.internal.lan> <Pine.LNX.4.61.0607110950450.30961@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0607110950450.30961@yvahk01.tjqt.qr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

>>> Hm, what's superblock 0.91? It is not mentioned in mdadm.8.
>>>
>> Not sure, the block version perhaps?
>>
> Well yes of course, but what characteristics? The manual only lists
>  0, 0.90, default
>  1, 1.0, 1.1, 1.2
> No 0.91 :(


AFAICR superblock version gets raised by 0.01 for the duration of 
reshape, so that non-reshape aware kernels do not try to assemble it 
(and cause data corruption).

Petr

