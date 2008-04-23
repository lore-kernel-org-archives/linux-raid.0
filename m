From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: managing raid on linux
Date: Wed, 23 Apr 2008 11:00:06 -0400
Message-ID: <480F4EF6.1000103@tmr.com>
References: <247041911@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <247041911@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: devzero@web.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

devzero@web.de wrote:
> Hello !
>
> since we use lots of servers with raid where i work, for every system i need to go trough that hassle to find out, how to monitor the state of the raid array.
>
> if you you have more than one brand of raid controller, you really need a large amount of time to find the proper tool for this, if you think you found it, then you have a broken link or the wrong version, the tool is outdated, doesn`t work with recent controller versions, is tricky to setup or difficult to use.
>
> this takes a lot of time and is a major annoyance.
>
> isn`t there a linux project which is adressing this?
> some site for the sysadmin to consult?
> i have raid controller xyz, what do i need to monitor the arrays state....?
>
> i would expect, that the linux kernel would provide sort of a standardized way to check the health state of a raid array - i.e. this should be completely done in kernel space, as some raid drivers do.
>
> instead i need to use a dozen different tools, which are often closed source, too.
>
> anybody suffer from that headaches, too ?
>   

You have that option, set your controllers to JBOD and use software 
raid. Most people don't play "flavor of the month" with hardware, and 
those of us who let purchasing alter hardware specs to "save money" use 
software raid.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


