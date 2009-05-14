From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: resync duration ?
Date: Fri, 15 May 2009 07:38:38 +1200
Message-ID: <4A0C733E.9010306@sauce.co.nz>
References: <1308264373.20090514150647@kaneda.iguw.tuwien.ac.at> <20090514135840.GB8862@atlantis.cc.ndsu.NoDak.edu> <4A0C4FAB.3020607@anonymous.org.uk> <20090514180747.GA9995@atlantis.cc.ndsu.NoDak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090514180747.GA9995@atlantis.cc.ndsu.NoDak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
List-Id: linux-raid.ids

Bryan Mesich wrote:
> On Thu, May 14, 2009 at 06:06:51PM +0100, John Robinson wrote:
> 
>>I think about 160 minutes is reasonable for 750GB, on an otherwise  
>>unloaded box; it's only 70MB/sec off 3 drives and on to 1 newer, faster  
>>drive.
> 
> 
> I have a similar setup with 4 750G SATA drives.  The box is
> failry beefy, with 8 processor cores and a PCI-E SATA controler
> (3Ware 9650SE).  For an initial sync, it will take about 315
> minutes to complete.
> 
> I'm not sure if this is a fair comparison, since Rainer was do a
> resync.
> 
> md8 : active raid5 sdx1[4] sdw1[2] sdv1[1] sdu1[0]
>       2197209600 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>       [>....................]  recovery =  1.6% (12015536/732403200) finish=312.3min speed=38437K/sec
> 
> I'm probably splitting hairs at this point.
> 
> Bryan

Just to add another data point, I replaced a dead 750GB drive in 4 x 750 
md RAID5 last week and it took 145 minutes.

Resync on another 16 x 750GB md RAID6 takes around 180min.

Regards,

Richard
