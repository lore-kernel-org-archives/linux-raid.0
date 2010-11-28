From: hansbkk@gmail.com
Subject: Q: LVM over RAID, or plain disks? A:"Yes" = best of both worlds?
Date: Sun, 28 Nov 2010 22:30:56 +0700
Message-ID: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 - - - - - - My abject apologies to all for improper addressing in my
previous messages (thanks to all those who set me straight :)

Hope you're all still willing to consider my request for feedback.
Start with a bit of context:

- SAN/NAS (call it FILER-A) hosting say a dozen TB and servicing a few
dozen client machines and servers, mostly virtual hosts. Another,
larger (FILER-B - still just tens of TB) host's drives are used for
storing backup sets, via not only Amanda, but also filesystems
comprising gazillions of hard-linked archive sets created by (eg)
rdiff-backup, rsnapshot and BackupPC. We're on a very limited budget,
therefore no tape storage for backups.

- I plan to run LVM over RAID (likely RAID1 or RAID10) for IMO an
ideal combination of fault tolerance, performance and flexibility.

- I am not at this point overly concerned about performance issues -
reliability/redundancy and ease of recovery are my main priorities.


Problem:

For off-site data rotation, the hard-linked filesystems on FILER-B
require full filesystem cloning with block-level tools rather than
file-level copying or sync'ing. My current plan is to swap out disks
mirrored via RAID, marking them as "failed" and then rebuilding using
the (re-initialized) incoming rotation set.

HOWEVER - the use of LVM (and possibly RAID10) adds complexity to the
filesystems, which makes disaster recovery from the detached disk sets
much more difficult than regular partitions on physical disks.


Theoretical solution:

Use RAID1 on the "top layer" to mirror the data stored in an LVM (set
of) disk(s) on the one hand (call it TopRAID1) to ***regular
partitions*** on actual physical disks on the other (call this the
TopRAID2 side).


(ASCII art best viewed with a monospaced font)

"TopRAID1" side
 ______________________________________
|                LVM VG                |
|  _____   _____________   __________  |
| | LV1 | |     LV2     | |    LV3   | |
| |     | |             | |          | |
| |     | |             | |          | |
| |     | |             | |          | |
| |     | |             | |          | |
| |     | |             | |          | |
| |_____| |_____________| |__________| |
|____v___________v______________v______|
     v           v              v
     v           v              v
   RAID1       RAID1          RAID1
     v           v              v
   __v__   ______v______   _____v____
  | HD1 | |     HD2     | |    HD3   |
  |     | |             | |          |
  |     | |             | |          |
  |     | |             | |          |
  |     | |             | |          |
  |     | |             | |          |
  |_____| |_____________| |__________|

"TopRAID2" side

The mirroring at the top level would be set up between the individual
LVs on the TopRAID1 side and regular filesystem partitions (no RAID or
LVM) on the TopRAID2 side. In the event of a massive host failure, the
filesystems on the TopRAID2 side could be easily mounted for data
recovery and/or service resumption on another machine, and the
TopRAID1 disk set rebuilt from scratch and then re-mirrored from the
TopRAID2 disks.

One design goal would be to not allow any LV to get so large that it
won't fit on a single physical disk on the TopRAID2 side. If this is
not possible, then the corresponding TopRAID2 side would need to
comprise a multiple disk set, perhaps striped by RAID0 - not as
straightforward to recover as single disks, but at least without the
LVM layer.

Remember, the main purpose of this arrangement is so that the disks in
the TopRAID2 set can be rotated out for offsite storage. Ideally this
would be done by using an extra identical set (TopRAID2a and
TopRAID2b) to minimize the time windows when the live data is running
on TopRAID1 only.

Note that on the TopRAID1 side the LVM layers could be running on top
of another set of RAID disks (call it the BottomRAID), again either
RAID1 or perhaps RAID10 mirroring at the lowest layer. This disk set
could be allowed to grow in both size and complexity, with an
expectation that in the event of massive failure I won't even attempt
to rebuild/recover it, just tear it down and set it up again from
scratch, then mirror the data back from TopRAID2.

At this point this is all idle speculation on my part, and although I
think the technology makes it possible, I don't know whether it is a
practical scheme.

An enhancement of this idea would be to implement the "TopRAID" with a
full-server mirror using drdb and heartbeat, perhaps eliminating the
need for intra-server disk mirroring. In this case the TopRAID1 server
would have the flexibile disk space allocation of LVM, while the
TopRAID2 server's disks would all be just regular partitions (no LVM),
again, easily swapped out for offsite rotation.

Any feedback on these ideas would be most appreciated.
