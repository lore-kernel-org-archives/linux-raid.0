From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-10 unbalanced reads
Date: Mon, 23 Feb 2009 23:15:32 +0100
Message-ID: <20090223221532.GA23542@lazy.lzy>
References: <20090209202728.GA11996@lazy.lzy> <20090209231138.GB13450@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090209231138.GB13450@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

some updates.

> > Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> > sda              10.08       183.15       408.74     755018    1684972
> > sda1              0.04         1.24         0.02       5118         66
> > sda2             10.03       181.71       408.72     749071    1684880
> > sdb              10.49       187.64       408.74     773532    1684972
> > sdb1              0.03         1.17         0.02       4837         66
> > sdb2             10.44       186.26       408.72     767832    1684880
> > md1              62.95       367.26       391.79    1513976    1615112
> > md0               0.02         0.18         0.00        724          8
[...]
> Anyway, I think the difference is too small to be of inportance
> for the performance. Or did you notice a difference?

What about this:

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda               5.43        64.15        71.33     598692     665656
sda1              0.01         0.15         0.01       1421         64
sda2              5.42        63.95        71.32     596823     665592
sdb               6.22       219.19        71.33    2045590     665656
sdb1              0.29        67.16         0.01     626774         64
sdb2              5.93       151.87        71.32    1417344     665592
md1              12.56       129.09        57.25    1204696     534320
md0               0.01         0.08         0.00        724          8

Now, I do not recall any particular reason why
it should be like this (i.e. no resync or else),
but it seems to me a bit too unbalanced.

Could it be a problem with /dev/sdb?
I run smart long tests weekly, but nothing special
was reported, until now.

bye,

-- 

piergiorgio
