From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 7] md: Introduction - raid5 reshape mark-2
Date: Tue, 24 Jan 2006 11:40:47 +1100
Message-ID: <20060124112626.4447.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Here is second release of my patches to support online reshaping
of a raid5 array, i.e. adding 1 or more devices and restriping the 
whole thing.

This release fixes an assortment of bugs and adds checkpoint/restart
to the process (the last two patches).
This means that if your machine crashes, or if you have to stop an
array before the reshape is complete, md will notice and will restart
the reshape at an appropriate place.

There is still a small window ( < 1 second) at the start of the reshape
during which a crash will cause unrecoverable corruption.  My plan is
to resolve this in mdadm rather than md. The critical data will be copied
into the new drive(s) prior to commencing the reshape.  If there is a crash
the kernel will refuse the reassmble the array.  mdadm will be able to 
re-assemble it by first restoring the critical data and then letting
the remainder of the reshape run it's course.

I will be changing the interface for starting a reshape slightly before
this patch become final.  This will mean that current 'mdadm' will not
be able to start a raid5 reshape.
This is partly to save people from risking the above mentioned tiny hole,
but also to prepare for reshaping which changes other aspects of the
shape, e.g. layout, chunksize, level.

I am expecting that I will ultimately support online conversion of
raid5 to raid6 with only one extra device.  This process is not
(efficiently) checkpointable and so will be at-your-risk.
Checkpointing such a process with anything like reasonable efficiency
requires a largish (multi-megabytes) temporary store, and doing so
will at-best halve the speed.  I will make sure the posibility of
add this later will be left open.

My thanks to those who have tested the first release, who have
provided feedback, who will test this release, and who contribute to
the discussion in any way.

NeilBrown



 [PATCH 001 of 7] md: Split disks array out of raid5 conf structure so it is easier to grow.
 [PATCH 002 of 7] md: Allow stripes to be expanded in preparation for expanding an array.
 [PATCH 003 of 7] md: Infrastructure to allow normal IO to continue while array is expanding.
 [PATCH 004 of 7] md: Core of raid5 resize process
 [PATCH 005 of 7] md: Final stages of raid5 expand code.
 [PATCH 006 of 7] md: Checkpoint and allow restart of raid5 reshape
 [PATCH 007 of 7] md: Only checkpoint expansion progress occasionally.
