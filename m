From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: maximum disk capacity?
Date: Fri, 13 Jun 2003 10:39:26 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0306131032590.1148-100000@multivac.sdsc.edu>
References: <016501c331d0$48854d00$6b01a8c0@bmoon>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <016501c331d0$48854d00$6b01a8c0@bmoon>
To: bmoon <bo@anthologysolutions.com>
Cc: Stephan van Hienen <raid@a2000.nu>, Donghui Wen <dhwen@protegonetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> What is the reason that it can not cover more than 2TB?

A 32-bit block number with 512-byte blocks.  This multiplies out to 2TB.

> By the way you are able to use more than 2TB, ~2.3TB???
> Why?

2TB binary is 2.2TB decimal (2,199,023,255,552).  You shouldn't be able to
get 2.3TB without the patch.

> > > Hi, I am setting up hardware raid with 7 harddrives on redhat linux.
> > > I use 3ware + hardware raid 5, each harddrive is 200G. For
> > > linux, this raid sould act as a 1.2TB scsi hard drive. But it seems
> > > redhat could not reconize it. I am wondering may be a 1.2TB hard drive
> > > is too large to linux. So my question is: what't
> > > the maxium disk capacity Linux can support?

There is a problem with the RedHat installation scripts.  When performing
a Kickstart install, and using the Grub boot loader, disks are limited to
1TB (binary).  Is this the problem you encountered?

Good luck.
				Peter Ashford

