From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Reading takes 100% precedence over writes for mdadm+raid5?
Date: Thu, 6 Dec 2007 04:06:37 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712060406170.5626@p34.internal.lan>
References: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
 <18259.15708.870492.17273@notabene.brown>  <Pine.LNX.4.64.0712021821290.13428@p34.internal.lan>
 <cccedfc60712051727u4164b488o820509087f46cbcd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60712051727u4164b488o820509087f46cbcd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 5 Dec 2007, Jon Nelson wrote:

> I saw something really similar while moving some very large (300MB to
> 4GB) files.
> I was really surprised to see actual disk I/O (as measured by dstat)
> be really horrible.
>
> -- 
> Jon
>

Any work-arounds, or just don't perform heavy reads the same time as 
writes?

Justin.
