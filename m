From: Scott Long <scott_long@adaptec.com>
Subject: Re: Adaptec 39160 RAID ?!
Date: Tue, 10 Feb 2004 19:33:15 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4029946B.7040003@adaptec.com>
References: <Pine.LNX.4.44.0402111215260.21666-100000@gw.luko.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0402111215260.21666-100000@gw.luko.org>
To: Luke Rosenthal <lists@luko.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luke Rosenthal wrote:
>>>Yes, but doesn't the card ship with "fake RAID"?
>>
>>No, it's just a plain old Ultra160 Dual Channel SCSI Host Adapter.
> 
> 
> I just purchased one actually, have hooked it up to a Quantum Atlas 10K2
> 
> and can't seem to get them talking in Ultra160 mode.  Here's the proc 
> output:
> 
> 
> Adaptec AIC7xxx driver version: 6.2.8
> aic7899: Ultra160 Wide Channel B, SCSI Id=0, 32/253 SCBs
> 
> Serial EEPROM:
> 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 
> 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0x43bb 
> 0xb8f4 0x5d5c 0x2800 0x0010 0xffff 0xffff 0xffff 0xffff 
> 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0xf4c7 
> 
> Channel A Target 0 Negotiation Settings
>         User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
> [snip snip Targets 1-14, nothing hooked up]
> Channel A Target 15 Negotiation Settings
>         User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
>         Goal: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Curr: 40.000MB/s transfers (20.000MHz, offset 127, 16bit)
>         Channel A Target 15 Lun 0 Settings
>                 Commands Queued 438859
>                 Commands Active 0
>                 Command Openings 32
>                 Max Tagged Openings 32
>                 Device Queue Frozen Count 0
> 
> 
> The drive has a SCA connector on the back, with a sticker on the
> connector 
> stating "Ultra160/LVD/SE".  To connect this drive I've used an adapter 
> which converts the SCA connection into a regular 68-pin internal one,
> then 
> used a terminated cable with Ultra160/LVD/SE marked on both the
> connectors 
> (there's 4 of them) AND the terminator.  I've tried turning the internal
> 
> terminator in the Adaptec BIOS on and off with no change.  There's no 
> other devices on this bus other than the drive & the host adapter.
> 

For whatever reason, the bus is running in single ended mode.  I don't
have a guide to the 10k2 handy (and google is turning up empty), but it
might either be jumpered wrong, or you might have a cabling issue.  You
might also want to check that the SCA<->68 pin coverter isn't
responsible.

> Is this normal?  What do "User", "goal" and "curr" mean?

User is what the BIOS is set to
Goal is the best that we think that we can get
Curr is what we are actually running at

> Why are there so many commands queued?

This is just a cummulative count since the system booted.

Scott

