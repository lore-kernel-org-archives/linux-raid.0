From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: Benefits from computing physical IDE disk geometry?
Date: Tue, 15 Apr 2003 14:33:51 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200304151436_MC3-1-3487-215F@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
	 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: Nick Piggin <piggin@cyberone.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Nick Piggin wrote:


> OK right. As far as I can see, the algorithm in the RAID1 code
> is used to select the best drive to read from? If that is the
> case then I don't think it could make better decisions given
> more knowledge.


  How about if it just asks the elevator whether or not a given read
is a good fit with its current workload?  I saw in 2.5 where the balance
code is looking at the number of pending requests and if it's zero then
it sends it to that device.  Somehow I think something better than
that could be done, anyway.


> It seems to me that a better way to layer it would be to have
> the complex (ie deadline/AS/CFQ/etc) scheduler handling all
> requests into the raid block device, then having a raid
> scheduler distributing to the disks, and having the disks
> run no scheduler (fifo).


 That only works if RAID1 is working at the physical disk level (which
it should be AFAIC but people want flexibility to mirror partitions.)


> In practice the current scheme probably works OK, though I
> wouldn't know due to lack of resources here :P


 I've been playing with the 2.4 read balance code and have some
improvements, but real gains need a new approach.

(cc'd to linux-raid)

--
 Chuck
