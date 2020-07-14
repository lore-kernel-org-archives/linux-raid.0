From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Reshape using drives not partitions, RAID gone after reboot
Date: Tue, 14 Jul 2020 18:27:39 -0500
Message-ID: <CAAMCDec22wshoG8eb9aM4su-EBdJRbh_LyVtaskR9FbYc4f=gw@mail.gmail.com>
References: <b551920e-ddad-c627-d75a-e99d32247b6d@gmail.com> <0b857b5f-20aa-871d-a22d-43d26ad64764@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0b857b5f-20aa-871d-a22d-43d26ad64764@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>
Cc: Adam Barnett <adamtravisbarnett@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Did you create the partition before you added the disk to mdadm or
after?  If after was it a dos or a gpt?  Dos should have only cleared
the first 512byte block.  If gpt it will have written to the first
block and to at least 1 more location on the disk, possibly causing
data loss.

If before then you at least need to get rid of the partition table
completely.   Having a partition on a device will often cause a number
of things to ignore the whole disk.  I have debugged "lost" pv's where
the partition effectively "blocked" lvm from even looking at the
entire device that the pv was one.

If it is a dos partition table then:
save a backup of each disk first (always a good idea, you can dd it
back if you screwed up so long as you carefully create the backups and
name them properly).
dd if=/dev/sdx of=/root/sdxbackup.img bs=512 count=1
then clear the partition table space, rebooting is probably the
easiest way to clear out the mappings, it can be done without
rebooting but I have to do it trial and error to figure out the exact
order and commands.
dd if=/dev/zero of=/dev/sdX bs=512 count=1

On Tue, Jul 14, 2020 at 6:11 PM antlists <antlists@youngman.org.uk> wrote:
>
> On 14/07/2020 20:50, Adam Barnett wrote:
> > Forcing the assembly does not work:
> >
> > $ sudo mdadm /dev/md1 --assemble --force /dev/sd[ijmop]1 /dev/sd[kln]
> > mdadm: /dev/sdi1 is busy - skipping
> > mdadm: /dev/sdj1 is busy - skipping
> > mdadm: /dev/sdm1 is busy - skipping
> > mdadm: /dev/sdo1 is busy - skipping
> > mdadm: /dev/sdp1 is busy - skipping
> > mdadm: Cannot assemble mbr metadata on /dev/sdk
> > mdadm: /dev/sdk has no superblock - assembly aborted
>
> Did you do an "mdadm --stop /dev/md1" before trying that? That's a
> classic error from an array that's previously been partially assembled
> and failed ...
>
> The other thing I'd do is make sure there aren't any other unepected
> partially assembled arrays. I doubt it applies here, but I have come
> across mirrors that get broken in half and you get two failed arrays
> instead of one working one ...
>
> Cheers,
> Wol
