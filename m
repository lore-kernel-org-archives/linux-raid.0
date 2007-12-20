From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Thu, 20 Dec 2007 11:24:50 +0100
Message-ID: <20071220102449.GA10225@boogie.lpds.sztaki.hu>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan> <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se> <Pine.LNX.4.64.0712191002580.2468@p34.internal.lan> <476957A7.5010805@tmr.com> <Pine.LNX.4.64.0712191253180.2468@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712191253180.2468@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

On Wed, Dec 19, 2007 at 12:55:16PM -0500, Justin Piszcz wrote:

> unligned, just fdisk /dev/sdc, mkpartition, fd raid.
>  aligned, fdisk, expert, start at 512 as the off-set

No, that won't show any difference. You need to partition _the RAID
device_. If the partitioning is below the RAID level, then alignment do
not matter.

What is missing from your original quote is that the original reporter
used fake-HW RAID which can only handle full disks, and not individual
partitions. So if you want to experience the same performance drop, you
should also RAID full disks together and then put partitions on top of
the RAID array.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
