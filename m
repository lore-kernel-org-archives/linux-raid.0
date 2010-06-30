From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Write-intent bitmap decreases or increase performance of
 RAID5?
Date: Wed, 30 Jun 2010 08:58:28 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1006300857300.8623@uplift.swm.pp.se>
References: <20100629201153.GA13018@localhost> <20100630111854.006ec4d0@natsu> <alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se> <20100630115927.090751dd@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100630115927.090751dd@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Shaochun Wang <scwang@ios.ac.cn>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 30 Jun 2010, Roman Mamedov wrote:

> This is not necessary. See the dd man page about the conv=fdatasync switch.
> You can even test with just 256 MB this way, and still get an extremely
> accurate result.

You're right, for writing this is ok. For read tests it's important to use 
more than ram though, to avoid doing performance testing from block cache 
instead of from the actual drives.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
