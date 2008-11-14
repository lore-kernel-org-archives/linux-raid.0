From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: OT: Tips for good hard drives for a home server
Date: Sat, 15 Nov 2008 06:47:16 +1300
Message-ID: <491DB9A4.7080308@sauce.co.nz>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>  <7d86ddb90811120619vca13676tb0192676ece0cb93@mail.gmail.com>  <491CA255.4070402@tmr.com>  <alpine.DEB.1.10.0811132357390.10993@uplift.swm.pp.se> <a43edf1b0811140528h5f8446b7i62ae9b2496fb1632@mail.gmail.com> <alpine.DEB.1.10.0811141437100.10993@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811141437100.10993@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Fri, 14 Nov 2008, Billy Crook wrote:
> 
>> Obviously RAID-class drives benefit in hardware raid (with hardware
>> raid controllers).  But do RAID-class drives benefit when used on a
>> non-raid hardware controller, with linux software raid (mdadm)?  What
>> about a hardware raid controller in JBOD mode?
> 
> This is not a HW vs SW issue, it has to to with the behaviour of the 
> drives in conjunction with the OS when a certain thing happens.
> 
> In a non-raid environment, you want to read the data at any cost, so 
> waiting 2 seconds for it to read is no real problem, you just want the 
> data.
> 
> In a raid environment you can reproduce the block by way of mirror or 
> parity, so you want the read to fail after a short time so it won't delay
> the reading of the data.

Here is a paper about the Western  Digital feature "TLER", which is used 
in all their RE series RAID drives.

http://www.wdc.com/en/library/sata/2579-001098.pdf

In addition, these drives are better able to cope with the problem of 
mechanical vibration/resonance that occurs when multiple drives are 
mounted in close proximity:

http://www.wdc.com/en/library/sata/2579-001079.pdf

These features will benefit HW and SW RAID implementations.

I have no association with Western Digital, other than as a satisfied user.

Regards,

Richard

