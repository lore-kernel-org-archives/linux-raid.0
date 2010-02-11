From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [PATCH 4/4] md: Enable takeover for external metadata
Date: Thu, 11 Feb 2010 12:34:53 +0000
Message-ID: <BE2BFE91933D1B4089447C64486040800156ECDB@irsmsx503.ger.corp.intel.com>
References: <F2A46F4A087B8547923AD59C289DC90E01D16228@irsmsx002.ger.corp.intel.com>
	 <20100201110829.5516c80e@notabene.brown>
	 <F2A46F4A087B8547923AD59C289DC90E01DCD389@irsmsx002.ger.corp.intel.com>
	 <20100210165710.11493bc5@notabene.brown>
 <e9c3a7c21002100936p279cddbr1a3d478267e5589b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21002100936p279cddbr1a3d478267e5589b@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

> I believe one thing that still needs investigation, before turning on
> the mdadm imsm support, is to see if we need superblock specific
> migration strategies in the kernel.  Unless we are incredibly lucky I
> do not think the native migration strategy will line up with what the
> option-rom expects from a checkpoint interpretation standpoint.
> Maciej, any comments on this aspect of the compatibility?
> 

Yes, you are right, the compatibility is a big issue here.
For now I can see three main aspects of the IMSM compatibility:
1. Checkpointing with IMSM Migration Record together with General Migration Copy Area
2. Migration optimization space
3. Checkpointing optimization algorithm

Ad.1.
This is a crucial issue for the compatibility and I'm working on it currently.

The Migration Record is used during a general migration process (reshape).
It is stored on the very last block of the raid device after the IMSM superblock.
If the OROM detects a migration in progress it examines the Migration Record
to get the current migration unit. 
In case when current unit is in the Migration Copy Area the OROM will
copy it to the destination array and update the Migration Record.

For now I have the preliminary version of checkpointing code (based on Adam's IMSM reshape patch)
that stores curr_migr_unit in IMSM Migration Record during the reshape and restarts the reshape using the Migration Record. 

My idea was that Migration Record should be updated directly from the kernel (in reshape_request()) during the reshape. 
However, since Migration Record contains some IMSM specific Fields like FamilyID, 
the mdmon, when starting the reshape, initiates the Migration Record on the disks.

Still I'll have to implement copying data with Migration Copy Area instead of using backup-file for IMSM...


Ad.2.
If source and destination arrays have the same number of data disks, IMSM in order to avoid overwriting source
stripes while copying (additional copy from src to Copying Area would be involved) uses Migration Optimization Space.
This is a 4MB of space, added at the beginning or at the end of destination array depending on free space availability.

Summarizing, the main idea is that src and dst arrays should start at different physical blocks.
The first block of the source array is store in the IMSM superblock and the first block of the dest array is 
both in the superblock and in the Migration Record.


Ad.3.
This is an algorithm optimizing the number of checkpoint writes during the reshape. 
My first impression is that it could be similar to the algorithm in reshape_request() but I'll need to investigate it more...


I would appreciate any feedback on these...
Thanks,
Maciek.

