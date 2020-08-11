From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Recommended filesystem for RAID 6
Date: Tue, 11 Aug 2020 21:23:05 +0500
Message-ID: <20200811212305.02fec65a@natsu>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 11 Aug 2020 00:42:33 -0400
George Rapp <george.rapp@gmail.com> wrote:

> Use case is long-term storage of many small files and a few large ones
> (family photos and videos, backups of other systems, working copies of
> photo, audio, and video edits, etc.)? Current usable space is about
> 10TB but my end state vision is probably upwards of 20TB. I'll
> probably consign the slowest working disks in the server to an archive
> filesystem, either RAID 1 or RAID 5, for stuff I care less about and
> backups; the archive part can be ignored for the purposes of this
> exercise.
> 
> My question is: what filesystem type would be best practice for my use
> case and size requirements on the big array? (I have reviewed
> https://raid.wiki.kernel.org/index.php/RAID_and_filesystems, but am
> looking for practitioners' recommendations.)  I've run ext4
> exclusively on my arrays to date, but have been reading up on xfs; is
> there another filesystem type I should consider? Finally, are there
> any pitfalls I should know about in my high-level design?

Whichever filesystem you choose, you will end up with a huge single point of
failure, and any trouble with that FS or the underlying array put all your
data instantly at risk. "But RAID6" -- what about a SATA controller failure,
or a flaky cabling/PSU/backplane, which disconnects, say, 4 disks at once "on
the fly". What about a sudden power loss amidst heavy write load. And so on.

First of all, ask yourself -- is all of this backed up? If no, then go and buy
more drives until the answer is yes. With current drive prices, or as you say,
with having lots of spare old drives lying around, there's no excuse to leave
anything non-trivial not backed up.

Secondly -- if all of this... is BACKED UP ANYWAY, why even run RAID? And with
RAID6, even waste 2 more drives for redundancy. Do you need 24x7 uptime of your
home NAS, do you have hotswap cages, do you require that the server absolutely
stays online while a disk is being replaced.

Most likely you do not. And the RAID's main purpose in that case is to just
have a unified storage pool, for the convenience of not having to manage free
space across so many drives. But given the above, I would suggest leaving the
drives with their individual FSes, and just running MergerFS on top: 
https://www.teknophiles.com/2018/02/19/disk-pooling-in-linux-with-mergerfs/

Massively simpler and more resilient, no longer a huge array which also needs
to be painstakingly reshaped up and down when you add/remove space. Just add an
extra disk and done. Of course no redundancy, hence the backups part. If a
drive fails, everything that was on that drive is gone. But the best part is,
ONLY what was on that drive. Plug a new one, restore the lost files from
backup, done. One caveat, need to keep a record of what's on each drive, I do
that with a command like "find /mnt/* > /somewhere/list-$date.txt", kept
periodically updated. Yes I use such solution myself now, having migrated from
a Btrfs on top of MD RAID, after a "flaky cabling"-induced complete failure of
the array-wide FS.

For the FS considerations, the dealbreaker of XFS for me is its inability to
be shrunk. The ivory tower people do not think that is important enough, but
for me that limits the FS applicability severely. Also it loved truncating
currently-open files to zero bytes on power loss (dunno if that's been
improved). IIRC JFS can't be shrunk either, but it seems like that one can be
considered legacy at this point. The remaining filesystems that can be freely
resized are Ext4 and Btrfs. In any case, do not go with Btrfs' built in RAID
yet:
https://lore.kernel.org/linux-btrfs/20200627032414.GX10769@hungrycats.org/

-- 
With respect,
Roman
