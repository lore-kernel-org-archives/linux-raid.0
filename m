From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] OLCE raid5/0 (all arrays in container)
Date: Mon, 17 Jan 2011 12:31:07 +1100
Message-ID: <20110117123107.58d1024e@notabene.brown>
References: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Thu, 13 Jan 2011 15:50:02 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> The following series adds possibility to reshape all (raid0/5) arrays in container for expansion feature.
> The main problem resolved in this series is how initialize second (and next) raid0 reshapes for container reshape
> executed as set of array reshapes.
> 
> For i.e. second raid0 array mdmon should initialize metadata to let know to mdadm that there is something more to reshape.
> But problem is what to do when mdmon is not loaded? (for first raid0 array this is not a problem, reshape_super() in mdadm updates metadata).
> 
> this is resolved by allowing mdadm to know what was reshaped so far. This allows to reshape arrays that are not reshaped yet,
> without update from mdmon.

There certainly are some complexities with reshaping a container with 2 RAID0
arrays in it.  However the approach you are taking seems too complicated.

This is how I think the particular case of 2 RAID0 array would work.  It
should generalise neatly to all other combinations.

1/ mdadm decides to proceeds with the reshape, updates the metadata (because
   mdmon isn't running), converts the array to RAID4, starts mdmon and then
   lets the reshape for the first array proceed.

2/ when the reshape completes, mdmon will notice and will call
   imsm_progress_container_reshape which will update the metadata
   for the second array so that reshape appears to be active.

3/ mdadm will convert the raid4 back to raid0 and so mdmon will exit.

4/ mdadm calls container_content and finds that the second array needs to
   be reshaped.  It converts the array to raid4 and starts mdmon.
   Then they oversee the reshape of the second array

5/ when the reshape completes, mdadm converts the array back to RAID0 and
   mdmon exits.

All done.


This should avoid almost all special-casing.

NeilBrown


> 
> BR
> Adam 
> 
> ---
> 
> Adam Kwolek (6):
>       FIX: sync_completed == 0 causes reshape cancellation in metadata
>       FIX: mdadm hangs during reshape
>       FIX: mdadm throws coredump on exit in error case
>       FIX: reshape raid0 on second array
>       FIX: continue raid0 reshape
>       imsm: Update metadata for second array
> 
> 
>  Grow.c        |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++------
>  monitor.c     |    4 ++
>  super-intel.c |   35 +++++++++++++++++++--
>  3 files changed, 120 insertions(+), 14 deletions(-)
> 

