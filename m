From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks, raid6, grub2, lvm2
Date: Fri, 01 May 2009 23:36:29 +0200
Message-ID: <874ow4ld42.fsf@frosties.localdomain>
References: <1240574900.4507.2076.camel@ezra>
	<87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	<1240957153.18303.689.camel@ezra>
	<18935.35747.471257.202356@notabene.brown>
	<49F78F26.2040909@zytor.com> <1240963225.18303.858.camel@ezra>
	<49F7997C.2070808@zytor.com> <1240964410.18303.895.camel@ezra>
	<20090429224347.GB29843@rlogin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090429224347.GB29843@rlogin.dk> (Michael Ole Olsen's message
	of "Thu, 30 Apr 2009 00:43:47 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Ole Olsen <gnu@gmx.net>
Cc: Daniel Reurich <daniel@centurion.net.nz>, "H. Peter Anvin" <hpa@zytor.com>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Ole Olsen <gnu@gmx.net> writes:

> I tried recently with grub2 and also the old grub in lenny (even the lenny
>     installer fails, though it seems to complete fine, it just don't boot
>     afterwards).
>
> didn't think I would get an issue trying to get /boot on my lvm2 raid6 volume,
>     as i recalled grub supported mdadm raids and also lvm2.

Grub supports neither. No idea if grub2 can do raid6.

> seems it has to be partitioned separately as a partition with mdadm and no
> lvm2 on top of the boot partition, thats the only thing grub supports, 
>      if I am not mistaken?
>
> I just made one big volume, then created the logical volume /boot , and
> neither grub or lilo would touch it (lilo only supports mdadm raid1 volumes)
>
> would be cool to be able to boot lvm2 /boot volumes with grub

yes it would.

> just wanted to give my recent experience with grub+lvm2+mdadm raid6.
>
>
> /Michael Ole Olsen

MfG
        Goswin
