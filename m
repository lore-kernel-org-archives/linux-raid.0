From: <me@heyjay.com>
Subject: Re: Sync rates?
Date: Thu, 6 May 2004 21:01:43 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008401c433d7$42be27c0$6705a8c0@a30>
References: <00a401c4339e$7f86b340$6705a8c0@a30> <yw1xsmede4hk.fsf@kth.se> <409A94BD.40207@steeleye.com> <00cb01c433a3$64865eb0$6705a8c0@a30> <409A9917.2090509@steeleye.com>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My machine was idle during the rebuild.  When I say idle, I mean no one
logged in, no user processes running (except me sshed into the box), no
database, no I/O other than the rebuild.

While the rebuild was going on my system was debilitated, totally slow to
respond to ssh commands

Jay
----- Original Message ----- 
From: "Paul Clements" <paul.clements@steeleye.com>
To: <me@heyjay.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, May 06, 2004 2:59 PM
Subject: Re: Sync rates?


> me@heyjay.com wrote:
>
> > platinum:~# cat /proc/sys/dev/raid/speed_limit_min
> > 1000
> > platinum:~# cat /proc/sys/dev/raid/speed_limit_max
> > 200000
>  > Are these acceptable?
>
> Well, those values are in KB/s. And, your resync rate is about:
>
> 120000000 / ( 24 * 60 * 60 ) = 1388 KB/s
>
> if my calculations are correct. I'd try bumping the min value up to say
> 10000 and see if that speeds things up. Is there much I/O activity on
> the system? That will slow down a resync quite a bit, too.
>
> --
> Paul
>
>

