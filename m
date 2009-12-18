From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Thu, 17 Dec 2009 19:33:04 -0600
Message-ID: <C7.62.01550.1DBDA2B4@cdptpa-omtalb.mail.rr.com>
References: <4B29F99A.2000709@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B29F99A.2000709@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'John Robinson' <john.robinson@anonymous.org.uk>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > the entire array.  The question is particularly pertinent given the fact
> the
> > growth is going to take nearly 5 days (a lot can happen in 5 days), and
> the
> > fact the system was having the rather squirrelly issue a few days back
> which
> > seems - emphasis on SEEMS - to have been resolved by disabling NCQ.
> What
> > happens if the system kicks a couple of drives, especially if one drive
> gets
> > kicked, a bunch of data gets written and then a few minutes later
> another
> > drive gets kicked?  In particular, what if neither of the two drives
> that
> > get kicked are the new drive?
> 
> Well, what happens if two drives get kicked in normal use over the
> course of 5 days?

	Nothing of any consequence, unless it happens in quick succession.
When drive A is kicked, if it is spurious, then the drive is simply added
back and a resync performed.  If the drive actually failed, then it is
replaced, and once again a resync is done.  Either way, it takes vastly less
time than a growth.  Assuming at least one of the kicks is not an
out-and-out drive failure, then recovering the bulk of the data is fairly
easy.  That may not be the case with two drives kicked during a growth,
since a big chunk of the data on the last drive will be completely missing.
What's more, one is left with an array which has neitehr properly N nor N +
1 drives, but is in the process of changing from one to the other.  Again,
recovering from a failed resync or a sudden non-drive failure (like a power
failure or a drive cable being accidentally yanked) is fairly easy.  I don't
know what will happen if one of the drive cables feeding three of the drives
is accidentally yanked.  That's why I am asking.

> I think you're being overly cautious, and I'll try to
> explain why.
 
> The reshape only reduces redundancy during the "critical section". After
> that, you're as redundant as usual and can tolerate a drive failure. On
> RAID-6, 2 drive failures.

	Yes, I know.  I've experienced a number of issues where two or more
drives have been taken offline by md, though.  As I say, recovering from
this when the array was in a stable configuration is not too difficult,
perhaps even without data loss.  What happens when the array is taken
offline and it has neither properly 7 nor 8 drives is a real question,
though.  Obviously, if the array can resume its expansion where it left off
after a failure event, then it is not an issue, but according to one of the
other correspondents, this feature is not available in my version of mdadm.

> A reshape should be considerably safer than
> doing a resync to a replacement drive, because in the reshape case if
> you get bad sectors md can regenerate the data from the parity info.

	Except that it takes many times longer, significantly increasing the
likelihood of such a failure during the event.

> Do you regularly run a check on your array? Or have you done one
> recently? And does the SMART info on all your drives look OK? These
> should be the case before attempting any reshape anyway,

	Yes, but that did not stop md from halting the array multiple times
during resyncs when NCQ was enabled.  Disabling NCQ seems to have alleviated
the issue, but I have no guarantees it won't happen again during the growth.

