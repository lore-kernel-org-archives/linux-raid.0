From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: new superblock and raid10 support in mdadm
Date: Tue, 14 Sep 2004 11:08:53 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16710.17573.491674.378912@cse.unsw.edu.au>
References: <1095088590.3713.4.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rich turner on Monday September 13
To: rich turner <rich@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 13, rich@storix.com wrote:
> the latest source of mdadm has ANNOUNCE-1.7.0 which indicates there will
> be a new superblock format. we are currently developing a process by
> which we read the superblock ourselves and parse through the information
> we need about the raid devices. our fear is that we develop the process
> to read the superblock and then it changes, which could cause us to
> completely rewrite the process.
> if we develop a process based on the current superblock format, will it
> still work with the new superblock format?

The old (current) super block format will continue to work and will
continue to be widely used.  It would be entirely appropriate that you
require people who use your tool/service to continue to use the old
format.  However I suspect it would not be a great burden for you to
support the new format as well if/when it became popular.

A new format is being supported because the old format has problems.
One is that it cannot work with devices larger than 2 Gigabytes (and I
have had a request from someone who wanted to include such a device in
an MD array).
Another is that it cannot support checkpointing of reconstruction in a
backwards compatible way (we have checkpointing of resync, but not
reconstruct).

If neither of these are a problem (and they won't be for many people)
then the old superblock format can and will still be used.

> is there any documentation for the format of the old superblock and new
> superblock?

Not in great detail.  include/linux/raid/md_p.h is probably the best
you will get.  When I finish new superblock support in mdadm, I will
probably add some documentation.


> will there be any indication within the superblock that indicates which
> format the superblock is using?

Definitely.  The "major_version" will be '1' for the new format, and
'0' for the old.

> 
> ANNOUNCE-1.7.0 also indicated support for raid10. outstanding news!
> while i understand this is still under development, we would like to
> learn as much as we can about this support so that we can support it
> when it is considered stable. any information you can provide is
> helpful.

The raid10 module is in 2.4.9-rc2 and will be in 2.4.9 when it gets
released. 
There is a comment at the top of drivers/md/raid10.c that briefly
describes the layout.  More documentation should appear in the next
mdadm release.

I include the mentioned comment below.

NeilBrown


/*
 * RAID10 provides a combination of RAID0 and RAID1 functionality.
 * The layout of data is defined by
 *    chunk_size
 *    raid_disks
 *    near_copies (stored in low byte of layout)
 *    far_copies (stored in second byte of layout)
 *
 * The data to be stored is divided into chunks using chunksize.
 * Each device is divided into far_copies sections.
 * In each section, chunks are laid out in a style similar to raid0, but
 * near_copies copies of each chunk is stored (each on a different drive).
 * The starting device for each section is offset near_copies from the starting
 * device of the previous section.
 * Thus there are (near_copies*far_copies) of each chunk, and each is on a different
 * drive.
 * near_copies and far_copies must be at least one, and there product is at most
 * raid_disks.
 */
