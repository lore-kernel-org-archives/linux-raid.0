From: Neil Brown <neilb@suse.de>
Subject: Re: Using LVM for RAID 1+0
Date: Wed, 19 Apr 2006 10:55:20 +1000
Message-ID: <17477.35448.136382.373967@cse.unsw.edu.au>
References: <6d5bedd80604181720s4a481844s22e107089c790e80@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ewan Grantham on Tuesday April 18
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday April 18, ewan.grantham@gmail.com wrote:
> Had though of setting up several disks as a RAID-5 array, but for some
> reason one of the disks would keep failing when I tried to build the
> array. The same disk, however, would format just fine with EXT3, and
> is quite happy about being put in a RAID-1 array with another disk.
> Given that strangeness, I'm thinking a better way to go is to pair off
> my disks into several RAID-1 arrays, and then use LVM to setup
> striping across all of them to effectively give me a RAID 1+0 setup.
> Since one pair of disks is a different size than the other pairs, I
> presumed this would be better than actually creating a RAID-0 across
> all the RAID-1 arrays. Is that correct?


No, this is not correct.
md/raid0 has no problem with devices being of different sizes.  It
will make use of all the space doing as much striping as possible.


However it sounds like your drive or your controller is not to be
trusted.  There is a reason that it is failing.  Maybe raid5 triggers
that reason more often, but that doesn't mean that raid1 won't
trigger it at all.  I suggest you be very wary of your hardware!

NeilBrown
