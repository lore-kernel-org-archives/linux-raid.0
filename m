From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Redundancy check using "echo check > sync_action": error
	reporting?
Date: Sat, 22 Mar 2008 09:27:33 -0400
Message-ID: <20080322132733.GR7991@mit.edu>
References: <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <20080321171348.GK7991@mit.edu> <47E3F1EF.3030705@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E3F1EF.3030705@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Bill Davidsen <davidsen@tmr.com>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 21, 2008 at 06:35:43PM +0100, Peter Rabbitson wrote:
>
> Of course it would be possible to instruct md to always read all 
> data+parity chunks and make a comparison on every read. The performance 
> would not be much to write home about though.

Yeah, and that's probably the real problem with this scheme.  You
basically reduce the read bandwidth of your array down to a single
(slowest) disk --- basically the same reason why RAID-2 is a
commercial failure.  

I suspect the best thing we *can* to do is for filesystems that
include checksums in the metadata and/or the data blocks, is if the
CRC doesn't match, to have the filesystem tell the RAID subsystem,
"um, could you send me copies of the data from all of the RAID-1
mirrors, and see if one of the copies from the mirrors causes a valid
checksum".  Something similar could be done with RAID-5/RAID-6 arrays,
if the fs layer could ask the RAID subsystem, "the external checksum
for this block is bad; can you recalculate it from all available
parity stripes assuming the data stripe is invalid".

Ext4 has metadata checksums; U Wisconsin's Iron filesystem (sponsored
with a grant from EMC) did it for both data and metadata, if memory
serves me correctly.  ZFS smashed through the RAID abstraction barrier
and sucked up RAID functionality into the filesystem so they could
this sort of thing; but with the right new set of interfaces, it
should be possible to add this functionality without reimplementing
RAID in each filesystem.

As far as the question of how often this happens, where a disk
silently corrupts a block without returning a media error, it
definitely happens.  Larry McVoy tells a story of periodically running
a per-file CRC across a backup/archival filesystems, and was able to
detect files that had not been modified changing out from under him.
One way this can happen is if the disk accidentally writes some block
to the wrong location on disk; the blockguard extension and various
enterprise databases (since they can control their db-specific on-disk
format) will encode the intended location of a block in their
per-block checksums, to detect this specific type of failure, which
should broad hint that this sort of thing can and does happen.

Does it happen as much as ZFS's marketing literature implies?
Probably not.  But as you start making bigger and bigger filesystems,
the chances that even relatively improbable errors happen start
increasing significantly.  Of course, the flip side of the argument is
that if you are using the huge arrays to store things like music and
video, maybe you don't care about a small amount of data corruption,
since it might not be noticeable to the human eye/ear.  That's a
pretty weak argument though, and it sends shivers up the spins of
people who are storing, for example, medical images of X-ray or CAT
scans.

						- Ted
