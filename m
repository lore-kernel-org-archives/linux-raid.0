From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: Benefits from computing physical IDE disk geometry?
Date: Wed, 16 Apr 2003 09:28:43 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200304160932_MC3-1-34A9-3A79@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
	 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: Nick Piggin <piggin@cyberone.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> The way you would do a good "goodness" function, I guess,
> would be to search through all requests on the device, and return
> the minimum distance from the request you are running the query
> on. Do this for both queues, and insert the request into the
> queue with the smallest delta. I don't see much else doing any
> good.


  That would be perfect.  And like you say in a later message, they're
in a tree so it might actually work.  Then the read balance code
wouldn't need to do that calculation at all.

  How hard would this be to add?



> On the other hand, if you simply have a fifo after the RAID
> scheduler, the RAID scheduler itself knows where each disk's
> head will end up simply by tracking the value of the last
> sector it has submitted to the device. It also has the advantage
> that it doesn't have "high level" scheduling stuff below it
> ie. request deadline handling, elevator scheme, etc.
> 
> This gives the RAID scheduler more information, without
> taking any away from the high level scheduler AFAIKS.


 But then wouldn't you have to put all that into the RAID
scheduler?

--
 Chuck
