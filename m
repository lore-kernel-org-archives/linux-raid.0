From: Billy Crook <billycrook@gmail.com>
Subject: LVM->RAID->LVM
Date: Sun, 24 May 2009 13:31:07 -0500
Message-ID: <a43edf1b0905241131t7dcb3d85v98597f061a4345d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I use LVM on top of raid (between raid and the filesystem).  I chose
that so I could export the LV's as iSCSI LUNs for different machines
for different purposes.  I've been thinking lately though, about using
LVM also, below raid (between the partitions and raid).  This could
let me 'migrate out' a disk without degrading redundancy of the raid
array, but I think it could get a little complicated.  Then again
there was a day when I thought LVM was too complicating to be worth it
at all.

If anyone here has done an 'LVM->RAID->LVM sandwich' before, do you
think it was worth it?  My understanding of LVM is that its overhead
is minimal, but would this amount of redirection start to be a
problem?  What about detection during boot?  I assume if I did this,
I'd want a separate volume group for every raid component.  Each
exporting only one LV and consuming only one PV until I want to move
that component to another disk.  I'm using RHEL/CentOS 5.3 and most of
my storage is served over iSCSI.  Some over NFS and CIFS.

What 'stacks' have you used from disk to filesystem, and what have
been your experiences?  (Feel free to reply direct on this so this
doesn't become one giant polling thread.)

I'm using partitioning->RAID->LVM->iSCSI->LUKS->EXT4.  It's been
reasonably fast and flexible, except with growing the raid arrays of
course.  The mdadm --grow operations seem to freeze md# I/O until the
its past the critical section which I imagine is by design, but it
freezes and waits even if it can't start the grow because a previous
reshape or resync is still in progress.  There's also the slight
nuisance of iscsi not passing through the new space after growing the
LV until you --delete the LUN and re-add it, but I guess I can live
with that.

I do wish there was an 'mdadm --block-until-all-healthy' that you
could use in scripts to block script execution until there were no
current or DELAYED resyncs or reshapes.
