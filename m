From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software RAID when it works and when it doesn't
Date: Tue, 23 Oct 2007 18:45:57 -0400
Message-ID: <471E79A5.5020607@tmr.com>
References: <14526.1192571833@mdt.ecitele.com>	 <87bqaw5tqb.fsf@informatik.uni-tuebingen.de> <1192777672.16416.495.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192777672.16416.495.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alberto Alonso wrote:
> On Thu, 2007-10-18 at 17:26 +0200, Goswin von Brederlow wrote:
>   
>> Mike Accetta <maccetta@laurelnetworks.com> writes:
>>     
>
>   
>> What I would like to see is a timeout driven fallback mechanism. If
>> one mirror does not return the requested data within a certain time
>> (say 1 second) then the request should be duplicated on the other
>> mirror. If the first mirror later unchokes then it remains in the
>> raid, if it fails it gets removed. But (at least reads) should not
>> have to wait for that process.
>>
>> Even better would be if some write delay could also be used. The still
>> working mirror would get an increase in its serial (so on reboot you
>> know one disk is newer). If the choking mirror unchokes then it can
>> write back all the delayed data and also increase its serial to
>> match. Otherwise it gets really failed. But you might have to use
>> bitmaps for this or the cache size would limit its usefullnes.
>>
>> MfG
>>         Goswin
>>     
>
> I think a timeout on both: reads and writes is a must. Basically I
> believe that all problems that I've encountered issues using software
> raid would have been resolved by using a timeout within the md code.
>
> This will keep a server from crashing/hanging when the underlying 
> driver doesn't properly handle hard drive problems. MD can be 
> smarter than the "dumb" drivers.
>
> Just my thoughts though, as I've never got an answer as to whether or
> not md can implement its own timeouts.

I'm not sure the timeouts are the problem, even if md did its own 
timeout, it then needs a way to tell the driver (or device) to stop 
retrying. I don't believe that's available, certainly not everywhere, 
and anything other than everywhere would turn the md code into a nest of 
exceptions.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

