From: Alex Butcher <linraid@assursys.co.uk>
Subject: Re: Software Raid 5 work on ROOT ?
Date: Fri, 4 Sep 2009 11:31:38 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0909041128110.8197@sbhezbfg.of5.nffheflf.cev>
References: <1252059563.4aa0e9ab25de3@imp.free.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1252059563.4aa0e9ab25de3@imp.free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: lfmarante@free.fr
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 4 Sep 2009, lfmarante@free.fr wrote:

> Hello every body.
>
> I have a question in regard of booting linux under a raid 5. It is possible ?
> All the guides that I found on the net say to have a /boot not stripped, (raid1
> is ok). [EX: http://www.gentoo.org/doc/en/gentoo-x86+raid+lvm2-quickinstall.xml
> ]
>
> They say to have / not stripped too.

No. That document only says "The partition you boot from must not be
striped". If you have a non-striped /boot, then that fulfils that
qualification, as long as your /boot also contains an initrd that is able to
bring your RAID5 / online.

Note that GRUB doesn't know how to boot from a RAID1 mirror; it just boots
from one component of the mirror.

Best Regards,
Alex
