From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Reliability of bitmapped resync
Date: Mon, 23 Feb 2009 21:19:05 +0100
Message-ID: <20090223201905.GA7585@lazy.lzy>
References: <20090223194019.GA3488@lazy.lzy> <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> What exactly do you mean by "check".
> 
> If you mean "look in /sys/block/md0/md/mismatch_cnt", then that is
> exactly what I would expect.  The resync found some differences, just
> as you would expect it to, and reported them.
> 
> However if by "check" you mean:
>   echo check > /sys/block/md0/md/sync_action
>   mdadm --wait /dev/md0
>   cat /sys/block/md0/md/mismatch_cnt

yes, that is what I mean.
I start the check _after_ the resync.

Actually, maybe this is not correct, I keep running
something like:

watch cat /proc/mdstat /sys/block/md2/md/mismatch_cnt

So I can see real-time, so to speak, the check
progress and the mismatch count, just to have
an idea on where, on the RAID, the mismatches
could be located. 

Is this a problem?

> then I would not expect any mismatches, and the resync should have
> fixed them.
> 
> If it is the later, that is a real concern and I will need to look into it.
> Please let me know exactly which kernel version and mdadm version you
> are running.

It is an up-to-date Fedora 10, i.e. kernel-2.6.27.15-170.2.24.fc10
and mdadm-2.6.7.1-1.fc10.

Thanks again,

bye,

-- 

piergiorgio
