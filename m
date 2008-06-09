From: Gavin Hamill <gdh@acentral.co.uk>
Subject: Re: Rebuild after a drive replacement
Date: Mon, 09 Jun 2008 10:15:19 +0100
Message-ID: <1213002919.15461.16.camel@gdh-work>
References: <1212958349.7596.14.camel@gdh-home>
	 <38060.192.168.1.70.1212963930.squirrel@neil.brown.name>
	 <1212999164.15461.2.camel@gdh-work>
	 <32774.192.168.1.70.1213002278.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32774.192.168.1.70.1213002278.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2008-06-09 at 19:04 +1000, NeilBrown wrote:
> On Mon, June 9, 2008 6:12 pm, Gavin Hamill wrote:
> > On Mon, 2008-06-09 at 08:25 +1000, NeilBrown wrote:
> >

> I suspect the partition is slightly too small.
> Check the sizes in /proc/partitions.
> 
> hde5 needs to be at least 174851136K.

Well spotted, that man! hde5 is indeed 50000 blocks smaller than the
others. I guess the debian installer must use different calculations
than cfdisk :(

> Newer version of mdadm notice this and report a better
> error message (I think 2.6.3 contains the fix).
> 
> So: you might need to repartition the drive and make hde5 a
> little bigger.

Yup - thanks muchly.. I'll give it a go and report back.

Cheers,
Gavin.


