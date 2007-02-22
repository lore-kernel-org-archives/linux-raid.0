From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Date: Thu, 22 Feb 2007 13:39:56 +1100
Message-ID: <17885.636.133245.572876@notabene.brown>
References: <20070220172544.15678.patches@notabene>
	<1070220063516.16208@suse.de>
	<20070221144806.e6eed85c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Wednesday February 21
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 21, akpm@linux-foundation.org wrote:
> On Tue, 20 Feb 2007 17:35:16 +1100
> NeilBrown <neilb@suse.de> wrote:
> 
> > +		for (i = conf->raid_disks ; i-- ;  ) {
> 
> That statement should be dragged out, shot, stomped on then ceremonially
> incinerated.

An experiment in lateral thinking?  I liked it, but there is no
accounting for taste.

> 
> What's wrong with doing
> 
> 	for (i = 0; i < conf->raid_disks; i++) {
> 
> in a manner which can be understood without alcoholic fortification?

I guess...  "Egoless programmer" and all that, "write for others to
read, not for the compiler", and as you say it comes to the same
number of bytes of code on common architectures.

> 
> ho hum.


I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.


NeilBrown
