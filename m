From: NeilBrown <neilb@suse.de>
Subject: Re: 4-disk raid5 with 2 disks going bad: best way to proceed?
Date: Fri, 8 Apr 2011 22:10:46 +1000
Message-ID: <20110408221046.2aa5e685@notabene.brown>
References: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
	<alpine.DEB.2.00.1104070916030.14027@uplift.swm.pp.se>
	<242C1984-F4B5-4C34-BF4C-619875BD9CAF@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <242C1984-F4B5-4C34-BF4C-619875BD9CAF@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rob pfile <rpfile@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 7 Apr 2011 15:15:09 -0700 rob pfile <rpfile@gmail.com> wrote:

> 
> On Apr 7, 2011, at 12:21 AM, Mikael Abrahamsson wrote:
> 
> > On Wed, 6 Apr 2011, rob pfile wrote:
> > 
> >> Hi all,
> >> 
> >> any collective wisdom on what to do here? i've got a 4-disk raid5, and the most recent checkarray showed several bad blocks caused by uncorrectable read errors on two of the disks in the array. both disks in question show 0 reallocated sectors, but one looks like this:
> > 
> > Generally I'd recommend a "repair" as it would try to read all, if it can't read it properly, it'd recalculate from parity and as long as that write succeeded, you'd be golden.
> > 
> > To be safe, stop the array, dd_rescue the two bad drives, start the array again with the originals in the array, don't mount the filesystem, issue repair and see what happens.
> > 
> > This is one reason why I nowadays always run RAID6, then you can fail a drive and still have parity for read errors...
> > 
> > 
> 
> thanks for your reply.
> 
> from reading a similar thread, (http://www.spinics.net/lists/raid/msg31779.html) it's stated that the "repair" command will rebuild the parity if it is thought to be wrong.  i don't think i want to risk writing parity blocks that are probably now correct and could become corrupted because of a bad data read messing up the parity... it's almost like i want something inbetween "check" and "repair" where when the disk gives a hard error on a sector, the data block containing that sector is reconstructed from the parity and then immediately written back to the disk. or does "check" already do that? i was guessing that it did not, or else the drives would probably show a few reallocated sectors.

When a device gives a hard read error md/raid always calculates the correct
data from other devices (Assuming that parity is correct) and writes it out.
It does this for check and for repair and for normal IO.

I am no expert on SMART however if there are no reallocated sectors then
maybe what happened is that whenever md wrote to a bad sector, the drive
determined that the media there was still usable and wrote the data there.
But that is just a guess.

> 
> by "as long as that write succeeded you'd be golden", do you mean that re-writing the block would either reallocate the bad sector, or that perhaps the write would just succeed on the same physical sector, thus cleaning it up somehow? i think reallocating the sector would be preferable but i guess we don't have too much control over what the disk does.
> 
> i guess i should clone these disks as you suggest. if dd_rescue runs without error then i suppose i can just put in the replacement disks and forget about it. if not, i could try the repair. i assume that if the repair goes horribly wrong, i could just put the clones into the array. but as above i'd worry that if corrupt parity got rewritten during the repair of the original disks that perhaps the clones would no longer match the corrupt parity. in that case i'd have to run "repair" again after putting the clones in, i assume.

I would probably be using 'check' rather than 'repair'.  The key is to read
all the drive so as to find any bad block and correct them.  Check does this.
If check reports errors in mismatch_cnt, then it might be appropriate to run
'repair'.  If any data has been corrupt it is already to late to do anything
about it.

NeilBrown


> 
> 
> yeah, i should probably look into raid6.
> 
> thanks,
> 
> rob
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

