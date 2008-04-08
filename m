From: "Sean H." <silverwraithii@gmail.com>
Subject: Re: Re-assembling a software RAID in which device names have changed.
Date: Tue, 8 Apr 2008 13:55:24 -0400
Message-ID: <fa037c550804081055p2d2550ccs8dfab22d2edb6920@mail.gmail.com>
References: <fa037c550804072134w59f0f280g3d86ed76a99a271e@mail.gmail.com>
	 <47FBAA76.20008@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47FBAA76.20008@msgid.tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>
List-Id: linux-raid.ids

On Tue, Apr 8, 2008 at 1:25 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> Sean H. wrote:
>
> > To preface, I'm a fairly new Linux user, and have little experience
> > with RAID. I've taken this question several places and have yet to get
> > an answer which solves my problem, so I figured I'd come to the
> > experts.
> >
> > I have a five-disk RAID 5, and one of the disks is failing. Every few
> > days it'll start buzzing, and will continue buzzing until the drive is
> > forced to spin down and back up, by either a restart or suspending to
> > RAM.
> >
> >  Now, today, I wanted to determine which disk was failing, so I
> > unmounted my array and unplugged drives - Specifically, three. The
> > third was the culprit, and I plugged the drives back in and rebooted.
> >
> >  The gift, or in this case, curse of my motherboard is that it
> > supports hot-swapping of SATA drives. So the drives didn't just
> > disappear inside the OS and reappear after a reboot. They disappeared
> > and re-appeared in the OS with incorrect /dev/sd* locations, and then
> > I rebooted.
> >
> >  I was unable to boot until I removed the line detailing the array
> > from my fstab. Now, when I manually 'mdadm --assemble /dev/md0' mdadm
> > finds the two untouched drives, then stops and tells me that they're
> > not enough to start the array.
> >
> >  So... How can I reassemble the array without knowing what order the
> > drives are in?
> >
>
>  Don't list individual component devices in mdadm.conf.
>  Use array UUIDs instead.
>
>  I.e., instead of:
>
>  --- WRONG ---
>  ARRAY /dev/md1 devices=/dev/sda1,/dev/sdb1,/dev/sdc1
>  --- WRONG ---
>
>  use this:
>
>  --- RIGHT ---
>  ARRAY /dev/md1 UUID=11111111:22222222:33333333:44444444
>  --- RIGHT ---
>
>  Or use modern ways to assemble the arrays - such as homehost
>  (requires version 1 superblock).
>
>  In either case mdadm will find the relevant components (assuming
>  DEVICE line in mdadm.conf is correct) and figure out the right
>  order.
>
>  /mjt
>

My mdadm.conf is configured with UUIDs:

# mdadm.conf written out by anaconda
DEVICE partitions
MAILADDR root
ARRAY /dev/md0 level=raid5 num-devices=5
uuid=58dcdaf3:bdf3f176:f2dd1b6b:f095c127

Tried the following: 'mdadm --assemble /dev/md0 --uuid
58dcdaf3:bdf3f176:f2dd1b6b:f095c127'
... and got this: mdadm: /dev/md0 assembled from 2 drives - not enough
to start the array.
(Which is what I've been getting for a while, now.)

It's possible to correct this issue by unplugging the three drives and
plugging them back in and rebooting, so the drives get their original
/dev/sd* locations, is it not? (Even if it it possible, I'd like to
learn how to fix problems like this at the software level over the
hardware level.)
