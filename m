From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-2.3.1 fails to hotadd device
Date: Mon, 27 Feb 2006 08:37:22 +1100
Message-ID: <17410.8082.794478.606126@cse.unsw.edu.au>
References: <20060226110859.GJ7030@skl-net.de>
	<17409.37867.588055.108823@cse.unsw.edu.au>
	<20060226121332.GK7030@skl-net.de>
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
> On 22:41, Neil Brown wrote:
> > > # mdadm /dev/md1 -a /dev/hdd1
> > > mdadm: cannot find valid superblock in this array - HELP
> > 
> > Can you
> >   strace -o /tmp/trace mdadm /dev/md1 -a /dev/hdd1
> > 
> > and send me /tmp/trace?
> 
> Here it comes.

Thanks.

> lstat64("/dev", {st_mode=S_IFLNK|0777, st_size=5, ...}) = 0

Your '/dev' is a symlink, and mdadm doesn't seem to like that.

Can you change the 'nftw' call in 'map_dev' in 'util.c' to

		nftw("/dev/.", add_dev, 10, FTW_PHYS);

and see if that helps?

It isn't really the right fix, but it is a quick-and-dirty that might
work.

NeilBrown
