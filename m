From: "Christian Kivalo" <valo@valo.at>
Subject: RE: Linear RAID (was Re: bad /proc/mdstat message)
Date: Mon, 12 Jan 2004 21:19:48 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NMEHJKFGFEGJPIPOLFFEEEGGDEAA.valo@valo.at>
References: <Pine.GSO.4.31.0401121348500.10347-100000@staff2.cso.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.31.0401121348500.10347-100000@staff2.cso.uiuc.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 2. Every time I reboot the raid partition doesn't get
> mounted.
hi!

are the partitions of type "Linux Raid Autodetect" (type fd)? i don't
know for sure if that apply's for linear also, but for all other raid
types, having the partition type 'fd', the array get's assembled at boot
time and properly mountet through fstab.

christian

