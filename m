From: Neil Brown <neilb@suse.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 09:07:23 +1000
Message-ID: <18935.35883.181289.739254@notabene.brown>
References: <1240574900.4507.2076.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Reurich on Saturday April 25
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 25, daniel@centurion.net.nz wrote:
> Hi,
> 
> I have got linux successfully booting from a raid5 whole disk set with /
> & /boot filesystems on that raid5 disk set.  This is possible thanks to
> grub2 (with some hacking to make it install correctly.)
> 
> The downside I found is that the system won't boot if the 1st disk is
> missing, as that contains the boot sector and core.img that grub
> requires to boot.  The linux kernel also get unhappy about the partition
> table of the first disk saying the volume is larger then the geometry of
> the physical first disk.

So where does grub store the core.img in this setup?

While the kernel might be noisy about large partitions, it should
just be noise - everything should still work  - right?

NeilBrown
