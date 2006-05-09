From: Neil Brown <neilb@suse.de>
Subject: Re: strange RAID5 problem
Date: Tue, 9 May 2006 15:45:25 +1000
Message-ID: <17504.11381.804875.246260@cse.unsw.edu.au>
References: <4460290C.50202@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maurice Hilarius on Monday May 8
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 8, maurice@harddata.com wrote:
> Good evening.
> 
> I am having a bit of a problem with a largish RAID5 set.
> Now it is looking more and more like I am about to lose all the data on
> it, so I am asking (begging?) to see if anyone can help me sort this out.
> 

Very thorough description, but you omitted the 'dmesg' output
corresponding to :

> 
> [root@box ~]# mdadm
> --assemble /dev/md3 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1
> /dev/sdv1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1
> /dev/sdad1 /dev/sdae1 /dev/sdaf1
> mdadm: failed to RUN_ARRAY /dev/md3: Invalid argument


Also, you don't seem to have tried '--force' with '--assemble'.  It
might help.

NeilBrown
