From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: OT: Tips for good hard drives for a home server
Date: Fri, 14 Nov 2008 14:40:28 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0811141437100.10993@uplift.swm.pp.se>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>  <7d86ddb90811120619vca13676tb0192676ece0cb93@mail.gmail.com>  <491CA255.4070402@tmr.com>  <alpine.DEB.1.10.0811132357390.10993@uplift.swm.pp.se>
 <a43edf1b0811140528h5f8446b7i62ae9b2496fb1632@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0811140528h5f8446b7i62ae9b2496fb1632@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 14 Nov 2008, Billy Crook wrote:

> Obviously RAID-class drives benefit in hardware raid (with hardware
> raid controllers).  But do RAID-class drives benefit when used on a
> non-raid hardware controller, with linux software raid (mdadm)?  What
> about a hardware raid controller in JBOD mode?

This is not a HW vs SW issue, it has to to with the behaviour of the 
drives in conjunction with the OS when a certain thing happens.

In a non-raid environment, you want to read the data at any cost, so 
waiting 2 seconds for it to read is no real problem, you just want the 
data.

In a raid environment you can reproduce the block by way of mirror or 
parity, so you want the read to fail after a short time so it won't delay
the reading of the data.

So as long as md can re-write a faulty block (which it can from 2.6.15 (or 
.16 or .17, I don't remember), you should have raid firmware in your 
drives for best performance.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
