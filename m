From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: RAID-5 streaming read performance
Date: Fri, 15 Jul 2005 06:01:18 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0507150558330.10696@praktifix.dwd.de>
References: <874qb14btr.fsf@uwo.ca> <1121220487.5552.34.camel@localhost.localdomain>
 <87mzorfmdx.fsf@uwo.ca> <1121257494.5504.4.camel@localhost.localdomain>
 <87eka2g9dp.fsf@uwo.ca> <1121259126.5504.14.camel@localhost.localdomain>
 <87vf3eeqe2.fsf@uwo.ca> <42D5573A.6090801@dgreaves.com> <87r7e23uo5.fsf@uwo.ca>
 <87wtns7pzc.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wtns7pzc.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

On Thu, 14 Jul 2005, Dan Christensen wrote:

> Summary so far:
>
> RAID-5, four SATA hard drives, 2.6.12.2 kernel.  Testing streaming
> read speed.  With readahead optimized, I get:
>
> each raw device:        58MB/s
> raid device:            78MB/s
> 3 or 4 parallel reads
> from the raw devices:  106MB/s
>
> I'm trying to figure out why the last two numbers differ.
>
Have you checked what the performance with a 2.4.x kernel is? If I
remember correctly there was some discussion on this list that 2.4 raid5
has better read performance.

Holger

