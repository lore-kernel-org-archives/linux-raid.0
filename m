From: Scott Long <scott_long@adaptec.com>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 15:29:48 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <403538DC.5040004@adaptec.com>
References: <Pine.LNX.4.58.0402190704420.25541@chaos.egr.duke.edu> <200402191958.i1JJwP225623@bzs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200402191958.i1JJwP225623@bzs.org>
To: michael@insulin-pumpers.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael wrote:
> 
> Bear in mind that what you are calling "true hardware raid" is really
> a microprocessor programmed to do the raid algorithims. Usually these
> microprocessors are stretched to the limit to handle the throughput
> of modern udam drives. I don't know but I suspect that the small
> overhead use in the mmu for software raid has far more and faster
> throughput than any of these dedicated microprocessors..... and, you
> can see the code and know it is bug free or will be if you report the
> bug.  I am the unhappy owner of several Adaptec raid cards that have
> onboard processors to handle not only raid, but command processing
> for the scsi bus.

What exactly are you talking about here?  Are you using a multi-channel
RAID card to do RAID on one channel and SCSI-passthru on the other?
Please explain.

> These turkeys have micro-code bugs that cause a
> variety of problem for which there is no workaround or solution other
> than trashing the cards.

What 'micro-code' bugs are you talking about?  What problems are you
talking about.  If you could provide some details to back up these 
claims, there might be some recourse.

> Don't get me wrong, I thing the 3ware
> product is exceptionally good, I just wouldn't use the raid code
> given the choice of linux software raid.
> 
> Currently running 10 linux software raid boxes -- mix of raid 1 and
> raid 5. Yes, I'm biased :-)
> 
> Michael
> Michael@Insulin-Pumpers.org

Scott

