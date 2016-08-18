From: Chris Dunlop <chris@onthe.net.au>
Subject: Rewrite md raid1 member
Date: Thu, 18 Aug 2016 13:04:51 +1000
Message-ID: <20160818030451.GA17225@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

G'day all,

What options are there to safely rewrite a disk that's part of a live MD
raid1?

Specifically, I have smartctl reporting a Current_Pending_Sector of 360 on a
member of a raid1 set.

A 'check' of the raid comes up clean. I'd like to see if I can clear the
pending sector count by rewriting the sectors. Whilst rewriting just those
sectors would be ideal, I don't know which they are, so it looks like a
whole disk write is the way to go.

I realise the safest way to fix this is using a spare disk and doing a
replace, allowing me to play with the "pending sector" disk to my heart's
content, but I'm also interested to see if it can be done safely on a live
system...

If the system had a spare hot swap disk bay, and I had a spare disk, I could
add another disk to the system and do the replace.

If I were happy to lose redundancy during the process, I could remove the
disk from the raid, wipe the superblock, add it again, and let it rebuild
the whole raid.

If it weren't the root filesystem, the filesystem could be taken offline
whilst doing the rebuild above to reduce the chance of the lost redundancy
producing undesirable results, but there's still the risk of problems
cropping up on the "good" disk during the rebuild.

If I were happy to wear the down time, I could boot into a rescue disk to do
it.

Another option might be to "dd" from the "good" disk:

dd if=/dev/sda of=/dev/sdb

...except that will put the wrong superblock on there. Using the same disk
for the src and dst might be an option:

dd if=/dev/sdb of=/dev/sdb

...but the seeking would kill the throughput. Perhaps a large blocksize
might help, e.g. bs=64K. Or, there could be some dance of 'dd'ing from the
same disk for the superblock, and 'dd'ing from the other disk for the bulk
data, using the Super Offset and Data Offset from "mdadm -E".

However using 'dd' allows for a window where dd reads data A from sda:X
(sector X), then the system writes data B to md0:X (i.e. to both sda:X and
sdb:X), then dd writes data A to sdb:X, putting the raid out of sync.

This could potentially be fixed by doing a 'repair' of the raid, except
that, as both sda and sdb are returning data but not the same data, it's
possible this will preserve the wrong data (i.e. write the old data A from
sdb:X to sda:X instead of writing the new data B from sda:X to sdb:X).

In this circumstance, how does md decide which is the "good" data? Is there
a way of specifying "in the case of discrepancies, trust sda"?

Perhaps, before writing to sdb, setting it to "blocked" the right thing to
do? I.e.:

echo "blocked" > /sys/block/md0/md/dev-sdb1/state
[ dd stuff per above ]
echo "-blocked" > /sys/block/md0/md/dev-sdb1/state

Per linux/Documentation/md.txt:
----
    Writing "blocked" sets the "blocked" flag.
    Writing "-blocked" clears the "blocked" flags and allows writes
            to complete and possibly simulates an error.
----

I can't find anything that tells me what this actually does in practice. I'm
guessing setting it to "blocked" will stop md writing to that device but
otherwise allow the md device to function normally, and setting it to
"-blocked" will allow writes to proceed and the md device will then use the
write-intent bitmap to copy over any writes that were blocked.

And what does "...and possibly simulates an error" imply?

Or is this 'dd' stuff just nuts, a case of "well that's a novel way of
trashing your data..." and/or "you're welcome to try, but you get to keep
all the pieces and don't come crying to us for help!"?

Thanks for any insights into this!


Cheers,

Chris
