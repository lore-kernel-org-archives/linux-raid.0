From: John Rowe <rowe@excc.ex.ac.uk>
Subject: Re: Slow reconstruction
Date: Wed, 29 Jun 2005 18:49:35 +0100
Message-ID: <1120067375.21458.258.camel@volt>
References: <1120061430.21458.236.camel@volt>  <42C2CEF0.7030108@h3c.com>
	 <1120066268.21458.252.camel@volt>  <1120067215.10448.61.camel@cutter>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120067215.10448.61.camel@cutter>
Sender: linux-raid-owner@vger.kernel.org
To: seth vidal <skvidal@phy.duke.edu>
Cc: Mike Hardy <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
> did you raise speed_limit_min??
> 
> if you didn't then you're probably being hit by the 'only use idle io'
> problem.

That's fixed it! It's now going along at around 5.7 MB/s which isn't
huge but is around 11 times what it was. Many thanks.

But I'm a bit surprised this makes a difference because there is no
other real IO going on.

John

