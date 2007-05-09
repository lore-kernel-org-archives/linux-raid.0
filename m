From: Bernd Schubert <bschubert@q-leap.de>
Subject: Re: "No such device" on --remove
Date: Wed, 09 May 2007 13:42:17 +0200
Message-ID: <f1sc2p$33q$1@sea.gmane.org>
References: <20070508170441.GB4333@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Benjamin Schieder wrote:


> root@crazyhorse:~# mdadm /dev/md/2 -r /dev/hdh5
> mdadm: hot remove failed for /dev/hdh5: No such device
> 
> md1 and md2 are supposed to be raid5 arrays.

You are probably using udev, don't you? Somehow there's presently
no /dev/hdh5, but to remove /dev/hdh5 out of the raid, mdadm needs this
device. There's a workaround, you need to create the device in /dev using
mknod and then you can remove it with mdadm.

We are presently running into a similar problem, which I'm going to describe
on this and hotplug list right now.


Hope it helps,
Bernd

