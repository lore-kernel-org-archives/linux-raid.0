From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 with rotating offsite disks for backup
Date: Tue, 8 Feb 2011 13:02:12 +1100
Message-ID: <20110208130212.71a7064d@notabene.brown>
References: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
	<20110208111743.1479308d@notabene.brown>
	<CD05E25F-0580-4BDE-B4C7-041D15B9C73F@stanford.edu>
	<20110208121923.5908630d@notabene.brown>
	<47409A64-9CF1-4E12-9DAD-F7079298B1FE@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47409A64-9CF1-4E12-9DAD-F7079298B1FE@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Klingner <klingner@stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Feb 2011 17:32:48 -0800 Jeff Klingner <klingner@stanford.edu> wrote:

> >>>> Also, if you want two rotating backups I would create two stacked raid1s.
> >>>> 
> >>>> mdadm -C /dev/md0 -l1 -n2 -b internal  /dev/main-device /dev/first-backup
> >>>> mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 /dev/second-backup
> >>>> mkfs -j /dev/md1
> 
> 
> 
> On Feb 7, 2011, at 5:19 PM, NeilBrown wrote:
> > I'm surprised that you found the correct advise, and chose not to follow
> > it .....
> 
> Thanks again for your advice.  I didn't search the list until after completing my initial setup; my mistake and my lesson learned: research first.
> 
> > The array you will end up installing on is (slightly) smaller than than the
> > array you have created.  So no: you cannot re-arrange things - you have to
> > start again.
> > 
> > 
> > (well, to be honest, it is possible that you could resize whatever is on the
> > array and then build the secondary array and make it work.  But that path is
> > error-prone and this margin is not large enough to properly describe the
> > process).
> 
> Reckless fool that I am, I'm going to try it anyway.  Here's my rough plan:
> 
> 1. Degrade the 3-disk raid1 array by removing two disks, leaving only one, and leaving the array running.
> 2. Set up the first 2-disk array (md0 in your description) de novo on the two freed disks
> 3. Move my data from the original raid1 array (with only 1 of three disks present) to the new 2-disk md0 via lvm mirroring

Nope.  That would be wrong.  You need to create both mirrors before moving
any data.
So:

  3.  Set up the second 2-disk array (md1) as a degraded array containing
  only md0 as a member:

     mdadm --create /dev/md1 -l1 -n2 -b internal /dev/md0 missing

  3a. move my data from the original raid1 to the new md1 using pvmove

> 4. Free the third disk by finally taking down the original raid1 array
> 5. create the second 2-device array (md1) using md0 and the freed third disk.  Somehow ensure that the md0 component has primacy for syncing.

Then step 5 becomes:
  5.  Add this newly freed disk to the degraded md1:
    mdadm /dev/md1 --add /dev/whatever

NeilBrown



> 
> Jeff

