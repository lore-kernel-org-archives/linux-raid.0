From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 problem
Date: Mon, 5 Dec 2005 08:47:50 +1100
Message-ID: <17299.25606.806494.749914@cse.unsw.edu.au>
References: <4392FB7C.6080600@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alfons Andorfer on Sunday December 4
Sender: linux-raid-owner@vger.kernel.org
To: Alfons Andorfer <a_a@gmx.de>
Cc: linux-raid@vger.kernel.org, n@suse.de
List-Id: linux-raid.ids

On Sunday December 4, a_a@gmx.de wrote:
> Hi,
> 
> I have a RAID5 array consisting of 4 disks:
> 
> /dev/hda3
> /dev/hdc3
> /dev/hde3
> /dev/hdg3
> 
> and the Linux machine that this system was running on crashed yesterday 
> due to a faulty Kernel driver (i.e. the machine just halted).
> So I resetted it, but it didn't come up again.
> I started the machine with a Knoppix CD and found out that the array had 
> been running in degraded mode for about two months (/dev/hda3 went off 
> then).

You want to be running "mdadm --monitor".  You really really do!
Anyone out there who is listening: if you have any md/raid arrays
(other than linear/raid0) and are not running "mdadm --monitor",
please do so.  Now.
Also run "mdadm --monitor --oneshot --scan" (or similar) from a
nightly cron job, so it will nag you about degraded arrays.
Please!

But why do you think that hda3 dropped out of the array 2 months ago?
The update time reported by mdadm --examine is
       Update Time : Sat Dec  3 18:56:59 2005

The superblock from hda3 seems to suggest that it was hdc3 that was
the problem.... odd.


> 
> "pass 1: checking Inodes, Blocks, and sizes
> read error - Block 131460 (Attempt to read block from filesystem 
> resulted in short read) during Inode-Scan  Ignore error?"


This strongly suggests there is a problem with one of the drives - it
is returning read errors.  Are there any informative kernel logs.
If it is hdc that is reporting errors, try to re-assemble the array
from hda3, hde3, hdg3.


NeilBrown
