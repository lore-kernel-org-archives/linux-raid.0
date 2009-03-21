From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
Date: Sat, 21 Mar 2009 12:15:12 -0700
Message-ID: <49C53CC0.5060303@zytor.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com>	 <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>	 <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com>	 <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>	 <49C45159.8020503@zytor.com> <e9c3a7c20903210819r222cd4acwb466d2a11d3388f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20903210819r222cd4acwb466d2a11d3388f6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ilya Yanok <yanok@emcraft.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Dan Williams wrote:
>>
>> No, you don't.  A and B (and g^{-x}) are scalars, meaning they're the
>> same for every element.  This is simpler to do.
> 
> Understood.  However this routine also needs to cover the non-generic
> and non-constant case where we have a separate coefficient per
> element.  I suppose it could scan the coefficient list to see if it
> can bypass the 2-dimensional lookup multiply.  At the very least we
> need something like the following, because async_pq is really only a
> helper routine for async_r6recov.c which knows how to avoid the
> synchronous path.
> 

Why does it?  I don't see why you'd need to cover the vector-vector case
at all, since it doesn't appear anywhere in the algorithms.  Certainly
going backwards from a vector-vector set to derive if you can do a
scalar-vector multiply when you should have known that in the first
place is not really useful.

> 
> Looking closer, the only other caller, async_pq_zero_sum, can be
> deleted because it has no users.  So async_pq can become a static
> routine in async_r6recov.
> 

That's another issue entirely, of course :)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

