From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 29/53] Add spares to raid0 array using takeover
Date: Tue, 30 Nov 2010 13:00:19 +1100
Message-ID: <20101130130019.3bbfd525@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080738.5221.94947.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080738.5221.94947.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:07:38 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Spares are used by Online Capacity Expansion to expand array.
> To run expansion on raid0, spares have to be added to raid0 volume also.
> Raid0 cannot have spares (no mdmon runs for raid0 array).
> To do this, takeover to raid5 (and back) is used. mdmon runs temporary for raid5 and spare drives can be added to container.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

I don't like this patch at all.

There is a lot of code in here that is very specific to IMSM, that has been
placed directly in Manage.c.  That is bad.

I gather you want to support

  mdadm /dev/md/imsm  --add /dev/newdisk

on a RAID0 and have it convert to RAID5, do the restripe, and convert back.

The IMSM specific code goes through a container and converts every member
array to raid5.

The 
  mdadm /dev/md/imsm --add /dev/newdisk

should just add the device to the container as a spare.  This might require
updating the IMSM metadata in some way, but doesn't require changing anything
to RAID5 and back.

Then when you do

  mdadm -G /dev/imsm --raid-disks=4

it will work with the imsm code to update every member array and add parts of
the newdisk to each array.

The conversion to RAID5 needs to happen in Grow_reshape when raid-disks is
changed on a RAID0.  It needs to happen while the array is frozen.

Not in Manage.c

NeilBrown



> ---
> 
>  Manage.c |  154 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 153 insertions(+), 1 deletions(-)
> 
