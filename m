From: Mike Hardy <mhardy@h3c.com>
Subject: Re: bit-rot, crc errors, etc question
Date: Thu, 06 Oct 2005 11:21:14 -0700
Message-ID: <43456B1A.3090806@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mjstumpf@pobox.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Meant to send this to the list as well, just sent it to Michael Stumpf
the first time. Its generally applicable though.

Any other / better thoughts very welcome...

-Mike

-------- Original Message --------
Subject: Re: bit-rot, crc errors, etc question
Date: Thu, 06 Oct 2005 11:19:59 -0700
From: Mike Hardy <mhardy@h3c.com>
To: mjstumpf@pobox.com
References: <43455064.8020102@pobox.com>


Assuming you're running PATA, use smartd to scheduled staggered daily
short tests, and weekly extended tests of all drives.

If you install smartmontools, you even get a nifty logwatch script that
digests all the disk stats and puts them in the daily maintenance emails.

You'll see a progression of soft read failures, to ECC recovered errors
to unrecoverable block errors generally.

When that happens you just fail the drive, use dd to directly plink the
bad blocks so the drive internals relocate them, use dd again to read
from the blocks to verify they're gone, then re-add the disk. I'd add
that its not a bad idea to put the affected array in read-only mode
while redundancy is lost, unless you're using raid6.

Not much muss, not much fuss.

If you're using SATA, lobby for SMART over SATA to be included in the
mainline kernels, possibly in the form of testing it.

Alternatively, it appears that Neil has just posted a bunch of patches
that enable full raid5 parity scans. That would be nearly as good as
smartd, except it won't tell you drive temparature or alien plot details
the way smartd does :-)

Googling for "BadBlockHowTo" will lead to more info as well. In general
bad blocks are expected, and not hard to recover from. Its all about
proactive detection and quick recovery so redundancy is maintained as
much as possible.

-Mike

Michael Stumpf wrote:
> Quick question:
> 
> Been running a large ext3 filesystem on an LVM set with multiple linux
> /dev/mdX raid5 arrays underneath.  Recently, upon trying to do full
> identical rewrites of every bit (literally) of data, I'm starting to
> find cases where the server locks up/reboots, and the culprit seems to
> be tracked to a first failure of one of the ATA drives having a bad
> CRC.  Replacing the single bad drive fixes the issue.
> 
> My best guess is this:  the filesystem is built on the LVM, composed of
> extents.  The extents reside on physical volumes.  The physical volumes
> are developing uncorrectable errors through natural use/time/heat/secret
> alien plot.  These silent failures sit around until I try to access
> those pieces of those drives, at which point big catastrophic failures
> occur, incurring downtime, potential data loss, and expense.
> 
> How can I 1) prevent this,  2) detect this,  3) correct this without
> tossing the drive for a single small bad area?
> 
> Is the md driver set smart enough to correct around such physical media
> errors?  Are there ways via mdadm/other tools to actively scan for such
> bad areas (obviously in this case filesystem tools to do this are
> useless, right)?  Can I potentially continue using this "bad" drive by
> somehow applying a correction?
> 
> Regards-
> Michael Stumpf
