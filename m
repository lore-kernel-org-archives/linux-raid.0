From: Neil Brown <neilb@suse.de>
Subject: Re: linear raid : mddev not protected in linear_add
Date: Wed, 20 May 2009 08:58:58 +1000
Message-ID: <18963.14770.706341.139054@notabene.brown>
References: <37d33d830905190523l1ae7536al83ed1255cba3050d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday May 19, sandeepksinha@gmail.com wrote:
> Hi,
> 
> In linear_add( ), the mddev is gets changed.
> Don't we require to lock/unlock around mddev inorder to avoid races?
> 

A good question.

To be able to answer it, we must also ask "what races do we need to
avoid".  Did you have some possible races in mind?

In linear add there are 3 lines which are in an important order:

	mddev->private = newconf;
	mddev->raid_disks++;
	....
	set_capacity(mddev->gendisk, mddev->array_sectors);

Until raid_disks in incremented, there will be no attempt to access
the extra information in ->private.
Until the set_capacity, there will be no attempt to send IO beyond the
reach of raid_disks.
So except that it might be wise to insert some barrier()s, it looks
OK....  or it did.

I just noticed that the new 'which_dev' checks mddev->raid_disks,
where as the old which_dev did not.

So if:
  which_dev takes a copy of mddev->private,
                               linear_add changes mddev->private
                               linear_add changes raid_disks
  which_dev takes a copy of mddev->raid_disks

then which_dev will have a raid_disks which points beyond the end of
conf->disks.  If the target sector were beyond the end of the original
array, we could fall off the end of that array which would be bad.
However as the sector number will have been tested again the size of
the array (in bio_check_eod from generic_make_request), that cannot
happen.  Unless which_dev was called from linear_mergeable_bvec...

I suspect in light of this it would be best to:
  1/ insert a barrier() between setting ->private and setting
      ->raid_disks
  2/ in which_dev, read ->raid_disks before ->private, and put a
      barrier in between.

We could possibly use rcu_dereference and rcu_assign_pointer, and
maybe even make use of rcu to free the old conf structure promptly
rather than keeping it around until the array is stopped.
That would require careful placement of rcu_read_{,un}lock around
access to ->private.

Probably best to just put barriers in for now, and leave the rcu
stuff.

NeilBrown


