From: Flynn <flynn@kodachi.com>
Subject: RAID6 Reshape Gone Awry
Date: Fri, 03 Aug 2012 01:27:29 -0400
Message-ID: <8C493F417CC49C6619BBAF45@ryoohko.kodachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Apologies in advance if this is the wrong place for this...

I'd been running a RAID6 with 5 1.5TB drives on CentOS 5.ancient for quite 
awhile.  Last week, I wanted to add a drive, and promptly ran into issues 
with my CentOS mdadm being unable to do the obvious thing with mdadm 
--grow, so I upgraded to Ubuntu 12.04 LTS.

All was well, briefly.

My RAID6 is actually a little bit odd in that the drives are split into 10 
partitions.  All the partition 5's are a RAID6; all the partition 6's are a 
RAID6; etc.  There's an LVM layer that sits on top.  This turned out to be 
handy when I changed the size of the drives in the RAID, so I stuck with it.

This means I have to actually do 10 mdadm --grow commands.  My original 
cunning plan was to issue one, wait for that partition to reshape, issue 
another, etc.  I scripted this -- and made a mistake, so the 'wait' step 
didn't happen.  I ended up with all ten partitions grown to 6 drives, and 
most of them marked pending reshape.

Again, all was well.

But you can guess what happened next, can't you?  That's right, the machine 
crashed.  On reboot, the reshape that had been underway at the time 
(partition 7) picked up and carried on just fine.  But partition 8 didn't. 
Nor anything after.

So at this point I have partitions 5, 6, and 7 happy; 8 - 14 are marked 
inactive.  The initial mdadm --grow reported that it passed the critical 
section long before the machine crashed, for all partitions.  mdadm 
--examine on the individual drives shows that each of these partitions 
believes that they are part of a RAID6 with 6 drives, correct checksums 
everywhere, event counters the same, but:

1)  Trying e.g.

    sudo mdadm --assemble --force /dev/md8 /dev/sd[bdefgh]8

says

mdadm: Failed to restore critical section for reshape, sorry.
      Possibly you needed to specify the --backup-file

Given that I didn't specify --backup-file to the initial mdadm --grow, this 
seems... perhaps not entirely helpful.

2)  In a working partition, I always see the 'this' entry in mdadm 
--examine's output matching up with the drive being read (e.g. /dev/sde5 
will say 'this' is /dev/sde5).  In a _non_-working partition, that's not 
the case (e.g. /dev/sdb7 says 'this' is /dev/sdg7).

3)  Finally, all the working partitions show that their superblocks are 
version 0.90.00, but all the non-working partitions show 0.91.00.

I've been beating my head on this for awhile, Googling around, learning a 
fair amount but not getting very far.  In theory there's nothing on this 
array that's irreplaceable (it's meant as a backup, not a primary store) 
but, well, it'd be nice to repair it rather than blowing it away.

This is mdadm 3.2.3.  Suggestions very welcome.  I can provide output to 
whatever people'd like to see, of course, but figured I'd wait for 
requests...

Thanks!

 -- Flynn

--
Never let your sense of morals get in the way of doing what's right.
                                                            (Isaac Asimov)

