From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Show me the cache, was Mirroring swap
Date: Fri, 27 Jun 2003 14:24:45 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0306271420230.7750-100000@sweetums.bluetronic.net>
References: <200306271104270562.57541D29@shargaas.coreyfro.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200306271104270562.57541D29@shargaas.coreyfro.com>
To: Corey McGuire <coreyfro@coreyfro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 27 Jun 2003, Corey McGuire wrote:
>"DisablePagingExecutive"=dword:00000001

(That doesn't actually work.  NT/2000/XP will still page the kernel parts.
 But not much of it.)

>...  "LargeSystemCache" hardly
>helps, as it basicly tells Windows "yes, all RAM _CAN_ be used for cache"
>instead of just a paultry 4MB.  Does this help?  Yeah, my 512MB machine is
>currently using 18MB's of cache.

Currently, my XP Home laptop is using 356,188K of cache.  That will go to
"all available RAM" if an application starts writing large volumes of data
to disk. (Linux throttles processes that flood the cache.)

--Ricky


