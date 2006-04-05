From: "Mike Garey" <random51k@gmail.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Wed, 5 Apr 2006 11:39:09 -0400
Message-ID: <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
References: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>
	 <4433E073.8040502@fnuck.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4433E073.8040502@fnuck.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/5/06, Troels Bang Jensen <marvin@fnuck.dk> wrote:
> This isn't quite what you asked about, but the rootraiddoc97 document is
> kinda obsolete by now
>
> -Debian Sarge has a new partitioner which can set up pretty advanced
> RAID configurations when installing. Just create RAID auto partitions on
> the disks and then create the arrays afterwards in the partitioner -
> it's far easier, and I've set up quite a few boot-on-RAID1 systems that way.

Thanks for the suggestion Troels, I didn't realize the rootraiddoc was
obsolete (although it is about 2 years old now it seems).  In the
future, I think I'll try using the debian partitioner, but at the
moment, I'd still like to find out why I can't mount /dev/md0, as it's
rather disturbing, given the fact that if this happens in a production
system and I can't recover from it, I'm screwed.

I tried booting from /dev/hdc1 (as /dev/md0 in grub) using a 2.6.15
kernel with md and raid1 support built in and this is what I now get:

md: autodetecting raid arrays
md: autorun ...
md: considering hdc1 ...
md: adding hdc1 ...
md: created md0
md: bind:<hdc1>
raid1: RAID set md0 active with 1 out of 2 mirrors
md: ...autrun done.

Warning: unable to open an initial console
Input: AT translated set 2 keyboard as /class/input/input0

and then at this point, the system just hangs and nothing happens.  So
I seem to be getting closer.. If I try booting from a kernel without
raid1 and md support, but using an initrd with raid1/md modules, then
I get the "ALERT! /dev/md0 does not exist.  Dropping to a shell!"
message.  I can't understand why there would be any difference between
using a kernel with raid1/md support, or using an initrd image with
raid1/md support, but apparently there is.  If anyone else has any
suggestions, please keep them coming.

Regards,

Mike
