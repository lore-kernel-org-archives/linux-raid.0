From: NeilBrown <neilb@suse.de>
Subject: Re: cannot examine IMSM metadata on a disk in non-IMSM compliant
 system
Date: Wed, 23 Mar 2011 12:15:37 +1100
Message-ID: <20110323121537.55cc741c@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D191E0AF4E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D191E0AF4E@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, 22 Mar 2011 16:50:10 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> >From 492192b1777936ccaf745aeb73f83f55c12a5a37 Mon Sep 17 00:00:00 2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Tue, 22 Mar 2011 17:39:57 +0100
> Subject: [PATCH 0/2] cannot examine IMSM metadata on a disk in non-IMSM compliant system
> 
> IMSM metadata handlers have following requirements:
> - disk is attached to Intel controller (ahci or SAS)
> - the whole disk set in one RAID volume belongs to the same controller
> - IMSM OROM/EFI properties available
> 
> In non-IMSM system a user can always set IMSM_NO_PLATFORM=1, so above requirements need not to be met.
> 
> This series allows a user can check if there is any IMSM metadata on the disk in non-IMSM compatible system without setting IMSM_NO_PLATFORM.
> Please take a look at my patches for this issue.
> The patches are still under testing, only basics has been checked.

I've applied these for now as it provide the basic functionality I wanted and
looks quite simple and so unlikely to break anything.
However I will almost certainly change it after 3.2.1 is out.

I would much rather that if the metadata handler sees metadata that is mostly
recognises but for some reason cannot handle perfectly, then it sets a flag
of some sort in mdinfo.
Then 'examine' can report that flag, and 'assemble' can refuse to assemble if
that flag is present.
But that can wait until later.

Thanks,
NeilBrown


> 
> Thanks,
> Marcin Labun
> 
> 
> Marcin Labun (2):
>   examine: allows to examine a disk metadata on non-metadata compliant
>     systems
>   super-intel: enable loading metadata from non-IMSM compliant disks
> 
>  Examine.c     |    2 ++
>  mdadm.h       |    6 +++++-
>  super-intel.c |   16 ++++++++++------
>  util.c        |    3 +++
>  4 files changed, 20 insertions(+), 7 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 

