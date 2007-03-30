From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
Date: Fri, 30 Mar 2007 14:38:48 +1000
Message-ID: <17932.37976.65001.735686@notabene.brown>
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan>
	<17931.23488.160031.119117@notabene.brown>
	<Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Thursday March 29
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 29, jpiszcz@lucidpixels.com wrote:
> 
> >
> > Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
> > running at?
> Around 44MB/s.
> 
> I do use the following optimization, perhaps a bad idea if I want other 
> processes to 'stay alive'?
> 
> echo "Setting minimum resync speed to 200MB/s..."
> echo "This improves the resync speed from 2.1MB/s to 44MB/s"
> echo 200000 > /sys/block/md0/md/sync_speed_min
> echo 200000 > /sys/block/md1/md/sync_speed_min
> echo 200000 > /sys/block/md2/md/sync_speed_min
> echo 200000 > /sys/block/md3/md/sync_speed_min
> echo 200000 > /sys/block/md4/md/sync_speed_min
> 

Yes, well....

You told it to use up to 200MB/s and the drives are only delivering
44MB/s, so they will be taking nearly all of the available bandwidth.
You shouldn't be too surprised if other things suffer.

NeilBrown
