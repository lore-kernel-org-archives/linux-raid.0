From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: recovering from a controller failure
Date: Sun, 30 May 2010 17:23:21 -0500
Message-ID: <F6.6D.28437.855E20C4@cdptpa-omtalb.mail.rr.com>
References: <4C02B497.3050708@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C02B497.3050708@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: 'Richard Scobie' <richard@sauce.co.nz>
Cc: 'Kyler Laird' <kyler-keyword-linuxraid00.a7e7f0@lairds.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	Oops!  You're right.

> -----Original Message-----
> From: Richard Scobie [mailto:richard@sauce.co.nz]
> Sent: Sunday, May 30, 2010 1:55 PM
> To: Leslie Rhorer
> Cc: 'Kyler Laird'; linux-raid@vger.kernel.org
> Subject: Re: recovering from a controller failure
> 
> Leslie Rhorer wrote:
> 
> > `mdadm --assemble --assume-clean /dev/mdX /dev/<drive0>  /dev/<drive1>
> > /dev/<drive2>  ...etc`
> 
> --assume-clean is not an option for assemble, the --force option is
> required.
> 
> Regards,
> 
> Richard


