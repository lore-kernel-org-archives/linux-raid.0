From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: raid6 appears not-degraded just after creation
Date: Sun, 05 Oct 2014 03:24:40 +0300
Message-ID: <54308FC8.3040202@iki.fi>
References: <54305509.30001@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54305509.30001@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

04.10.2014, 23:14, Ethan Wilson kirjoitti:
> MD Raid6 appears not-degraded during initial resync just after creation:
> 
> md106 : active raid6 sdbv1[7] sdbr1[6] sdbq1[5] sdbp1[4] sdbo1[3] 
> sdbn1[2] sdbm1[1] sdbl1[0]
>        3144938496 blocks super 1.2 level 6, 512k chunk, algorithm 2 
> [8/8] [UUUUUUUU]
>        [======>..............]  resync = 34.3% (179834012/524156416) 
> finish=54.3min speed=105637K/sec
> 
> and also from sys filesystem:
> 
> cat /sys/block/md106/md/degraded
> 0
> 
> (kernel 3.14.19)
> 
> Is this normal?

I'd say so.

(Re)syncing does not mean the array is degraded - everything you write
to the new array still has full redundancy immediately.

-- 
Anssi Hannula
