From: Neil Brown <neilb@suse.de>
Subject: Re: Auto Rebuild on hot-plug
Date: Wed, 31 Mar 2010 12:35:34 +1100
Message-ID: <20100331123534.1b86c77d@notabene.brown>
References: <20100325113543.0e2124c5@notabene.brown>
	<4BAC56FE.1000009@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAC56FE.1000009@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: linbloke <linbloke@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 26 Mar 2010 17:41:02 +1100
linbloke <linbloke@fastmail.fm> wrote:

> Hi Neil,
> 
> I look forward to being able to update my mdadm.conf with the paths to 
> devices that are important to my RAID so that if a fault were to develop 
> on an array, then I'd be really happy to fail and remove the faulty 
> device, insert a blank device  of sufficient size into the defined path 
> and have the RAID auto restore. If the disk is not blank or too small, 
> provide a useful error message (insert disk of larger capacity, delete 
> partitions, zero superblocks) and exit.  I think you do an amazing job 
> and it worries me that you and the other contributors to mdadm could 
> spend your valuable time trying to solve problems about how to cater for 
> every metadata, partition type etc when a simple blank device is easy to 
> achieve and could then "Auto Rebuild on hot-plug".

:-)

One the one hand, we should always look beyond the immediate problem we are
tring to solve in order to see the big picture and make sure the solution we
choose doesn't cut us off from solving other more general problems when they
arrive.
On the other hand, we don't want to expand the scope so much that we end up
biting off more than we can chew.

A general design with a specific implementation is probably a good target....

Thanks,
NeilBrown

> 
> Perhaps as we nominate a spare disk, we could nominate a spare path. I'm 
> certainly no expert and my use case is simple (raid 1's and 10's) but it 
> seems to me a lot of complexity can be avoided for the sake of a blank disk.
> 
> Cheers,
> Josh
> 
> 
> 

