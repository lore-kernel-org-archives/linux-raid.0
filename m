From: Mike Hardy <mhardy@h3c.com>
Subject: the dreaded double disk failure
Date: Wed, 12 Jan 2005 23:14:09 -0800
Message-ID: <41E61FC1.6060603@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


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
