From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Wed, 02 Apr 2008 13:43:12 -0400
Message-ID: <47F3C5B0.2040206@tmr.com>
References: <47F020C6.1060809@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47F020C6.1060809@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robert L Mathews wrote:
> I'm using a two-disk SATA RAID 1 array on a number of identical 
> servers, currently running kernel 2.6.8 (I know that's outdated; we 
> use security backports and will soon be upgrading to 2.6.18).

If you look at the change logs for versions between 2.6.8 and 2.6.24 you 
will see a lot of improvements in disk error handling.  The kernel you 
are running is probably incapable of handling the particular failure you 
are getting, at least for values of "handle" which include "cleanly 
report failure back to the md layer." Unless you have some very good 
reason for upgrading to another old kernel, you really should consider 
moving to something more recent. Security backports seem to be aimed at 
intrusion prevention and not data security in this case.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


