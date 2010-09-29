From: Tim Small <tim@seoss.co.uk>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 13:21:53 +0100
Message-ID: <4CA32F61.3070802@seoss.co.uk>
References: <4CA300EB.1070909@xunil.at> <4CA32AA3.3090602@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA32AA3.3090602@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: lists@xunil.at, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/09/10 13:01, Michael Tokarev wrote:
>
>> I also ran a "echo check>  /sys/block/mdX/md/sync_action" because this
>> had helped to remove those errors at another server, unfortunately it
>> did not help here.
>>      
> It should be repair, not check - check merely reads stuff, repair tries
> to fix it.
>
>    

No it shouldn't, AFAIK - check will read from all sectors on all drives, 
and will trigger a rewrite on unreadable blocks (which is what the  OP has).

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

