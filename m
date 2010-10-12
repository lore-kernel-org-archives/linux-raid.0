From: Tim Small <tim@seoss.co.uk>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Tue, 12 Oct 2010 15:06:45 +0100
Message-ID: <4CB46B75.8050205@seoss.co.uk>
References: <4C938103.1010304@seoss.co.uk>	<20100918085925.5fee83ee@notabene>	<4C97BD21.1040405@seoss.co.uk>	<4C991D61.1040400@seoss.co.uk> <20100922083039.283ccdfd@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100922083039.283ccdfd@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry, hit send too soon...


On 21/09/10 23:30, Neil Brown wrote:
> It is odd that 2.6.32 works and 2.6.26 doesn't as I cannot find any change
> between the two that could be related.
> There were some deadlock issues if a read-error was detected during resync
> but I don't think you are getting read errors are you?
>    

Nope, no read errors.

> A bisect would of course be easier for me, though not particularly easy for
> you....
>    

I haven't as-yet been able to reproduce the issue without running OpenVZ 
on the box - I suppose the two possibilities are:

1. The bug is in the OpenVZ patches (seems unlikely given the nature of 
the hang, but possible I suppose).
2. The bug is only triggered by the workload which the VZ container is 
producing

... so without this, a bisect is a non-starter.

Grrr.

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

