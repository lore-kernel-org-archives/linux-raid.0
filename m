From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Thanks :)
Date: Sat, 23 Oct 2004 08:52:53 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <417A0DD5.4030109@robinbowes.com>
References: <41794C1D.4080004@dgreaves.com> <41796ACC.2010601@robinbowes.com> <20041022205144.GA28719@hamachi.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041022205144.GA28719@hamachi.dyndns.org>
To: Steven Ihde <x-linux-raid@hamachi.dyndns.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steven Ihde wrote:
> On Fri, 22 Oct 2004 21:17:16 +0100, Robin Bowes wrote:
> 
>>David Greaves wrote:
>>
>>>I got this yesterday
>>>
>>>#################
>>>This is an automatically generated mail message from mdadm
>>>running on cu.dgreaves.com
>>>
>>>A Fail event had been detected on md device /dev/md0.
>>>#################
>>
>>David,
>>
>>How have you set things up to achieve this?
> 
> 
> See the section on Monitor mode (-F option) in the mdadm man page.
> Debian's mdadm package, for example, sets it up so mdadm -F gets run
> automatically at boot time to monitor your arrays.


Sorry, I wasn't clear enough in my question...

I am aware of mdadms' monitor mode; in fact, I'm sure it used to run 
when I first started using mdadm (on Fedora Core 2 installed from rpm 
built myself from src rpm).

I seem to remember that this was disabled at some stage but can't 
remember the detail - possibly something to do with preventing the array 
from shutting down cleanly because mdadm -F was open on it.

I am hoping that someone can suggest how best to run mdadm -F on Fedora 
Core 2. Perhaps it could be as simple as creating a script in 
/etc/init.d/ which would terminate before the array is shutdown?

R.
-- 
http://robinbowes.com
