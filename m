From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: RAID-10 unbalanced reads
Date: Mon, 23 Feb 2009 23:52:02 +0100
Message-ID: <20090223225202.GA28505@rap.rap.dk>
References: <20090209202728.GA11996@lazy.lzy> <20090209231138.GB13450@rap.rap.dk> <20090223221532.GA23542@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090223221532.GA23542@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 23, 2009 at 11:15:32PM +0100, Piergiorgio Sartor wrote:
> Hi,
> 
> some updates.
> 
> > > Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> > > sda              10.08       183.15       408.74     755018    1684972
> > > sda1              0.04         1.24         0.02       5118         66
> > > sda2             10.03       181.71       408.72     749071    1684880
> > > sdb              10.49       187.64       408.74     773532    1684972
> > > sdb1              0.03         1.17         0.02       4837         66
> > > sdb2             10.44       186.26       408.72     767832    1684880
> > > md1              62.95       367.26       391.79    1513976    1615112
> > > md0               0.02         0.18         0.00        724          8
> [...]
> > Anyway, I think the difference is too small to be of inportance
> > for the performance. Or did you notice a difference?
> 
> What about this:
> 
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sda               5.43        64.15        71.33     598692     665656
> sda1              0.01         0.15         0.01       1421         64
> sda2              5.42        63.95        71.32     596823     665592
> sdb               6.22       219.19        71.33    2045590     665656
> sdb1              0.29        67.16         0.01     626774         64
> sdb2              5.93       151.87        71.32    1417344     665592
> md1              12.56       129.09        57.25    1204696     534320
> md0               0.01         0.08         0.00        724          8
> 
> Now, I do not recall any particular reason why
> it should be like this (i.e. no resync or else),
> but it seems to me a bit too unbalanced.
> 
> Could it be a problem with /dev/sdb?
> I run smart long tests weekly, but nothing special
> was reported, until now.

You think the sdb2 read rate of 151 blks/s vs sda2 63 blks/s is strange?
Well, it does look strange. OTOH the tps is 

sdb2   5.93
sda2   5.42 

Which is not so big a difference. 

what is sdb1 and sda1 used for? the fugures there seems even stranger.
It also looks strnge that the sdb disk is the slower about 80 MB/s
while sda is around 110 MB/s - and then sdb produces more than sda...

Best regards
keld
