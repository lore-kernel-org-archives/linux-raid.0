From: Helge Hafting <helgehaf@aitel.hist.no>
Subject: raid-0 oddity in 2.5.30 - can mount but not fsck
Date: Tue, 06 Aug 2002 09:09:42 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D4F7636.679E27D0@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-kernel@vger.kernel.org, neilb@cse.unsw.edu.au, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried to run 2.5.30 on a smp machine that use raid-1 and raid-0.
The RAIDs are autodetected.  The bootup fsck complained
that it couldn't find a valid superblock on /dev/md/1, which scared me
a bit.  But there is no problem with the device - mount
does not complain and mounts the fs (ext2) just fine.

The 2.5.30-kernel is patched for a max BIO size of 4k, so there
won't be trouble with BIOs crossing stripe boundaries.

2.5.7 have no problem with the RAIDs.

Helge Hafting
