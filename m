From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Sync rates?
Date: Thu, 06 May 2004 15:59:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <409A9917.2090509@steeleye.com>
References: <00a401c4339e$7f86b340$6705a8c0@a30> <yw1xsmede4hk.fsf@kth.se> <409A94BD.40207@steeleye.com> <00cb01c433a3$64865eb0$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00cb01c433a3$64865eb0$6705a8c0@a30>
To: me@heyjay.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

me@heyjay.com wrote:

> platinum:~# cat /proc/sys/dev/raid/speed_limit_min
> 1000
> platinum:~# cat /proc/sys/dev/raid/speed_limit_max
> 200000
 > Are these acceptable?

Well, those values are in KB/s. And, your resync rate is about:

120000000 / ( 24 * 60 * 60 ) = 1388 KB/s

if my calculations are correct. I'd try bumping the min value up to say 
10000 and see if that speeds things up. Is there much I/O activity on 
the system? That will slow down a resync quite a bit, too.

--
Paul
