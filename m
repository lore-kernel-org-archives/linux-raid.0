From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Inexpensive RAID1 controller for home server?
Date: Sat, 18 Aug 2012 23:09:43 -0500
Message-ID: <50306707.40302@hardwarefreak.com>
References: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/18/2012 2:18 PM, Mark Knecht wrote:
> Hi,
>    I wonder if there is direct knowledge here about this controller?
> 
> http://www.amazon.com/HighPoint-Rocket-SATA-PCI-Express-Controller/dp/B002VEWBGO
> 
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

Given the potential Marvell conflict issue, go with Silicon Image:

http://www.newegg.com/Product/Product.aspx?Item=N82E16815124027

All Silicon Image chips are supported in mainline, have been forever.

-- 
Stan

