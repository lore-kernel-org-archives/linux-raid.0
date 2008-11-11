From: "NeilBrown" <neilb@suse.de>
Subject: Re: How about reversed (or offset) disk components?
Date: Wed, 12 Nov 2008 07:32:18 +1100 (EST)
Message-ID: <62a7356ceb508b25c3951da7fc7d10b5.squirrel@neil.brown.name>
References: <43d009740811111040x5e610582n9f9bd4354682ca16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43d009740811111040x5e610582n9f9bd4354682ca16@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, November 12, 2008 5:40 am, Igor Podlesny wrote:
> 	Hi!
>
> 	And I have one more idea: How about reversed (or offset) disk
> components? -- It's known that linear read speed is decreasing when
> reading from the beginning to end of HDD, thus leading to situation
> when reading from RAID is good at its beginning and rather poor at its
> ending. My suggestion (possibly) would make that speed almost constant
> in despite of reading position. Examples:
>
> 	RAID5:
>
> 	disk1: 0123456789
> 	disk2: 3456789012
> 	disk3: 6789012345
>
> 	i. .e, the disk1's chunks aren't offseted at all, and disks' 2 and 3 are.
>
> 	RAID0:
>
> 	disk1: 0123456789
> 	disk2: 9876543210
>
> 	Any drawbacks?

It is hard to be really sure without implementing the layout and making
measurements.
You could probably do this by partitioning each device into three partitions,
combining those together with a linear array so they are in a different
order, then combining the three linear arrays into a raid5.

However:  the common understanding (which could be wrong) is that the
speed of a RAID is often limited by the slowest device.  Your arrangement
not only puts fast cylinders at each offset, but also slow cylinders.
I would expect the net result to be slower than normal, not faster.

NeilBrown

