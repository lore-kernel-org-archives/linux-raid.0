From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: LVM over RAID, or plain disks? A:"Yes" = best of both worlds?
Date: Sun, 28 Nov 2010 12:34:02 -0600
Message-ID: <2D.98.07087.690A2FC4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of hansbkk@gmail.com
> Sent: Sunday, November 28, 2010 9:31 AM
> To: linux-raid@vger.kernel.org
> Subject: Q: LVM over RAID, or plain disks? A:"Yes" = best of both worlds?
> 
>  - - - - - - My abject apologies to all for improper addressing in my
> previous messages (thanks to all those who set me straight :)
> 
> Hope you're all still willing to consider my request for feedback.
> Start with a bit of context:
> 
> - SAN/NAS (call it FILER-A) hosting say a dozen TB and servicing a few
> dozen client machines and servers, mostly virtual hosts. Another,
> larger (FILER-B - still just tens of TB) host's drives are used for
> storing backup sets, via not only Amanda, but also filesystems
> comprising gazillions of hard-linked archive sets created by (eg)
> rdiff-backup, rsnapshot and BackupPC. We're on a very limited budget,
> therefore no tape storage for backups.
> 
> - I plan to run LVM over RAID (likely RAID1 or RAID10) for IMO an
> ideal combination of fault tolerance, performance and flexibility.
> 
> - I am not at this point overly concerned about performance issues -
> reliability/redundancy and ease of recovery are my main priorities.

	In that case, I'm not sure about your desire for the additional
complexity.  Someone else suggested RAID6, which from an operational
standpoint is much simpler.  The main reason, it seems to me, for the more
complex topologies would be enhancing perfromance.

> Problem:
> 
> For off-site data rotation, the hard-linked filesystems on FILER-B
> require full filesystem cloning with block-level tools rather than
> file-level copying or sync'ing.

	Yeah.  That's a bit of a sticky problem.  RAID1 or LVM certainly
fill the bill in terms of cloning.  It's the "data rotation" that throws a
monkey wrench into the gears.

> My current plan is to swap out disks
> mirrored via RAID, marking them as "failed" and then rebuilding using
> the (re-initialized) incoming rotation set.

	That sounds to me like a situation fraught with potential problems,
especially failures.  It seems to me swapping out disks in this fashion -
especially if there is any sort of striping - is merely going to wind up
producing a bunch of incompatible backup disks.

> HOWEVER - the use of LVM (and possibly RAID10) adds complexity to the
> filesystems, which makes disaster recovery from the detached disk sets
> much more difficult than regular partitions on physical disks.
> 
> 
> Theoretical solution:
> 
> Use RAID1 on the "top layer" to mirror the data stored in an LVM (set
> of) disk(s) on the one hand (call it TopRAID1) to ***regular
> partitions*** on actual physical disks on the other (call this the
> TopRAID2 side).
> 
> 
> (ASCII art best viewed with a monospaced font)
> 
> "TopRAID1" side
>  ______________________________________
> |                LVM VG                |
> |  _____   _____________   __________  |
> | | LV1 | |     LV2     | |    LV3   | |
> | |     | |             | |          | |
> | |     | |             | |          | |
> | |     | |             | |          | |
> | |     | |             | |          | |
> | |     | |             | |          | |
> | |_____| |_____________| |__________| |
> |____v___________v______________v______|
>      v           v              v
>      v           v              v
>    RAID1       RAID1          RAID1
>      v           v              v
>    __v__   ______v______   _____v____
>   | HD1 | |     HD2     | |    HD3   |
>   |     | |             | |          |
>   |     | |             | |          |
>   |     | |             | |          |
>   |     | |             | |          |
>   |     | |             | |          |
>   |_____| |_____________| |__________|
> 
> "TopRAID2" side
> 
> The mirroring at the top level would be set up between the individual
> LVs on the TopRAID1 side and regular filesystem partitions (no RAID or
> LVM) on the TopRAID2 side. In the event of a massive host failure, the
> filesystems on the TopRAID2 side could be easily mounted for data
> recovery and/or service resumption on another machine, and the
> TopRAID1 disk set rebuilt from scratch and then re-mirrored from the
> TopRAID2 disks.

	This will certainly work.  Let me ask you this:  What advantage do
you seek from using LVM on side 1?  Growth?  Re-sizing?

> One design goal would be to not allow any LV to get so large that it
> won't fit on a single physical disk on the TopRAID2 side. If this is
> not possible, then the corresponding TopRAID2 side would need to
> comprise a multiple disk set, perhaps striped by RAID0 - not as
> straightforward to recover as single disks, but at least without the
> LVM layer.

	To my mind, a solution which assumes the data payload will not
exceed a certain physical size is poorly considered unless the server hosts
only a very specific application whose data extents are specifically limited
by the application itself.  The beauty, as it were, of LVM is that it can
easily accommodate changing space needs within a pool of available storage
space.  If there are strict limits on the payload size, then I'm not certain
how LVM would offer advantages, especially if you are disallowing striping
the volumes.

> Remember, the main purpose of this arrangement is so that the disks in
> the TopRAID2 set can be rotated out for offsite storage. Ideally this
> would be done by using an extra identical set (TopRAID2a and
> TopRAID2b) to minimize the time windows when the live data is running
> on TopRAID1 only.

	What you are proposing can certainly be done, but it sounds awfully
frail, to me.  I think a better solution would be to be a RAID1 mirror of
every volume - each volume being a RAID or LVM of some number of disks, with
no disk being host to more than one volume on either side.  Then, rather
than failing an element, you can fail the entire volume set, stop the volume
and take all the disks offline at once.  Not only that, but if I were you, I
would make it a 3 volume mirror, keeping at least 2 volumes online at one
time.  Given your need to rotate the entire volume set, I don't believe
RAID10 will be ideal for what you want, but if not a relatively simple
matrix of RAID0 and RAID1 should work.  I'm not all that familiar with
RAID10, though, so one of the more expert members of the list may want to
chime in.

> Note that on the TopRAID1 side the LVM layers could be running on top
> of another set of RAID disks (call it the BottomRAID), again either
> RAID1 or perhaps RAID10 mirroring at the lowest layer. This disk set
> could be allowed to grow in both size and complexity, with an
> expectation that in the event of massive failure I won't even attempt
> to rebuild/recover it, just tear it down and set it up again from
> scratch, then mirror the data back from TopRAID2.
> 
> At this point this is all idle speculation on my part, and although I
> think the technology makes it possible, I don't know whether it is a
> practical scheme.

	It sounds practical to me in terms of setting it up, but not in
terms of being reliable, given the way you intend to use it.

> An enhancement of this idea would be to implement the "TopRAID" with a
> full-server mirror using drdb and heartbeat, perhaps eliminating the
> need for intra-server disk mirroring. In this case the TopRAID1 server
> would have the flexibile disk space allocation of LVM, while the
> TopRAID2 server's disks would all be just regular partitions (no LVM),
> again, easily swapped out for offsite rotation.
> 
> Any feedback on these ideas would be most appreciated.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

