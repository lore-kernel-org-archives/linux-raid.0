From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: On URE and RAID rebuild - again!
Date: Tue, 5 Aug 2014 21:01:59 +0200
Message-ID: <20140805190159.GA2897@lazy.lzy>
References: <53D8ACF0.1070202@assyoma.it>
 <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
 <53D8ED99.90606@assyoma.it>
 <20140731073121.38cd1773@notabene.brown>
 <53D9ED48.9000307@assyoma.it>
 <1370eb7a35b628323646a86094a26912@assyoma.it>
 <20140803134834.7773b0ab@notabene.brown>
 <53DF8A31.8060609@assyoma.it>
 <alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se>
 <35916d10dab6084e6f28da2e0975fce7@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <35916d10dab6084e6f28da2e0975fce7@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 05, 2014 at 12:44:04AM +0200, Gionatan Danti wrote:
[...]
> Yes, I understand this. However, the linked article (and many others) state:
> "If you have a 2TB drive, you write 2TB to it, and then you fully read that,
> just over 6 times, then you will run into one read error, theoretically
> speaking."

This means they, who wrote the article, did not
really *tested* what they wrote.
Which already tells us a lot about the quality
of the article itself.

> I read my 500 GB drive over _60_ times, reading 3x more total data than
> stated above.
> 
> I started the entire discussion to know how UREs are calculated, trying to
> understand if they are expressed as probability ("1 probabily over 10^14
> that we can not read a sector) or a statistical record ("we found that 1 on
> 10^14 is not readable").

What's the difference between "probability" and
"statistical record"?
Is not one calculated with the other?

> If defined as a probability, I am very lucky: if my math is OK, I should
> have only 0.5% to read about 40 TB of data (my math is:
> (1-(1/10^14))^(3*(10^14))). If, on the other hand, UREs are defined as

I'm to lazy to try to understand what 3*10^14 is.
What is it?

> statistical evidence (as MTBF), environment and test conditions (eg: duty
> cycle, read/write distribution, etc) are absolutely critical to understand
> what this parameter really mean for us.

I'm under the impression you did not grasp the
concept of probability is such contex.
Given that it is not clear how the manufacturers
compute their numbers, both cases you describe
are the same.
All the possible conditions are included in the
probability computation.

You can state: under worst case scenario, *each*
bit has a probability of 10E-14 of being wrong.
What does this mean?

> I'm under impression (and maybe I'm wrong, as usual :)) that UREs mainly
> depends on incomplete writes and/or unsable sectors. If this is the case,
> maybe the published URE values are related to the entire HDD warranty. In
> other word, they should be read as "in normal condition, with typical loads,
> out HDD will exibit about 1/10^14 unrecoverable error during the entire disk
> lifespan".

As already wrote by others, it is not clear what
that number (10E-14) means.
A common understanding could be, as stated above,
each bit has a *probability* of 10E-14 of being wrong.

Practically, it does *not* mean that reading 10E14 bit
will deliver one bit wrong sistematically.

Furthermore, as already again stated, very likely
an "average" HDD has much lower URE probability.

> 
> It is reasonable? Or I am horribly wrong?

Is this pure curiosity from your side or are
you trying to achieve something?

There is a report, from CERN I think, provinding
real world statistics about HDD problems.

http://storagemojo.com/2007/09/19/cerns-data-corruption-research/

bye,

pg

> Regards.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
