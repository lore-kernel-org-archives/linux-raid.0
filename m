From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: integrity verification on raid-5?
Date: Sat, 18 Dec 2010 11:25:57 +0100
Message-ID: <20101218102557.GA3201@lazy.lzy>
References: <4D0BD140.6040205@feystorm.net>
 <20101217212436.GA11425@cthulhu.home.robinhill.me.uk>
 <4D0BE22F.8000706@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D0BE22F.8000706@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick H." <linux-raid@feystorm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> The docs say that for both raid 5 & 6 it the repair function simply
> rewrites the parity drive(s). For raid-5 I can understand this as
> there's no way to tell if the data is incorrect, or if the parity is
> incorrect since there's only 1 parity. And while I dont know the
> details of the algorithms involved in raid-6, couldnt you do
> something like:
> Calculate replacement data for both parity drives
> If one of the 2 parity drives doesnt match its replacement data
>    assume that drive is bad
> Else if both parity drives dont match their replacement data
>    one of the data drives must be bad
>    calculate replacement data for each data drive and find the one
> that doesnt match
>    If more than 1 data drive doesnt match its replacement data
>       we have multiple-drive failure (could be any combination of
> parity & data drives) and cant determine which ones
> Else
>    the world is ok
> 
> Its probably a heck of a lot more computationally expensive, but it
> can isolate which drive is the bad one. But again, I'm not
> knowledgeable on the the internal details of raid-6 and might just
> be completely off my rocker.
> 

Welcome to the club!

It seems this topic pops up more or less
each 6 months...

Unfortunately, it also seems that the
core developers do not have high priority
on this one.

BTW, did anybody else look into this?

Is there any possiblities to perform this
kind of check in user space?

bye,

-- 

piergiorgio
