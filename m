From: <me@heyjay.com>
Subject: Can't add or delete a device from raid 1
Date: Tue, 25 May 2004 23:56:07 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001e01c442dd$e9636f30$6705a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to add a partition to a raid 1 set that I built with a "missing"
partition.  But mdadm won't let me add it to md0, or remove it

platinum:~# cd /
platinum:/# mdadm /dev/md0 -r /dev/hda1
mdadm: hot remove failed for /dev/hda1: No such device or address
platinum:/# mdadm /dev/md0 -a /dev/hda1
mdadm: hot add failed for /dev/hda1: Invalid argument

I don't get this.  I had it all working, then I tried to update my kernel to
2.6.5, then the machine wouldn't boot without my interaction.  So now when
I boot to the old (working) kernel.  I'm missing on partiion on
/dev/md0.

I'm running on debian

Thanks
Jay



