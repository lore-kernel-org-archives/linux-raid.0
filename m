From: "Sandra Escandor" <sescandor@evertz.com>
Subject: RE: clarifying what can be done during resync
Date: Mon, 27 Jun 2011 08:35:38 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD376C7@otis.burlington.evertz.tv>
References: <C70A636B101FD44999B82525C3E92AFAD374BD@otis.burlington.evertz.tv> <20110627154729.521e875a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20110627154729.521e875a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for clarifying, Neil. I actually came across this on someone's
blog explaining how they got RAID10 (with imsm metadata) up and running,
and he mentions that he made sure to wait until resync was done before
mounting. I did the same thing, thinking that maybe I might break
something if I didn't.

Sandra

-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Monday, June 27, 2011 1:47 AM
To: Sandra Escandor
Cc: linux-raid@vger.kernel.org
Subject: Re: clarifying what can be done during resync

On Thu, 23 Jun 2011 15:38:06 -0400 "Sandra Escandor"
<sescandor@evertz.com>
wrote:

> Hello,
> 
> Just wanted to make sure if this was a myth or not: Is it true that
when
> an array is in resync status, then mounting it is not at all possible?
>

Pure myth.  Where did you hear it?

Best approach is to try .. if it is not at all possible, then it won't
work.
But in fact it does :-)

NeilBrown
