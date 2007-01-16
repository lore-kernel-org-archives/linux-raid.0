From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Mon, 15 Jan 2007 19:41:23 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701151938060.11250@filesrv1.baby-dragons.com>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>
 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>
 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu>
 <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com>
 <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org> <45AB9DC6.50509@tmr.com>
 <45ABAA43.2000902@robinbowes.com> <Pine.LNX.4.64.0701151321190.16472@twinlark.arctic.org>
 <45AC1DD9.9070402@panix.com> <Pine.LNX.4.64.0701151643270.16472@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701151643270.16472@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Dean ,

On Mon, 15 Jan 2007, dean gaudet wrote:
...snip...
> it should just be:
>
> echo check >/sys/block/mdX/md/sync_action
>
> if you don't have a /sys/block/mdX/md/sync_action file then your kernel is
> too old... or you don't have /sys mounted... (or you didn't replace X with
> the raid number :)
>
> iirc there were kernel versions which had the sync_action file but didn't
> yet support the "check" action (i think possibly even as recent as 2.6.17
> had a small bug initiating one of the sync_actions but i forget which
> one).  if you can upgrade to 2.6.18.x it should work.
>
> debian unstable (and i presume etch) will do this for all your arrays
> automatically once a month.
>
> -dean

 	Being able to run a 'check' is a good thing (tm) .  But without a method 
to acquire statii & data back from the check ,  Seems rather bland .  Is there a 
tool/file to poll/... where data & statii can be acquired ?
 		Tia ,  JimL

-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
