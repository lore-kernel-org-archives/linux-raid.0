From: David Greaves <david@dgreaves.com>
Subject: Re: Keeping debian from auto-assembling
Date: Wed, 30 Apr 2008 14:09:03 +0100
Message-ID: <48186F6F.9070006@dgreaves.com>
References: <200804301354.35407.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200804301354.35407.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:
> I'd like to assembla manually to investigate why the bloody 5th disk flies 
> from the array at EVERY boot time (third so far, wonder how much stress the 
> disks take) but I can't seen to disable it.
> 
> All 5 disks are 0xFD, but I passed raid=noautodetect to the end of the kernel 
> line, I set "assemble at startup" in /etc/defaults/mdadm to "false", I 
> cleared the mdadm.conf - still it assembles the array. No idea why.

initrd or udev?

> 
> Hints? I'm currently pretty much down with my nerves on this issue.
> 
> Dex

Since you shutdown and booted another distro to see == Events then it's not a
bad shutdown process.

On reboot it looks like something is assembling the array partially.
I'd upgrade udev, then test and then upgrade initrd-tools.

David
