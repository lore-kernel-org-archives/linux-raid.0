From: Derek Vadala <derek@cynicism.com>
Subject: Re: raid1: module or compiled in?
Date: Wed, 7 May 2003 12:07:30 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030507160730.D592A3B84A@jaded.cynicism.com>
References: <1052320882.649.99.camel@zrr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1052320882.649.99.camel@zrr>
To: Zeno Davatz <zdavatz@generika.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 May 2003, Zeno Davatz wrote:

> If I want the software raid to work do I need to compile it into the
> kernel or does it suffice if I just load the support as module?
>
> I was reading in the software-RAID Howto that the support should NOT be
> loaded as Module. Why would that be?

It depends when you start the arrays. If you are booting from SW RAID or
autostarting, you need to have the driver compiled into the kernel or you
need to use an initial RAM disk that preloads the md driver and necessary
RAID level modules.

If you are booting the system from a standalone disk you can skip this and
use modules without the initial RAM disk.  After the system comes up, just
start the array using mdadm or raidstart (in rc.local, for example).

A lot of people prefer compiling drivers directly into the kernel for
production systems. I've found both approaches work just fine.

-- 
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

