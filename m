From: Tim Small <tim@seoss.co.uk>
Subject: Re: Data-check brings system to a standstill
Date: Fri, 18 Jun 2010 18:10:24 +0100
Message-ID: <4C1BA880.1050609@seoss.co.uk>
References: <4C0FCFCD.4070201@quo.to> <4C19015B.3020807@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C19015B.3020807@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jordan Russell <jr-list-2010@quo.to>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/06/10 17:52, Bill Davidsen wrote:
>> As of kernel 2.6.32 (I didn't see this when I was running 2.6.24-2.6.27
>> previously), the kernel also emits "hung task" warnings every few
>> minutes while the data-check is in progress:
>>
>> # echo check > /sys/block/md1/md/sync_action
>> # cat /var/log/messages
>

Have things switched to AHCI (or similar SATA controller) with NCQ 
since?  If so, do you drives have buggy firmware which makes them suck 
with sequential reads when NCQ is enabled?  See the libata wiki for 
details - you can try disabling NCQ (or limiting queue depth to 2, or 
whatever) to test it....

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

