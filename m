From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: the dreaded double disk failure
Date: Thu, 13 Jan 2005 03:37:01 -0500
Message-ID: <200501130835.j0D8Z5902816@www.watkins-home.com>
References: <41E61FC1.6060603@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E61FC1.6060603@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mike Hardy' <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Your static data could be on a bad block, you never know.

You should do something like a nightly dd of every disk!  Then you would
stand a good chance of finding the bad block before md does.  When I find a
bad block I fail the disk then overwrite the disk/partition with a dd
command.  This causes the disk to re-map the bad block to a spare block.
Then I test the disk with another dd read command.  Once I am sure the disk
is good, I add it back to the array.  All of this is a real pain in the @$$.
Some people just fail the disk, then add it back in.  They just let the
re-sync cause the disk to re-map the bad block.  I guess I feel more
in-control my way.

After I started testing my disks every night, I stopped getting bad blocks.
Maybe blocks need to be read every so often to keep them working?  Sounds
stupid to me too!  Maybe I have just been lucky!

Ok, lecture over.  :)

If raidreconf did not finish, I think you should expect major data loss!
If raidreconf did not finish, stop here and ignore any advice below!

You have more than 1 option.

OPTION ONE:
If you assemble the array with 1 missing disk and no spare, it will not
attempt to re-build or re-sync.  It will just be fine until it finds the bad
block as you said.

So, I think your plan will work.  But I think you may need to assemble 3
times before you have all of your data!  In each case, when you determine
which file is on a bad block, delete the file after you get a good copy,
then the next time you will not have a read error on that file.  I think
this is what you meant, but not sure.

OPTION TWO:
If you have an extra disk, you could use dd_rescue to make a copy of one of
your bad disks.  This will cause corruption related to the bad block.  But
it would get you going again.  Then assemble your array with this "new" disk
and the other bad disk as missing.  Once you are sure your data is there you
could add you missing disk and it will re-sync.  The re-sync should cause
the disk to re-map the bad block.

OPTION THREE:
Another idea!  Maybe risky!  It scares me!
But if I am correct, no data loss.
For this to work, you must not use any tools to change any data on any of
the 8 disks!!!!!!!!!!
No attempts to repair the disks with dd or anything!!!!!

Assemble your array with hdk1 missing.  Then add hdk1 to the array, the
array will start to re-sync.  This re-sync should overwrite the disk with
the same data that is all ready there.  The re-sync should re-map the bad
block and continue until hdo1 hits its bad block.  At that time hdo1 will be
kicked out, and the array will be down.  But hdk1 should now be good since
the data should still be on it.  So, now assemble the array with hdo1
missing, then add hdo1 and a re-sync will start, this should correct the bad
block and the re-sync should finish, unless you have a third bad block.
Each time you have a read error, just repeat the process with the disk that
got the last read error as the missing disk, then add it to the array to
start another re-sync.

I think the above should work regardless of which disk you use as the
missing disk.  But if you chose poorly, you will have 1 extra iteration of
the whole process.

OPTION FOUR:  (not an option)
A standalone tool to scan the disks and repair as you suggest would be real
cool!  It would just read test every disk until it finds a read error, then
compute the missing data, then re-write it.  Then continue on.  It could
also verify the parity and correct as needed.  I don't think such a tool
exists today.

Whatever you choose, getting a second (or third) opinion can't hurt!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mike Hardy
Sent: Thursday, January 13, 2005 2:14 AM
To: linux-raid@vger.kernel.org
Subject: the dreaded double disk failure


Alas, I've been bitten.

Worse, it was after attempting to use raidreconf and having it trash the 
array with my backup on it instead of extending it. I know raidreconf is 
a use-at-your-own-risk tool, but it was the backup, so I didn't mind.

Until I got this (partial mdadm -E output):

       Number   Major   Minor   RaidDevice State
this     7      91        1        7      active sync   /dev/hds1
    0     0      33        1        0      active sync   /dev/hde1
    1     1      34        1        1      active sync   /dev/hdg1
    2     2      56        1        2      active sync   /dev/hdi1
    3     3      57        1        3      faulty   /dev/hdk1
    4     4      88        1        4      active sync   /dev/hdm1
    5     5      89        1        5      faulty   /dev/hdo1
    6     6      90        1        6      active sync   /dev/hdq1
    7     7      91        1        7      active sync   /dev/hds1

/dev/hdk1 has at least one unreadable block around LBA 3,600,000 or so, 
and /dev/hdo1 has at least one unreadable blok around LBA 8,000,000 or so.

Further, the array was resyncing (power failure due to construction, yes 
its been one of those days - but it was actually in sync) when the first 
bad block hit, but I know that all the data I care about was static at 
the time, so barring some fsck cleanup, all the important blocks should 
have correct parity.

Which is to say that I think my data exists, its just a bit far away at 
the moment.

The first question is, would you agree?

Assuming its there, my general plan is to do this to get my data out:

1) resurrect the backup array
2) add one faulty drive to the array, with bad blocks there
    (an mdadm assemble with 7 of the 8, forced?)
3) start the backup, fully anticipating the read error and disk ejection
4) add the other faulty drive in, with bad blocks there
    (mdadm assemble with 7 of the 8, forced again?)
5) finish the backup

The second question is, does that sound sane? Or is there a better way?

Finally, to get the main array healthy, I'm going to take note of which 
files kicked out which drives, and clobber them with the backed up version.

Alternately, how hard would it be to write a utility that inspected the 
array, took the LBA(s) of the bad block on one component, and 
reconstructed it for rewrite via parity. A very smart dd, in a way. Is 
that possible?

Finally, I heard mention (fromo Peter Breuer I think) of a raid5 patch 
that tolerates sector read errors and re-writes automagically. Any info 
on that would be interesting.

Thanks for your time
-Mike
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

