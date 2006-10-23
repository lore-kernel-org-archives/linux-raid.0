From: Neil Cavan <nrcavan@engmail.uwaterloo.ca>
Subject: Re: RAID5 Recovery
Date: Sun, 22 Oct 2006 22:52:33 -0400
Message-ID: <BAYC1-PASMTP03983D4F0B5666E72D056AE8000@CEZ.ICE>
References: <BAYC1-PASMTP06741EF4074D618C18E59FE8030@CEZ.ICE>
	 <1161479672.14505.10.camel@localhost>
	 <17724.6902.507094.791289@cse.unsw.edu.au>
Reply-To: nrcavan@engmail.uwaterloo.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17724.6902.507094.791289@cse.unsw.edu.au>
Message-Id: <1161571953.4871.8.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The drives have not been repartitioned.

I think what happened is that I created a new raid5 array over the old
one, but never synced or initialized it.

I'm leery of re-creating the array as you suggest, because I think
re-creating an array "over top" of my existing array is what got me into
trouble in the first place.

Also, from mdadm man page (using v 1.12.0):

--assume-clean
    Tell mdadm that the array pre-existed and is known to be clean.
    This is only really useful for Building RAID1  array.   Only
    use this if you really know what you are doing.  This is currently
    only supported for --build.

This suggests to me that I can only use this to build a legacy array
without superblocks - which I don't want - and that since my array was
RAID5, that it's not "really useful", whatever that means. Oh, and also,
I don't really know what I'm doing. ;)

If I do re-create the array to regenerate the superblocks, isn't it
important that I know the exact parameters of the pre-existing array, to
get the data to match up? chunk size, parity method, etc?

I just don't want to rush in and mess things up. Did that once
already. ;)

Thanks,
Neil

On Mon, 2006-23-10 at 11:29 +1000, Neil Brown wrote:
> On Saturday October 21, nrcavan@engmail.uwaterloo.ca wrote:
> > Hi,
> > 
> > I had a run-in with the Ubuntu Server installer, and in trying to get
> > the new system to recognize the clean 5-disk raid5 array left behind by
> > the previous Ubuntu system, I think I inadvertently instructed it to
> > create a new raid array using those same partitions.
> > 
> > What I know for sure is that now, I get this:
> > 
> > user@host:~$ sudo mdadm --examine /dev/hda1
> > mdadm: No super block found on /dev/hda1 (Expected magic a92b4efc, got
> > 00000000)
> > user@host:~$ sudo mdadm --examine /dev/hdc1
> > mdadm: No super block found on /dev/hdc1 (Expected magic a92b4efc, got
> > 00000000)
> > user@host:~$ sudo mdadm --examine /dev/hde1
> > mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc, got
> > 00000000)
> > user@host:~$ sudo mdadm --examine /dev/hdg1
> > mdadm: No super block found on /dev/hdg1 (Expected magic a92b4efc, got
> > 00000000)
> > user@host:~$ sudo mdadm --examine /dev/hdi1
> > mdadm: No super block found on /dev/hdi1 (Expected magic a92b4efc, got
> > 00000000)
> > 
> > I didn't format the partitions or write any data to the disk, so I think
> > the array's data should be intact. Is there a way to recreate the
> > superblocks, or am I hosed?
> 
> Weirds.... Could the drives have been repartitioned in the process,
> with the partitions being slightly different sizes or at slightly
> different offsets?  That might explain the disappearing superblocks,
> and remaking the partitions might fix it.
> 
> Or you can just re-create the array.  Doing so won't destroy any data
> that happens to be there.
> To be on the safe side, create it with --assume-clean.  This will avoid
> a resync so you can be sure that no data blocks will be written at
> all.
> Then 'fsck -n' or mount readonly and see if you data is safe.  
> Once you are happy that you have the data safe you can trigger the
> resync with
>    mdadm --assemble --update=resync .....
> or 
>    echo resync > /sys/block/md0/md/sync_action
> 
> (assuming it is 'md0').
> 
> Good luck.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

