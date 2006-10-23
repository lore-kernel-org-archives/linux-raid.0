From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 Recovery
Date: Mon, 23 Oct 2006 11:29:26 +1000
Message-ID: <17724.6902.507094.791289@cse.unsw.edu.au>
References: <BAYC1-PASMTP06741EF4074D618C18E59FE8030@CEZ.ICE>
	<1161479672.14505.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Cavan on Saturday October 21
Sender: linux-raid-owner@vger.kernel.org
To: nrcavan@engmail.uwaterloo.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 21, nrcavan@engmail.uwaterloo.ca wrote:
> Hi,
> 
> I had a run-in with the Ubuntu Server installer, and in trying to get
> the new system to recognize the clean 5-disk raid5 array left behind by
> the previous Ubuntu system, I think I inadvertently instructed it to
> create a new raid array using those same partitions.
> 
> What I know for sure is that now, I get this:
> 
> user@host:~$ sudo mdadm --examine /dev/hda1
> mdadm: No super block found on /dev/hda1 (Expected magic a92b4efc, got
> 00000000)
> user@host:~$ sudo mdadm --examine /dev/hdc1
> mdadm: No super block found on /dev/hdc1 (Expected magic a92b4efc, got
> 00000000)
> user@host:~$ sudo mdadm --examine /dev/hde1
> mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc, got
> 00000000)
> user@host:~$ sudo mdadm --examine /dev/hdg1
> mdadm: No super block found on /dev/hdg1 (Expected magic a92b4efc, got
> 00000000)
> user@host:~$ sudo mdadm --examine /dev/hdi1
> mdadm: No super block found on /dev/hdi1 (Expected magic a92b4efc, got
> 00000000)
> 
> I didn't format the partitions or write any data to the disk, so I think
> the array's data should be intact. Is there a way to recreate the
> superblocks, or am I hosed?

Weirds.... Could the drives have been repartitioned in the process,
with the partitions being slightly different sizes or at slightly
different offsets?  That might explain the disappearing superblocks,
and remaking the partitions might fix it.

Or you can just re-create the array.  Doing so won't destroy any data
that happens to be there.
To be on the safe side, create it with --assume-clean.  This will avoid
a resync so you can be sure that no data blocks will be written at
all.
Then 'fsck -n' or mount readonly and see if you data is safe.  
Once you are happy that you have the data safe you can trigger the
resync with
   mdadm --assemble --update=resync .....
or 
   echo resync > /sys/block/md0/md/sync_action

(assuming it is 'md0').

Good luck.

NeilBrown
