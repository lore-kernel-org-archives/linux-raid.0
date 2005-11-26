From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Booting from raid1 -- md: invalid raid superblock magic on sdb1
Date: Sat, 26 Nov 2005 12:36:24 -0500
Message-ID: <052101c5f2af$ec7a16f0$200a11ac@NCNF5131FTH>
References: <050501c5f2a4$fe72c560$200a11ac@NCNF5131FTH> <559c115f0605930c434a98c6cfd8fd66@logidac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed	reply-type=response
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Filion <gfk@logidac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 26 November 2005 12:16:14, Guillaume Filion wrote:
> Le 05-11-26, =E0 11:18, David M. Strang a =E9crit :
> > md: invalid raid superblock magic on sdb1
>
> Did you include the md and raid1 modules in mkinirtd.conf?
>
> I'll admit that while I have my root on a raid1 device, I'm a bit con=
fused=20
> by the whole process... :-/
>

Well, actually... I don't use an initrd. All my drivers are straight=20
compiled into the kernel.

> I found this document particularly helpful:
> http://xtronics.com/reference/SATA-RAID-Debian.htm
>

Good document, I've looked at that one a bit too. It seems that the md.=
txt=20
from the kernel Documentation is perhaps what is throwing me awry.

-- David M. Strang=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
