From: David Chinner <dgc@sgi.com>
Subject: Re: limits on raid
Date: Mon, 18 Jun 2007 14:57:59 +1000
Message-ID: <20070618045759.GD85884050@sgi.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <18035.3009.568832.785308@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758843AbXFRE64@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18035.3009.568832.785308@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jun 16, 2007 at 07:59:29AM +1000, Neil Brown wrote:
> Combining these thoughts, it would make a lot of sense for the
> filesystem to be able to say to the block device "That blocks looks
> wrong - can you find me another copy to try?".  That is an example of
> the sort of closer integration between filesystem and RAID that would
> make sense.

I think that this would only be useful on devices that store
discrete copies of the blocks on different devices i.e. mirrors. If
it's an XOR based RAID, you don't have another copy you can
retreive....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
