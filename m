From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: Re: maximum disk capacity?
Date: Fri, 13 Jun 2003 10:58:17 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002001c331d5$5e1d4f00$df01010a@moon>
References: <Pine.GSO.4.30.0306131032590.1148-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Peter L. Ashford" <ashford@sdsc.edu>, bmoon <bo@anthologysolutions.com>
Cc: Stephan van Hienen <raid@a2000.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried to use fdisk, sfdisk  to partition /dev/sdb which is 1.2TB.
It always complaint could not read sector 0.

I also tried dd if=/dev/sdb of=boot.sec bs=512 count=1,
it has the same error.

But if I tried to write using
   dd if=/dev/zero of=/dev/sdb bs=512 count=1

It works.

Also, the kernel found this disk, but report the size as a negative number.
I guess if using unsigned interger (32 bit), linux can support 2TB for one
block device.
But some time, the other tools only use (int, signed interger), then it can
only support 1TB.


Donghui

----- Original Message -----
From: "Peter L. Ashford" <ashford@sdsc.edu>
To: "bmoon" <bo@anthologysolutions.com>
Cc: "Stephan van Hienen" <raid@a2000.nu>; "Donghui Wen"
<dhwen@protegonetworks.com>; <linux-raid@vger.kernel.org>
Sent: Friday, June 13, 2003 10:39 AM
Subject: Re: maximum disk capacity?


> > What is the reason that it can not cover more than 2TB?
>
> A 32-bit block number with 512-byte blocks.  This multiplies out to 2TB.
>
> > By the way you are able to use more than 2TB, ~2.3TB???
> > Why?
>
> 2TB binary is 2.2TB decimal (2,199,023,255,552).  You shouldn't be able to
> get 2.3TB without the patch.
>
> > > > Hi, I am setting up hardware raid with 7 harddrives on redhat linux.
> > > > I use 3ware + hardware raid 5, each harddrive is 200G. For
> > > > linux, this raid sould act as a 1.2TB scsi hard drive. But it seems
> > > > redhat could not reconize it. I am wondering may be a 1.2TB hard
drive
> > > > is too large to linux. So my question is: what't
> > > > the maxium disk capacity Linux can support?
>
> There is a problem with the RedHat installation scripts.  When performing
> a Kickstart install, and using the Grub boot loader, disks are limited to
> 1TB (binary).  Is this the problem you encountered?
>
> Good luck.
> Peter Ashford
>
>

