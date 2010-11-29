From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/53] External Metadata Reshape
Date: Mon, 29 Nov 2010 14:32:24 +1100
Message-ID: <20101129143224.0619ed5f@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:03:51 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> This patch series (combines 3 previous series in to one) for mdadm and introduces features:
> - Freeze array/container and new reshape vectors: patches 0001 to 0015
>   mdadm devel 3.2 contains patches 0001 to 0013 already,  patches 0014 and 0016 fixes 2 problems in this functionality
> - Takeover: patches 0016 to 0017
> - Online Capacity Expansion (OLCE): patches 0018 to 0036
> - Checkpointing: patches 0037 to 0045
> -  Migrations: patches 0045 to 0053
>     1. raid0 to raid5 : patch 0051
>     2. raid5 to raid0 : patch 0052
>     3. chunk size migration) : patch 0053
> 
> Patches are for mdadm 3.1.4 and Neil's feedback for 6 first OLCE patches is included.
> There should be no patch corruption problem now, as it is sent directly from stgit (not outlook).
> 
> For checkpointing md patch "md: raid5: update suspend_hi during reshape" is required also (sent before).

I think I've decided that I don't want to apply this patch to raid5.  I
discussed this with Dan Williams at the plumbers conference and he took
notes, so hopefully he can correct anything in the following.

I think it was me that suggested this patch in the first place, so it
probably seemed like a good idea at the time.  But I no longer think so.

This is how I think it should work - which should probably go in
external-reshape-design.txt.

An important principle is that everything works much like it currently does
for the native metadata case except that some of the work normally performed
by the kernel is now performed by mdmon.  So the only changes to mdadm need
to work with external metadata in general involve communicating directly with
mdmon when it would normally only communicate with the kernel.  (of course
where will be other changes required to mdadm to deal with the specifics of
reshaping imsm and general container-based metadata).

Also, the atomicity provided by the kernel may not be implicitly available to
the kernel+mdmon pairing, so mdadm may get involved in negotiating the
required atomicity.

Just to be explicit, we are talking here about a 'reshape' which requires
restriping the array, moving data around and taking a long time.   Reshapes
which are atomic or just require a resync are much simpler than this.

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


In the case where the number of data devices is changing there are large
periods of time when no backup of data is needed.  In this case mdmon still
needs to update the metadata from time to time, and the kernel needs to be
made to wait for that update.  This is done with sync_max.  So in those cases
the primary sets in the above become just 8c, 8d, 8e, 8f, and
suspend_lo,suspend_hi aren't changed.

It is tempting to have mdmon update sync_max, as then mdadm would not be
needed at all when no backup is happening.  I think that is the path of
reasoning I followed previously which lead to having the kernel update
suspend_hi.  But I don't think that is a good design now.
Sometimes it really has to be mdadm updating sync_max, so it should always
been mdadm updating sync_max.

It should be a reasonably simple change to your code to follow this
pattern.  If the only problem that I find in any of your patches is that they
don't quite follow this pattern properly I will happily fix them to follow
the pattern and apply them with the fix.



> New vectors (introduced by Dan Williams) reshape_super() and manage_reshape() are used in whole process.
> 
> In the next step, I'll rebase it to mdadm devel 3.2, meanwhile Krzysztof Wojcik will prepare additional fixes for raid10<->raid0 takeover
> 
> I think that few patches can be taken in to devel 3.2 at this monent i.e.:
>     0014-FIX-Cannot-exit-monitor-after-takeover.patch
>     0015-FIX-Unfreeze-not-only-container-for-external-metada.patch
>     0016-Add-takeover-support-for-external-meta.patch
>     0018-Treat-feature-as-experimental.patch
>     0033-Prepare-and-free-fdlist-in-functions.patch
>     0034-Compute-backup-blocks-in-function.patch

I would really rather take as much as is ready.  The fewer times I have to
review a patch, the better.
So if a patch looks close enough that I can apply it as-is, or with just a
few fixes, then I will. That way you only need to resent the patches that
need serious work.


NeilBrown
