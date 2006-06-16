From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: ANNOUNCE: mdadm 2.5.1 - A tool for managing Soft RAID under Linux
Date: Fri, 16 Jun 2006 13:54:46 -0400
Message-ID: <4492F066.7060709@tmr.com>
References: <17554.895.666628.776527@cse.unsw.edu.au> <4492D26B.4070705@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4492D26B.4070705@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:

> Neil Brown wrote:
>
>>
>> I am pleased to announce the availability of
>>    mdadm version 2.5.1
>
>
> Hi Neil,
>
> Here's a small patch to allow compilation on gcc 2.x. It looks like 
> gcc 3.x allows variable declarations that are not at the start of a 
> block of code (I don't know if there's some standard that allows that 
> in C code now, but it doesn't work with all C compilers). 

Even if valid, having the declaration at the top of the block in which 
it's used makes the program more readable.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

