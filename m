From: "bmoon" <bo@anthologysolutions.com>
Subject: Re: maximum disk capacity?
Date: Fri, 13 Jun 2003 14:33:46 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <018701c331f3$79ab76c0$6b01a8c0@bmoon>
References: <Pine.GSO.4.30.0306131032590.1148-100000@multivac.sdsc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Peter L. Ashford" <ashford@sdsc.edu>
Cc: Stephan van Hienen <raid@a2000.nu>, Donghui Wen <dhwen@protegonetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My question is from  Stephan van Hienen's email;

"
         if you need to go above to 2TB, you need the largedisk patch
         which doesn't work with sw raid5 (so no 2TB+ with sw raid5)

          i'm running with 13*180GB (+1 Hotspare) in sw raid5 (hd's
         connected to 2*3ware 7850)
"

What is the reason why it can not work with SW raid5 even with the largedisk
patch???



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

