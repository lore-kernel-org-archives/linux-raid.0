From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: [long] general advice: config recommendations
Date: Wed, 08 Feb 2012 22:45:18 -0800
Message-ID: <uk6c09xju8.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello fellow RAIDers,

I'm looking for some pointers on how I might best configure my modest
mdraid array.  After some unfortunate hardware failures, it looks like I
will not be able to recover my existing array.  (This is a minor
annoyance, which is why I'm leaning towards starting over instead of
spending more time trying to recover.)

My basic situation: I have a 16-bay chassis attached to a 3ware 9550
controller.  I'm really unhappy with the controller, but am wary of
replacing it for various reasons (hard to find PCI-X controllers, very
hard to find 16-port PCI-X controllers, cards I've found would need
cables replaced as well).  And, as we've talked about on list,
enterprise-class drives are hard to find as well, at least for a few
months, so I need to battle my EARS/EADS drives for at least a little
longer.  (I do have 5 RE4 drives I can use, and may test some of the
Hitachis we've talked about.)  My last array was a 10x2TB RAID6
resulting in about 15TB of usable storage; at the time it was ~90% full,
but if my snapshots are gone I may have some time where I don't get
quite that full.

I am looking for the best compromise between maximizing storage,
defending against the EADS drives, the potential to recover from
multiple drive failures, and being able to swap out the EADS drives
quickly once I'm able to get better drives.  Easy, right?  ;-)

So, some options I'm tossing around:

-- [ot] LVM or no LVM?  I am certainly not well-versed in LVM, but
it's certainly possible that LVM helped contribute to not being able
to recover the existing filesystem.  I am wondering if it is worth
the extra overhead (and metadata) to get the benefits of LVM if the odds
are slim that I'll have storage I can't integrate into the md RAID
arrays.  I know that's OT, but...

--RAID6, RAID50, RAID5s+LVM, separate RAID5s?  RAID6 maximizes storage,
but has longer rebuild times; any RAID5 combination makes rebuilds (and
reshapes?) faster, but I worry that there's less leeway in an individual
RAID5 if there's one with multiple EADS drives.  One option I had in
mind was to throw as many of my enterprise drives at my more important
snapshots, and put the EADS drives all together to snapshot the less
important data.  So perhaps I could have a RAID6 that included all the
RE4 drives, plus two EADS drives, for ~9TB usable, and a RAID5 or RAID6
with four or five drives for the rest.  Or I could make two four drive
RAID5s, either in a RAID50 or LVM, for ~11TB usable (I would want to
find another RE4 or equivalent for this).

Are there any appreciable advantages of RAID50 over RAID5s grouped
together by LVM or vice-versa?  They seem very similar superficially.
Can I add a disk and reshape one member of a RAID50 without modifying
the other?  I don't think the 3ware 9550 supports that.  This situation
seems like it's the stereotypical use case for LVM, but perhaps a plain
RAID50 has advantages that make it preferable.

--Finally, the age-old argument: whole disks or partitions?  I wonder if
this is the mdraid equivalent of emacs vs. vi.  :)  I used partitions in
the last array, but TBH I wasn't all that happy with it, though I
couldn't explain why.  It could be I'm just used to working with whole
disks on RAID controllers.

--Any other pointers/advice/gotchas?

Thanks for reading--if you've made it this far I probably owe you a
beer!

--keith

-- 
kkeller@wombat.san-francisco.ca.us


