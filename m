From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 11:32:15 -0500
Message-ID: <200501081632.j08GWM909993@www.watkins-home.com>
References: <20050108145228.GB26475@janus>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050108145228.GB26475@janus>
Sender: linux-raid-owner@vger.kernel.org
To: 'Frank van Maarseveen' <frankvm@frankvm.com>
Cc: 'Mario Holbe' <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't recall having 2 disks with read errors at the same time.  But others
on this list have.  Correctable read errors is my most common problem with
my 14 disk array.  I think this partitioning approach will help.  But as you
say, it is more complicated, which adds some risk, I believe.  But you can
compute the level of reduced risk, but you can't compute the level of
increased risk.

Some added risk:
	More complicated setup, increases user errors.
	Example:  Maarten plans to have 2 spare partitions on an extra disk.
Once he corrects the read error on the failed partition, he needs to remove
the failed partition, fail the spare and add the original partition back to
the correct array.  He has a 6 times increased risk of choosing the wrong
partition to fail or remove.  Is that 36 time increased risk of user error?
Of course, the level of error may be negligible, depending on who the user
is.  But it is still an increase of risk.

	There was at least 1 case on this list where someone failed or
removed the wrong disk from an array, so it does happen.

If 6 partitions is 6 time better than 1, then 36 would be 6 times better
than 6.  Is there a sweet spot?

Also, I mentioned it before.  Don't combine the RAID5 arrays with RAID0.
Since the RAID5 arrays are on the same set of disks, the poor disk heads
will be flapping all over the place.  Use a linear array, or LVM.

Also, Neil has an item on his wish list to handle bad blocks.  Once this is
built into md, the 6 partition idea is useless.

I test my disks every night with a tool from Seagate.  I don't think I have
had a bad block since I started using this tool each night.  The tool is
free, it is called "SeaTools Enterprise Edition".  I assume it only works
with Seagate disks.

Guy

-----Original Message-----
From: Frank van Maarseveen [mailto:frankvm@frankvm.com] 
Sent: Saturday, January 08, 2005 9:52 AM
To: Guy
Cc: 'Mario Holbe'; linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

On Fri, Jan 07, 2005 at 04:57:35PM -0500, Guy wrote:
> His plan is to split the disks into 6 partitions.
> Each of his six RAID5 arrays will only use 1 partition of each physical
> disk.
> If he were to lose a disk, all 6 RAID5 arrays would only see 1 failed
disk.
> If he gets 2 read errors, on different disks, at the same time, he has a
1/6
> chance they would be in the same array (which would be bad).
> His plan is to combine the 6 arrays with LVM or a linear array.

Intriguing setup. Do you think this actually improves the reliability
with respect to disk failure compared to creating just one large RAID5
array?

For one second I thought it's a clever trick but gut feeling tells
me the odds of losing the entire array won't change (simplified --
because the increased complexity creates room for additional errors).

-- 
Frank

