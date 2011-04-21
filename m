From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Direct disk access on IBM Server
Date: Wed, 20 Apr 2011 23:50:01 -0400
Message-ID: <BANLkTint14TBOaBqaaXrUggeJWMPShWA8A@mail.gmail.com>
References: <iok28i$tp6$1@dough.gmane.org>
	<4DADEBC3.9060404@hardwarefreak.com>
	<iomfkq$qqr$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iomfkq$qqr$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 20, 2011 at 7:24 AM, David Brown <david@westcontrol.com> wrote:
> Pros for hardware raid:
>
> + It can have battery backup (I don't have one at the moment - I have an
> excellent UPS for the whole system).
> + Rebuilds will be handled automatically by just adding new disks
> + The card supports online resizing and reshaping
> + It looks like the card supports caching with an SSD
> + The card supports snapshots of the virtual drives

Unless the card allows you to enable the write cache without the
backup battery you will not see the real performance of the card. This
option is normally locked out to prevent data loss in case the system
crashes, power is pulled, etc. An external UPS will not protect in all
cases if you enable the write back cache without battery.

I have systems with both software raid and hardware raid. If the
budget allows I tend to go the hardware raid route. When buying a
Dell, HP, etc server with hardware raid you end up with a complete
package. The enclosure, card, and server monitoring software make it
easy to manage and visually see which drive has failed.

Ryan
