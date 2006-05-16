From: Dan Christensen <jdc@uwo.ca>
Subject: recovery from mkswap on mounted raid1 ext3 filesystem?
Date: Mon, 15 May 2006 22:19:09 -0400
Message-ID: <87hd3qu2xu.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I accidentally ran mkswap on an md raid1 device which had a mounted
ext3 filesystem on it.  I also did a swapon, but I don't think
anything was written to swap before I noticed the mistake.  How much
of the partition is toast, and is it something e2fsck might fix?

Luckily I have a recent full backup, but it would be easier if
there was a quick fix!  :-)

Thanks,

Dan

(For the curious: I made the mistake because my fstab file had md0 and
md1 reversed, because a few kernel revisions back the kernel decided
to name them differently.  And for some reason, the "mount" command
reports the wrong information from my fstab rather than the right
information which is (for example) in /proc/mounts.  Is this a bug?

Moreover, shouldn't the mkswap command check whether a device is in
use before overwriting it?

I realize this isn't the right list for these questions...)

