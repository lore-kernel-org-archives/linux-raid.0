From: Roger Ellison <raennnn@adelphia.net>
Subject: Debian Sarge mdadm raid 10 assembling at boot problem
Date: Wed, 05 Jan 2005 00:50:41 -0500
Message-ID: <1104904239.1613.26.camel@rae.home>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg>
	 <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es>
	 <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es>
	 <20050102194240.GE99565@caffreys.strugglers.net>
	 <5h1ma2-asq.ln1@news.it.uc3m.es>
	 <20050103003005.GG99565@caffreys.strugglers.net>
	 <2rana2-0if.ln1@news.it.uc3m.es> <41D93657.7090908@tls.msk.ru>
	 <a41oa2-fr7.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a41oa2-fr7.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been having an enjoyable time tinkering with software raid with
Sarge and the RC2 installer.  The system boots fine with Raid 1 for
/boot and Raid 5 for /.  I decided to experiment with Raid 10 for /opt
since there's nothing there to destroy :).  Using mdadm to create a Raid
0 array from two Raid 1 arrays was simple enough, but getting the Raid
10 array activated at boot isn't working well.  I used update-rc.d to
add the symlinks to mdadm-raid using the defaults, but the Raid 10 array
isn't assembled at boot time.  After getting kicked to a root shell, if
I check /proc/mdstat only md1 (/) is started.  After running mdadm-raid
start, md0 (/boot), md2, and md3 start.  If I run mdadm-raid start again
md4 (/opt) starts.  Fsck'ing the newly assembled arrays before
successfully issuing 'mount -a' shows no filesystem errors.  I'm at a
loss and haven't found any similar issue mentions on this list or the
debian-users list.  Here's mdadm.conf:

DEVICE partitions
DEVICE /dev/md*
ARRAY /dev/md4 level=raid0 num-devices=2
UUID=bf3456d3:2af15cc9:18d816bf:d630c183
   devices=/dev/md2,/dev/md3
ARRAY /dev/md3 level=raid1 num-devices=2
UUID=a51da14e:41eb27ad:b6eefb94:21fcdc95
   devices=/dev/sdb5,/dev/sde5
ARRAY /dev/md2 level=raid1 num-devices=2
UUID=ac25a75b:3437d397:c00f83a3:71ea45de
   devices=/dev/sda5,/dev/sdc5
ARRAY /dev/md1 level=raid5 num-devices=4 spares=1
UUID=efec4ae2:1e74d648:85582946:feb98f0c
   devices=/dev/sda3,/dev/sdb3,/dev/sdc3,/dev/sde3,/dev/sdd3
ARRAY /dev/md0 level=raid1 num-devices=4 spares=1
UUID=04209b62:6e46b584:06ec149f:97128bfb
   devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sde1,/dev/sdd1


Roger

