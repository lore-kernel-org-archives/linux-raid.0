From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Support for PATA in Promise 378 driver
Date: Mon, 23 Feb 2004 20:20:35 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <403AA6E3.70300@pobox.com>
References: <20040223141636.20fed6ba@hantst.kabel.utwente.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040223141636.20fed6ba@hantst.kabel.utwente.nl>
To: Anton Starikov <A.Starikov@utwente.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anton Starikov wrote:
> Hi!
> 
> As I can see, there is no support for PATA port on promise 378 chip
> currently.
> 
> Is this support planned?
> If now, why? Is there some religious reasons?  ;) 
> Or just matter of time?
> 
> I just see, that I'm not one person who can't migrate to 2.6 because of
> using PATA port on 378.
> There is no driver from Promise, driver from libata also does not
> support.
> 
> So, now I see two solutions:
> 1) adopt promise driver from vendor (which use cam) for 2.6
> kernel, if there is religious reasons ;)
> 2) try to work under libata promise driver in order to have
> support for PATA port. 


It's a to-do item at the moment...

	Jeff



