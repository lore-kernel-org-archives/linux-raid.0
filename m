From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid resync
Date: Mon, 13 Oct 2003 11:31:22 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16266.106.834009.353263@notabene.cse.unsw.edu.au>
References: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi>
	<16243.55544.424789.503682@notabene.cse.unsw.edu.au>
	<61251.194.237.142.24.1064557502.squirrel@ncircle.nullnet.fi>
	<16243.57487.124068.470173@notabene.cse.unsw.edu.au>
	<17620.194.237.142.24.1064560221.squirrel@ncircle.nullnet.fi>
	<16243.61083.69286.766387@notabene.cse.unsw.edu.au>
	<087f01c38e05$b401bfa0$6501a8c0@bmasi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bo Moon on Wednesday October 8
To: Bo Moon <bo@anthologysolutions.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 8, bo@anthologysolutions.com wrote:
> Neil,
> 
> >From md.c, there must be some changes or improvement to RAID1&5 resync code,
> which enabled the request based resynchronization.

I think you are referring to the comment in the top of md.c and I
think you are misunderstanding what is says.  Just read it as "I
changed some stuff so it worked better", or simply ignore it.

Does that help?

NeilBrown

> 
> Does it mean we could enable or disable this resync?
> If so, how could we make it(where in the code)?
> 
> Why do we have this feature the disk will be under no integrity if we
> disable this resync?
> 
> Thanks in advance,
> 
> Bo
