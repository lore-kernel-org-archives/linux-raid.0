From: Brian Ristuccia <bristuccia@starentnetworks.com>
Subject: best effort rebuild with 1 failed, 1 marginal disks in raid5?
Date: Sun, 28 Nov 2004 11:06:50 -0500
Message-ID: <20041128160649.GB30940@sw.starentnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 3 disk raid5 array which recently suffered catastrophic failure of
one disk. While the array was degraded, one more disk failed out of the
array due to a bad block. Investigation with badblocks reveals the marginal
disk has only a handful of bad blocks.

What I'd like to do is start the array with the good disk and the marginal
disk, add a 3rd known good disk, and rebuild the array as best as possible.
Then I'd fail the marginal disk and install another good disk.  Finally, I'd
use the list from badblocks, debugfs, some algebra, and some guesswork to
determine which files I need to restore from backups. Since there's only a
few bad blocks, I suspect it'll be just a few files from tape and perhaps
fishing some stuff out of lost+found if any directories got damaged.

I am able to force the marginal disk back into the array with the '-f'
option to mdadm --assemble. When I add a 3rd good disk back into the set, it
begins a rebuild. But when it gets to one of the bad blocks on the marginal
disk, that disk is removed from the array and I'm left with a non-working
array and the rebuild stops.

Is there any way to tell the kernel raid resync stuff to make a best effort
for the rebuild, writing empty or bogus data for the bad blocks? This
filesystem is fairly large, so if I can avoid a complete restore from
backup it would save a lot of time. Also, it would make it vastly easier to
recover the files created between the most recent backup and now, which
would otherwise be quite laborious because currently I have to manually
reactivate the array every time my tar or dump stumbes on a file or
directory with a bad block. 

Note that I've already attempted the trick of trying to clear bad blocks by
writing to them similar to what's documented at
http://smartmontools.sourceforge.net/BadBlockHowTo.txt without much success.
I get I/O errors on write to these blocks also.

-- 
Brian Ristuccia
