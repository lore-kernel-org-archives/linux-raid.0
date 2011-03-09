From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] Make OLCE workeable
Date: Wed, 9 Mar 2011 11:53:12 +1100
Message-ID: <20110309115312.37a04ad7@notabene.brown>
References: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, 08 Mar 2011 14:24:29 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> This is first part of my comments for your latest changes on devel3-2 regarding reshape and reshape restart.
> Unfortunately those changes breaks OLCE functionality. This patch series makes OLCE workable (mdadm UT suits 12 and 13 succeed).

That's really strange as the patches all look wrong.  I'll do some testing
my self and see what I can come up with.

> 
> Problems:
> 1. In passing in mdinfo (array.level) raid4 for transition raid0->raid0.
>    This causes problems in takeover
>    a.Raid0 takeover doesn't occur. array.level == reshape.level == 4
>      Resolution: Decision about takeover has to be made based on real md level not info->array.level

But takeover doesn't *need* to occur.
When we have a RAID0 array and we want to make it grow, we have to 'takeover'
to RAID4 first.
But when assembling an array that is in the middle of a growth we assemble
it as a RAID4 array - so it never was a RAID0 array.  It starts out as
RAID4.

>    b.Decision about backward takeover cannot be always taken by mdadm. mdadm can think that original level is raid4
>      Resolution: use level read from md as orig_level (not from metadata)

I see that is a problem.   We should record '0' as the 'new_level' and
get mdadm to make use of that information.

> 
> 2.On the begin of reshape_array() array structure is read from md (via ioctrl). Md knows nothing about raid4 working level, so spares_needed is wrongly computed
>   Resolution: use info->array.raid_disks instead array.raid_disks to compute  spares_needed.

md certainly should know about RAID4 working level because it is assembled
as RAID4.... hopefully some testing will show me what you really mean.

> 3.Analyse_changes() delta_parity concept doesn't match information currently metadata reports. Result of this is wrongly computed reshape.after.data_disks field.
>   Resolution: do not use delta_parity, base on information from metadata handle

You cannot just remove delta_parity like that.  It is needed when we start
a growth.  Maybe it is confusing when we restart a growth - I will look
in to in.

> 4.Defects/potential defects
>  a.delta_disks should be checked in sysfs_set_array()

No it shouldn't.  If delta_disks is UnSet, then the metadata handler has
done the wrong thing.

>  b.array assembly problem
> reshape_active flag has to be evaluated. Existing second map doesn't means reshape always (rebuild, initialization)

There is no problem here.  I agree with your second sentence, but that 
code already does this.
That first patch in your series makes *no* change to the meaning
of the code.
Before the patch it is 

  if (condition) {
     variable = 1;
     stuff;
     ...

After the patch it is

  variable = condition;
  if (variable) {
     stuff;
     ...


which has exactly the same effect.

So I haven't applied any of these matches as none of them make any sense to
me - sorry.

NeilBrown



> 
> I've tried to follow your idea in this series. Generally it seems ok (proved by UT). I like putting more array configuration in sysfs_set_array().
> 
> Now I'm going to look at patches at the reshape restart point of view.
> I'll let you know results soon.
> 
> BR
> Adam
> 
> 
> ---
> 
> Adam Kwolek (5):
>       FIX: Compute spares_needed basing on metadata info
>       FIX: Remove delta_parity concept
>       FIX: Allow for takeover
>       FIX: Set new raid disks when delta_disks is valid
>       fix: array is reassembled inactive if stopped during resync
> 
> 
>  Grow.c        |   22 +++++-----------------
>  super-intel.c |    5 +++--
>  sysfs.c       |    4 +++-
>  3 files changed, 11 insertions(+), 20 deletions(-)
> 

