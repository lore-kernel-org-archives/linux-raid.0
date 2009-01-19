From: Neil Brown <neilb@suse.de>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 12:40:12 +1100
Message-ID: <18803.55804.905420.503480@nbeee.brown>
References: <18763.7881.300921.177207@notabene.brown>
	<20090111181413.GA24988@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Piergiorgio Sartor on Sunday January 11
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 11, piergiorgio.sartor@nexgo.de wrote:
> Hi,
> 
> something else you can add to your "todo list",
> or not, as you like.
> 
> RAID-5/6 with heterogeneous devices.
> The idea would be to build a RAID-5/6 with devices
> of different size, but using, whenever possible,
> the complete available space.
> Example: let's say we have 6 HDs, 3x 500GB and 3x 1TB.
> The idea is to have a single md device, in RAID-5,
> where the first part of the device (500GB range) uses
> the whole 6 HDs, while the second part uses only 3.
> Specifically, the first part will have 500GB x5
> and the second 500GB x2.
> This is already doable by partitioning the HDs properly
> before and creating 2 md devices.
> Nevertheless, given the "grow" possibility, in both
> directions (disk number, disk size), the RAID only
> solution would be interesting.

I've thought about this occasionally but don't think much of the idea.
It seems nice until you think about what happens when devices fail
and you need to integrate hot spares.
Clearly any spare will need to be as big as the largest device.
When that get integrated in place of a small device, you will be
wasting space on it, and then someone will want to be able to
grow the array to use that extra space, which would be rather
messy.

I think it is best to assume that all devices are the same size.
Trying to support anything else in a useful way would just add
complexity with little value.


> 
> RAID-5/6 pre-caching.  Maybe this one is already there, in any case
> the idea would be to try to cache a complete stripe set, in case of
> RAID-5/6, in order to avoid sub sequent reads in case of write.
> This could be a user switchable parameter, for example when the user
> knows there will be a lot of read-modify-write to the array.

We already do some degree of caching. This primarily exists so that
we can be working on multiple stripes at once.  If there are multiple
write accesses to a stripe while it stays in cache you could save some
reads, but I suspect that most times stripes fall out of cache before
they are used again.  That cache can be made bigger, but I'm not sure
it would help a lot..


Thanks for the ideas.

NeilBrown
