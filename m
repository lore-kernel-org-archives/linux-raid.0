From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Fri, 15 Apr 2011 16:31:08 -0500
Message-ID: <4DA8B91C.8050005@hardwarefreak.com>
References: <4DA6CCFE.8020708@crc.id.au>	<20110414185304.5bc1cca5@natsu>	<4DA6F3B2.8080402@crc.id.au>	<4DA7513C.5020505@hardwarefreak.com> <20110415105846.1c4ec630@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110415105846.1c4ec630@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov put forth on 4/14/2011 11:58 PM:
> On Thu, 14 Apr 2011 14:55:40 -0500
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> Steven Haigh put forth on 4/14/2011 8:16 AM:
>>
>>> That is a very nice writeup... I searched for the HighPoint Rocket 620 -
>>> listed as $24.99 on NewEgg - but Australian suppliers seem to have it
>>> above $100AUD. The cheapest price I found was $54AUD - and they were out
>>> of stock.
>>
>> This is the card you should get:
>> http://www.sybausa.com/productInfo.php?iid=536
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16815124027
>>
>> It's the same Syba Sil3132 based card BackBlaze uses in their 45 drive
>> mdadm managed pods.
>>
> 
> Did you read the second link you posted, specifically the Feedback section?
> That's one more confirmation of corruption issue we discussed in this thread.

The overall Newegg rating for the Syba card you deride is 4/5 eggs
across 109 reviews.  If the card was as horrible as you make it out to
be, the rating would be 1/5 not 4/5, and people would stop buying it.

Note that the user who posted the read corruption issue referred to a
single application in Windows 7 where this error occurred, TeraCopy.
It's far more likely he was up against an application or driver issue
than a hardware issue with the Syba card.  He did not state whether a
Windows Explorer copy would also cause the problem, nor xcopy, nor
Robocopy, etc.

BTW, did you even read the BackBlaze blog I posted?  They run hundreds
of this exact Syba 3132 card, with Linux, with mdraid, and have reported
zero problems.  And they're using a 5:1 PMP on each 3132 port.  If these
cards, or the 3132 were junk, as you state, surely BackBlaze would have
run into problems in 2+ years of full production, no?

Again, you're taking isolated incidents and assuming they are the norm,
when they most certainly are not.

-- 
Stan
