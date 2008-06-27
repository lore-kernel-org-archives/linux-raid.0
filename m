From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running arrays.
Date: Sat, 28 Jun 2008 09:41:03 +1000
Message-ID: <18533.31375.280387.666514@notabene.brown>
References: <20080627164503.9671.patches@notabene>
	<1080627065116.10596@suse.de>
	<200806271809.29768.Markus@hochholdinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Markus Hochholdinger on Friday June 27
Sender: linux-raid-owner@vger.kernel.org
To: Markus Hochholdinger <Markus@hochholdinger.net>
Cc: linux-raid@vger.kernel.org, Chris Webb <chris@arachsys.com>
List-Id: linux-raid.ids

On Friday June 27, Markus@hochholdinger.net wrote:
> Hi,
> 
> Am Freitag, 27. Juni 2008 08:51 schrieb NeilBrown:
> > From: Chris Webb <chris@arachsys.com>
> > Allow /sys/block/mdX/md/rdY/size to change on running arrays, moving the
> > superblock if necessary for this metadata version. We prevent the available
> > space from shrinking to less than the used size, and allow it to be set to
> > zero to fill all the available space on the underlying device.
> 
> I'm very happy of this new feature. But I'm a little confused how to use it 
> correctly.
> Can md now recognize the change by itself and I only have to run mdadm --grow? 
> Or have I manually update /sys/block/mdX/md/rdY/size and afterwards run 
> mdadm --grow?

No, md does not recognise the change by itself.
Currently you need to update ..../size yourself before using 
   "mdadm --grow"
This should probably be incorporated into mdadm at some stage, but it
hasn't yet.

> 
> To be on the safe side I'd first lvresize one disk of the raid1, then do 
> mdadm --grow to let md update/move the superblock of this disk. And after 
> this is successful, lvresize the other disk and do mdadm --grow. So in case 
> of a failure i wouldn't loose the whole raid1!?
> Am I correct or am I missing something?

You don't want to "mdadm --grow" until everything has been resized.
First lvresize one disk, then write '0' to the .../size file.
Then do the same for the other disk.
Then "mdadm --grow /dev/mdX --size max".

NeilBrown
