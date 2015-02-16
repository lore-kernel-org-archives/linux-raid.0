From: Chris <email.bug@arcor.de>
Subject: Re: re-add POLICY
Date: Mon, 16 Feb 2015 12:23:46 +0000 (UTC)
Message-ID: <loom.20150216T124230-883@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb <at> suse.de> writes:
 
> Does your array have a write-intent bitmap configured?
> If it does, then "POLICY action=re-add" really should work.

Thank you for your insight. You are correct, the array has no write-intent
bitmap.

 
> If it doesn't, then maybe you need "POLICY action=spare".

OK, I will test this when the notebook is back in the house.



Actually, the man page had kind of kept me from trying this, because it
mentions the condition "if the device is bare", and I didn't want arbitrary
bare disk, partition, or free space to be automatically added, but just to
trigger an automatic try with raid members that got pulled and are save to
re-sync. (e.g. after the occasional bad block error that gets remapped by
the hardrives firmware)

[man page: spare works] "as  above  and  additionally:  if  the device is
bare it can become a spare if there is any array that it is a candidate for
based on domains and metadata."

Also, I wouldn't want a temporarily removed raid member to be added as spare
to some other array. Only have them added (re-synced even if no bitmap
re-add is possible) to the array they belong according to their superblock.

 
> This isn't the default, because depending on exactly how/why the device
> failed, it may not be safe to treat it as a spare.

OK, I can imagine detecting the corner cases may require some inteligent
error logging.

What I am looking for is a safe re-sync configuration option between
bitmap-based re-add, and treating a device as arbitrary spare drive.


Practically, this could be something like an additional action=re-sync
option in between re-add/spare, or having the "re-add" action also do
(non-bitmap) full re-syncs, if the device is in a clean state.


May recording the fail event count in the remaining superblocks help, as
described in
http://permalink.gmane.org/gmane.linux.raid/48077
help to detect the clean state?

Kind Regards,
Chris







