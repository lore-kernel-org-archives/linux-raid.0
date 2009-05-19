From: Neil Brown <neilb@suse.de>
Subject: Re: RCU detected CPU 1 stall (t=4295904002/751 jiffies) Pid: 902, comm: md1_raid5
Date: Tue, 19 May 2009 11:05:54 +1000
Message-ID: <18962.1522.937784.126331@notabene.brown>
References: <12a901c9d805$119fef20$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janos Haar on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 19, janos.haar@netcenter.hu wrote:
> Hello list, Neil,
> 
> Somebody can say something about this issue?
> I am not surprised, if it is hardware related, but this is on a brand new 
> server, so i am looking for a solution... :-)
> May 17 23:12:13 gladiator-afth1 kernel: RCU detected CPU 1 stall 
> (t=4295904002/751 jiffies)

I have no idea what this means.
I've occasionally seen this sort of message in early boot then the
system continued to work perfectly so I figured it was an early-boot
glitch.  I suggest asking someone who understands RCU.

> 
> The entire log is here:
> http://download.netcenter.hu/bughunt/20090518/messages
> 
> The system is on the md1, and working, but slowly.

How slowly?  Is the slowness due to disk throughput?
Have you tested the individual drives and compared that with the
array?


> If i left the server for 1 day,  it will crash without a saved log.

This is a concern!  It usually points to some sort of hardware
problem, but it is very hard to trace.
Is the power supply rated high enough to support all devices?
I cannot think of anything else to suggest .. except start swapping
components until the problem goes away...

NeilBrown
