From: Neil Brown <neilb@suse.de>
Subject: Re: Infinite fail-retry loop on degraded RAID1 array
Date: Fri, 28 Apr 2006 08:16:24 +1000
Message-ID: <17489.17080.597282.782574@cse.unsw.edu.au>
References: <AE5398F6F2923E429D8870BFDE090196025BC13F@sloexchange01.corp.pt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Matt Harding on Tuesday April 25
Sender: linux-raid-owner@vger.kernel.org
To: Matt Harding <Matt.Harding@pt.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 25, Matt.Harding@pt.com wrote:
> I am experiencing a problem that I think was supposed to be fixed some
> time ago (if I read the previous discussion correctly) but appears to
> have resurfaced on my somewhat unusual configuration.

The only particularly "unusual" thing I can see in your configuration
is 2.6.12, which is nearly a year old :-)

The code for handling read errors during resync was written in
December, so I suspect you'll have a lot better luck with
2.6.16.latest.

NeilBrown
