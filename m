From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID-5 to RAID-6 Reshape Process
Date: Mon, 23 Nov 2009 07:19:07 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0911230717070.14550@uplift.swm.pp.se>
References: <E0A5D033-60CF-4CC6-A124-37C597C6235B@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E0A5D033-60CF-4CC6-A124-37C597C6235B@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Hattersley <joshhattersley@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 22 Nov 2009, Joshua Hattersley wrote:

> I have a home server running Ubuntu 9.04 Server (kernel 
> 2.6.28-16-server), which has three drives in RAID-5 using mdadm (version 
> 2.6.7.1 according to mdadm --version).  I would like to reshape this 
> array into a RAID-6 using one additional drive, thereby turning it into 
> a four disk RAID-6 array (with the intention to grow the usable size of 
> the array later on).  I've been scouring the relevant info I can find on 
> the web and haven't come across a well-outlined process by which to 
> accomplish this.

Read the mdadm annoucement from the 19th. You need latest mdadm and kernel 
2.6.32 to do the reshape. After that is done you can run the raid6 on the 
2.6.28 kernel you're running already.

Personally I'd make sure my data was properly backed up before doing this 
process, it's quite recent code.
