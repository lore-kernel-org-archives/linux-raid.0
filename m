From: Neil Brown <neilb@suse.de>
Subject: Re: Suspend_hi mamagment during reshape
Date: Thu, 9 Dec 2010 21:28:10 +1100
Message-ID: <20101209212810.28fd4f45@notabene.brown>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
	<20101206132108.21125.54920.stgit@gklab-170-024.igk.intel.com>
	<20101208141016.437dfd2d@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17676EAED@irsmsx503.ger.corp.intel.com>
	<20101209090558.32f48daa@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176A1B088@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176A1B088@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Thu, 9 Dec 2010 08:42:35 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> Hi,
> 
> I've got a problem with suspend_hi management during check-pointing, as we discuss this a while ago.
> 
> Currently, I've corrected check-pointing in the way that mdmon sets suspend_hi to the place that sync_max is set in current pass to guard access.
> This assumption looks for me ok in general, problem is when mdadm decides to set sync_max to max. mdmon cannot set max due to fact that this would block
> rest of array to user. This means that mdmon should move sync_max and suspend_hi in parallel through the rest of array by some distances.
> This can gives us additional opportunities to store checkpoints. I would like to know your opinion about such solution.

suspend_hi should be manipulated by mdadm, not mdmon.

Here is my outline that I sent earlier.  Please base your implementation on
this, though feel free to comment if you find some part of it doesn't work.

This is from my email to you on 29 Nov 2010 
 subject: Re: [PATCH 00/53] External Metadata Reshape


1/ mdadm freezes the array so the no recovery or reshape can start.
2/ mdadm sets sync_max to 0 so even when the array is unfrozen, no data will
   be relocated.  It also sets suspend_lo and suspend_hi to zero.
3/ mdadm tells the kernel about the requested reshape, setting some or all of
   chunk_size, layout, level, raid_disks (and later, data_offset for each
   device).
4/ mdadm checks that mdmon has noticed the changes and has updates the
   metadata to show a reshape-in-progress (ping_monitor).
5/ mdadm unfreezes the array for mdmon (change the '-' in metadata_version
   back to '/') and calls ping_monitor
6/ mdmon assigns spares as appropriate and tells the kernel which slot to use
   for each.  This requires a kernel change.  The slot number will be stored
   in saved_raid_disk.  ping_monitor doesn't complete until the spares have
   been assigned.
7/ mdadm asked the kernel to start reshape (echo reshape > sync_action).
   This causes md_check_recovery to all remove_and_add_spares which will
   add the chosen spares to the required slots and will create the reshape
   thread.  That thread will not actually do anything yet as sync_max
   is still 0.

8/ Now we loop, performing backups, reshaping data, and updating the metadata.
   It proceeds in a 'double-buffered' process where we are backing up one
   section while the previous section is being reshaped.

 8a/ mdadm sets suspend_hi to a larger number.  This blocks until intervening
     IO is flushed.
 8b/ mdadm makes a backup copy of the data up to the new suspend_hi
 8c/ mdadm updates sync_max to match suspend_hi.
 8d/ kernel starts reshaping data and periodically signals progress through
     sync_completed
 8e/ mdmon notices sync_completed changing and updates the metadata to
     record how far the reshape has progressed. 
 8f/ mdadm notices sync_completed changing and when it passes the end of the
     oldest of the two sections being worked on it uses ping_monitor to
     ensure the metadata is up-to-date and then moves suspend_lo to the
     beginning of the next section, and then goes back to 8a.

9/ When sync_completed reaches the end of the array, mdmon will notice and
   update the metadata to show that the reshape has finished, and mdadm will
   set both suspend_lo and suspend_hi to beyond the end of the array, and all
   is done.


> 
> Second problem is about cleanup after reshape. 
> >From uses space after reshape, I'm not able to set suspend_hi to 0. This is up to suspend_hi_store() checks.(suspend_lo cannot be set to 0, and suspend_hi cannot be less than suspend_lo).
> I think that part of Maciek's patch should be applied to md in raid5.c, so at the end of raid5_finish_reshape() the following code should be placed:
> 
> if (mddev->external) {
> 	mddev->suspend_hi = 0;
> 	mddev->suspend_lo = 0;
> 	mddev->pers->quiesce(mddev, 1);
> 	mddev->pers->quiesce(mddev, 0);
> }
> 
> The other option is accept for setting suspend_lo/hi to 0 when there is no array processing (reshape), but first change I think is better.
> What is your opinion?

Why do you want to set suspend_hi to zero after a reshape.
Just set both suspend_hi and suspend_lo to the size of the array (which is
where the above process would get them to) and leave them there.

NeilBrown


> 
> BR
> Adam
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

