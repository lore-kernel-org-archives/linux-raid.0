From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: OT: Tips for good hard drives for a home server
Date: Fri, 14 Nov 2008 12:51:09 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811141250040.16928@p34.internal.lan>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>  <7d86ddb90811120619vca13676tb0192676ece0cb93@mail.gmail.com>  <491CA255.4070402@tmr.com>  <alpine.DEB.1.10.0811132357390.10993@uplift.swm.pp.se>
 <a43edf1b0811140528h5f8446b7i62ae9b2496fb1632@mail.gmail.com> <alpine.DEB.1.10.0811141437100.10993@uplift.swm.pp.se> <491DB9A4.7080308@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <491DB9A4.7080308@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sat, 15 Nov 2008, Richard Scobie wrote:

> Mikael Abrahamsson wrote:
>> On Fri, 14 Nov 2008, Billy Crook wrote:
>> 
>>> Obviously RAID-class drives benefit in hardware raid (with hardware
>>> raid controllers).  But do RAID-class drives benefit when used on a
>>> non-raid hardware controller, with linux software raid (mdadm)?  What
>>> about a hardware raid controller in JBOD mode?
>> 
>> This is not a HW vs SW issue, it has to to with the behaviour of the drives 
>> in conjunction with the OS when a certain thing happens.
>> 
>> In a non-raid environment, you want to read the data at any cost, so 
>> waiting 2 seconds for it to read is no real problem, you just want the 
>> data.
>> 
>> In a raid environment you can reproduce the block by way of mirror or 
>> parity, so you want the read to fail after a short time so it won't delay
>> the reading of the data.
>
> Here is a paper about the Western  Digital feature "TLER", which is used in 
> all their RE series RAID drives.
>
> http://www.wdc.com/en/library/sata/2579-001098.pdf
>
> In addition, these drives are better able to cope with the problem of 
> mechanical vibration/resonance that occurs when multiple drives are mounted 
> in close proximity:
>
> http://www.wdc.com/en/library/sata/2579-001079.pdf
>
> These features will benefit HW and SW RAID implementations.
>
> I have no association with Western Digital, other than as a satisfied user.
>

I have enabled TLER on all of my Velociraptors, we will see if they 'hang'
up anymore and drop out of the raid or just throw bad sector errors right
away, however, I am not sure md(Linux) can handle this, where as a 3ware card
remaps the bad sector, the kernel does not (or at least I have never seen it
do it on my system), instead the drive shows an Uncorrectable_Sector or 
similar..

Justin.

