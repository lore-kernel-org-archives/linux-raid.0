From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 0 of 7 - Introduction
Date: Fri, 23 Jan 2004 11:13:40 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040123105615.2237.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Herewith, 7 more patches for drivers/md and related code.

The first fixes a lock-up that was introduced by a recent patch (as I
was worried might happen...).

The fourth makes device IO statistics work for md arrays.

The sixth, which depends on come code rearrangement in the 5th, is the
most significant of the patches. It allows md devices to be partitioned
(I finally figured out the *right* way to do this).

A second major number is dynamically allocated, and md arrays can be
created under this major as well as the traditional '9'.
Arrays created under the new major get 64 minor numbers, 63 of which
can be used for different partitions.

The arrays assembled under the new major are completely
separate from any arrays assembled under the old major (9).
(though an array created under one can be shut down and re-assembled
under another).

Currently this means that only 4 md arrays can be partitioned.
However once user-space catches up with the new 32bit device numbers
in the kernel, the limit will be many thousands.

Creating device nodes in /dev is left as a exercise for the reader
(as the major number can be different at each reboot).  Maybe devfs or
udev are solutions.

The allocated major number can be found by looking for "mdp" in
/proc/devices.

Partitioned md devices have names like
    md_dXpY
in /proc/partitions and /sys/block, are recommended to have names like
   /dev/md/dXpY
in /dev (X and Y are numbers).

Finally, the last (7th) patch is more of a sick joke than a serious
patch, though I would not object to it being included in the kernel.
Currently  devices that are not partitionable (e.g. md devices with
major '9') do not show up in /proc/partitions, which is a regression
from 2.4.   Maybe it is better to remove the "sgp->minors == 1" test,
but as Linus put that in.....

NeilBrown
