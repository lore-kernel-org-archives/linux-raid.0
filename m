From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: On URE and RAID rebuild - again!
Date: Tue, 05 Aug 2014 00:44:04 +0200
Message-ID: <35916d10dab6084e6f28da2e0975fce7@assyoma.it>
References: <53D8ACF0.1070202@assyoma.it>
 <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
 <53D8ED99.90606@assyoma.it> <20140731073121.38cd1773@notabene.brown>
 <53D9ED48.9000307@assyoma.it> <1370eb7a35b628323646a86094a26912@assyoma.it>
 <20140803134834.7773b0ab@notabene.brown> <53DF8A31.8060609@assyoma.it>
 <alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

Il 2014-08-04 20:40 Mikael Abrahamsson ha scritto:
> 
> Why do you think that's wrong? 10^-14 is what the vendor guarantees. I
> have had drives with worse performance (after a couple of months I had
> several UNC sectors without reading much).
> 
> Your claim about the article being wrong is the same as saying that
> the risk reported of getting into a car accident is wrong because
> you've driven that amount of kilometers but haven't been in an
> accident yet.
> 
> This is statistics, marketing and warranty, not guaranteed behavior.

Yes, I understand this. However, the linked article (and many others) 
state:
"If you have a 2TB drive, you write 2TB to it, and then you fully read 
that, just over 6 times, then you will run into one read error, 
theoretically speaking."

I read my 500 GB drive over _60_ times, reading 3x more total data than 
stated above.

I started the entire discussion to know how UREs are calculated, trying 
to understand if they are expressed as probability ("1 probabily over 
10^14 that we can not read a sector) or a statistical record ("we found 
that 1 on 10^14 is not readable").

If defined as a probability, I am very lucky: if my math is OK, I should 
have only 0.5% to read about 40 TB of data (my math is: 
(1-(1/10^14))^(3*(10^14))). If, on the other hand, UREs are defined as 
statistical evidence (as MTBF), environment and test conditions (eg: 
duty cycle, read/write distribution, etc) are absolutely critical to 
understand  what this parameter really mean for us.

I'm under impression (and maybe I'm wrong, as usual :)) that UREs mainly 
depends on incomplete writes and/or unsable sectors. If this is the 
case, maybe the published URE values are related to the entire HDD 
warranty. In other word, they should be read as "in normal condition, 
with typical loads, out HDD will exibit about 1/10^14 unrecoverable 
error during the entire disk lifespan".

It is reasonable? Or I am horribly wrong?
Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
