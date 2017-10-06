From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Fri, 6 Oct 2017 00:13:56 -0700
Message-ID: <20171006071356.GA1847@infradead.org>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
 <874ls0s7un.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name>
 <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
 <87d162380v.fsf@notabene.neil.brown.name>
 <4bc99226-0843-351b-dca6-7d0a083de925@intel.com>
 <87mv5517w9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mv5517w9.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 06, 2017 at 10:39:50AM +1100, NeilBrown wrote:
> Hmmm.. interesting that it is multiple applications.
> Given that both md and dm have been around for years and have layered on
> top of exiting devices without hiding them, it is hard to see how these
> applications have not run into problem before.
> 
> There is some precedent for hiding things from /proc/partitions.
> removable devices like CDROMs are hidden, and you can easily hide
> individual devices by setting GENHD_FL_SUPPRESS_PARTITION_INFO.
> We might be able to get that through.  It is certainly worth writing a
> patch and letting people experiment with it.

No way in hell this would get through.  Preemptive NAK right here.

That whole idea is just amazingly stupid, and no one has even explained
a reason for it.
