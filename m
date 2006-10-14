From: Neil Brown <neilb@suse.de>
Subject: Re: new features time-line
Date: Sat, 14 Oct 2006 10:03:30 +1000
Message-ID: <17712.10578.16619.929884@cse.unsw.edu.au>
References: <000a01c6ef12$0030b640$eb00000a@mine3ad5e808fe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan on Friday October 13
Sender: linux-raid-owner@vger.kernel.org
To: Dan <dan@korstad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 13, dan@korstad.net wrote:
> I am curious if there are plans for either of the following;
> -RAID6 reshape
> -RAID5 to RAID6 migration

No concrete plans with timelines and milestones and such, no.
I would like to implement both of these but I really don't know when I
will find/make time.  Probably by the end of 2007, but that is not a
promise.

Of course someone else could implement them.  RAID6 reshape should be
fairly straight forward given that RAID5 and RAID6 use the same code
and RAID5 reshape is done.
RAID5 to RAID6 conversion would be a bit trickier, but not much.
A point worth noting is that RAID5->RAID6 conversion without growing
the array at the same time is not a good idea.  It will either be
dangerous (a crash during the reshape will cause corruption of data)
or slow (all data needs to be copied one extra time - the 'critical
region' of raid5 reshape becomes the whole array if you don't grow the
array). 

Probably the fastest way for these to get implemented is for someone
else to try and post the results.  I would be very likely to comment
and help get the patch into a reliable and maintainable form and then
pass it on upstream.

Are you any good at coding :-)


> 
> Here is why I ask, and sorry for the length.

All sounds fairly sensible.  Except that as I say above, the option of
growing a raid5 bit by bit, then adding the last disk and making it
raid6 is not such a good approach.

NeilBreon
