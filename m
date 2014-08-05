From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: On URE and RAID rebuild - again!
Date: Tue, 05 Aug 2014 21:42:17 +0200
Message-ID: <228fa3bd137e034e9ec974094f37b368@assyoma.it>
References: <53D8ACF0.1070202@assyoma.it>
 <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
 <53D8ED99.90606@assyoma.it> <20140731073121.38cd1773@notabene.brown>
 <53D9ED48.9000307@assyoma.it> <1370eb7a35b628323646a86094a26912@assyoma.it>
 <20140803134834.7773b0ab@notabene.brown> <53DF8A31.8060609@assyoma.it>
 <alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se>
 <35916d10dab6084e6f28da2e0975fce7@assyoma.it>
 <20140805190159.GA2897@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140805190159.GA2897@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

Il 2014-08-05 21:01 Piergiorgio Sartor ha scritto:
> 
> This means they, who wrote the article, did not
> really *tested* what they wrote.
> Which already tells us a lot about the quality
> of the article itself.

True. Problem is that the web is full of similar articles, which sounded 
waaaaay to much "suspicious" is what they said.

> What's the difference between "probability" and
> "statistical record"?
> Is not one calculated with the other?

Premise: I am not a statistical expert, so maybe I used the wrong terms 
and/or my entire reasoning is flawed.

I am trying to imagine _how_ the various vendors arrive at the claimed 
number and _how much_ we have confidence in URE rate. _If_ for some 
reason (eg: magnetical interference during write and/or rest) a fixed 
"wrong read" probability exists _and_ _if_ it is correct to consider 
each sector read as totally indipendent events, HDD manufacturer may 
have a quite precise formula from which URE rate is obtained.

If, on the other hand, they "simply" observe how a big drive population 
reacts over time, maybe we can expect bigger variations between drivers.

I'm just speculating here; what really worried me was "you can't read 6 
times your 2 TB drive" argument :)

> I'm to lazy to try to understand what 3*10^14 is.
> What is it?

I have read about 40 TB of data, or 320 Tb. 10^14 is 12.5 TB or 100 Tb, 
if you prefer. So 3*10^14 simply is the numnber of bit that I read (URE 
is expressed as 1 event over 10^14 bit, so I wonder that make sense to 
use the same scale here).

> I'm under the impression you did not grasp the
> concept of probability is such contex.
> Given that it is not clear how the manufacturers
> compute their numbers, both cases you describe
> are the same.
> All the possible conditions are included in the
> probability computation.

I can see your point...

> You can state: under worst case scenario, *each*
> bit has a probability of 10E-14 of being wrong.
> What does this mean?

... and _this_ is what really interested me. Manufacturer publish URE 
rate as "max" values, so should be reasonable to assume that they are 
worst-case scenario. If this is the case, we can be quite sure that our 
URE rate will be lower then published specs (assuming that drive are 
deployed with care).

On the other hand, in some articles and even in this mailing list I read 
that published URE rate really are a "max of various means" and do not 
represent true worst-case scenario.

> As already wrote by others, it is not clear what
> that number (10E-14) means.
> A common understanding could be, as stated above,
> each bit has a *probability* of 10E-14 of being wrong.
> 
> Practically, it does *not* mean that reading 10E14 bit
> will deliver one bit wrong sistematically.

But if the spec is representative of normal usage scenario, reading 40 
TB of data with URE of 10^-14 has very high probabily to return a bad 
read (>95%) ...

> Furthermore, as already again stated, very likely
> an "average" HDD has much lower URE probability.

This is reassuring :)

> 
> Is this pure curiosity from your side or are
> you trying to achieve something?
> 
> There is a report, from CERN I think, provinding
> real world statistics about HDD problems.
> 
> http://storagemojo.com/2007/09/19/cerns-data-corruption-research/
> 
> bye,

Yes, I saw this article and read it with great interest. After all it 
seems that the greater part of data corruption is due to 
firmware/kernel/driver bug, and that URE rate play a minor role here.

Thank you very much guys. I'm sorry to boring you with all these 
questions, but I'm just trying to learn something!
Regards.


-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
