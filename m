From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: raid 5 corruption
Date: Wed, 8 Mar 2006 11:29:14 +0100
Message-ID: <62b0912f0603080229i61fab398p28f541e00a424699@mail.gmail.com>
References: <37363.127.0.0.1.1141797527.squirrel@a2s5.a2hosting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37363.127.0.0.1.1141797527.squirrel@a2s5.a2hosting.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: goldfita@signalsguru.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Todd <goldfita@signalsguru.net> wrote:
> The strangest thing happened the other day. I booted my machine
> and the permissions were all messed up. I couldn't access many
> files as root which were owned by root. I couldnt' run common
> programs as root or a standard user.

Odd, have you found out why?
What was the first error you saw?

> So I restarted and it wouldn't mount my raid drive (raid 5, 5 disks).
> I tried doing it manually from the livecd, and it's telling me it
> can't mount with only 2 disks.

Is that because the kernel found only 2/5 physical disks,
or because MD thinks that they're out-of-date?

> I tried to force with four drives and it claims there's no
> superblock for sda3.

Try mdadm --assemble --force again, but exclude sda3 and
assemble the array using the 4 other drives instead?

You might want to run mdadm to query the superblock on each device.

You can post the output to this list so others will be able to see
which of your drives are considered 'freshest' by MD etc.

> There's nothing wrong with my disks. I can mount the boot partition.

One doesn't imply the other.  And since you don't tell where the boot
partition resides, it hardly seems relevant to your RAID devices..

> It's fine as far as I can tell. Does anyone know what's going on?
> Has anyone else experienced this?
> I have had problems in the past with other machines.
> One time a redhat machine locked up in X.

Yeah, I've had X lock up on me quite a lot.

> I don't know if it was just X or the kernel.

Probably the graphics driver.

> I restarted and it couldn't find the root i-node.
> It may have been correctable, but I just reinstalled.
> It seems strange that windows can crash on me every day and
> it still starts right back up. (I still have 98.)
> But linux seems to have more fragile file systems.

Windows' flushing policy is a LOT more sane than Linux'.
That's probably why you'll rarely get corrupted filesystems
with Windows, and often with Linux.

Like you, I've had filesystem corruption after system crashes
happen to me with Linux quite a lot, and never (even though
it crashes much more often) with Windows.

My guess is that the Linux kernel folks are more concerned with
a .01% improvement in performance than with your data and that's
why the policy is as it is..  But I could easily be wrong, so take
it with a grain of salt.
