From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 11:23:36 +1100
Message-ID: <17358.56328.161673.604026@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<Pine.LNX.4.64.0601170805290.17902@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday January 17, babydr@baby-dragons.com wrote:
>  	Hello Neil ,
> 
> On Tue, 17 Jan 2006, NeilBrown wrote:
> > Greetings.
> >
> > In line with the principle of "release early", following are 5 patches
> > against md in 2.6.latest which implement reshaping of a raid5 array.
> > By this I mean adding 1 or more drives to the array and then re-laying
> > out all of the data.
>  	Please inform me of which of the 2.6.latest to use ?  Tia ,  JimL
> 
> The latest stable version of the Linux kernel is:		2.6.15.1 	2006-01-15 06:14 UTC 	F 	V 	  	C 	Changelog
> The latest prepatch for the stable Linux kernel tree is:	2.6.16-rc1 	2006-01-17 08:09 UTC 	  	V 	  	C 	Changelog
> The latest snapshot for the stable Linux kernel tree is:	2.6.15-git12 	2006-01-16 08:04 UTC 	  	V 	  	C 	Changelog

Yes, any of those would be fine.

NeilBrown
