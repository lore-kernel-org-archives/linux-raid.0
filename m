From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: raid bug in 2.4.20
Date: Fri, 11 Apr 2003 06:10:27 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304110613_MC3-1-33F7-C4B9@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
	 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Paul Clements wrote:


> Have you been able to reproduce this problem with any regularity? Or
> have you tried? I have an idea what *might* be causing this, if you're
> willing to try out a patch...


 Please post it even if he can't try it.

 All I have found so far is two missing newlines in the status
message code (symptom: lines containing "<6>" in the syslog.)

 (later) just noticed that the raid1 status printout doesn't show the
write_only flag.  This should probably be added...


> BTW, the md "BUG" you originally reported is not really a bug -- that
> always happens when you try to raidhotremove an active disk.


 It calls MD_BUG() when that happens, though.

--
 Chuck
 I am not a number!
