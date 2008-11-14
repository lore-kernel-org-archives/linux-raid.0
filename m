From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Feature suggestion: immediate repair attempt on failed read?
Date: Fri, 14 Nov 2008 12:29:25 +0000
Message-ID: <491D6F25.8030301@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/11/2008 23:04, Mikael Abrahamsson wrote (in the "OT: Tips for good 
hard drives for a home server" thread):
> Looking at the md code in linux, would it be possible to do some work 
> around here in that if a drive read operationstalls, let's try to read 
> from the other drives and then re-write the block on the drive that 
> stalled?

I'd like to second this suggestion; my coding skills are WAY too rusty 
to attempt it myself, but it sounds like an excellent idea.

We could also have a timeout setting so that if a read stalls, at least 
the application can get its data (by reading the other discs) and the md 
subsystem can carry on waiting for the read and/or just doing the 
rewrite in the background.

What happens at the moment - could one slow read cause the array to be 
switched into degraded mode immediately?

Cheers,

John.
