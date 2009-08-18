From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Hot-swapping: what's that? (and 3ware 9650SE)
Date: Tue, 18 Aug 2009 16:12:06 -0400
Message-ID: <87f94c370908181312o3b349c15r41d93c1dd4a75843@mail.gmail.com>
References: <4A8AFC5F.3070108@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A8AFC5F.3070108@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: kwick <kwick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 18, 2009 at 3:09 PM, kwick<kwick@shiftmail.org> wrote:
> Hello raid-ers
> I have been reading previous posts in this ML regarding hot-swapping
> capability of controllers or the lack thereof.
>
> One question remains: ok but what is hot-swap anyway?

I think originally hot-swap meant swapping components with power
connected.  i.e You don't have to power down the whole computer to
swap components.

At least on the sata list they now tend to use hot-swap to mean you
can walk up to a chassis and just pull the drive and plug in another
and the system will recognize it is a new drive automatically.  But
they ONLY mean it at the sata level.

They talk about warm-swap if you have to have user interaction
involved.  So if a controller is warm-swap only you have to manually
trigger a sata bus scan before the new drive is visible.

> If I have a controller that does not notify the operating systems of
> drive removal and insertions, but will give error if one writes to the
> device while the HDD is disconnected, and will correctly write to the
> disk if the HDD is later reconnected, would this be "hot-swap"?

It is hot-swap at the hardware level anyway.

I don't know if mdraid and the low level sata drivers are integrated
enough to call it hot-swap from a users perspective.

ie. Does the user have to manually trigger a reconfig / rebuild, or
does it happen automatically?

> Actually we have a 3ware 9650SE controller in JBOD mode here, and it
> behaves very similarly to what I have described. Two differences:
> 1- it actually notifies the OS of drive removal, I can see that in
> dmesg, but the block device special-files are still not deleted from the
> system in response to this. However if you read or write from those
> block devices it immediately returns error (dd stops immediately)
> 2- you need to use the tw_cli commandline prog to rescan the controller
> after the drives' insertion (doing this you can decide whether notify
> the OS or not, but this apparently does not make a substantial
> difference, it just gets logged in dmesg). The new inserted drives will
> get the old drive letters (block-device files), i.e. the drive letters
> stay attached to the physical slots, except the case in which you are
> reordering drives, in this latter case the controller will try to remap
> the "units" so that the drive letters follow the HDDs (it uses the
> serial numbers to identify the HDDs).
>
> So is this a "hot-swap" controller or not? What is hot-swap more than this?

You had to use tw_cli to scan rescan the controller.  I would call
that warm swap even at the hardware level.

> BTW I'd have a few more questions which are important for us, related to
> hot-swapping. I understand these might be offtopic here, but I see you
> are knowledgeable over this matter, so I hope I can ask:
>
> With the 9650SE as described before, I would like to reliably flush all
> data to a drive before removing the drive manually.
> - Do you confirm that "umount" is not enough for flushing the block device?
> - Is the bash "sync" command / sync() syscall what I have to use? (after
> umount)
> - Is the sync() enough anyway?

I personally think of umount being stronger than just sync.  So I
umount a drive before pulling it out.  I'm fairly confident the umount
does an internal drive sync at the end of the process so there is no
need to umount; sync;

sync by itself should be good enough IF you know for sure no processes
are still writing to the drive and IF you have a journaled filesystem
in use.  Even with a journaled filesystem the unapplied journal
entries will have to be applied the next time you mount the drive.

fyi: fat has unique mount option that is much more efficient than full
"sync" mode on mount, but that keeps the disk cache written  to disk
most of the time.  It was written to support thumbdrives that people
want to plug in, use, and unplug with no other user action.

fyi2: I would call thumbdrives that mount automatically with mount
option truly hot-swap all the way up and down the stack.

>
> Thank you
> kwick

Greg
