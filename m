From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Thu, 26 Nov 2009 15:03:45 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0911261459330.14550@uplift.swm.pp.se>
References: <4B0E7111.20202@shiftmail.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B0E7111.20202@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 26 Nov 2009, Asdo wrote:

> Now I am scared about initiating the first scrub because if it turns out 
> that 3 areas in different disks have bad sectors I think am gonna lose 
> the whole array.

What kernel are you using?

As of 2.6.15 or so, sending "repair" (or "resync", I don't remember 
exactly) to the md will read all data and if there is bad data, parity 
will be used to write to the bad sector (it shouldn't kick the disk).

<http://linux-raid.osdl.org/index.php/RAID_Administration>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
