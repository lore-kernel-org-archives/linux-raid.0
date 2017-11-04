From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID header in XFS area?
Date: Sat, 4 Nov 2017 18:30:17 +0000
Message-ID: <59FE0739.8020400@youngman.org.uk>
References: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/17 18:10, David F. wrote:
> Question,  We had a customer remove a drive from a NAS device that as
> mirrored using mdadm, the file system id for the partitions were 0xFD
> (linux raid automount). The put it on a USB port and booted Linux
> which attempts to mount any RAID devices.  The XFS had some issues, so
> looking at it I see some type of RAID header for MyBook:2 at offset
> 4K.   Searching Internet on mdadm found:

First things first. DO NOT mount the array read/write over a USB
connection. There's a good chance you'll regret it (raid and USB don't
like each other).
> 
> Version 1.2: The superblock is 4 KiB after the beginning of the device.
> 
> I wouldn't think the RAID area would be available to the file system,
> but assuming so, there must be some type of way to find out where the
> real data for that went?   Or perhaps mdadm messed it up when trying
> to mount and the other drive didn't exist.  Here details of it.

mdadm did exactly what it is supposed to do. A mirror with one drive is
degraded, so it assembled the array AND STOPPED. Once you force it past
this point, I think it will happily go past again no problem, but it's
designed to refuse to proceed with a damaged array, if the array was
fully okay previous time.

So, in other words, the disk and everything else is fine.

What's happened is that mdadm has assembled the array, realised a disk
is missing, AND STOPPED.

What should happen next is that the array runs, so you need to do
mdadm --run /dev/md0
or something like that. You may well need to add the --force option.

Finally you need to mount the array
mount /dev/md0 /mnt READ ONLY !!!
Sorry, I don't know the correct option for read only

At this point, your filesystem should be available for access.
Everything's fine, mdadm is just playing it safe, because all it knows
is that a disk has disappeared.

And you need to play it safe, because USB places the array in danger.

Cheers,
Wol
