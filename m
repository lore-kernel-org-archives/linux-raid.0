From: NeilBrown <neilb@suse.de>
Subject: Re: reshape failure
Date: Thu, 17 Feb 2011 07:32:47 +1100
Message-ID: <20110217073247.2dbc9299@notabene.brown>
References: <AANLkTikniCc3NNxgf9tW8Gb4qvUM-UfCJDazYC6Th1jZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikniCc3NNxgf9tW8Gb4qvUM-UfCJDazYC6Th1jZ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias McNulty <tobias@caktusgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 10:46:32 -0500 Tobias McNulty <tobias@caktusgroup.com>
wrote:

> Hi,
> 
> I tried to start a reshape over the weekend (RAID6 -> RAID5) and was
> dismayed to see that it was going to take roughly 2 weeks to complete:
> 
> md0 : active raid6 sdc[0] sdh[5](S) sdg[4] sdf[3] sde[2] sdd[1]
> 5860543488 blocks super 0.91 level 6, 64k chunk, algorithm 2 [5/5]
> [uuuuu] [>....................] reshape = 0.0% (245760/1953514496)
> finish=21189.7min speed=1536K/sec
> 
> The disk that contained the backup file began experiencing SATA errors
> several days into the reshape, due to what turned out to be a faulty
> SATA card.  The card has since been replaced and the RAID1 device that
> contains the backup file successfully resync'ed.
> 
> However, when I try to re-start the reshape now, I get the following error:
> 
> nas:~# mdadm --assemble /dev/md0 --backup-file=md0.backup /dev/sdc
> /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh
> mdadm: Failed to restore critical section for reshape, sorry.
> 
> Is my data lost for good?  Is there anything else I can do?

Try above command with --verbose.
If a message about "too-old timestamp" appears, run

 export MDADM_GROW_ALLOW_OLD=1

and run the command again.

In either case, post the output.

NeilBrown
