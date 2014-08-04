From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: On URE and RAID rebuild - again!
Date: Mon, 4 Aug 2014 20:40:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se>
References: <53D8ACF0.1070202@assyoma.it> <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se> <53D8ED99.90606@assyoma.it> <20140731073121.38cd1773@notabene.brown> <53D9ED48.9000307@assyoma.it> <1370eb7a35b628323646a86094a26912@assyoma.it>
 <20140803134834.7773b0ab@notabene.brown> <53DF8A31.8060609@assyoma.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53DF8A31.8060609@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Aug 2014, Gionatan Danti wrote:

> As you can find, no error was reported, and I don't find anything 
> suspicious in dmesg. At least, this should prove that article as this 
> [1] are quite wrong.

Why do you think that's wrong? 10^-14 is what the vendor guarantees. I 
have had drives with worse performance (after a couple of months I had 
several UNC sectors without reading much).

Your claim about the article being wrong is the same as saying that the 
risk reported of getting into a car accident is wrong because you've 
driven that amount of kilometers but haven't been in an accident yet.

This is statistics, marketing and warranty, not guaranteed behavior.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
