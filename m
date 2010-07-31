From: Marco <jjletho67-diar@yahoo.it>
Subject: Re: raid1 performance
Date: Sat, 31 Jul 2010 15:21:40 +0000 (GMT)
Message-ID: <13942.81514.qm@web28516.mail.ukl.yahoo.com>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com> <20100725211926.7547c12e@natsu> <23123.42111.qm@web28503.mail.ukl.yahoo.com> <20100726210324.6a4077e6@notabene> <379853.84515.qm@web28502.mail.ukl.yahoo.com> <20100728082358.4abc6868@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100728082358.4abc6868@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> sda 84.02 
>> sdb 113,69
>> md2 8,01
>> 
>> md2 and his meber have a very different ratio....
>
>Strange isn't it.  And the ratios are the other-way-around to what I get.
>I don't currently understand why ... but it might not be at all relevant to
>the speed difference.

Hi,
i did some test on a different machine with centos 5.5 and ICH10 disk 
controller. On this machine i have no performance issue: hdparm -t return the 
same value (about 107 MB/s) on both /dev/md0 and its members

I measured the "ratio" and i obtained 8.02 for md0 and 505 for meber disk. I it 
seems that the "raito" is not so relevant for this issue. What do you think ?
In this case the md device was not mounted.
I also tried several different io scheduler whithout noting any effect on 
sequential read eprformance.

Marco


      

