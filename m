From: "bmoon" <bo@anthologysolutions.com>
Subject: Re: maximum disk capacity?
Date: Fri, 13 Jun 2003 10:21:52 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <016501c331d0$48854d00$6b01a8c0@bmoon>
References: <007201c330b9$c316f310$3001a8c0@melkor> <16104.22361.508001.916567@gargle.gargle.HOWL> <00db01c330ca$5ae72290$3001a8c0@melkor> <200306121814.32072.bernd-schubert@web.de> <009001c3313d$54027880$df01010a@moon> <Pine.LNX.4.53.0306130949210.30359@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Stephan van Hienen <raid@a2000.nu>, Donghui Wen <dhwen@protegonetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What is the reason that it can not cover more than 2TB?
By the way you are able to use more than 2TB, ~2.3TB???
Why?

----- Original Message ----- 
From: "Stephan van Hienen" <raid@a2000.nu>
To: "Donghui Wen" <dhwen@protegonetworks.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Friday, June 13, 2003 12:51 AM
Subject: Re: maximum disk capacity?


> On Thu, 12 Jun 2003, Donghui Wen wrote:
> 
> > Hi, I am setting up hardware raid with 7 harddrives on redhat linux.
> > I use 3ware + hardware raid 5, each harddrive is 200G. For
> > linux, this raid sould act as a 1.2TB scsi hard drive. But it seems
> > redhat could not reconize it. I am wondering may be a 1.2TB hard drive
> > is too large to linux. So my question is: what't
> > the maxium disk capacity Linux can support?
> 
> no problem till 2TB
> if you need to go above to 2TB, you need the largedisk patch
> which doesn't work with sw raid5 (so no 2TB+ with sw raid5)
> 
> i'm running with 13*180GB (+1 Hotspare) in sw raid5 (hd's
> connected to 2*3ware 7850)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
