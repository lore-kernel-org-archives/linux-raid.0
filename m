From: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
Subject: Re: mbr-install for Raid 1, mdadm -a /dev/md0 /dev/sda1
Date: Wed, 6 Oct 2004 18:34:11 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041006183411.10578ab7@zrr.local>
References: <20041005093440.2b639e71@zrr.local>
	<41626483.60505@tls.msk.ru>
	<20041006105620.465baff7@zrr.local>
	<41641A79.6030709@begu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41641A79.6030709@begu.net>
To: RAID Linux <linux-raid@vger.kernel.org>
Cc: Bernd Fischer <bernd@begu.net>
List-Id: linux-raid.ids

Hi Bernd

Thanks for your prompt reply.

On Wed, 06 Oct 2004 18:16:57 +0200
Bernd Fischer wrote:

> Zeno R.R. Davatz wrote:
> 
> >> No, you would have to use boot=/dev/md0 in your lilo.conf,
> 
> > Do I have to run 'lilo -v' so lilo gets this?
> 
> As usual, you have to run lilo everytime you install a new kernel or 
> edit lilo.conf
> 
> > Because whenever I run lilo -v (22.5.8) with 'boot=/dev/md0 I get the wonderful Error of:
> > Fatal: Trying to map files from unnamed device 0x0000 (NFS ?)
> 
> > Any hints?
> 
> I had the same problem some time ago. AFAIR it went away when I updated 
> to lilo 22.6
> As a workaround, create a symlink to /dev/md0 ( e.g. /dev/MD0 ) and use 
> this as your boot device in lilo.conf.
I managed to boot my /dev/md2 (using find . -xdev | cpio -pm /mnt/newroot instead of cp -ax / /mnt/newroot to copy my system to Raid). Now I am doing 'mdadam -a /dev/md2 /dev/sda3'

as next I would do 'mdadm -a /dev/md0 /dev/sda1'

Will the lilo problem then vanish?

Thanks for your Feedback.
Zeno
