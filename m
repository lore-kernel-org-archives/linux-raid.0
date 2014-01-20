From: Mason Loring Bliss <mason@blisses.org>
Subject: Questions about bitrot and RAID 5/6
Date: Mon, 20 Jan 2014 15:34:33 -0500
Message-ID: <20140120203433.GY6553@blisses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was initially writing to HPA, and he noted the existence of this list, so
I'm going to boil down what I've got so far for the list. In short, I'm
trying to understand if there's a reasonable way to get something equivlant
to ZFS/BTRFS on-a-mirror-with-scrubbing if I'm using MD RAID 6.



I recently read (or attempted to read, for those sections that exceeded my
background in math) HPA's paper "The mathematics of RAID-6", and I was
particularly interested in section four, "Single-disk corruption recovery".
What I'm wondering if he's describing something theoretically possible given
the redundant data RAID 6 stores, or something that's actually been
implemented in (specifically) MD RAID 6 on Linux.

The world is in a rush to adopt ZFS and BTRFS, but there are dinosaurs among
us that would love to maintain proper layering with the RAID layer being able
to correct for bitrot itself. A common scenario that would benefit from this
is having an encrypted layer sitting atop RAID, with LVM atop that.



I just looked through the code for the first time today, and I'd love to know
if my understanding is correct. My current read of the code is as follows:

linux-source/lib/raid6/recov.c suggests that for a single-disk failure,
recovery is handled by the RAID 5 code. In raid5.c, if I'm reading it
correctly, raid5_end_read_request will request a rewrite attempt if uptodate
is not true, which can call md_error, which can initiate recovery.

I'm struggling a little to trace recovery, but it does seem like MD maintains
a list of bad blocks and can map out bad sectors rather than marking a whole
drive as being dead.

Am I correct in assuming that bitrot will show up as a bad read, thus making
the read check fail and causing a rewrite attempt, which will mark the sector
in question as bad and write the data somewhere else if it's detected? If
this is the case then there's a very viable, already deployed option for
catching bitrot that doesn't require complete upheaval of how people manage
disk space and volumes nowadays.

On a related note, raid6check was mention to me. I don't see that available
on Debian or RHEL stable, but I found a man page:

    https://github.com/neilbrown/mdadm/blob/master/raid6check.8

The man page says, "No write operations are performed on the array or the
components," but my reading of the code makes it seem like a read error will
trigger a write implicitly. Am I misunderstanding this? Overall, am I barking
up the wrong tree in thinking that RAID 6 might let me preserve proper
layering while giving me the data integrity safeguards I'd otherwise get from
ZFS or BTRFS?

Thanks in advance for clarifications and pointers!

-- 
Mason Loring Bliss             mason@blisses.org            Ewige Blumenkraft!
(if awake 'sleep (aref #(sleep dream) (random 2))) -- Hamlet, Act III, Scene I
