From: Neil Brown <neilb@suse.de>
Subject: Re: Updating superblock to reflect new disc locations
Date: Thu, 12 Jan 2006 14:01:18 +1100
Message-ID: <17349.50814.993086.189022@cse.unsw.edu.au>
References: <43C495BA.9070502@mm.quex.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Alger on Wednesday January 11
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 11, linux-raid@mm.quex.org wrote:
> 
> 
> Any suggestions would be greatly appreciated. The system's new and not 
> yet in production, so I can reinstall it if I have to, but I'd prefer to 
> be able to fix something as simple as this.

Debian's installer - the mkinitrd part in particular - is broken.
If you look in the "initrd" (it is just a compressed CPIO file) you
will find the mdadm command used to start the root array explicitly
lists the devices to use.  As soon as you change the devices, it stops
working :-(  Someone should tell them about uuids.

I think you can probably fix you situation by:
  Booting up and having a degraded array
  hot-add the missing device and wait for it to rebuilt
  rerun mkinitrd

The last bit might require some learning on your part.  I don't know
in Debian's mkinitrd requires and command line args, or where it puts
the result, or whether you have to tell lilo/grub about the new files.

I would try just running "mkinitrd" with no args, and the "lilo" - if
you are using lilo, and reboot.  See what happens....

NeilBrown
