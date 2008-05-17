From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Mechanism to safely force repair of single md stripe w/o hurting
 data integrity of file system
Date: Sat, 17 May 2008 21:29:05 +0200
Message-ID: <482F3201.9080908@rabbit.us>
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <A20315AE59B5C34585629E258D76A97C6B3E91@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C6B3E91@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:
> I'm trying to figure out a mechanism to safely repair a stripe of data
> when I know a particular disk has a unrecoverable read error at a
> certain physical block (for 2.6 kernels) 
> 
> <snip>
> 
> As such, anybody up to the challenge of writing the code?  I want it
> enough to paypal somebody $500 who can write it, and will gladly open
> source the solution.  
> 

Damn, here goes $500 :) Unfortunately the only thing I can bring to the table 
is a thread[1] about a mechanism that would fit your request nicely. Hopefully 
someone will pick this stuff up and make it a reality.

Peter

[1] http://marc.info/?l=linux-raid&m=120605458309825
