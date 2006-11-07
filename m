From: Neil Brown <neilb@suse.de>
Subject: Re: invalid (zero) superblock magic upon creation of a new RAID-1 array
Date: Tue, 7 Nov 2006 15:57:23 +1100
Message-ID: <17744.4659.23326.515464@cse.unsw.edu.au>
References: <20061105085702.GD20184@grok.co.za>
	<17742.25334.685135.990170@cse.unsw.edu.au>
	<20061106064233.GA2793@grok.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Andrews on Monday November 6
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Andrews <tandrews@grok.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 6, tandrews@grok.co.za wrote:
> On Mon, Nov 06, 2006 at 09:17:26AM +1100, Neil Brown wrote:
> > You mdadm to assemble the array, it is more flexible than auto-detect.
> 
> Thanks Neil, I fixed my problem by creating the raid set using the "-e"
> option:
> 
>     mdadm -C /dev/md0 -e 0.90 --level=raid1 --raid-devices=2  /dev/sda1 /dev/sdb1
> 
> You're suggestion to use mdadm to assemble the array is not an option
> for me because it is the root partition that is raided, but thanks for
> putting me in the right direction.

You can use mdadm to assemble the root partition with suitable
initramfs magic, and I gather most distributions use initramfs (or
initrd) by default now.  But getting the magic to work isn't always as
straight forward as you would like.

You solution is should work fine so stick with it.

NeilBrown
