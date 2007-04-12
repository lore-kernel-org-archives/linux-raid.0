From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: raid10 kernel panic on sparc64
Date: Thu, 12 Apr 2007 23:28:23 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704122326450.14441@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704020211380.1245@yvahk01.tjqt.qr>
 <20070412.142628.27805319.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070412.142628.27805319.davem@davemloft.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids


On Apr 12 2007 14:26, David Miller wrote:
>From: Jan Engelhardt <jengelh@linux01.gwdg.de>
>Date: Mon, 2 Apr 2007 02:15:57 +0200 (MEST)
>
>> Kernel is kernel-smp-2.6.16-1.2128sp4.sparc64.rpm from Aurora Corona.
>> Perhaps it helps, otherwise hold your breath until I reproduce it.
>
>Jan, if you can reproduce this with the current 2.6.20 vanilla
>kernel I'd be very interested in a full trace so that I can
>try to fix this.
>
>With the combination of an old kernel and only part of the
>crash trace, there isn't much I can do with this report.

Hi David,

I have not forgotten this issue, but the fact that there is not any serial
console attached right now makes it kinda hard to get the system back up
in case I let it oops. Apologies for the delay it takes.


Jan
-- 
