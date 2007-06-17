From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: limits on raid
Date: Sun, 17 Jun 2007 13:16:30 -0400
Message-ID: <46756C6E.1070106@tmr.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david@lang.hm wrote:
> On Sat, 16 Jun 2007, Neil Brown wrote:
>
>> It would be possible to have a 'this is not initialised' flag on the
>> array, and if that is not set, always do a reconstruct-write rather
>> than a read-modify-write.  But the first time you have an unclean
>> shutdown you are going to resync all the parity anyway (unless you
>> have a bitmap....) so you may as well resync at the start.
>>
>> And why is it such a big deal anyway?  The initial resync doesn't stop
>> you from using the array.  I guess if you wanted to put an array into
>> production instantly and couldn't afford any slowdown due to resync,
>> then you might want to skip the initial resync.... but is that really
>> likely?
>
> in my case it takes 2+ days to resync the array before I can do any 
> performance testing with it. for some reason it's only doing the 
> rebuild at ~5M/sec (even though I've increased the min and max rebuild 
> speeds and a dd to the array seems to be ~44M/sec, even during the 
> rebuild)
>
> I want to test several configurations, from a 45 disk raid6 to a 45 
> disk raid0. at 2-3 days per test (or longer, depending on the tests) 
> this becomes a very slow process.
>
I've been doing stuff like this, but I just build the array on a 
partition per drive so the init is livable. For the stuff I'm doing a 
total of 500-100GB is ample to do performance testing.
> also, when a rebuild is slow enough (and has enough of a performance 
> impact) it's not uncommon to want to operate in degraded mode just 
> long enought oget to a maintinance window and then recreate the array 
> and reload from backup.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

