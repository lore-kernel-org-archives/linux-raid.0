From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Thu, 20 Dec 2007 11:33:56 +0100
Message-ID: <20071220103356.GB10225@boogie.lpds.sztaki.hu>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan> <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

On Wed, Dec 19, 2007 at 04:01:43PM +0100, Mattias Wadenstein wrote:

> From that setup it seems simple, scrap the partition table and use the disk 
> device for raid. This is what we do for all data storage disks (hw raid) 
> and sw raid members.

And _exactly_ that's when you run into the alignment problem. The common
SW RAID case (first partitioning, then building RAID arrays from
individual partitions) does not suffer from this issue.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
