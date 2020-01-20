From: "Andrey ``Bass'' Shcheglov" <andrewbass@gmail.com>
Subject: Re: Repairing a RAID1 with non-zero mismatch_cnt
Date: Tue, 21 Jan 2020 01:30:41 +0300
Message-ID: <CADSg1Jj3XmD_RmSedn3AT9uCXbHQGa6ATBK1UP33onS8Vi=60g@mail.gmail.com>
References: <CADSg1Jh1i+OPq0_hWOvHxK0xroUbn_w0_ZjxjwcnrbSsBXGY5A@mail.gmail.com>
 <5E25876A.1030004@youngman.org.uk>
Reply-To: andrewbass@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E25876A.1030004@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Many thanks for your response, Wol.

On Mon, 20 Jan 2020 at 13:56, Wols Lists <antlists@youngman.org.uk> wrote:
>
> > The question is: is it possible to assemble an array in a read-only mode,
> > so that the underlying block device is never written to,
> > the metadata in the superblock remains intact and the event count is
> > not incremented?
> >
> > My intention is to avoid the resync when my original /dev/md0 is
> > reassembled from /dev/sda1 and /dev/sdb1.
> >
> Then how (assuming one drive is corrupt) are you going to re-assemble
> the array without forcing a resync on that drive?

Well, of course I will resync eventually, but

1. My original intention was to find the files residing on top of
corrupted blocks and then restore (rewrite) them using the data
recovered from the intact replica.
2. From my experience, an MD array may start re-syncing automatically
at system boot, and this is what I'd rather avoid -- I want to proceed
through all the steps manually, fully understanding what I is being
done.

> >
> > If you have any other recommendations on how to interactively repair
> > the array (I want to be able to peek at the data being synced),
> > I'd appreciate you sharing them.
> >
> My inclination (no warranty included!) would be to shut down the array,
> then assemble it with "/dev/sda1 missing" and --force if necessary. fsck
> that, then rinse and repeat with the second drive.
>
> Assuming neither drive has problems, you should then be able to assemble
> --assume-clean, which will prevent the sync, otherwise you'll have to
> just re-add the duff drive and let it resync.
>
> (In other words, why worry about the resync, because if you find the
> problem then you're going to have to resync to fix it, anyway.)

Thanks, will try that.

Does it make any sense to backup the superblocks of the replicas (e.
g.: using `dd`)?
And if so, then what precautions should be made before restoring the
superblock from a backup?

> Hint - look at dm-integrity. I believe you can put the integrity
> information elsewhere (if you've got a spare bit of disk space) so this
> issue won't arise again. It's new with raid, but apparently works fine
> with raid-1. Don't try it with the higher raids - 5 or 6 - yet.

Thanks, I'll give it a try.

Regards,
Andrey.
