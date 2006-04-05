From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Wed, 5 Apr 2006 19:20:11 +0300
Message-ID: <5b170a7d0604050920p674e10a9u9e26a52fcf3933c1@mail.gmail.com>
References: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>
	 <4433E073.8040502@fnuck.dk>
	 <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mike Garey <random51k@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/5/06, Mike Garey <random51k@gmail.com> wrote:
> I tried booting from /dev/hdc1 (as /dev/md0 in grub) using a 2.6.15
> kernel with md and raid1 support built in and this is what I now get:
>
> md: autodetecting raid arrays
> md: autorun ...
> md: considering hdc1 ...
> md: adding hdc1 ...
> md: created md0
> md: bind:<hdc1>
> raid1: RAID set md0 active with 1 out of 2 mirrors
> md: ...autrun done.
>
> Warning: unable to open an initial console
> Input: AT translated set 2 keyboard as /class/input/input0
>
> and then at this point, the system just hangs and nothing happens.  So
> I seem to be getting closer.. If I try booting from a kernel without
> raid1 and md support, but using an initrd with raid1/md modules, then
> I get the "ALERT! /dev/md0 does not exist.  Dropping to a shell!"
> message.  I can't understand why there would be any difference between
> using a kernel with raid1/md support, or using an initrd image with
> raid1/md support, but apparently there is.  If anyone else has any
> suggestions, please keep them coming.

Sounds like your initrd could use a command like

mdadm --assemble /dev/md0 /dev/hda1 /dev/hdc1

at some point before mounting the real rootfs. There are many cleaner
examples in the list archive, but that should do the trick. It seems
like your initrd-kernel doesn't autostart the raid for some reason
(config option?).

Note, you should never do any read/write access to the component disks
after creating the raid. I guess you know this already, but some
wording seemed suspect.

Can you specify more what is the problem with mounting md0? The log
snipped doesn't show any errors about that.
