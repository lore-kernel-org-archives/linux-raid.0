From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: RE: [md PATCH 00/16] bad block list management for md and RAID1
Date: Fri, 18 Jun 2010 00:30:08 -0400
Message-ID: <002c01cb0e9e$f4ba41e0$de2ec5a0$@woodlea.com>
References: <20100606235833.13302.60932.stgit@notabene.brown>	<hvd5iq$u83$1@dough.gmane.org>	<003901cb0e35$422f9020$c68eb060$@woodlea.com> <20100618135818.79967b83@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100618135818.79967b83@notabene.brown>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: 'Brett Russ' <bruss@netezza.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I think it would be a mistake to incorporate bad-block detection
functionality
> into md or mdadm.  We already have a program which does that and
> probably does it better than I could code.  Best to try to leverage what
> already exists.

I agree - I was thinking along the lines of maintenance type cases, where we
currently run an array check once a week - we could also schedule a full
'non-destructive badblocks -w' type test once a month (say), to catch disks
which are starting to go bad. Since mdadm understands the RAID layout, it
could migrate/redirect a stripe or block to another area, run badblocks on
each of the disks specifying the start and end sectors, and if the area on
one of the disks was bad, mark the area as bad - and since the data has been
redirected, we don't lose anything. If the area is good, then the data gets
moved back to its original location, and mdadm moves on to the next
stripe/block. I really think you'd need to do a fully destructive write test
on the drive though - I've actually just finished testing a Spinpoint F3
this evening, which has shown up 5 bad sectors, all on the 4th write pass
(0x00), so a quick read test probably wouldn't have shown them up.


> I'm not sure I see the logic though.  Surely if a drive has any errors
when new,
> then you don't want to trust it at all and cascading failure is likely and
> tomorrow there will be more errors.  So t would be best to do the badblock
> scan first and only add it to the array if it were completely successful.

Agreed Neil - I guess I am thinking more of the maintenance type cases, but
it would be nice to have mdadm check the drive when it's added to the array.
You could just blindly add the drive, and immediately schedule a full
badblocks test - but I guess I would still be paranoid, and still check the
disk before adding it.



