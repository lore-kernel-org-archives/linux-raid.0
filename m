From: piergiorgio.sartor@nexgo.de
Subject: Another RAID-5 problem
Date: Wed, 9 May 2012 11:10:58 +0200 (CEST)
Message-ID: <2002541871.570559.1336554658940.JavaMail.ngmail@webmail06.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

we're hit by a RAID-5 issue, it seems Ubuntu 12.04 is shipping
some bugged kernel/mdadm combination.

Following the other thread about a similar issue, I understood
it is possible to fix the array without losing data.

Problems are:

1) We do not know the HDD order and it is a 5 disks RAID-5
2) 4 of 5 disks have a data offset of 264 sectors, while the
fourth one, added later, has 1048 sectors.
3) There is a LVM setup on the array, not a plain filesystem.

Any idea on how can we get the array back without losing any
data?

At the moment, it seems quite difficult to provide dump of
"mdadm -E" or similar, since the PC does not boot at all.
In any case, if necessary we could try to take a picture of
the screen and send it here or directly per email, if appropriate.

Thanks a lot in advance,

bye,

-- 

piergiorgio
