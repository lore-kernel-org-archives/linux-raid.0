From: Zeno Davatz <zdavatz@generika.cc>
Subject: Re: raid1: module or compiled in?
Date: 07 May 2003 18:03:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052323420.1551.116.camel@zrr>
References: <1052320882.649.99.camel@zrr>  <3EB92AE6.91F9FED4@SteelEye.com>
Reply-To: zdavatz@generika.cc
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EB92AE6.91F9FED4@SteelEye.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-05-07 at 17:48, Paul Clements wrote:
> Zeno Davatz wrote:
> 
> > I am a Debian Woody 2.4.20 user and got the following question:
> > 
> > If I want the software raid to work do I need to compile it into the
> > kernel or does it suffice if I just load the support as module?
> 
> md generally does have to be compiled in...the raid personality modules
> (raid1, raid5, etc.) can be compiled as modules... more below...
>  
> > I was reading in the software-RAID Howto that the support should NOT be
> > loaded as Module. Why would that be?
> 
> Were they talking about _md_ needing to be compiled in? Because it has
> to be compiled into the kernel if you want to use persistent superblocks
> and/or use it for your root partition. I have patches against 2.4 and
> 2.5 to fix this md problem, BTW, if anyone wants them...I posted the 2.5
> one a while back...
Ok, thanks. This is useful. In that case I must patch the kernel with your patch
or I must compile md into the kernel.

Thanks for the hint.

Zeno


> --
> Paul

