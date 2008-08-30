From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: I/O wait problem with hardware raid
Date: Sat, 30 Aug 2008 14:47:21 -0400
Message-ID: <48B995B9.2040600@tmr.com>
References: <48B75097.7000509@harvee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48B75097.7000509@harvee.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Eric S. Johansson" <esj@harvee.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eric S. Johansson wrote:
> I'm not sure if this mailing lists is just for the Linux kernel raid  so  this
> query does not belong, feel free to tell me where to go.
>
> I'm running Ubuntu 8.04 on an HP ProLiant ml350 with an E200i sata raid card.
>
> The problem is the I/O wait percentage increases during data transfer. A simple
> rsync transfer will bring the percent I/O wait value up to the mid-20s to 40s
> and a little more stress causes the wait percentage to climb to upper 90% range.
>  it appears that most of the I/O wait time is from the disk array because a copy
> has a similar effect.  However, I cannot eliminate some contribution by the
> networking code.
>
> I'm not sure how to debug this. vmstat doesn't show anything extraordinary so
> I'm left scratching my head.
>
> what should I be looking for?
>   

iowait means that there is a program waiting for I/O. That's all. Of 
course when you do a copy (regardless of software) the CPU is waiting 
for disk transfers. I'm not sure what you think you should debug, i/o 
takes time, and if the program is blocked until the next input comes in 
it will enter the waitio state. If there is no other process to use the 
available CPU it becomes waitio, which is essentially available CPU 
cycles similar to idle.

What exactly do you think is wrong?

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


