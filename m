From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Hardware versus Software
Date: Wed, 19 May 2004 15:00:40 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405191452450.14297-100000@sweetums.bluetronic.net>
References: <ac.5847806b.2ddc5d88@aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac.5847806b.2ddc5d88@aol.com>
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 19 May 2004 AndyLiebman@aol.com wrote:
>But the question still remains, is there any other safety and reliability
>advantage to using Hardware? Is the data on a Hardware RAID more likely to
>remain intact in the event of a computer crash or freeze?

The linux software RAID is good stuff.  It *can* be difficult to repair
an array in a few cases -- don't put the root FS in a non-mirrored array
and they shouldn't be a problem.

As you don't care about CPU cycles used by the array, you're far better
off using the software raid with normal drive controllers. (esp. true
for SATA.)  Hardware RAID cards generally offer better managability
and stability -- the OS doesn't have to know if a drive fails, they're
designed to hot-swap drives with little or no fuss, etc.  But, they will
be just a reliable as anything else.

For a system I never want to have to touch, I use hardware raid.  For those
systems sitting at my feet, that isn't as important.

--Ricky


