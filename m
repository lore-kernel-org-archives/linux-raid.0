From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid bug in 2.4.20
Date: Thu, 10 Apr 2003 21:40:52 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E961D24.BB595F33@SteelEye.com>
References: <Pine.LNX.4.44.0304101623300.25209-100000@karma.hagopian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Rob Hagopian <rob@hagopian.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Rob Hagopian wrote:
 
> Personalities : [linear] [raid0] [raid1] [raid5]
> read_ahead 1024 sectors
> md7 : active raid1 sdb6[2] sda6[0]
>       1052160 blocks [2/1] [U_]
> 
> md0 : active raid1 sdb1[2] sda1[0]
>       128384 blocks [2/1] [U_]
>       [>....................]  recovery =  0.0% (0/128384)
> finish=3658.9min speed=0K/sec

Have you been able to reproduce this problem with any regularity? Or
have you tried? I have an idea what *might* be causing this, if you're
willing to try out a patch...

BTW, the md "BUG" you originally reported is not really a bug -- that
always happens when you try to raidhotremove an active disk.

--
Paul
