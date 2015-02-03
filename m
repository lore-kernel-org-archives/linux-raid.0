From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Off-Topic Write cache disabling?
Date: Tue, 3 Feb 2015 12:49:44 -0600
Message-ID: <CAAMCDedvF+Nv9LYqM7Ddgg2xMQKtgQDntOsG0krxWCV4H+zQmA@mail.gmail.com>
References: <CAFE24U1G9+bqTzK4eD-cenyc5CGQQdrcu7S9Ks4CsHPS9wJ4zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFE24U1G9+bqTzK4eD-cenyc5CGQQdrcu7S9Ks4CsHPS9wJ4zA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Weedy <weedy2887@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In general if you completely disable write caching things will likely
be unusable.    When I have benchmarked things attempting to turn off
write cache performance has been mostly unusable.

I usually change /etc/sysctl.conf and change these entries to control
the amount of dirty cache.

vm.dirty_background_bytes = 25000000
vm.dirty_bytes = 50000000

That says max dirty allowed is 50mb, and it syncs down to 25mb when it syncs.

If you want to tighten things up I would lower those numbers down to
say 10mb/5mb and that should limit how much you can have in the dirty
cache.

You can obviously go lower, but I would expect issues if you get too
low, but I don't know what too low is.

On Tue, Feb 3, 2015 at 11:45 AM, Weedy <weedy2887@gmail.com> wrote:
> Is there a kernel option or sysfs toggle that disables write caching?
> Or forces the kernel to commit everything constantly.
>
> ------
> I don't really want to join another ML, especially a higher traffic
> one just to ask this when it only bugs me sometimes. But I'll shut up
> if this is unwanted.
> ------
>
> I use a similar kernel config with respect to selected options on all
> my systems but this only effect my laptop.
> On any of my personal system or system I have remote access too
> nr_dirty drifts up and down and nr_writeback stays around 0 (assuming
> the system isn't working hard).
> On my laptop both nr_dirty and nr_writeback stay at 0. I can make them
> go up to 10ish if I untar something but then almost immediately go
> back to 0. If I didn't know better I would swear dirty_*_centisecs or
> something was set to a near instant commit interval but I haven't
> found evidence of that. The hard drive light blinks almost constantly
> once a second, even if I'm at a X login screen.
> As I said this doesn't bug me most of the time but if I let my FF
> session get too large or start multiple VMs anything that might make
> me swap a little, the machine pretty much dies from IOWAIT. Which I'm
> guessing is because it's trying to flush (syncfs?) imediately and
> constantly.
>
> You guys spend all day in the IO subsystem, any idea where I can keep
> looking? It has persisted across reboots and kernel updates.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
