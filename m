From: Neil Brown <neilb@suse.de>
Subject: Re: [patch 1/1] [mdadm] Add partition checks when creating a new array
Date: Fri, 13 Nov 2009 13:49:24 +1100
Message-ID: <19196.51508.947560.851117@notabene.brown>
References: <EB332302649177439359CE520D92A0AF9F559760@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Trela, Maciej on Thursday November 12
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Thursday November 12, Maciej.Trela@intel.com wrote:
> Hello Neil,
> I'm sending the patch that is connected with intel metadata compatibility.
> 
> The new code checks for existing partitions when creating an array.
> If the metadata overwrites the last partition, the warning is shown to the user. The patch supports only MBR and GPT partition table types.
> Despite the patch was implemented as IMSM compatibility issue I've decided to include the partition check for all metadata types as a generic code.
> I would appreciate any feedback.

Sorry for not responding the first time you posted this.

I agree with the principle.  However I would rather not add code for
reading different partition types to mdadm.  It would be much nicer if
that code came from a library.
Is there a good library that we could use?
libparted might be a possibility, but it seems rather over-weight.
/lib/libparted-1.9.so.12.0.0 is larger than /sbin/mdadm !!!

Are there any other libraries for reading different partition tables?
I guess we can open-code it if we have to but I'd be happy if another
solution could be found.

I should probably change to using libblkid to check for the various
filesystem types...

Is this check really relevant for anything other RAID1 array.  For any
other level, the fact that the metadata lies inside or outside the
current partitions is quite irrelevant as the old data will not be
useful anyway.

And I don't think it is sensible to report "unknown partition table".
If there is no partition table, there is nothing to check.

NeilBrown

