From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Recovering From RAID5 Failure
Date: Tue, 21 Apr 2020 11:22:24 -0500
Message-ID: <CAAMCDeegCE4x26L4OYttiABxvxiu4qYykAo-b-53G-qW8Ua1Hw@mail.gmail.com>
References: <CAM++EjGaFBh8ZChnyY0p=du0CKFT1WVikSNYyUUcJhuKwQf4sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAM++EjGaFBh8ZChnyY0p=du0CKFT1WVikSNYyUUcJhuKwQf4sQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leland Ball <lelandmball@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Do a smartctl --all /dev/sdX against each disk and post that.


On Tue, Apr 21, 2020 at 11:16 AM Leland Ball <lelandmball@gmail.com> wrote:
>
> Hello,
>
> I have an old NAS device (Iomega StorCenter ix4-200d  2.1.48.30125)
> which has failed to warn me that things were going awry. The NAS is
> now in a state that appears unrecoverable from its limited GUI, and is
> asking for overwrite confirmation on all 4 drives (1.8TB WD drives).
> This smells of data loss, so I hopped on the box and did some
> investigating:
>
> I can "more" to find data on each of two partitions for each of the 4
> drives /dev/sd[abcd][12] so the drives are functioning in some
> capacity. I believe this is running in a RAID 5 configuration, at
> least that's what the settings state.
>
> Here's what I'm working with...
> # mdadm --version
> mdadm - v2.6.7.2 - 14th November 2008
>
> I believe the array was first created in 2011. Not sure if the disks
> have been replaced since then, as this array was given to me by a
> friend.
>
> I am unsure of how I should go about fixing this, and which (if any)
> drives truly needs replacing. My next step would be to try:
> # mdadm /dev/md1 --assemble /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
> (and if that didn't work, maybe try the --force command?). Would this
> jeopardize data like the --create command can?
>
> I've compiled output from the following commands here:
> https://pastebin.com/EmqX3Tyq
> # fdisk -l
> # cat /etc/fstab
> # cat /proc/mdstat
> # mdadm -D /dev/md0
> # mdadm -D /dev/md1
> # mdadm --examine /dev/sd[abcd]1
> # mdadm --examine /dev/sd[abcd]2
> # cat /etc/lvm/backup/md1_vg
> # dmesg
> # cat /var/log/messages
>
> I don't know if md0 needs to be fixed first (if it's even
> malfunctioning). I have never administered RAID volumes at this level
> before. Would appreciate any help you can provide. Thanks!
