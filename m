From: Neil Brown <neilb@suse.de>
Subject: Re: Resize on dirty array?
Date: Tue, 8 Aug 2006 10:46:35 +1000
Message-ID: <17623.57067.835826.446152@cse.unsw.edu.au>
References: <44D7DC93.2070905@net1plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Peverill on Monday August 7
Sender: linux-raid-owner@vger.kernel.org
To: James Peverill <jamespev@net1plus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 7, jamespev@net1plus.com wrote:
> 
> I have a software raid 5 setup with four drives.  One drive failed.  I 
> got a replacement but unfortunately it turns out that my original disks 
> were just a few gigs over the replacement.  It seems that most 
> manufacturers don't actually advertise the REAL capacity of the disk, so 
> getting one that is the same size as the old ones could be tough.(and 
> they aren't available anymore of course...)
> 
> So my question... can I resize the array while it is missing a drive?  
> The raid is <50% full, and the few gigs is only a few percent.  In 
> retrospect I shouldn't have sized them right to the limit...

Yes, that should work.

First resize the filesystem to make it smaller.
Then resize the array
  mdadm --grow /dev/mdX --size=whatever

You have to calculate 'whatever' yourself.  It is in kibibytes and
must be 128K < size of new drive, and obviously must leave room for
the filesystem.

A good suggestion is:
  shrink the filesystem a lot.
  shrink the array an adequate amount
  add the new drive
  resize the array up to 'max'  (mdadm -G /dev/mdX --size=max)
  resize the filesystem up to max.

NeilBrown
