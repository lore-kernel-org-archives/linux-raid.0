From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: devices get kicked from RAID about once a month
Date: Wed, 02 Jun 2010 13:42:43 -0400
Message-ID: <4C069813.3010308@tmr.com>
References: <87k4qho723.fsf@uwo.ca>	<628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>	<876321o3lm.fsf@uwo.ca> <4C067AD6.7040700@anonymous.org.uk> <871vcpo0n6.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871vcpo0n6.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Christensen wrote:
> John Robinson <john.robinson@anonymous.org.uk> writes:
>
>   
>> My Samsung Spinpoint F1's can have TLER enabled using a more recent
>> smartctl. It's not appeared as part of a formal release yet but a
>> patch went in to r3065 in SVN:
>> http://sourceforge.net/apps/trac/smartmontools/log/trunk/smartmontools
>>     
>
> Thanks.  I got the svn3077 from Debian testing, but it doesn't seem to
> be supported with my drives:
>
> # smartctl -l scterc /dev/sda
> smartctl 5.40 2010-03-16 r3077 [i686-pc-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen,
> http://smartmontools.sourceforge.net
>
> Warning: device does not support SCT Commands
>
> Any other suggestions?
>   

Presumably something shows in the logs, that's the next place to look.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

