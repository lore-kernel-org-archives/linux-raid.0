From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: thanks md raid
Date: Thu, 10 May 2012 21:51:58 +0000
Message-ID: <4FAC387E.1010006@pocock.com.au>
References: <4FAC0ED2.2000201@pocock.com.au> <4FAC37D9.6040403@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC37D9.6040403@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/05/12 21:49, Stan Hoeppner wrote:
> On 5/10/2012 1:54 PM, Daniel Pocock wrote:
>>
>> I'm glad my RAID1 worked as expected... just hoping I don't encounter
>> any read timeouts on the non-TLER drive before my rebuild finishes:
> 
> You have an inverse understanding of ERC.  Drives without ERC will retry
> forever, or until an upper layer puts a stop to its efforts.  Drives
> with a 7 second ERC will return a hard error after 7 seconds.
> 
> So the only way you'll get a timeout with your rebuild is if the healthy
> drive spends 30 seconds retying a sector read.
> 

I was thinking about the more obscure case - that some other URE
followed by an attempt at write access on the good drive fails and it
becomes degraded
