From: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
Subject: Re: mbr-install for Raid 1 with Root on Raid5
Date: Wed, 6 Oct 2004 07:59:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041006075958.10a58d2a@zrr.local>
References: <20041005093440.2b639e71@zrr.local>
	<41626483.60505@tls.msk.ru>
	<20041005154755.021a0f72@zrr.local>
	<4162E6FE.90400@begu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4162E6FE.90400@begu.net>
To: RAID Linux <linux-raid@vger.kernel.org>
Cc: Bernd Fischer <bernd@begu.net>, Hannes Wyss <hwyss@ywesee.com>
List-Id: linux-raid.ids

Bernd!

thanks for your Mail, Time and Help.

On Tue, 05 Oct 2004 20:25:02 +0200
Bernd Fischer wrote:
>  > You suppose that I am running a RAID1 as you say I should install the
>  > boot-image of lilo to my root partition because Install-Mbr checks
>  > for it there. My problem: My Root-Partition is a RAID5. I would like
>  > to boot from a RAID1 and get my RAID5 going from there.
> 
> Basically the same procedure. Just replace the words "root partition"
> with "boot partition" or "partition on which you install your kernel" in
> Michaels instructions.
I'm doing exactly that or at least I believe so.

I run 
install-mbr -t 150 /dev/sda1
install-mbr -t 150 /dev/sdb1
install-mbr -t 150 /dev/sdc1
install-mbr -t 150 /dev/sdd1

then in lilo.conf I put 

boot = /dev/md0
root = /dev/md2

then I reboot and I get:

MBR FA: (I hit 'A')
MBR 1234F: (I hit '1')
MBR
MBR FA: 

.. and nothing boots. MBR just stands there forever.

Any hints?

Thanks for your Feedback.

Zeno

PS: Lilo can not write it's boot-image on RAID5, only on RAID1.
