From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Spare-group drive affinity with mdadm?
Date: Wed, 18 Aug 2004 12:27:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16674.48792.132076.666009@cse.unsw.edu.au>
References: <411AA9D5.7090508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brendan Conoboy on Wednesday August 11
To: Brendan Conoboy <blc@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 11, blc@redhat.com wrote:
> Hello,
> 
> I've just setup a raid 10 array (6 mirrors striped together) and have 
> two extra drives available as hot spares.  The mirrors themselves are 
> composed of two drives on separate scsi controllers to keep the SCSI bus 
> from saturating.  The performance of this setup is just phenomenal, but 
> the hot spares are not yet setup.
> 
> It appears that when using mdadm that one can use the spare-group 
> feature to share a single hot-spare amongst multiple raid groups. 
> AFAICT, this is done by placing the hot spare or spares in a single 
> mirror, then designating it as part of the same spare group as a number 
> of other mirrors using the same spare-group name.  For instance, if 
> /dev/md0 has two spare drives, but /dev/md1 does not, I can do this to 
> share the spares:
> 
> ARRAY /dev/md0 level=raid1 num-devices=2 
> devices=/dev/sda1,/dev/sde1,/dev/sdc1,/dev/sdd1 spare-group=g1
> ARRAY /dev/md1 level=raid1 num-devices=2 devices=/dev/sdb1,/dev/sdf1 
> spare-group=g1
> ARRAY /dev/md2 level=raid0 num-devices=2 devices=/dev/md0,/dev/md1
> 
> This is very handy, but performance-wise it's suboptimal.  When a drive 
> fails the system might activate a spare that's on a different scsi chain 
> than the drive that just failed, reducing overall redundancy and 
> throughput.   It'd be nice if when a drive fails, a hot spare on the 
> same chain would be preferred over a drive on a different chain.  Of 
> course this is a pretty arbitrary distinction and something that would 
> need configuration, but it doesn't seem like too much of a stretch over 
> what mdadm can do already.  Maybe some sort of extended mdadm.conf 
> syntax like:
> 
> AFFINITY /dev/sda,/dev/sdb spares=/dev/sdc
> AFFINITY /dev/sde,/dev/sdf spares=/dev/sdd
> 
> (Assuming sda, sdb and sdc are on one chain and sde, sdf, and sdd are on 
> another).
> 
> Is an enhancement like this feasible?

No, at least not in that form.
Device names (like "sda") are not stable.  If drive is added or
removed, lots of names can change.  So hard coding them in mdadm.conf
is a bad idea.

I think the best solution would be to allow mdadm to run an external
program which makes a selection.
It could be given an MD array and a list of possible spares, and it
should return the preferred on.

You would then want to write a program (script?) that implemented
whatever policy you wanted.
You policy seems to be "balance active drives across scsi busses",
which would require checking each array, and possibly looking at drive
stats to see which drives were actually being used.
This is certainly a reasonable policy, but someone else might want a
different one....

Does that sound reasonable?

NeilBrown
