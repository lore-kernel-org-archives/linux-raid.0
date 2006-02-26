From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-2.3.1 fails to hotadd device
Date: Mon, 27 Feb 2006 09:57:12 +1100
Message-ID: <17410.12872.640975.243595@cse.unsw.edu.au>
References: <20060226110859.GJ7030@skl-net.de>
	<17409.37867.588055.108823@cse.unsw.edu.au>
	<20060226121332.GK7030@skl-net.de>
	<17410.8082.794478.606126@cse.unsw.edu.au>
	<20060226222050.GO7030@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Sunday February 26
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 26, maan@systemlinux.org wrote:
> On 08:37, Neil Brown wrote:
> > Your '/dev' is a symlink, and mdadm doesn't seem to like that.
> > 
> > Can you change the 'nftw' call in 'map_dev' in 'util.c' to
> > 
> > 		nftw("/dev/.", add_dev, 10, FTW_PHYS);
> > 
> > and see if that helps?
> 
> Jup, that does the trick:
> 
> 	# ./mdadm /dev/md1 -a /dev/hdd1
> 	mdadm: re-added /dev/hdd1

Great.

> 
> > It isn't really the right fix, but it is a quick-and-dirty that might
> > work.
> 
> Is it considered an invalid configuration to have /dev being a symlink
> (to /udev as in my case)?

Not invalid.  Just untested.... until now - thanks.

I'll make sure 2.4 handles this a lot more gracefully.

NeilBrown
