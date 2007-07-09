From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Fwd: Re: RAID performance is not too well....
Date: Mon, 9 Jul 2007 13:39:16 +0200
Message-ID: <20070709113916.GA9781@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Bill Told me to report this to linux-raid. But Possibly
the raid code can't be blamed, because it is the filesystem
code that messes up. 



----- Forwarded message from Bill Davidsen <davidsen@tmr.com> -----
> 
> From: Bill Davidsen <davidsen@tmr.com>
> To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
> CC: linux-kernel@vger.kernel.org
> Date: Thu, 05 Jul 2007 15:35:36 -0400
> Subject: Re: RAID performance is not too well....
> X-Spam-Status: No, score=3.0 required=5.0 tests=AWL,BAYES_99 autolearn=no 
	version=3.1.7-deb

> Rogier Wolff wrote:
> >Hi,
> >
> >I have an application that creates some 228 thousand files,
> >spread over about 4000 directories. Total is not more than 
> >1.3Gb.  (I'm not sure, and I don't care if it's 10% or 90% of
> >that number)
> >
> >Anyway, I've loaded all of the 1.3Gb into the cache (the machine
> >has 8Gb of RAM), so that only writes need to take place. 
> >
> >After a while the machine goes into a routine of writing
> >about 500 to 1000kbytes per second. 
> >
> >Sync seems to take a long time: 
> >
> >zebigbos:/recover7/bd4256_jense/tree> time sync 
> >0.004u 0.136s 5:44.66 0.0%      0+0k 0+0io 0pf+0w
> >zebigbos:/recover7/bd4256_jense/tree> 
> >
> >The machine normally reads up to about 150 Mbytes per second without
> >trouble. 
> >
> >I'm suspecting that the writes to the inodes and files all end
> >up "fragmented" such that reads to complete the RAID stripes 
> >need to be performed: 
> >
> >Iostat shows: 
> >
> >Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> >sda              75.25       277.23       126.73        280        128
> >sdb              91.09       400.00       134.65        404        136
> >sdc              71.29       253.47        95.05        256         96
> >sdd             100.99       221.78       304.95        224        308
> >
> >However, I would say that all those new files should be "clustered" 
> >such that the chances of writing a full stripe becomes reasonable. 
> >Moreover, clustering should, even with reading other parts of the
> >stripe result in a performance on the order of 10 to 50 times better. 
> >
> >Raid block (stripe) size  is 64k.  (Next time I format a partition, 
This should be chunk size. ^^^^^^^^ 
> >I will chose 512k, causing the readperformance to increasae from 150Mb
> >per second to about 200Mb per second). 
> >
> I'm not sure what you mean by "Raid block," and a stripe size on 64k is 
> improbably low. That sounds like a chunk size using common nomenclature. 

OK. chunk size. 

> You don't say what RAID level you are using, nor what filesystem type, 

RAID 5. 

> so it's really hard to give you any useful help, other than "send more 
> information, use standard terms, send to the linux-raid list, not kernel."
> 
> By "format a partition" do you mean "create an array?" Or ???

Ehh. Yes. 

	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
