From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 00:00:44 -0700
Message-ID: <e9c3a7c20807160000w3fdd76efu68ebc79e8fe315ae@mail.gmail.com>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <487CC660.9030004@ziu.info>
	 <1216179392.5633.348.camel@sam.localdomain>
	 <487D7139.5050302@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <487D7139.5050302@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Ben Martin <monkeyiq@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 15, 2008 at 8:55 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> Ben Martin wrote:
>
>> I have been meaning to ask for a while, why is the stripe_cache_size
>> set so low by default if it has such an effect on performance?
>
> I can't comment on the above, but looking at this:
>
> http://marc.info/?l=linux-raid&m=120668318422034&w=2
>
> with the 2.6.26 release, bumping up the stripe cache should no longer be
> necessary.
>

To be clear bumping up the cache size can still increase performance
but the ratio of performance/stripe_cache_size should now be larger,
i.e. more sequential write performance at smaller cache sizes.

> Regards,
>
> Richard

--
Dan
