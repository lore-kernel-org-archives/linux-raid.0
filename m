From: "Ryan Wagoner" <rswagoner@gmail.com>
Subject: raid 1 mismatch_cnt
Date: Mon, 3 Nov 2008 10:40:42 -0400
Message-ID: <7d86ddb90811030640t752c31d6k236b1de8586e7ae9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have two servers with CentOS 5.2 running kernel 2.6.18-92.1.13 and
mdadm 2.6.4-1. When I run check > sync_action on the arrays the RAID 5
arrays always come back with a mismatch_cnt of 0. However both servers
have certain RAID 1 arrays that come back with mismatch_cnt != 0. I
have read through the mailing list archives and know that this is
common for arrays containing swap.

The first server had /boot come back !=0, which I repaired and another
check came back 0. I then ran a fschk -f which stated it made
corrections.

The second server had / come back !=0 and /vmware !=0. I was hesitant
to repair /vmware because it has vmdk files on the file system. Upon
further mailing list reading I read that aborted file writes can cause
the mismatch. I'm assuming that is what is happening especially with
the vmware mount, since it contains virtual machines which do have
swap files contained inside them.

If I understand this correctly the mismatch data most likely will not
be data that is allocated to a current file in the ext3 filesystem.
Likely it is swap from the virtual machines or on the / mount data
from a write that was aborted. I'm still not sure how /boot had
mismatches as it isn't written to often on the other server. Even if
it was an aborted write why the fschk corrections? These servers have
not been powered off improperly and are on a UPS.

How come when the write is aborted the underlying RAID 1 writes can't
be completed? With RAID 5 and an aborted write the parity seems to
still be updated as those arrays have no mismatches. I have virtual
machines on the first server on a RAID 5 array with no mismatches. It
just makes me a bit worried of the integrity of the RAID 1 volumes.

Is it possible that from an aborted write the file system knows that
certain inodes should be there and with the underlying RAID mismatches
fschk finds inconsistencies in the file system?

Thanks,
Ryan Wagoner
