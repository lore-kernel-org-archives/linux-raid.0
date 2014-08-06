From: Chris Murphy <lists@colorremedies.com>
Subject: Re: On URE and RAID rebuild - again!
Date: Wed, 6 Aug 2014 10:34:02 -0600
Message-ID: <47BC249A-F0A4-4130-B6DE-26D2CCD72B56@colorremedies.com>
References: <53D8ACF0.1070202@assyoma.it> <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se> <53D8ED99.90606@assyoma.it> <20140731073121.38cd1773@notabene.brown> <53D9ED48.9000307@assyoma.it> <1370eb7a35b628323646a86094a26912@assyoma.it> <20140803134834.7773b0ab@notabene.brown> <53DF8A31.8060609@assyoma.it> <alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se> <35916d10dab6084e6f28da2e0975fce7@assyoma.it>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <35916d10dab6084e6f28da2e0975fce7@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Aug 4, 2014, at 4:44 PM, Gionatan Danti <g.danti@assyoma.it> wrote:

> Il 2014-08-04 20:40 Mikael Abrahamsson ha scritto:
>> Why do you think that's wrong? 10^-14 is what the vendor guarantees. I
>> have had drives with worse performance (after a couple of months I had
>> several UNC sectors without reading much).
>> Your claim about the article being wrong is the same as saying that
>> the risk reported of getting into a car accident is wrong because
>> you've driven that amount of kilometers but haven't been in an
>> accident yet.
>> This is statistics, marketing and warranty, not guaranteed behavior.
> 
> Yes, I understand this. However, the linked article (and many others) state:
> "If you have a 2TB drive, you write 2TB to it, and then you fully read that, just over 6 times, then you will run into one read error, theoretically speaking."

A while ago I brought up the fact the less than sign is ignored in such assertions. And that's why they draw the wrong conclusions.


> I read my 500 GB drive over _60_ times, reading 3x more total data than stated above.

Right and it wouldn't surprise me if you could read it 600 times without unrecoverable read error. Also note that the spec doesn't require that you read every sector. You could have read one sector 24414062500 times to arrive at just over 1E14 bits read, assuming it's a 512 byte drive.

http://arxiv.org/pdf/cs/0701166.pdf


> I started the entire discussion to know how UREs are calculated, trying to understand if they are expressed as probability ("1 probabily over 10^14 that we can not read a sector) or a statistical record ("we found that 1 on 10^14 is not readable").

Neither. Both conclusions are overreach based on what the spec says. The spec is not stating an average, and we also know from a large body of publicly available information that drive failure rates aren't constant with age. So the distribution is actually quite complex.



> If defined as a probability, I am very lucky: if my math is OK, I should have only 0.5% to read about 40 TB of data (my math is: (1-(1/10^14))^(3*(10^14))). If, on the other hand, UREs are defined as statistical evidence (as MTBF), environment and test conditions (eg: duty cycle, read/write distribution, etc) are absolutely critical to understand  what this parameter really mean for us.


A URE isn't a failure to a manufacturer. Strictly speaking they're only promising less than one error per 12TB of bits read,in this example. If a read error happens more frequently, the implicit performance hasn't been met and you're entitled to a replacement. Otherwise you're not. But in practice manufacturers hand out RMAs for warranty drives for almost any reason which is why almost half of the drives they take back under warranty have no spec busting problems per their testing. So what parameters users have for "failure" vs the manufacturer, aren't exactly aligned.


> 
> I'm under impression (and maybe I'm wrong, as usual :)) that UREs mainly depends on incomplete writes and/or unsable sectors. If this is the case, maybe the published URE values are related to the entire HDD warranty. In other word, they should be read as "in normal condition, with typical loads, out HDD will exibit about 1/10^14 unrecoverable error during the entire disk lifespan".

You can only arrive at this conclusion by ignoring the < sign that all the manufacturers use (or the explicitly stated "less than" phrasing).


Chris Murphy