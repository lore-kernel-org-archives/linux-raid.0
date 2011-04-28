From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Thu, 28 Apr 2011 18:11:12 -0400
Message-ID: <4DB9E600.6040508@turmel.org>
References: <4DA773EB.5030005@turmel.org>	<327628.84887.qm@web65101.mail.ac2.yahoo.com> <20110429021118.0f247326@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110429021118.0f247326@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Gavin Flower <gavinflower@yahoo.com>, =?ISO-8859-1?Q?Mathias_Bur=E9?= =?ISO-8859-1?Q?n?= <mathias.buren@gmail.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/28/2011 04:11 PM, Roman Mamedov wrote:
> On Thu, 28 Apr 2011 13:03:39 -0700 (PDT)
> Gavin Flower <gavinflower@yahoo.com> wrote:
> 
>> A couple of days ago, my friend Mario brought over his oscilloscope and a
>> volt meter.  The 5 volt rail was showing about 4.7 volts, typically it
>> should be 5.2 - 5.4 (from memory of what he said), and the voltage looked
>> shaky on the oscilloscope.  The old power supply rated at 400 Watts.  
> 
> 4.7V is fine, those voltages have a tolerance of +/-10%. And if you have a
> deviation there, it is actually better for it to be to the lower side, than
> equivalent to the higher. Reason: no heat increase.

Uh.  Close, but no.

Quoting the Seagate manual for that drive:

> 2.7.3 Voltage tolerance
> 
> Voltage tolerance (including noise):
>  5V +10% / -7.5%
> 12V +10% / -10.0%

So he was somewhere around 75mV above the low spec, and it was "shaky".  If his meter was rounding up to 4.7 from 4.65, he could have been as close as 25mV to the low spec.

Based on the manual, the best noise tolerance will be at 5.0625V, the middle of the spec.

There might be big datacenter engineers that'll trade some noise margin for heat dissipation savings.  For that drive's active power consumption, a 5% voltage reduction (half of his noise margin) will save him, at most, 28W (5 drives * 6.19W * 0.95^2).  That's a savings of $14 per year for 24/7/365 usage in my household.

I'd spend the $14 for the safety margin on *my* data.  (And I do.)

Regards,

Phil
