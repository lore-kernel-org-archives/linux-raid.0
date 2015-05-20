From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Replacing a failed disk "in advance"
Date: Wed, 20 May 2015 16:20:49 +0200
Message-ID: <20150520142049.GT24672@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	Hello,

I have a RAID-5 volume of 8 physical disks. One of these disks failed the SMART
self-test with an unreadable block error. Unfortunately I have discovered
that there is _another_ bad block on another disk. It is a different block,
so the RAID-5 volume as a whole is still working. But as a whole, the
RAID-5 volume has at least two unreadable sectors on two different disks.

What is the best way to replace these two failing disks one by one without
the loss of data? I cannot mdadm --fail one of them, because the
subsequent rebuild on a new disk would fail on reading the other bad block.

I would like to add the ninth drive to the RAID-5 volume, and put a replica
of one of the failing drives to it. Then remove the just-replicated drive,
and do the same with the other failing drive.

Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak   <kas at {fi.muni.cz - work | yenya.net - private}> |
| New GPG 4096R/A45477D5 -- see http://www.fi.muni.cz/~kas/pgp-rollover.txt |
| http://www.fi.muni.cz/~kas/     Journal: http://www.fi.muni.cz/~kas/blog/ |
           Smart data structures and dumb code works a lot better
           than the other way around.           --Eric S. Raymond
