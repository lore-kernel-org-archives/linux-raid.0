From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 2 May 2009 21:16:35 -0500
Message-ID: <20090503021639269.WFUM19475@cdptpa-omta01.mail.rr.com>
References: <49F99AD1.9090204@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F99AD1.9090204@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On 30/04/2009 01:55, Leslie Rhorer wrote:
> >> What I'd be much more inclined to do is create 2 RAID 5 sets, one of 1T
> >> discs, and one of 1.5T discs, then combine the two using LVM. It just
> >> feels more natural to me that way. In addition, while both setups will
> >> tolerate one disc failure, yours will then only tolerate one particular
> >> one of the remaining 11 failing (the companion drive in the LVM/linear
> >> pair), and mine will tolerate a failure of any drive on the other RAID-
> 5.
> >
> > I had thought of this, but then replacing the 1T + 1.5T pairs with 3T
> > drives, which I expect to happen eventually, will be more difficult.
> 
> Not really. You can just replace the drives in one array with 3T ones
> (one at a time, waiting for the rebuild to complete each time), grow the
> array, resize LVM's PV with `pvresize`, tell LVM to move the data from
> the other array across with `pvmove`, decommission the now-empty
> array/PV, and finally resize the filesystem.

	Yeah, but that requires replacing all the drives of one size and
growing the array.  It's a bit more trouble than simply taking a 1T + 1.5T
pair offline and replacing with a single 3T drive.  It also requires buying
six 3T drives all at once.  With the other method, I can buy two 3T drives,
swap out two pairs of drives, and then add one 1.5T drive to each of two
other 1.5T drives and move the remaining six 1T drives into two sets of
three drives.  Grow the array and I'm up to 15T with two extra 1.5T drives
while only having purchased an additional 2 drives.  As my budget allows, I
can replace each two or 3 element set with a single 3T drive.

> If you can have all the drives online at once, it's easier than that -
> make a new array of 3T drives, add it to the LVM VG, and `pvmove` all
> your data, decommission the now-empty arrays/PVs, and resize the fs.
> 
> Or you might choose to keep one of the arrays of smaller drives and have
> a larger backup system, no `pvmove`s required.

Yeah, but depending on the actual cost of 3T drives at the time, buying six
of them might be a bit difficult.

