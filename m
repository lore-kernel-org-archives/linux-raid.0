From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: On URE and RAID rebuild - again!
Date: Tue, 05 Aug 2014 08:52:01 +0200
Message-ID: <53E07F11.5050103@assyoma.it>
References: <53D8ACF0.1070202@assyoma.it>	<alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>	<53D8ED99.90606@assyoma.it>	<20140731073121.38cd1773@notabene.brown>	<53D9ED48.9000307@assyoma.it>	<1370eb7a35b628323646a86094a26912@assyoma.it>	<20140803134834.7773b0ab@notabene.brown>	<53DF8A31.8060609@assyoma.it>	<alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se>	<35916d10dab6084e6f28da2e0975fce7@assyoma.it> <20140805092951.7d8f8e6d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140805092951.7d8f8e6d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids



On 05/08/2014 01:29, NeilBrown wrote:
> On Tue, 05 Aug 2014 00:44:04 +0200 Gionatan Danti <g.danti@assyoma.it> wrote:
>
>
> Probabilities are often calculated by examining a statistical record - the
> two concepts are not separate.
> There is probably some theoretical analysis, some statistical analysis, some
> marketing and maybe even some actuarial analysis that goes in to the quoted
> figure.  I remember when CPU speed was measured in "MIPS".
> This stood for
>     Meaningless Indicators of Performance for Salesmen
>
> URE rates numbers are probably equally trustworthy.
>
> The probability number doesn't tell you much at all about your drive.
> Your drive probably works much better than the quoted rate, but could be much
> worse.
> The quoted number might say something useful about a collection of 10,000
> drives, but if you can afford those, you can probably afford to competent
> statistician to explain the details too.
>
>
>
> I'm not an electro-magnetic engineer, but I would guess that UREs are caused
> by some combination of:
>   - irregularities in the physical media
>   - imperfections in positioning of the write head
>   - fluctuations in temperature and pressure which could
>     affect precise performance of resistors and capacitors etc.
>
> and probably various quantum effects that I know nothing about.
>
> Maybe most UREs come from a spec of dust that was in the wrong place at the
> wrong time.
>
> If think a better summary would be:
>    in normal conditions and typical loads, a collection of 10^14 drives will
>    exhibit errors somewhere in the collection on a regular basis.
>
>
> NeilBrown
>

VERY informative post. Thank you Neil.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
