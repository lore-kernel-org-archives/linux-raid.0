From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: dean's linux raid wishlist
Date: Sun, 26 Oct 2003 17:31:53 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0310261730450.20038@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

for your enjoyment :)

<http://arctic.org/~dean/raid-wishlist.html>

dean's linux raid wishlist

$Id: raid-wishlist.html,v 1.3 2003/10/27 01:30:15 dean Exp $

   here's my wishlist for enhancements i'd like to see in the linux raid
   subsystem. i thought it'd be interesting to share... if i had more
   money than i knew what to do with, i'd fund someone to work on this
   stuff. alas. :)

   overall i'm pretty damn happy with the systems i've been able to build
   with linux md. maintaining these systems over time, and through
   various forms of failures has given me a few battle scars... those
   scars are what lead to this wishlist.

logging raid

   send writes to a log first, sync the log, then ack the upper layers.
   play the log against the raid in the background.

   if there's a system crash then it is sufficient to replay the logs in
   order to get the raid back in sync. note that such a log replay is in
   general more accurate than a resync or reconstruct -- because in a
   resync/reconstruct it's not guaranteed that the resulting data will be
   the most recently ack'd copy. (consider that resync/reconstruct need
   to select from several permutations of disks to decide what is the
   "master" copy of the data).

   it should be possible to place the log on any block device -- i would
   expect to use either a mirrored pair of [1]nvram devices, or a
   mirrored pair of disks. (a disk used exclusively for a single log has
   very high locality and seek latency is almost non-existent... it's
   faster to ack writes on such a disk than it is on a larger raid5.)

   i understand that linux-2.6 will improve resync/reconstruct by saving
   a "progress indicator" so that the process can be restarted after a
   reboot. this has been a terrible source of headache on linux-2.4. but
   overall my wish is for logging techniques so that huge arrays will be
   even more feasible.

partially failed disks

   a common failure mode for a disk is to develop a local read error, a
   few sectors which are unreadable. presently any such error causes md
   to mark the disk as faulty and remove it from the raid. there are two
   unfortunate aspects of this approach:
    1. it is generally possible to reconstruct the area with the read
       error from the rest of the raid. if it is then rewritten the disk
       has a chance to allocate replacement sectors for the bad blocks.
       the bad disk should still be replaced immediately -- but this
       approach continues to give you the redundancy of the rest of the
       platter, delaying a fatal two disk failure.
    2. if two disks fail with read errors in non-overlapping stripes the
       raid is considered dead... even though the raid is completely
       reconstructible. for example, suppose it is a 4 disk raid5 with D
       = data, P = parity, and X = read error, in the following sectors:

                              disk0 disk1 disk2 disk3
                      stripe0   D     D     D     P
                      stripe1   D     D     P     D
                      stripe2   D     P     X     D
                      stripe3   X     D     D     D

       it is obvious that stripe2 can be reconstructed using disk0,
       disk1, and disk3. stripe3 can be reconstructed using disk1, disk2,
       and disk3.

   note that raid1 benefits from these techniques as much as raid5 does
   -- especially raid1 on more than 2 disks.

   at a minimum it would be nice to have an offline tool capable of
   reconstructing a raid which handles problem #2 above.

raid6

   hpa has developed a second redundancy function using the galois field
   defined in the AES specification. his redundancy function is
   orthogonal to standard XOR-based parity. using them in concert allows
   for two disks of redundancy -- a very desirable situation. he has
   demonstrated assembly implementations which generate the two functions
   in parallel at speeds comparable to generating parity alone.

delay resync/reconstruct boot option

   there have been many times when i've been frustrated by the
   resync/reconstruct beginning immediately at md startup. the typical
   situations this is undesirable include when i'm dealing with a disk
   failure; or when i'm dealing with some other system problem requiring
   lots of reboots and power cycles.

consistency check / repair tool

   just like fsck is still useful with logging filesystems, no matter how
   hard we've tried to prove a raid will never end up in an inconsistent
   state it would be nice to have a consistency checking / repair tool.

References

   1. http://www.umem.com/
