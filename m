From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/21] Series short description
Date: Wed, 24 Nov 2010 16:04:48 +1100
Message-ID: <20101124160448.78d53972@notabene.brown>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Tue, 23 Nov 2010 13:39:38 +0100
Adam Kwolek <adam.kwolek@intel.com> wrote:

> This patch series bases on previously sent patch series: array/container freezing by Dan Williams, and my and Maciej Trela's patches for OLCE and check pointing for external metadata.
> This patch series implements:
> 1. Patches 0001 to 0018 : fixes for freezing, OLCE and check pointing
> 2. Patches 0018 to 0021 : implements new migration features for external metadata:
>     - Migration raid0 to raid5
>     - Migration raid5 to raid0
>     - Chunk size migration

I'm afraid this series isn't much use to me.

It appears to be intended to apply after the previous set of 31 patches you
posted.  However I haven't applied any of those.  I responded to the first 6
explaining why each was either wrong, unacceptable, or not explained well
enough for me to review it properly, and I just stopped at 6.

So for example,
   [PATCH 04/21] FIX: Use MDADM_EXPERIMENTAL environment variable
is of no use to me as I never applied the patch that it tried to fix.
I could probably pick out the  patches that can still apply, but I'd rather
not have to.

Please send a set of patches against my devel-3.6 branch with any 'fixes' to
your own patches already merged back into those patches.
Then I will apply as much as I can, and explain was is need to make any other
acceptable.

Thanks,

NeilBrown


> 
> We are planning in the few days add fixes for raid10 <-> raid0 takeover also.
> 
> Migration feature reuses code flow introduced for OLCE (Online Capacity Expansion) and uses the same grow/reshape flow in mdadm/mdmon.
> Migration is executed in the following way:
> 1. mdadm: reshape_super() prepares metadata update and sends it to mdmon
> 2. mdadm: waits for reshape array state
> 3. monitor: receives metadata update and applies it.
> 4. monitor: metadata update triggers managemon.
> 5. managemon: updates array (md) configuration and starts reshape
> 6. mdadm: finds that reshape is started and continues it using check pointing
> 7. mdadm: reshape is finished and manage_reshape() finalizes array:
>     - Sets array size as is given in metadata
>     - Performs takeover to raid0 if necessary
> 
> In current patches placement of manage_reshape() function call was changed.
> It is moved to end of array processing to use common code form Grow.c for external metadata reshape case
> (we do not need to duplicate existing code) as it would do the same things as code for native metadata.
> New manage_reshape() placement causes a few things to do in implementation only and simplifees code.
> 
> Migrations command line:
> 1. Execute migration raid0->raid5:
>     mdadm  - -grow /dev/md/array_name -level 5 -layout=left-asymmetric
> 
>     This converts n-disks raid0 array to (n+1)-disks raid5 array. Additional raid5 array disk is user from spares pool
> 
> 2. Execute migration raid5->raid0:
>     mdadm  - -grow /dev/md/array_name -level 0
> 
>     This converts n-disks raid5 array to n-disks raid0 array.
> 3. Execute chunk size migration
>     mdadm  - -grow /dev/md/array_name -chunk N
> 
>     where N is ne chunk size value
> 
> In current patch series testing of 'experimental' flag was changes according to Neil's suggestion, as I've found it useable for my testing purposes.
> The rest of comments to already reviewed patches (OLCE/check pointing) will be implemented in next step.
> 
> 
> ---
> 
> Adam Kwolek (21):
>       Migration: Chunk size migration
>       Migration raid0->raid5
>       Migration: raid5->raid0
>       imsm: Use geo structure
>       Change manage_reshape() placement
>       FIX: Start mdmon after changing level
>       FIX: Checkpointing: Enable checkpointing for non-growing migrations
>       FIX: Level field can be NULL
>       imsm Fix: Core during rebuild on array details read
>       WORKAROUND: md reports idle state during reshape start
>       FIX: Honor !reshape state on wait_reshape() entry
>       FIX: Unfreeze not only container for external metadata
>       FIX: Cannot exit monitor after takeover
>       imsm: FIX: Continue expansion after -As command
>       imsm: FIX: Reshape Cancel message on 2nd array doesn't work correctly
>       imsm: FIX: Guard size setting
>       FIX: Allow for reshape without backup file
>       FIX: Use MDADM_EXPERIMENTAL environment variable
>       imsm: FIX: imsm_check_reshape_conditions change ret_val
>       imsm: Change some debug output information
>       imsm: Remove unnecessary code
> 
> 
>  mdadm/mdadm/Detail.c      |    1 
>  mdadm/mdadm/Grow.c        |  178 ++++++++----
>  mdadm/mdadm/Makefile      |    6 
>  mdadm/mdadm/managemon.c   |  113 ++++++-
>  mdadm/mdadm/mdadm.h       |    7 
>  mdadm/mdadm/mdmon.h       |    4 
>  mdadm/mdadm/mdstat.c      |    2 
>  mdadm/mdadm/monitor.c     |   11 +
>  mdadm/mdadm/msg.c         |    5 
>  mdadm/mdadm/restripe.c    |    1 
>  mdadm/mdadm/super-intel.c |  693 +++++++++++++++++++++++++++++++++------------
>  mdadm/mdadm/util.c        |   88 +++++-
>  12 files changed, 830 insertions(+), 279 deletions(-)
> 

