From: David Mansfield <md@dm.cobite.com>
Subject: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 11:36:33 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1098718593.5399.29.camel@duxeon.cobite.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

After a few recent severe raid failures (one linux md, one 3ware), my
understanding and fear about linux md is greatly increased.  Single
sector unrecoverable errors are doing us in!

To alleviate these fears, we (my coworkers and I) believe we need to
start a policy of conducting a 'background media scan' of the actual
underlying physical devices in a raid 5.  This is easily accomplished on
the 3ware (it's built in), but we are struggling with linux md.

A utility called SCU, http://www.bit-net.com/%7Ermiller/scu.html, will
allow us to scan the media, and, if necessary, reassign the bad blocks. 
We have used this on scsi disks before, it seems to work, as a lowlevel
tool.

However! If two bad blocks are discovered on two different disks in the
raid 5 (even if the bad blocks are in different stripes), we will be
screwed, because the raid system will kick out the disk immediately when
the first bad sector is found, and then reconstruction will fail when
the second bad sector is found.  screwed.

Which brings me (finally) to my questions:

1) does linux md have a plan for integrating background media scanning
and automatic sector reassignment like hardware solutions have?

2) how can we force (or manually perform) a stripe-wise resync? is it
possible to take the raid offline completely, read the data with dd,
compute the parity manually, reassign the bad block using SCU and
rewrite the parity block with dd then put the raid online again?

If #2 is possible, I'm sure a quick-and-dirty perl script could be
created to do the work, which I'd be happy to do, if it's theoretically
doable.

Thanks,
David


