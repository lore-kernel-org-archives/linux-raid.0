From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid6 low performance 8x3tb drives in singledegraded mode(=7x3tb)
Date: Wed, 12 Sep 2012 10:42:29 +0100
Message-ID: <20560.22789.265849.102178@tree.ty.sabi.co.UK>
References: <504FD153.9090602@sandberg-consult.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <504FD153.9090602@sandberg-consult.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> I have setup an array of 7x3tb WD30EZRX drives, though its
> meant for 8x, so it runs in singledegraded mode.

An (euphemism) amazing concept, with (euphemism) surprising
effects:

> the issue is that i get very poor performance, generally
> roughly 25MB/s writes only. [ ... ]

> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s [ ... ]
> sdb            1370.00   732.00  109.00   30.00 11824.00  5864.00 [ ... ]
> sdf            1392.00   839.00   88.00   33.00 11840.00  6976.00 [ ... ]
> sdd            1422.00   863.00   64.00   29.00 13448.00  6384.00 [ ... ]
> sdg            1388.00   446.00   92.00   18.00 11840.00  3248.00 [ ... ]
> sdc            1395.00   857.00   85.00   40.00 11840.00  6944.00 [ ... ]
> sda            1370.00   985.00  111.00   41.00 11888.00  7744.00 [ ... ] 
> sde            1417.00   669.00   70.00   21.00 13528.00  5040.00 [ ... ]
> sdh               0.00     0.00    0.00    0.00     0.00     0.00 [ ... ]
> md0               0.00     0.00    0.00   86.00     0.00 17656.00 [ ... ]
> dm-0              0.00     0.00    0.00    0.00     0.00     0.00 [ ... ]

It is (euphemism) mysterious that 'rsec/s' is nearly twice as
high as 'wsec/s', and (euphemism) obscure that the RAID set is
also 'sync'ing:

>     Number   Major   Minor   RaidDevice State
>        0       8        0        0      active sync   /dev/sda
>        1       8       16        1      active sync   /dev/sdb
>        2       8       32        2      active sync   /dev/sdc
>        3       8       48        3      active sync   /dev/sdd
>        4       8       64        4      active sync   /dev/sde
>        5       8       80        5      active sync   /dev/sdf
>        8       8       96        6      active sync   /dev/sdg
>        7       0        0        7      removed

> [ ... ] so i must assume the issue is in the raid layer.

Or perhaps in the greyware layer :-).
