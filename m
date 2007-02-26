From: "David Rees" <drees76@gmail.com>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Mon, 26 Feb 2007 13:13:04 -0800
Message-ID: <72dbd3150702261313o88c1dd6tf910049e69708868@mail.gmail.com>
References: <1172258378.21648.51.camel@cowie> <45DF46B7.3040707@maine.edu>
	 <1172406243.3765.29.camel@cowie> <45E1E051.1020908@sauce.co.nz>
	 <72dbd3150702260856p5053d028je85cacffb15a5536@mail.gmail.com>
	 <1172510818.11898.33.camel@cowie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1172510818.11898.33.camel@cowie>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Colin Simpson <csimpson@csl.co.uk>
Cc: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/26/07, Colin Simpson <csimpson@csl.co.uk> wrote:
> If I say,
>
> dd if=/dev/sda2 of=/dev/null
>
> where /dev/sda2 is a component of an active md device.
>
> Will the RAID subsystem get upset that someone else is fiddling with the
> disk (even in just a read only way)? And will a read error on this dd
> (caused by a bad block) cause md to knock out that device?

The MD subsystem doesn't care if someone else is reading the disk, and
I'm pretty sure that rear errors will be noticed by the MD system,
either.

-Dave
