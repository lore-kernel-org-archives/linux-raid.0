From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md Grow for Raid 5
Date: Wed, 9 Mar 2005 10:55:47 +1100
Message-ID: <16942.15235.437442.433397@cse.unsw.edu.au>
References: <676e074ffe5f52e6671aac5a2c14e984@case.edu>
	<422DFE60.5020807@weisshuhn.de>
	<422E1C6A.2000006@h3c.com>
	<422E31F3.3070104@panix.com>
	<422E3352.20002@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Mike Hardy on Tuesday March 8
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: berk walker <berk@panix.com>, Frank Wittig <fw@weisshuhn.de>, John Poirier <john.poirier@case.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 8, mhardy@h3c.com wrote:
> 
> berk walker wrote:
> > Have you guys seen/tried mdadm 1.90?  I am delightfully experiencing the 
> 
> I believe the mdadm based grow does not work for raid5, but only for 
> raid0 or raid1. raidreconf is actually capable of adding disks to raid5 
> and re-laying out the stripes / moving parity blocks, etc

There are different dimensions for growing....
You can make the component devices bigger, or you can add component
devices.  You can increase storage or you can increase redundancy.

If you replace all the devices in a raid1, raid5, or raid6 with large
devices (presumably one at a time allowing for a reconstruct each
time) then mdadm will allow you to "grow" the array to make use of the
extra space.

mdadm will also allow you to "grow" and raid1 array by adding extra
devices.  This only increases redundancy, not capacity.

I code to allows you to "grow" a linear array by adding a drive to
it.  I'm not sure if I have submitted this code.

I plan a raid4 version that organises the data in a linear rather than
a striped fashion.   It would be quite simple for mdadm to 'grow' this
sort of array.

All of these do not require moving data around, so they are easy.

Growing a raid5 or raid6 by adding another drive is conceptually
possible to do while the array is online, but I have not definite
plans to do this (I would like to).  Growing a raid5 into a raid6
would also be useful.
These require moving lots of data around, and need to be able to cope
with drive failure and system crash.... a fun project..

As has been said, raidreconf does at least some of this off-line.

NeilBrown
