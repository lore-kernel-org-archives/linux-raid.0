From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid1: module or compiled in?
Date: Wed, 07 May 2003 11:48:54 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB92AE6.91F9FED4@SteelEye.com>
References: <1052320882.649.99.camel@zrr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: zdavatz@generika.cc
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zeno Davatz wrote:

> I am a Debian Woody 2.4.20 user and got the following question:
> 
> If I want the software raid to work do I need to compile it into the
> kernel or does it suffice if I just load the support as module?

md generally does have to be compiled in...the raid personality modules
(raid1, raid5, etc.) can be compiled as modules... more below...
 
> I was reading in the software-RAID Howto that the support should NOT be
> loaded as Module. Why would that be?

Were they talking about _md_ needing to be compiled in? Because it has
to be compiled into the kernel if you want to use persistent superblocks
and/or use it for your root partition. I have patches against 2.4 and
2.5 to fix this md problem, BTW, if anyone wants them...I posted the 2.5
one a while back...

--
Paul
