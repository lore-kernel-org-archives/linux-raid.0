From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 18:39:32 +0200
Message-ID: <20080715163932.GA23164@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1216130769.5633.318.camel@sam.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 16, 2008 at 12:06:09AM +1000, Ben Martin wrote:
> Hi,
>   Apologies if posting this here is inappropriate but a recent article
> of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> card and might be of interest to list members:
> 
> http://www.linux.com/feature/140734

It is (at least to me) very interesting to see comparisons on HW vs SW
raid.

I think tho, that you give it some bias not testing the best
configurations for Linux SW raid. For example raid10, the f2 and o2
layouts are faster than n2, and you don't know if Adaptec has some kind
of improved layout.

It would be interesting if you could enhance your article with benchmarks
on raid10, f2 and o2 layouts. I think they would outperform HW raid, at
least on input. And I would like to see how they perform on outout and
rewrite, with ext3 and xfs. We do have some tests, but many of them are
without a file system layer.

I would also welcome test with mobo HW RAID - Many mobo's today come
with some HW raid functionality, and many people would be in the
situation of whether to choose a HW or SW configuration.

best regards
keld
