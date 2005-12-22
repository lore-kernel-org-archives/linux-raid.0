From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: First RAID Setup
Date: Thu, 22 Dec 2005 09:27:29 -0500
Message-ID: <43AAB7D1.8090400@tmr.com>
References: <20051218220831.77225.qmail@web54606.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051218220831.77225.qmail@web54606.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andargor The Wise <andargor@yahoo.com>
Cc: "Callahan, Tom" <CallahanT@tessco.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andargor The Wise wrote:

>Yet another thing, someone has suggested that I should
>increase the chunk size for my RAID5 from 32 to either
>64 or 128.
>
>Is it worth it, considering that the system doesn't
>normally run on a heavy load? Mail for a few users,
>some read-only database applications, website, etc.
>Mostly a development machine.
>  
>

Can't think of a case where it's not worth having better performance... 
I should write a WP on stripe size, and what happens as you change it 
with given loads.

>Would this alleviate the "pauses" during large file
>transfers/copies that I have indicated in my previous
>post?
>
>I'm asking because backing up ~176 GB, reconfiguring
>the RAID, and restoring it properly so the machine
>boots (the RAID5 is /) is quite a PITA.
>

You may have some special case, but I would never put data that large in 
/ just as a system admin issue. It makes backups and restores, as well 
as upgrades quite unpleasant. I guess you may have noticed that by now 
;-) Good luck!

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

