From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch v3 1/5] raid5: make release_stripe lockless
Date: Wed, 28 Aug 2013 10:30:44 -0400
Message-ID: <20130828143044.GD9295@htj.dyndns.org>
References: <20130827095038.303090029@kernel.org>
 <20130827095427.324728970@kernel.org>
 <20130828140422.GC9295@htj.dyndns.org>
 <20130828142908.GA6355@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130828142908.GA6355@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, dan.j.williams@gmail.com
List-Id: linux-raid.ids

Hello,

On Wed, Aug 28, 2013 at 10:29:08PM +0800, Shaohua Li wrote:
> This order issue is fixed in the second patch.

Oh, great.

> It's true making raid5 multi-threading might change order, I mentioned this in
> the third patch (the direct impact is request size)

Yeah, so, if at all possible, it's a good idea to preserve the
relative order, timing and plug boundaries of IOs.  Those tell the
elevator a lot about the IOs.

Thanks.

-- 
tejun
