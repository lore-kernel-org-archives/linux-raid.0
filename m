From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 004 of 11] md: Increase the delay before marking metadata
 clean, and make it configurable.
Date: Mon, 01 May 2006 16:15:00 +1000
Message-ID: <4455A764.1000307@yahoo.com.au>
References: <20060501152229.18367.patches@notabene>	<1060501053019.22949@suse.de>	<20060430224404.1060d29a.akpm@osdl.org> <17493.42109.153523.381980@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17493.42109.153523.381980@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Sunday April 30, akpm@osdl.org wrote:
>
>>NeilBrown <neilb@suse.de> wrote:
>>
>>>
>>>When a md array has been idle (no writes) for 20msecs it is marked as
>>>'clean'.  This delay turns out to be too short for some real
>>>workloads.  So increase it to 200msec (the time to update the metadata
>>>should be a tiny fraction of that) and make it sysfs-configurable.
>>>
>>>
>>>...
>>>
>>>+   safe_mode_delay
>>>+     When an md array has seen no write requests for a certain period
>>>+     of time, it will be marked as 'clean'.  When another write
>>>+     request arrive, the array is marked as 'dirty' before the write
>>>+     commenses.  This is known as 'safe_mode'.
>>>+     The 'certain period' is controlled by this file which stores the
>>>+     period as a number of seconds.  The default is 200msec (0.200).
>>>+     Writing a value of 0 disables safemode.
>>>+
>>>
>>Why not make the units milliseconds?  Rename this to safe_mode_delay_msecs
>>to remove any doubt.
>>
>
>Because umpteen years ago when I was adding thread-usage statistics to
>/proc/net/rpc/nfsd I used milliseconds and Linus asked me to make it
>seconds - a much more "obvious" unit.  See Email below.
>It seems very sensible to me.
>

Either way, all ambiguity is removed if you put the unit in the name. And
don't use jiffies because that obviously is not portable (which sounds like
it was Linus' biggest concern).

Once you do that, I don't much care whether you use seconds or milliseconds.
Other than to note that many of our units now are ms, especially when 
they're
measuring things at or around the ms order of magnitude. But I'm not 
aware of
so many proc values that don't work in integers.

--

Send instant messages to your online friends http://au.messenger.yahoo.com 

