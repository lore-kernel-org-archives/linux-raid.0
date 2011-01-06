From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/34] OLCE for external metadata (devel3.2)
Date: Thu, 6 Jan 2011 19:34:14 +1100
Message-ID: <20110106193414.38e55f03@notabene.brown>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 04 Jan 2011 15:34:38 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> This patch series implements Online Capacity Expansion (OLCE) feature in mdadm devel3.2. for Raid5 and Raid0.
> This is implemented as reshape of whole container (all arrays that belongs to container are reshaped).
> Raid0 reshape is implemented using takeover to raid4 transition.
>
> ---

Thanks.
I have reviewed all of these and applied several, changed other, rejected the
rest as detailed below.

Before doing that I finished the refactoring that I was doing so devel-3.2
compiles again.

My next step with this is to do some testing.

As I say below, feel free to resend anything that you find that you still
need.  Maybe I'll understand it better the second time around, or will be
able to suggest a better way of doing it.

In particular, there is no ->manage_reshape method (I didn't take that patch)
so any attempt to reshape an imsm array will crash.  We need to write a
manage_reshape based on the new child_monitor and using the new
progress_reshape.

BTW, when you split a string e.g.
   "this is a long string"
to
   "this is a"
   " long string"

you do *not* need a '\' at the end of the first line.


Thanks,
NeilBrown


> 
> Adam Kwolek (31):
>       Raid0: detect reshape on array start
Applied, but I'm not sure that it is needed or that set_array_state
does what is expected any more...
>       Raid0: Reload disk list on 'next' raid0 array
Not applied - probably because I am too tired to think clearly
about it.  If you still need this, feel free to resubmit it
and I'll think about it then.
>       Raid0: Run 'next' reshapes without meta update
Not applied.  I don't think the fix is right, but I'm not
100% sure, and it might be fixed by other changes that I have
made.  So feel free to resubmit something like this if it is
still a problem.
>       imsm: FIX: do not repair raid4 arrays
Applied
>       Raid0: execute backward takeover
Applied, but I used a different test which is more generic.
>       Detect level change
Applied
>       Take in mind takeover during disk add
Not applied.  This patch is irrelevant because of an earlier patch
which I didn't apply.
>       imsm: Update raid0 metadata for reshape
Applied, though reshape_super should *both* queue and update and
change the metadata in-place, so I changed it to do that.
>       imsm: Move reshape update processing to function
Applied, though I had to do it by hand - hope I didn't break anything.
However the little extra bit in imsm_reshape_super didn't make sense,
and wasn't documented, so I left it out.
>       Add spares to raid0 in mdadm
Applied with changes.  The Assemble.c part of this was OK.
The super-intel.c was not.  That logic needed to be in Assemble.c
I have put it there (untested).
>       imsm: Update metadata for second array
Applied with a few changes.  I broke the new code out into
a separate function, and then called that function from a
different place - I think a more correct place but you might
like to check.
>       Set array size after adding new disks
Applied, with a few changes.  e.g. 'array_size' can read as 'default'.
And we might want to change array_size when raid_disks decreases as well.
>       imsm: update array size information in metadata
Applied.
>       FIX: Initialize subarray variable in reshape_array
No applied - I fixed this a different way already.
>       imsm: FIX: Division by 0
Applied
>       imsm: Finalize reshape in metadata
Applied
>       Finalize reshape after adding disks to array
Not applied.  This should not be needed as the code near the comment:
		/* Reshape has progressed or completed so we need to
		 * update the array state - and possibly the array size
		 */
should handle this case.  If it doesn't it should be fixed.
>       imsm: FIX: Fill sys_name in container_content()
Not applied.  container_content should not set sys_name as the volume could
easily not have a sys_name yet.  Rather some other code should call
sysfs_init() at an appropriate time.  I have done that.
>       FIX: Use sysfs to change array parameters
Applied
>       FIX: added disks are not used by reshape process /md/
Not applied.  Definitely the wrong fix.  Need more details of the
problem.
>       FIX: change adding disks criteria
Not applied.  I'm not convinced this is the correct fix.
For devices already in the array, disk.state should not be zero.
So if it is, then something else is wrong.   I would need to know more
about that problem you are seeing.
>       FIX: Get array information in reshape_array()
Applied
>       imsm: FIX: support general migration by getinfo_super_imsm_volume
Applied.
>       FIX: Arrays cannot be opened exclusively
Why do you say that arrays cannot be opened exclusively?  You might be right,
but I need mor explanation before I can apply this patch - it "seems" wrong
to me.
Not applied.
>       imsm: FIX: update first array in container only
Applied.  Note that when starting array that is part-way through a reshape
of the first array we will need to alloc space just like we allocate
spare here.
>       FIX: get updated information from metadata
Applied, but with substantial changes.
reshape_super reloads the metadata, not reshape_container, so that
it can know if the array size needs to be changed.
>       imsm: FIX: Do not update anchor directly
Not applied.  I don't think this is correct.  The metadata *should* be
updated directly.
When converting a RAID0 to a RAID5 there is no mdadm running so we should:
  ->reshape_super
  ->sync_super
  start mdmon
  proceed with reshape.

>       imsm: FIX: Perform first metadata update for container operation
Applied.
>       imsm: FIX: display error message
Applied ... and I change the other dprintfs to fprintfs as I think
reshape_super should give an message any time it doesn't succeed.
>       imsm: FIX: display correct information for '-E' option
Applied
>       mdadm: second_map enhancement for imsm_get_map()
Applied.
> 
> Krzysztof Wojcik (3):
>       FIX: Position calculation in mdstat_by_subdev
Applied.
>       FIX: Change size condition in imsm_reshape_is_allowed_on_container
Not applied.  Size of '-1' means 'not change was requested'.  Size of '0'
means 'set to maximum size'.  So the test requiring '-1' seems correct.
>       Manage reshape process in manage_reshape vector.
Not applied.  Seems pointless, and ->manage_reshape is not allowed to say
  "management of process not supported".  If ->reshape_super allows the
  reshape, then ->manage_reshape *must* support it.

> 
> 
>  Grow.c        |  174 ++++++++++++------
>  Manage.c      |   13 -
>  managemon.c   |   12 +
>  mdstat.c      |    4 
>  monitor.c     |   20 ++
>  super-intel.c |  561 ++++++++++++++++++++++++++++++++++++++++++---------------
>  6 files changed, 576 insertions(+), 208 deletions(-)
> 

