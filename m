From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Requesting replace mode for changing a disk
Date: Tue, 12 May 2009 20:21:14 -0500
Message-ID: <20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
References: <4A060CBE.9090308@tmr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A060CBE.9090308@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> This is one of many things proposed occasionally here, no real
> objection, sometimes loud support, but no one actually *does* the code.

	At the risk of being a metoo, I would really love this feature.

> You have described the problem exactly, and the solution is still to do
> it manually. But you don't need to fail the drive long term, if you can
> stop the array for a few moments. You stop the array, remove the suspect
> drive,

Um, how, exactly?  That is to say, after stopping the array, how does one
remove the drive?  From the next step in your suggestion, it doesn't seem
tome you are talking about physically removing the drive, so how does one
remove a drive from a stopped array for this purpose?  I didn't think that
either

	mdadm -r <drive> <array>
or

	mdadm -f <drive> <array>

could be used on a stopped array.  Am I mistaken?

> create a raid1 of the suspect drive marked write-mostly and the
> new spare,

But doesn't creating the array with the drive wipe the contents?  If so, it
doesn't seem to me this provides much redundancy.

> then add the raid1 in place of the suspect drive.

Before starting the array?  If so, how?  Or should one do an assemble
including the newly minted RAID1?  I thought mdadm would take the newly
added drive to be blank, even if it isn't.

> For any
> chunks present on the new drive the reads will go there, reducing

Huh?  Are you saying any read which finds one chunk missing will
automatically write back the missing data (doing a spot rebuild), or
something else?

> access, while data is copied from the old to the new in resync, and

See my query above.  It seems to me you are saying the RAID1 can be created
without wiping the drive.

> writes still go to the old suspect drive so if the new drive fails you
> are no worse off.

I think I would expect the old drive to be more likely to fail than the new.

> When the raid1 is clean you stop the main array and
> back the suspect drive out.

OK, basically the same question.  How does one disassemble the RAID1 array
without wiping the data on the new drive?
 

