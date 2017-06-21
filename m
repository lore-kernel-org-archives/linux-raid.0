From: LM <linux-raid@moellendorf.eu>
Subject: Assemble the previously replaced components of a previously created
 array into an active array
Date: Wed, 21 Jun 2017 22:15:36 +0200
Message-ID: <20170621201536.GI14809@lars-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I replaced all component devices of my RAID5 like in the example below:

mdadm /dev/md/test --add-spare /dev/loop20 --replace /dev/loop10 --with /dev/loop20
mdadm /dev/md/test --add-spare /dev/loop21 --replace /dev/loop11 --with /dev/loop21
mdadm /dev/md/test --add-spare /dev/loop22 --replace /dev/loop12 --with /dev/loop22
mdadm /dev/md/test --add-spare /dev/loop23 --replace /dev/loop13 --with /dev/loop23
mdadm /dev/md/test --remove /dev/loop10 /dev/loop11 /dev/loop12 /dev/loop13

Now one of my new disks failed. I currently rebuilding the RAID with the
failed disk hoping that the reason for failure has been resolved.

But I wonder if I could just:

1) power down the machine
2) replace all for disks by the removed old (and functioning) disks
3) assemble the old RAID

This would be a great relief, because no relevant data changed since the
replacement. However, the RAID has been in use during the replacement
and this makes me worry that the RAID cannot be assembled using the old
disks due to data inconsistency.

Best,
Lars
