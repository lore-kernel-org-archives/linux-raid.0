From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid warning on 2.6.7
Date: Tue, 3 Aug 2004 12:12:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16654.62612.63068.887576@cse.unsw.edu.au>
References: <20040802212538.626e51d7.a_bouter@ezrs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Arjan Bouter on Monday August 2
To: Arjan Bouter <a_bouter@ezrs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 2, a_bouter@ezrs.com wrote:
> Hi,
> 
> I wonder if you can tell me more about this warning I get during boot:
> 
> md: raidstart(pid 475) used deprecated START_ARRAY ioctl. This will not be
> supported beyond 2.6

The "START_ARRAY" ioctl is badly designed.  It makes assumptions about
the stability of device number which are simply untrue.
As a consequence, the "raidstart" program which uses START_ARRAY is
potentially dangerous, in that it seems to work most of the time so
you can get a false sense of security that your system is configured
properly.  But if a drive dies, raidstart may not be able to restart
your array.

> 
> The warning was followed by one of my mirrors disks being kicked out, but that
> can be a mere coincidence.

Very likely a coincidence.

> 
> I was wondering if there's going to be a new version of raidtools anytime soon
> for kernels 2.6 and later?

I am not aware of any on-going development of raidtools.  All parts of
it other than "raidstart" should continue to work however.
I recommend using mdadm instead of raidtools.  It is maintained.

NeilBrown
