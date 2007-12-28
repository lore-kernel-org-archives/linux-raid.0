From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5 grow reshaping speed is unchangeable
Date: Thu, 27 Dec 2007 19:57:32 -0500
Message-ID: <477449FC.6080400@tmr.com>
References: <380-22007124277469805@mochamail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <380-22007124277469805@mochamail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cody Yellan <cody@mochamail.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Cody Yellan wrote:
> I forgot the version information:
>
> mdadm - v2.5.4 - 13 October 2006
> kernel 2.6.18-53.el5 #1 SMP
>
> Would anyone consider it unsafe to upgrade to the latest version of
> mdadm on a production machine using Neil Brown's srpm?
>   

I wouldn't expect any problems, although I don't think there will be a 
benefit, either. The problem with RHEL is that while it's stable in 
terms of bug fixes, it also doesn't get any performance benefits.

Why not wait until Neil gets back from the holiday and see if he has any 
words of advice?

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


