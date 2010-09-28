From: Tim Small <tim@seoss.co.uk>
Subject: Re: 3-way mirrors
Date: Tue, 28 Sep 2010 17:42:28 +0100
Message-ID: <4CA21AF4.8060308@seoss.co.uk>
References: <20100907141904.3696.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100907141904.3696.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/09/10 15:19, George Spelvin wrote:
> After some frustration with RAID-5 finding mismatches and not being
> able to figure out which drive has the problem, I'm setting up a rather
> intricate 5-way mirrored (x 2-way striped) system.
>    

I know that this doesn't solve your current problem, but I wondered if 
the fact that mismatch_cnt is not a reliable indication of corruption on 
RAID1 and RAID10 is a problem with your proposed solution?  I don't know 
how difficult it would be to fix that whilst you are at it (add a data 
copy in the write path).

Whilst I think about it, perhaps mismatch_cnt should be dropped from 
RAID1 / RAID10 entirely, as it doesn't seem to be particularly useful 
as-is....

Perhaps the data-copy mode could be a runtime option, and mismatch_cnt 
would only appear when it was switched on (and a repair forced when 
making the transition from no-copy mode to copy mode?).

Cheers,

Tim.


-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

