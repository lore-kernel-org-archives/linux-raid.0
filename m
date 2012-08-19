From: Phil Turmel <philip@turmel.org>
Subject: Re: Inexpensive RAID1 controller for home server?
Date: Sat, 18 Aug 2012 23:20:52 -0400
Message-ID: <50305B94.4020607@turmel.org>
References: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/18/2012 03:18 PM, Mark Knecht wrote:
> Hi,
>    I wonder if there is direct knowledge here about this controller?
> 
> http://www.amazon.com/HighPoint-Rocket-SATA-PCI-Express-Controller/dp/B002VEWBGO

I have one of these in a non-critical home system (light duty media
server).  Rather old mobo, actually...  32bit w/ PCIe v1 slots.  Card
maxes out at 200MB/s in that system.  Theoretically capable of 500MB/s
in a PCIe v2 slot.

Kernel is vanilla 2.6.39.4 at the moment.  Card is bound to the ahci
driver with no problems.  Hotplug works fine, too.

>    I'm looking to add an inexpensive 2-port controller for a home
> server that's out of ports on the MB but has room in the chassis for a
> couple more drives running RAID1. The machine has been successfully
> running mdadm for the last couple of years and the power supply is
> plenty big enough to take on the new hardware.
> 
>    According the the Highpoint site is has native Linux support so it
> doesn't appear there are any major driver availability issues. The one
> problem I've read about that concerns me is it may conflict with
> existing on-board Marvell eSATA controllers which this machine has.
> 
>    If this is a bad type of controller for a sinple RAID1 addition
> please feel free to point me at an alternative. Amazon or NewEgg is
> preferred.

I got mine from NewEgg, FWIW.

HTH,

Phil

