From: Keld Simonsen <keld@keldix.com>
Subject: Re: raid1 performance
Date: Sat, 31 Jul 2010 18:04:44 +0200
Message-ID: <20100731160444.GA19780@rap.rap.dk>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com>
 <20100725211926.7547c12e@natsu>
 <23123.42111.qm@web28503.mail.ukl.yahoo.com>
 <20100726210324.6a4077e6@notabene>
 <379853.84515.qm@web28502.mail.ukl.yahoo.com>
 <20100728082358.4abc6868@notabene>
 <13942.81514.qm@web28516.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <13942.81514.qm@web28516.mail.ukl.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco <jjletho67-diar@yahoo.it>
Cc: Neil Brown <nfbrown@novell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 31, 2010 at 03:21:40PM +0000, Marco wrote:
> >> sda 84.02 
> >> sdb 113,69
> >> md2 8,01
> >> 
> >> md2 and his meber have a very different ratio....
> >
> >Strange isn't it.  And the ratios are the other-way-around to what I get.
> >I don't currently understand why ... but it might not be at all relevant to
> >the speed difference.
> 
> Hi,
> i did some test on a different machine with centos 5.5 and ICH10 disk 
> controller. On this machine i have no performance issue: hdparm -t return the 
> same value (about 107 MB/s) on both /dev/md0 and its members
> 
> I measured the "ratio" and i obtained 8.02 for md0 and 505 for meber disk. I it 
> seems that the "raito" is not so relevant for this issue. What do you think ?
> In this case the md device was not mounted.
> I also tried several different io scheduler whithout noting any effect on 
> sequential read eprformance.
> 
> Marco

maybe try out raid10,f2 instead of raid1. You should get about double
the sequential read performance out of your raids, then, eg tested
with hdparm.

best regards
keld
