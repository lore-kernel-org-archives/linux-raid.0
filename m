From: Gordon Henderson <gordon@drogon.net>
Subject: RE: Mirroring swap
Date: Thu, 26 Jun 2003 09:30:23 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0306260916190.5551-100000@unicorn.drogon.net>
References: <BKEGKPICNAKILKJKMHCAEEFPEHAA.Riley@Williams.Name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BKEGKPICNAKILKJKMHCAEEFPEHAA.Riley@Williams.Name>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 26 Jun 2003, Riley Williams wrote:

> Personally, I can't see the point. the contents of swap are by
> definition short term temporary data with copies held either in
> memory or elsewhere on the hard disk subsystem.

Not strictly true. The whole point of "virual memory" is that the OS has
the right to shift parts of, or an entire programs data segment (and
stack, and other volatile data needed to resume execution of that program
which isn't mirrored elsewhere in memory or the filing system)  onto a
swap device when memory becomes tight. If later, it tries to read that
data back to resume execution of the program and it fails then at best it
will abort the program and at worst it'll just give up and panic. I've had
the latter happen when a swap partition developed a bad sector.

So now with important machines which had mirrored or RAIDed disk systems,
I always put swap on a mirrored or RAID5d device.

Eg.

gordonh @ red: cat /proc/swaps
Filename                        Type            Size    Used    Priority
/dev/md2                        partition       1991672 12512   -1

md2 : active raid5 hdm2[2] hdk2[4] hdi2[1] hdg2[3] hde2[0]
      1991680 blocks level 5, 32k chunk, algorithm 0 [5/5] [UUUUU]

> My preference is to create multiple swap partitions, one on each
> hard drive, as in that situation, the swap subsystem always uses
> a swap partition on a different drive to the original copy when
> it decides where to swap out to.

Linux will round-robbin swap allocation between all swap devices, unless
you give a device a higher priority in the fstab. (or swapon command)

Gordon

