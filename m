From: hansbkk@gmail.com
Subject: Re: raid1 with rotating offsite disks for backup
Date: Thu, 10 Feb 2011 02:37:10 +0700
Message-ID: <AANLkTik+WR5r_xBAFhKrUCwQgAzz+x2_AVQ9vjr=Rdco@mail.gmail.com>
References: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Klingner <klingner@stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 8, 2011 at 6:53 AM, Jeff Klingner <klingner@stanford.edu> wrote:
> I'm planning a backup system for my home server and have run into a question I can't find answered in the mailing list archives or the wiki.  Here's the plan:
>
> 1. Install system and valuable data on a 3-disk raid1 array (call the disks A, B, and C).
> 2. Remove disk C, put it offsite.  ("offsite" is moderately time-consuming to get to.)
> 3a. Periodically, remove disk B, take it offsite, and retrieve disk C
> 3b. Insert disk C, which will be re-synced to gain any changes made since it was removed.
> 4. Repeat steps 3a and 3b indefinitely, alternating the roles of disks B and C.
>
> Thus I hope to get continuous protection against a single drive failure and protection back to the last offsite swap for corrupted or deleted data.


I went through a (probably much too) long discussion here on similar
(but more complex) ideas.


http://www.issociate.de/board/goto/2050886/Q:_LVM_over_RAID,_or_plain_disks?_A:%22Yes%22_=_best_of_both_worlds?.html

Bottom line conclusions
  - mdraid isn't designed for this, and may not be as resilient as you'd expect
  - there is extra overhead involved in the resulting filesystem on
the member, that in this case doesn't actually help fault-tolerance,
makes it more difficult to recover your data from the offsite drive,
and wastes time
  - better to just mount a plain-partitioned disk and rsync for your
removable offsite backups

In my case, some of the target filesystems (backup targets with
millions of hardlinks, created by tools like rdiff-backup and
BackupPC) can't be duplicated at the file-level; I need to copy the
filesystem using block-level tools, so that's why the end of the
thread talks about COTS cloning tools as well as FOSS enhanced
versions of dd.

For regular filesystems, IMO rsync's the way to go.
