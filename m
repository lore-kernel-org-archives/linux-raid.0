From: <me@heyjay.com>
Subject: Re: RAID becomes un-bootable after failure
Date: Wed, 2 Jun 2004 10:11:54 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000701c448b7$19e3c8b0$6705a8c0@a30>
References: <40BDEA63.5040001@plasticboy.com>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ben Williams <benw@plasticboy.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I have a 2-disk RAID-1 that I set up using the Red Hat 9 installer. My 
> problem is that pretty much any simulated drive failure makes the system 
> unbootable. If I power down the machine and remove drive 1, the system 
> can't find any bootable device.

Maybe you need to do:

$ grub
grub> root (hd0)
grub> setup (hd0,0)
grub> root (hd1)
grub> setup (hd1,0)

Jay

