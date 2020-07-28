From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
Date: Tue, 28 Jul 2020 14:23:22 -0600
Message-ID: <CAJCQCtRx7NJP=-rX5g_n5ZL7ypX-5z_L6d6sk120+4Avs6rJUw@mail.gmail.com>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
 <CAJCQCtSfz+b38fW3zdcHwMMtO1LfXSq+0xgg_DaKShmAumuCWQ@mail.gmail.com> <29509e08-e373-b352-d696-fcb9f507a545@xmyslivec.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29509e08-e373-b352-d696-fcb9f507a545@xmyslivec.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Vojtech Myslivec <vojtech@xmyslivec.cz>
Cc: Chris Murphy <lists@colorremedies.com>, Michal Moravec <michal.moravec@logicworks.cz>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 28, 2020 at 7:31 AM Vojtech Myslivec <vojtech@xmyslivec.cz> wrote:

> > dmesg
> > mdadm -E
> > mdadm -D
> > btrfs filesystem usage /mountpoint
> > btrfs device stats /mountpoint

These all look good.


> > SCT Error Recovery Control:
> >            Read:    100 (10.0 seconds)
> >           Write:    100 (10.0 seconds)
>
> It is higher than you expect, yet still below kernel 30 s timeout, right?

It's good.


> > It's not related, but your workload might benefit from
> > 'compress=zstd:1' mount option. Compress everything across the board.
> > Chances are these backups contain a lot of compressible data. This
> > isn't important to do right now. Fix the problem first. Optimize
> > later. But you have significant CPU capacity relative to the hardware.
>
> OK, thanks for the tip. Overall CPU utilization is not high at the
> moment. The server is dedicated to backups so I can try this.
>
> In fact, I am scared a bit of any compression related to btrfs. I do not
> to blame anyone, I just read some recommendation about disabling
> compression on btrfs (Debian wiki, kernel wiki, ...).

That's based on ancient kernels. Also the last known bug was really
obscure, I never hit it. You had to have some combination of inline
extents and also holes. You're using 5.5, and that has all bug fixes
for that. At least Facebook folks are using compress=zstd:1 pretty
much across the board and have a metric s ton of machines they're
doing this with, so it's reliable.

> In most cases backups are pretty fast and it runs only one at a time.
> From the logs on the server, I can see it it get stuck when only one
> backup process is running.
>
> But I am not able to tell if a background btrfs-cleaner procces is
> running at that moment. I can focus on this if it helps.

Your dmesg contains
[ 9667.449898] INFO: task md1_reclaim:910 blocked for more than 120 seconds.

It might be helpful to reproduce and take sysrq+w at the time of the
blocking. Sometimes it's best to have the sysrq trigger command ready
in a hell, but don't hit enter until the blocked task happens.
Sometimes during blocked tasks it takes forever to issue a command.

It would be nice if an md kernel developer can comment on what's going on.

Does this often happen when a btrfs snapshot is created? That will
cause a flush to happen and I wonder if that's instigating the problem
in the lower layers.


-- 
Chris Murphy
