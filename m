From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: mdadm: Assemble.c: "force-one" update conflicts with the
 split-brain protection logic
Date: Tue, 28 Aug 2012 10:45:49 +0300
Message-ID: <CAGRgLy7fy49gVAAR4Ti6Hotb1Aw+0UQ9aKBmjzB+uMiqB13qMw@mail.gmail.com>
References: <CAGRgLy5zfK+wLNfMHxAaEsYs=6qeSA4iqaWDZoUhh8a1D2eBBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5zfK+wLNfMHxAaEsYs=6qeSA4iqaWDZoUhh8a1D2eBBg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
yet another issue that I see with the "force-one" update, is that it
does not increment the event count on the bitmap of the appropriate
device.

Here is a scenario that I hit:

# raid5 with 4 drives: A,B,C,D
# drive A fails, then drive B fails
# force-assembly is performed
# drive B has higher event count than A, so it is selected for the
"force-one" update. However, the "force-one" update does not update
the bitmap event counter. As a result, the following happens:
# array is started in the kernel
# bitmap_read_sb() is called and calls read_sb_page()
# read_sb_page() loops through devices and picks the first one that is
In_sync. In our case, this is drive B. So bitmap superblock from drive
B is read. But this superblock has a stale event count. It was not
updated by "force-one". So, as a result, bitmap is considered as stale
and marked as BITMAP_STALE.
# As a result of BITMAP_STALE, bitmap->events_cleared is set to
mddev->events (and also the bitmap is set to all 1's)
# Later, when drive A is re-added, its event count is less than
events_cleared, because events_cleared has been bumped up. So drive A
is rejected by re-add.

The workaround in this case, is to wipe the superblock on A and add it
as a fresh drive.

Thanks,
Alex.


On Wed, Aug 22, 2012 at 8:50 PM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
> Hi Neil,
> I see the following issue:
>
> # I have a raid5 with drives a,b,c,d. Drive a fails, and then drive b
> fails, and so the whole array fails.
> # Superblocks of c and d show a and b as failed (via 0xffe in
> dev_roles[] array).
> # Now I perform --assemble --force
> # Since b has higher event count than a, b's event count is bumped to
> match the event count of c and d ("force-one")
> # However, something goes wrong and assembly is aborted
> # Now assembly is restarted (--force doesn't matter now)
>
> At this point, drive b is chosen as "most_recent", since it comes
> first and has highest event count (equal to c and d).
> However, when drives c and d are inspected, they are rejected by the
> following split-brain protection code:
>                 if (j != most_recent &&
>                     content->array.raid_disks > 0 &&
>                     devices[most_recent].i.disk.raid_disk >= 0 &&
>                     devmap[j * content->array.raid_disks +
> devices[most_recent].i.disk.raid_disk] == 0) {
>                         if (c->verbose > -1)
>                                 pr_err("ignoring %s as it reports %s as failed\n",
>                                         devices[j].devname, devices[most_recent].devname);
>                         best[i] = -1;
>                         continue;
>                 }
>
> because the dev_roles[] array of c and d show b as failed (because b
> really had failed while c and d were operational).
>
> So I was thinking that the "force-one" update should also somehow
> align the dev_roles[] arrays of all devices that it affects. More
> precisely, if we decide to promote a device via "force-one" path, we
> must update dev_roles[] of all "good" devices to say that the promoted
> device is not 0xffe, but has a valid role. Does this make sense? What
> do you think?
>
> And I also think, that the split-brain protection logic that you added
> should be made a little bit more explicit. Currently, the first device
> with the highest event count is selected as "most_recent", and
> split-brain protection is enforced WRT to that device. But this logic
> can be affected by the order of devices passed to "assemble". I
> already mentioned that in the past I pitched a proposal of dealing
> with it. Do you want me to go over it and try to pitch it again?
>
> Thanks!
> Alex.
