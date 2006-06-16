From: Neil Brown <neilb@suse.de>
Subject: Re: RAID on the root partition /
Date: Fri, 16 Jun 2006 16:13:18 +1000
Message-ID: <17554.19454.430249.106797@cse.unsw.edu.au>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
	<17550.2944.728044.154492@cse.unsw.edu.au>
	<4558af040606151953g2ae4c1aasb0c398294cda5887@mail.gmail.com>
	<17554.13434.191935.975865@cse.unsw.edu.au>
	<44923E20.3030401@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Adam Talbot on Thursday June 15
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <talbotx@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 15, talbotx@comcast.net wrote:
> What I hope to be an easy fix.  Running Gentoo Linux and trying to setup
> RAID 1 across the root partition hda3 hdc3.  Have the fstab set up to
> look for /dev/md3 and I have built the OS on /dev/md3.  Works fine until
> I reboot. System loads and states it can not find /dev/md3 and when I
> look md3 not started.  I have MD as part of the kernel, I have
> mdadm.conf setup like so:
> 
> DEVICE /dev/hda3 /dev/hdc3
> ARRAY /dev/md3 level=raid1 devices=/dev/hda3,/dev/hdc3
> 
> What am I missing?

If that mdadm.conf is on the root filesystem, then obviously it is of
no value for setting up the root filesystem.

You can:
  - use an initramfs to do the work. Many distros do this for you.
    The mdadm source contains some notes and scripts that I use.
  - use a boot parameter of
         md=3,/dev/hda3,/dev/hdc3
    This is probably easiest, and as ide drives don't change their
    names this should be safe.

initramfs is best though.

NeilBrown
