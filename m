From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: shown disk sizes
Date: Tue, 23 Jul 2013 19:12:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307231911380.8891@uplift.swm.pp.se>
References: <1374071867.25339.14.camel@heisenberg.scientia.net>  <20130718094327.7d46949e@notabene.brown> <1374596770.8463.23.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374596770.8463.23.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Jul 2013, Christoph Anton Mitterer wrote:

> Questions
> 1) How does mdadm choose the data alignment? It seems to also use
> completely "odd" numbers like 262144 sectors

2^18=262144

Nothing odd about it.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
