From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: md-raid and block sizes
Date: Tue, 28 Dec 2010 12:50:50 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1012281247080.27193@uplift.swm.pp.se>
References: <1293451228.3266.9.camel@Waves.darkmere> <AANLkTikWxCxVUO+O8MXRXRR7Y8R5xGC1Catv-EiNGcDj@mail.gmail.com> <1293525980.23780.2.camel@Waves.darkmere> <AANLkTin=-0CN-teD5p4H_nFbuZ944DVuDMku3FaD7uv7@mail.gmail.com>
 <20101228224513.31e71638@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101228224513.31e71638@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: hansbkk@gmail.com, "D.S. Ljungmark" <spider@skuggor.se>, doug@easyco.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Dec 2010, Neil Brown wrote:

> If anyone has any data on default spin-down times of these "green" 
> drives I would be keen to hear about it.

The problem I've seen is the load/unload cycle count increasing, the head 
parking occurs after 8 seconds.

<http://slickdeals.net/permadeal/39631>

I've never seen one spin down though, I wonder if the original poster was 
talking about the head parking and not drive spindown.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
