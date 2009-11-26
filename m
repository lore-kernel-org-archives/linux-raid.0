From: Asdo <asdo@shiftmail.org>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Thu, 26 Nov 2009 15:13:19 +0100
Message-ID: <4B0E8CFF.1080106@shiftmail.org>
References: <4B0E7111.20202@shiftmail.org>
 <alpine.DEB.1.10.0911261459330.14550@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.1.10.0911261459330.14550@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Thu, 26 Nov 2009, Asdo wrote:
>
>> Now I am scared about initiating the first scrub because if it turns 
>> out that 3 areas in different disks have bad sectors I think am gonna 
>> lose the whole array.
>
> What kernel are you using?
>
> As of 2.6.15 or so, sending "repair" (or "resync", I don't remember 
> exactly) to the md will read all data and if there is bad data, parity 
> will be used to write to the bad sector (it shouldn't kick the disk).
>
> <http://linux-raid.osdl.org/index.php/RAID_Administration>
>
Kernel is ubuntu kernel 2.6.24 .
In the page you are linking I don't see mention of the fact that drives 
won't be kicked with a "repair" or "check".
In fact regarding "check" this is written:
  'check' just reads everything and doesn't trigger any writes unless a 
read error is detected, in which case the normal read-error handing 
kicks in.
"normal error handling" seems to suggest that if the read error is 
uncorrectable the drive will be kicked. You don't think so?

Thank you


