From: <mk423@lw1.cc-computer.de>
Subject: Re: Can't add or delete a device from raid 1
Date: Wed, 26 May 2004 14:54:27 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0405261443440.32533-100000@lw2.cc-computer.de>
References: <001e01c442dd$e9636f30$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001e01c442dd$e9636f30$6705a8c0@a30>
To: linux-raid@vger.kernel.org
Cc: me@heyjay.com
List-Id: linux-raid.ids

Hi!

On Tue, 25 May 2004 me@heyjay.com wrote:

> I'm trying to add a partition to a raid 1 set that I built with a "missing"
> partition.  But mdadm won't let me add it to md0, or remove it
>
> platinum:~# cd /
> platinum:/# mdadm /dev/md0 -r /dev/hda1
> mdadm: hot remove failed for /dev/hda1: No such device or address
> platinum:/# mdadm /dev/md0 -a /dev/hda1
> mdadm: hot add failed for /dev/hda1: Invalid argument

What do "mdadm --detail /dev/md0" and "mdadm --examine /dev/hda1"
report?

Regards,
Martin

