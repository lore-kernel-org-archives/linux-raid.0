From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Preparation advice?
Date: Sat, 27 Nov 2004 08:46:37 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0411270837340.5805@lion.drogon.net>
References: <6d5bedd8041126205255c0fe7d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd8041126205255c0fe7d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 26 Nov 2004, Ewan Grantham wrote:

> Am about to venture into the MD world. I have 4 250-Gig HDs, 1 on
> IDE1, 1 on IDE2, 1 on the internal firewire port, 1 on a PCI Firewire
> card. So I think I have my failure points reasonably spread :-)

Sounds like a bit of a homebrew bits & pieces box... :)

> Since two of these are external drives, any special considerations?

Make sure their power and data cables, and on/off switches are secure...

> I
> am running a Debian from a Knoppix 3.6 HD Install with a 2.4.27
> kernel. I just updated the mdadm package using synaptic to 1.7, which
> I assume is the best version to run. My OS/Boot Disk is seperate, so I
> don't have to worry about that, but would like to have the array come
> up when the system does. Pointers to FAQs on any of this would also be
> appreciated.

Read the Software RAID FAQ on

  http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html

It's got basic instructions for both the older raidtools and the newer
mdadm.

What is your boot disk connected to? Hopefully not the same controller as
one of your RAID disks...

And might you not want to make the bood drive mirrored also?

Anyway, for the big array, assuming you just want one big ~750GB array
(RAID 5 gives N-1 capacity) partition each drive the same way with one
partition for the whole disk, then mark each partition with type FD and
build the array. Make sure the kernel has RAID built-in to it, or the RAID
modules are loaded at boot time and off you go. Once it's built, make a
mount point for it and put an entry in the /etc/fstab for it and it'll be
there for all time....

Gordon
