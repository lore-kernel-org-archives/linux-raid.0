From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: Single md physical device limit
Date: Mon, 19 Aug 2002 16:57:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CDF05CB9FCA0C845B9778F9E463C476101FC63@cinshrexc01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Interesting, when I initially built my array (with RedHat raidtools-0.90
not mdctl/mdadm, on kernel 2.4.17) it stated that I could only stripe
across 12 devices.  Do you have any idea from which this number comes?
Is it an old limit?

Thanks again for your help.

Regards,
Andy.

-----Original Message-----
From: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
Sent: Monday, August 19, 2002 4:14 PM
To: Rechenberg, Andrew
Cc: linux-raid@vger.kernel.org
Subject: Re: Single md physical device limit


On Monday August 19, ARechenberg@shermanfinancialgroup.com wrote:
> 
> Without drastically modifying the kernel code, is there any way to
> increase the physical device limit when building a single md device?
I
> believe that the currently limit is 12 physical disks (?)

No, but the current limit is 27 .....
> 
> For reference, I would like to stripe across an entire Dell PowerVault
> 220S, which has 14 drives in it.

so this should work fine.

NeilBrown
