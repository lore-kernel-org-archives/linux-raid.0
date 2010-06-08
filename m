From: Mario <mgiammarco@gmail.com>
Subject: Re: It is possible to put write cache on ssd?
Date: Tue, 8 Jun 2010 07:31:21 +0000 (UTC)
Message-ID: <loom.20100608T092726-796@post.gmane.org>
References: <loom.20100604T102522-67@post.gmane.org> <4C0D44FC.8020908@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen <davidsen <at> tmr.com> writes:


> Actually playing with that now. I got an Intel SATA 40GB SSD, and I am 
> trying various combinations of things to put on it. One thing which I 
> hoped would benefit was to put a f/s journal on SSD and then use the 
> option to push all through the journal (data=journal) in hopes that it 
> would then free the RAM needed for cache and thus speed operation.
> 
>

Probably it is due to two things:

1) to see advantages you have to test in a server situation where a 
lot of thread are writing AND others are reading. So in this case
 writes to hard disk can be delayed a lot to give less latency to reads.
2) A lot of tuning is due to force linux to keep data on journal
 as long as it can.



