From: Dan Christensen <jdc@uwo.ca>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 17:16:59 -0400
Message-ID: <87k6jt84vo.fsf@uwo.ca>
References: <87r7e23uo5.fsf@uwo.ca>
	<Pine.LNX.4.44.0507140004550.29240-200000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn <hahn@physics.mcmaster.ca> writes:

>> Is there a way for me to simulate readahead in userspace, i.e. can
>> I do lots of sequential asynchronous reads in parallel?
>
> there is async IO, but I don't think this is going to help you much.
>
>> Also, is there a way to disable caching of reads?  Having to clear
>
> yes: O_DIRECT.

That might disable caching of reads, but it also disables readahead,
so unless I manually use aio to simulate readahead, this isn't going
to solve my problem, which is having to clear the cache before each
test to get relevant results.

I'm really surprised there isn't something in /proc you can use to
clear or disable the cache.  Would be very useful for benchmarking!

Dan

