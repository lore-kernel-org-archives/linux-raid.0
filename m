From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] UT FIX: Pass all UT in suit 13
Date: Wed, 9 Feb 2011 20:52:03 +1100
Message-ID: <20110209205203.344b6a9e@notabene.brown>
References: <20110209083129.27876.82194.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209083129.27876.82194.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Feb 2011 09:31:29 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Parameters in UT suit 13 were wrongly chosen. This causes that
> computed number of backup blocks was too big comparing to loop devices
> size used in test. Changes in test parameters (chunk, array size)
> causes that backup blocks passes mdadm condition for very small
> loop devices.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

applied,

Thanks,
NeilBrown


> ---
> 
>  tests/13imsm-r0_r0_2d-grow-r0_r0_5d |    4 ++--
>  tests/13imsm-r0_r0_3d-grow-r0_r0_4d |    2 +-
>  tests/13imsm-r0_r5_3d-grow-r0_r5_5d |    4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tests/13imsm-r0_r0_2d-grow-r0_r0_5d b/tests/13imsm-r0_r0_2d-grow-r0_r0_5d
> index 80e0cf0..1b851a9 100644
> --- a/tests/13imsm-r0_r0_2d-grow-r0_r0_5d
> +++ b/tests/13imsm-r0_r0_2d-grow-r0_r0_5d
> @@ -10,13 +10,13 @@ spare_list="$dev2 $dev3 $dev4"
>  # Before: RAID 0 volume in slot #0, 2 disks, 64k chunk size
>  #         RAID 0 volume in slot #1, 2 disks, 256k chunk size
>  vol0_level=0
> -vol0_comp_size=$((5 * 1024))
> +vol0_comp_size=$((4 * 1024))
>  vol0_chunk=64
>  vol0_num_comps=$num_disks
>  vol0_offset=0
>  
>  vol1_level=0
> -vol1_comp_size=$((5 * 1024))
> +vol1_comp_size=$((6 * 1024))
>  vol1_chunk=256
>  vol1_num_comps=$num_disks
>  vol1_offset=$((vol0_comp_size + 2048))
> diff --git a/tests/13imsm-r0_r0_3d-grow-r0_r0_4d b/tests/13imsm-r0_r0_3d-grow-r0_r0_4d
> index 17f24d7..27ba83b 100644
> --- a/tests/13imsm-r0_r0_3d-grow-r0_r0_4d
> +++ b/tests/13imsm-r0_r0_3d-grow-r0_r0_4d
> @@ -17,7 +17,7 @@ vol0_offset=0
>  
>  vol1_level=0
>  vol1_comp_size=$((5 * 1024))
> -vol1_chunk=512
> +vol1_chunk=128
>  vol1_num_comps=$num_disks
>  vol1_offset=$((vol0_comp_size + 2048))
>  
> diff --git a/tests/13imsm-r0_r5_3d-grow-r0_r5_5d b/tests/13imsm-r0_r5_3d-grow-r0_r5_5d
> index 6462d6b..d0db9ae 100644
> --- a/tests/13imsm-r0_r5_3d-grow-r0_r5_5d
> +++ b/tests/13imsm-r0_r5_3d-grow-r0_r5_5d
> @@ -11,13 +11,13 @@ spare_list="$dev3 $dev4"
>  #         RAID 5 volume in slot #1, 3 disks, 512k chunk size
>  vol0_level=0
>  vol0_comp_size=$((5 * 1024))
> -vol0_chunk=256
> +vol0_chunk=128
>  vol0_num_comps=$num_disks
>  vol0_offset=0
>  
>  vol1_level=5
>  vol1_comp_size=$((5 * 1024))
> -vol1_chunk=512
> +vol1_chunk=128
>  vol1_num_comps=$((num_disks - 1))
>  vol1_offset=$((vol0_comp_size + 2048))
>  

