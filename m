From: Neil Brown <neilb@suse.de>
Subject: Re: Replace drive in RAID5 without losing redundancy?
Date: Tue, 6 Mar 2007 09:29:16 +1100
Message-ID: <17900.39356.684798.56121@notabene.brown>
References: <37643E71-0FD9-4F8A-AE68-A8565FEB0247@bj-ig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ralf Muller on Monday March 5
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 5, ralf@bj-ig.de wrote:
> 
> Is it possible to mark a disk as "to be replaced by an existing spare",
> then migrate to the spare disk and kick the old disk _after_ migration
> has been done? Or not even kick - but mark as new spare.

No, this is not possible yet.
You can get nearly all the way there by:

  - add an internal bitmap.
  - fail one drive
  - --build a raid1 with that drive (and the other missing)
  - re-add the raid1 into the raid5
  - add the new drive to the raid1
  - wait for resync

This has just a very tiny window when the array is degraded.  The
bitmap allows the re-added drive to be resynced very quickly.
The next step should be:
  - fail out the raid1
  - disassemble the raid1
  - re-add the new drive to the raid5
However that won't work as the superblock will be in the wrong place
on the new drive.
It wouldn't be hard to relocate the superblock, but there currently is
no code to do this.

NeilBrown
