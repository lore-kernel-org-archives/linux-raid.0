From: Neil Brown <neilb@suse.de>
Subject: Re: new features time-line
Date: Thu, 19 Oct 2006 12:46:47 +1000
Message-ID: <17718.59159.519516.656790@cse.unsw.edu.au>
References: <000a01c6ef12$0030b640$eb00000a@mine3ad5e808fe>
	<17712.10578.16619.929884@cse.unsw.edu.au>
	<453592FB.4090105@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Tuesday October 17
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dan <dan@korstad.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 17, davidsen@tmr.com wrote:
> We talked about RAID5E a while ago, is there any thought that this would 
> actually happen, or is it one of the "would be nice" features? With 
> larger drives I suspect the number of drives in arrays is going down, 
> and anything which offers performance benefits for smaller arrays would 
> be useful.

So ... RAID5E is RAID5 using (N-1)/N of each drive (or close to that)
and not having a hot spare.
On a drive failure, the data is restriped across N-1 drives so that it
becomes plain RAID5.  This means that instead of having an idle spare,
you have spare space at the end of each drive.

To implement this you would need kernel code to restripe and array to
reduce the number of devices (currently we only increase the number of
devices).

Probably not too hard - just needs code and motivation.  

Don't know if/when it will happen, but it probably will
.... especially if someone tries writing some code (hint hint to any
potential developers out there...)

NeilBrown
