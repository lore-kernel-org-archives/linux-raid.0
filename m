From: dean gaudet <dean@arctic.org>
Subject: Re: Keeping debian from auto-assembling
Date: Mon, 26 May 2008 04:10:53 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0805260408400.19238@twinlark.arctic.org>
References: <200804301354.35407.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200804301354.35407.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 30 Apr 2008, Dexter Filmore wrote:

> I'd like to assembla manually to investigate why the bloody 5th disk flies 
> from the array at EVERY boot time (third so far, wonder how much stress the 
> disks take) but I can't seen to disable it.
> 
> All 5 disks are 0xFD, but I passed raid=noautodetect to the end of the kernel 
> line, I set "assemble at startup" in /etc/defaults/mdadm to "false", I 
> cleared the mdadm.conf - still it assembles the array. No idea why.

you need to rebuild your initramfs after you make those changes to 
/etc/defaults/mdadm ... easiest is:

dpkg-reconfigure linux-image-`uname -r`

-dean
