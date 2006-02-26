From: Andre Noll <maan@systemlinux.org>
Subject: Re: mdadm-2.3.1 fails to hotadd device
Date: Sun, 26 Feb 2006 23:20:50 +0100
Message-ID: <20060226222050.GO7030@skl-net.de>
References: <20060226110859.GJ7030@skl-net.de> <17409.37867.588055.108823@cse.unsw.edu.au> <20060226121332.GK7030@skl-net.de> <17410.8082.794478.606126@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17410.8082.794478.606126@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08:37, Neil Brown wrote:
> Your '/dev' is a symlink, and mdadm doesn't seem to like that.
> 
> Can you change the 'nftw' call in 'map_dev' in 'util.c' to
> 
> 		nftw("/dev/.", add_dev, 10, FTW_PHYS);
> 
> and see if that helps?

Jup, that does the trick:

	# ./mdadm /dev/md1 -a /dev/hdd1
	mdadm: re-added /dev/hdd1

> It isn't really the right fix, but it is a quick-and-dirty that might
> work.

Is it considered an invalid configuration to have /dev being a symlink
(to /udev as in my case)?

Thanks
Andre

-- 
The only person who always got his work done by Friday was Robinson Crusoe
