From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Fri, 6 Oct 2017 09:59:18 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710060951260.31961@uplift.swm.pp.se>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org> <871sn78pzt.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se> <874ls0s7un.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name> <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com> <87d162380v.fsf@notabene.neil.brown.name> <4bc99226-0843-351b-dca6-7d0a083de925@intel.com> <87mv5517w9.fsf@notabene.neil.brown.name>
 <20171006071356.GA1847@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171006071356.GA1847@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: NeilBrown <neilb@suse.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 6 Oct 2017, Christoph Hellwig wrote:

> That whole idea is just amazingly stupid, and no one has even explained
> a reason for it.

It's all about making it easier for the people using the functionality we 
have and less risk of making a mistake. See my previous email about people 
I have seen that would have benefited from the active component drives 
being not writable (or hidden).

Yes, I know this goes against the old unix "don't try to stop the user 
from shooting themselves in the foot", but I do think this should be user 
configurable.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
