From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: what superblock to use
Date: Tue, 21 Apr 2009 10:20:17 -0400
Message-ID: <49EDD621.5090804@tmr.com>
References: <49EC7B22.8070805@lfarkas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49EC7B22.8070805@lfarkas.org>
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@lfarkas.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente wrote:
> hi,
> what's the current recommended superblock to use for a newly created
> raid5-6 array with 6 pieces of 1tb disk? by default mdamd use 0.90. is
> it worth to change it to any 1.x format?
> anyway is there any advantage of a raid6 over raid5+1spare disk? afaik
> raid5 will be faster and use less cpu and both case 2 disk can failed.
> thanks in advance.
>
>   
Let me be Devil's Advocate. The advantage of raid6 is that it will 
survive the failure of two drives at the same time, while a spare must 
be rebuilt (a good argument for fast rebuild and let response go to blazes).

The advantage of raid5+S is that with a failure of a single drive you 
run your io in recovery mode, and it is slow, while after rebuild on the 
spare raid5+S is as fast as ever.

I have been trying some things with raid5e, and as soon as I find a good 
primer on using events to kick the recovery off I will be able to report 
some sucess with this. My POC uses a script, and works fine if I poll to 
detect the disk failure.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


