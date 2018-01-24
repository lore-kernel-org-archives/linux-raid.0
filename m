From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recovering Partial Data From Re-Added Drive
Date: Wed, 24 Jan 2018 11:00:31 +0100
Message-ID: <20180124100031.GA4073@metamorpher.de>
References: <CAPE0SYx2Pf=hVe46NVLqTC3g9WQd1MckceS818bWzeNYdOVkNQ@mail.gmail.com>
 <20180123224610.GA8114@metamorpher.de>
 <CAPE0SYy8VWazr9SDVqr7tpV7oRxG23Dgpkmp-96wOa2=E0EoNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPE0SYy8VWazr9SDVqr7tpV7oRxG23Dgpkmp-96wOa2=E0EoNQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liwei <xieliwei@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 24, 2018 at 03:34:31PM +0800, Liwei wrote:
> However, how do I get mdadm to accept the re-added drive without
> trying to sync?

There is --freeze-reshape as well as --action=frozen or you could 
also go to /sys/block/mdX/md/ and set sync speeds to near zero, 
but with overlay, sync won't cause damage other than filling up 
your overlay backing device. If something goes wrong on top of 
the overlays, you just stop everything, reset the overlays and 
start over with a new experiment.

On overlays, you can also play with mdadm --create --assume-clean 
(which you should never do on bare drives, as it's easy to get 
the RAID settings and drive order wrong) so you can re-create 
using only the drives you want (use 'missing' otherwise).

Recreating with mdadm usually looks something like:

    mdadm --create /dev/md42 --assume-clean \
    --level=5 --chunk=512 --metadata=1.2 --data-offset=2048 \
    --raid-devices=3 missing /dev/mapper/overlay-sd{y,z}1

i.e. you have to specify everything, in particular level, 
chunksize, offsets, metadata version, layout, drive order, ... 
according to your existing RAID. Compare mdadm --examine 
before / after the re-create to see if properties match 
(creation time, uuid etc. change, chunksize/layout/offset 
/ device role etc. has to stay the same).

One thing of note is that a sync action doesn't just affect the 
current progress of the sync, but the entire drive - the sync 
progress can only be at one place at a time, but the RAID has to 
stay in sync as a whole as well, so - if there are any writes 
during a sync, they also immediately go to the resyncing drive.

It's different during a grow reshape - new drive only used in 
the region that has already been reshaped onto it, everything 
else still mapped to the old drives - but a resync affects 
the whole drive immediately, if there are any writes.

Regards
Andreas Klauer
