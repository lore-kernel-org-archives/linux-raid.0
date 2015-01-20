From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Subject: Re: kernel refuses devices mdadm -E accepts
Date: Tue, 20 Jan 2015 19:43:40 +0100
Message-ID: <CAA-O0XjtzHkm28rmRtH4sFhqD7nKHd6LSFi4+PBquXPTAO8-CQ@mail.gmail.com>
References: <CAA-O0XjoD3fQaMpYYmy4kpBSxD+K9TKX_QGr9mcNVuye43XWHg@mail.gmail.com>
	<54BE9E47.9030706@turmel.org>
	<54BE9F2A.9090102@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54BE9F2A.9090102@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

An email race condition. ;-)

On Tue, Jan 20, 2015 at 7:32 PM, Phil Turmel <philip@turmel.org> wrote:
> Woops!
> I'd still try a liveCD with 3.18.x or 3.19.

Right. I am considering ordering one of these new 8TB hard disks so I
can raw copy the raid partitions before I try anything drastic.
Unfortunately even 8TB won't fit 4x3TB of data. :-/ I am fairly
certain my data is still good since all disks have a clean bill of
health and other partitions on them worked with bonnie. So, I figure
my biggest risk right now, is doing something else stupid.

The system remains bootable as the uefi+boot+root filesystems were on
RAID1 x4 arrays and not the data RAID5 array. I'm hesitant to take
action until I find away to store the raw partitions, but installing
3.19 and booting that from my existing root partition sounds harmless
enough.

The system does not have a CD-ROM and has insufficient SATA connectors
to attach one. I could try booting via a USB drive, though.
