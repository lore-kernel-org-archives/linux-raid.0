From: "Michael" <michael@insulin-pumpers.org>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 11:58:23 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402191958.i1JJwP225623@bzs.org>
References: <Pine.LNX.4.58.0402190704420.25541@chaos.egr.duke.edu>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20040219175630.GA20790@datavibe.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Thu, Feb 19, 2004 at 07:06:32AM -0500, Joshua Baker-LePain wrote:
> >
> > I fully agree on avoiding cheap "hardware" RAID cards.  Regarding drivers 
> > going away, though, the 3ware drivers are open source and have been in the 
> > kernel for a long time.  If 3ware were to disappear (unlikely), I'd be 
> > willing to bet that the drivers stay supported by the community.
> > 
> 
> I have always avoided the promise fasttrak cards for exactly that
> reason ("hardware" being in quotes).  It's my understanding that
> they're not much more than their udma cards with drivers that do
> most of the RAIDing.
> 
> It was also my understanding that the 3ware cards are true hardware
> raid and are up to the task of something like this, which would also
> explain why they're 4x the cost.
> 

Bear in mind that what you are calling "true hardware raid" is really 
a microprocessor programmed to do the raid algorithims. Usually these 
microprocessors are stretched to the limit to handle the throughput 
of modern udam drives. I don't know but I suspect that the small 
overhead use in the mmu for software raid has far more and faster 
throughput than any of these dedicated microprocessors..... and, you 
can see the code and know it is bug free or will be if you report the 
bug. I am the unhappy owner of several Adaptec raid cards that have 
onboard processors to handle not only raid, but command processing 
for the scsi bus. These turkeys have micro-code bugs that cause a 
variety of problem for which there is no workaround or solution other 
than trashing the cards. Don't get me wrong, I thing the 3ware 
product is exceptionally good, I just wouldn't use the raid code 
given the choice of linux software raid. 

Currently running 10 linux software raid boxes -- mix of raid 1 and 
raid 5. Yes, I'm biased :-)

Michael
Michael@Insulin-Pumpers.org
