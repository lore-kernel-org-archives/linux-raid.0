From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: [PATCH 00/19] Hardware Accelerated MD RAID5: Introduction
Date: Wed, 13 Sep 2006 09:15:12 +0200
Message-ID: <20060913071512.GA23492@unthought.net>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

On Mon, Sep 11, 2006 at 04:00:32PM -0700, Dan Williams wrote:
> Neil,
> 
...
> 
> Concerning the context switching performance concerns raised at the
> previous release, I have observed the following.  For the hardware
> accelerated case it appears that performance is always better with the
> work queue than without since it allows multiple stripes to be operated
> on simultaneously.  I expect the same for an SMP platform, but so far my
> testing has been limited to IOPs.  For a single-processor
> non-accelerated configuration I have not observed performance
> degradation with work queue support enabled, but in the Kconfig option
> help text I recommend disabling it (CONFIG_MD_RAID456_WORKQUEUE).

Out of curiosity; how does accelerated compare to non-accelerated?

-- 

 / jakob

