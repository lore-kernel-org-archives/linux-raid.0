From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-6 ...
Date: Thu, 13 Jan 2005 13:11:55 +1100
Message-ID: <16869.55531.489452.193862@cse.unsw.edu.au>
References: <200501101713.j0AHDx922062@www.watkins-home.com>
	<Pine.LNX.4.56.0501121020490.21510@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gordon Henderson on Wednesday January 12
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 12, gordon@drogon.net wrote:
> 
> Until now I haven't really paid too much attention to the RAID-6 stuff,
> but I have an application which needs to be as resilient to disk failures
> as possible.
> 
> So other than what's at:
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/hpa/
> 
> and the archives of this list (which I'm re-reading now), can anyone give
> me a quick heads-up about it?
> 
> Specifically I'm still buried in the dark days of 2.4.27/28 - are there
> recent patches against 2.4?

There is no current support for raid6 in any 2.4 kernel and I am not
aware of anyone planning such support.  Assume it is 2.6 only.

> 
> If RAID-6 isn't viable for me right now, what I'm planning is as follows:
> 
> Put 8 x 250GB SATA drives in the system, and arrange them in 4 pairs of
> RAID-1 units.
> 
> Assemble the 4 RAID-1 units into a RAID-5.

Sounds reasonable.

NeilBrown
