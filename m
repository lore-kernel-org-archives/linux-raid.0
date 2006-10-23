From: Neil Brown <neilb@suse.de>
Subject: Re: Restoring a RAID 5
Date: Mon, 23 Oct 2006 14:40:33 +1000
Message-ID: <17724.18369.353769.772975@cse.unsw.edu.au>
References: <200610171908.27505.hal@thresholddigital.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hal Vaughan on Tuesday October 17
Sender: linux-raid-owner@vger.kernel.org
To: hal@thresholddigital.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 17, hal@thresholddigital.com wrote:
> I have a system with 5 drives: a system/boot drive and a RAID5  composed 
> of 3 active drives and a spare (formated in ext3).  The boot/system 
> drive died on me the other day and I've restored it, re-installing 
> Debian Sarge.  The RAID drives were not effected by the failure.
> 
> Now that the system is up and running, I want to restore the RAID.   
> I've been searching and tried:
> 
> mdadm --examine --scan /dev/hde /dev/hdf /dev/hdg /dev/hdh
> 
> and got:
> 
> ARRAY /dev/md0 level=raid5 num-devices=3 
> UUID=d6fd4af2:5e5d0da2:9dec7c5f:ad60c25d
>    devices=/dev/hdf
> 
> I'm a little puzzled by this, since I created the drive specifying hde 
> first, and would expect mdadm to find that drive and not hdf.  It also 
> finds only that one drive and does not seem to see hde or hdg as part 
> of the RAID.

The implication of this is that hde, hdg, hdh no longer have valid
raid superblocks.  That is a bit of a worry.

> 
> When I type the same for any other drive, I get (depending on the drive 
> letter):
> 
> mdadm: No super block found on /dev/hdg (Expected magic a92b4efc, got 
> 00000000)
> 
> Is this correct?  Is there only one superblock and not one per drive?  
> (I may have misunderstood that.)

There should be one per drive.  Something has happened to those
drives.

Is there any chance they are on a different controller which maybe
sees them as a different size, or something weird like that?

Maybe trying re-arranging where the drives are plugged in and see what
"mdadm --examine /dev/xxx" says in each configuration.  Somehow you
need to find those other superblocks before you can assemble your
array.

NeilBrown
