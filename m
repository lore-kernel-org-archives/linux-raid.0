From: David Bell <david@DB7654321.dyndns.org>
Subject: Re: raid boot problems
Date: 05 Jan 2003 21:29:30 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1041823769.31794.27.camel@david.bellshomenet.net>
References: <20021227203609.GD26188@oxygenetic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021227203609.GD26188@oxygenetic.com>
To: bruno waes <waesb@oxygenetic.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2002-12-27 at 14:36, bruno waes wrote:
> rainman:~# more /mnt/root/etc/lilo.conf
> lba32
> disk=/dev/md1
> bios=0x80
> partition=/dev/md0
> boot=/dev/sda
> root=/dev/md1
> ...

I was having problems booting from my IDE RAID 1 until I edited
lilo.conf to this:

lba32
boot=/dev/md5
raid-extra-boot="/dev/hda,/dev/hdc"
root=/dev/md1

/dev/md5 is /boot, /dev/md1 is /.  /dev/hda and /dev/hdc are the raid
disks.


