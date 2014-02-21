From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: AW: raid 'check' does not provoke expected i/o error
Date: Fri, 21 Feb 2014 10:43:48 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1402211040100.15054@uplift.swm.pp.se>
References: <5307034E.9080007@eyal.emu.id.au> <A2EC67620EC7424F9EC3DD49243E9060466ECD34@AUDIINSX0328.audi.vwg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2EC67620EC7424F9EC3DD49243E9060466ECD34@AUDIINSX0328.audi.vwg>
Sender: linux-raid-owner@vger.kernel.org
To: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>
Cc: 'Eyal Lebedinsky' <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 21 Feb 2014, Samer, Michael (I/ET-83, extern) wrote:

>> In short: smartctl lists one pending sector. A dd of that disk provokes an i/o error
>> as expected. A raid 'sync_action=check' does not find a problem and does *not* trigger
>> an i/o error. Why?
>
> Hello Eyal
> Why not using ddrescue (or dd_rescue) instead (errorprone).

Probably because he wants to have the pending sector recalculated from 
parity and written to with correct data.

Eyal, I had the same problem. I have reported this in the thread named 
"Re: read errors not corrected when doing check on RAID6". The problem 
wasn't found then and I have since worked around the problem by doing a 
want-replace of the bad drive, so good you too reported this. Perhaps the 
problem can be found and corrected now that I am not the only one 
reporting this behavior.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
