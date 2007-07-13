From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 3ware 9650 tips
Date: Sat, 14 Jul 2007 03:30:51 +0400
Message-ID: <46980B2B.4070101@msgid.tls.msk.ru>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan> <alpine.LRH.0.999.0707131501350.25773@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.0.999.0707131501350.25773@chaos.egr.duke.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joshua Baker-LePain wrote:
[]
> Yep, hardware RAID -- I need the hot swappability (which, AFAIK, is
> still an issue with md).

Just out of curiocity - what do you mean by "swappability" ?

For many years we're using linux software raid, we had no problems
with "swappability" of the component drives (in case of drive
failures and what not).  With non-hotswappable drives (old scsi
and ide ones), rebooting is needed for the system to recognize the
drives.  For modern sas/sata drives, i can replace a faulty drive
without anyone noticing...  Maybe you're referring to something
else?

Thanks.

/mjt


