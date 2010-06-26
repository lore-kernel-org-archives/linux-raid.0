From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID grow and disk failure
Date: Sat, 26 Jun 2010 15:12:35 +0200
Message-ID: <20100626131235.GA12127@lazy.lzy>
References: <20100624181213.GB9038@lazy.lzy>
 <20100625075751.4429f224@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100625075751.4429f224@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> Assuming the code doesn't have any bugs, the reshape will stop, then
> immediately restart picking up where it left off.

thanks, that's what I wanted to know.

> You will of course end up with a degraded array

Yes, that was clear.

> It might be nice in these circumstances to abort the reshape and revert back
> the the previous number of devices - particularly if it was the new device
> that failed.  However that currently isn't supported.

Well, probably as an option, it could be interesting.

Actually, I would be still interested, we already
discussed the topic, on a RAID-5/6 with HDDs of
different size.
This would simplify many things...

> > 1)
> > mdadm --grow ...
> > mdadm --wait
> > pvresize
> 
> Yes.
> 
> > 
> > 2)
> > mdadm --grow
> > pvresize
> 
> No.
> Until the reshape has completed, the extra space is not available.

There seem to be an issue, here, maybe.

Using the command line:

mdadm --grow /dev/md/vol02 --bitmap=none; mdadm --grow /dev/md/vol02 -n 9 --backup-file=/var/tmp/md125.backup; mdadm --wait /dev/md/vol02; mdadm --grow /dev/md/vol02 --bitmap=internal --bitmap-chunk=128

Note that /dev/md/vol02 is the usual link to /dev/md125,
which should be the same for this scope, I guess.

I got (in two independent tests):

mdadm: Need to backup 2688K of critical section..
mdadm: failed to set internal bitmap.

Re-issuing:

mdadm --wait /dev/md/vol02; mdadm --grow /dev/md/vol02 --bitmap=internal --bitmap-chunk=128

Does wait.

Could it be the devices (being USB) are so slow
that some race condition is uncovered and the
immediate "--wait" after the "--grow" does not work?

Thanks,

bye,

-- 

piergiorgio
