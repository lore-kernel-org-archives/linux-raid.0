From: Tim Small <tim@seoss.co.uk>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Tue, 19 Oct 2010 17:29:10 +0100
Message-ID: <4CBDC756.7010606@seoss.co.uk>
References: <4C938103.1010304@seoss.co.uk>	<20100918085925.5fee83ee@notabene>	<4C97BD21.1040405@seoss.co.uk>	<4C991D61.1040400@seoss.co.uk>	<20100922083039.283ccdfd@notabene>	<4CBC9774.6020500@seoss.co.uk> <20101019171650.20c83e7e@notabene> <4CBDC641.9090009@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CBDC641.9090009@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/10/10 17:24, Tim Small wrote:
>
>  and got this:
>

... sorry meant to say, got this as the last partial call through 
raise_barrier, but I haven't been able to draw any further conclusions.  
Got to head off now for the day, so I thought I'd punt this out and have 
another stare at the code tomorrow.

Cheers,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

