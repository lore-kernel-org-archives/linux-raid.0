From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing
 assembly.
Date: Fri, 27 Apr 2007 15:01:20 -0400
Message-ID: <46324880.7060404@tmr.com>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>	 <462CF303.6030004@dgreaves.com>	 <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>	 <c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>	 <462DC0B0.9010105@dgreaves.com> <c384c5ea0704240544vd15e939kdf46bd75d341f30a@mail.gmail.com> <462FD6AF.3070403@tmr.com> <46310198.8090503@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46310198.8090503@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Bill Davidsen wrote:
>   
>> Leon Woestenberg wrote:
>>     
>>> We will try to make disk clones first. Will dd suffice or do I need
>>> something more fancy that maybe copes with source drive read errors in
>>> a better fashion? 
>>>       
>> Yes to both. dd will be fine in most cases, and I suggest using noerror
>> to continue after errors, and oflag=direct just for performance. You
>> could use ddrescue, it supposedly copes better with errors, although I
>> don't know details.
>>
>>     
>
> Hi Bill
>
> IIRC dd will continue to operate on error but just retries a set number of times
> and continues to the next sector.
>
>   
As I read the O.P. that's fine in this case, two drives believed just 
fine, one showing okay in SMART, all should copy with dd. The last drive 
is probably not recoverable, and if the other three are recovered RAID5 
will recover in any case without it.
> ddrescue does clever things like jumping a few sectors when it hits an error,
> then, after it has retrieved as much data off the disk as possible it starts to
> bisect the error area.
>
> This type of algorithm is good because disks often die after a few minutes of
> being powered and deteriorate rapidly as data is recovered - hammering them on
> retries on an error on sector 312, 313, 314.... when you have millions of
> (currently) readable sectors elsewhere is a bad idea because it can minimise the
> time you have left to read your data. It's also very fast, provides continuous updates to the screen as to where it is and the io rates it is currently seeing and those it's averaging, it also writes
> a log of what it's done to local file to allow restarts.
> etc etc etcc..
> try it - IMHO it's the right tool for the (data-recovery) job :)
>   
I won't recommend a tool I haven't tried, and in this case I don't think 
is going to be needed. I mentioned it existed, that's as far as I want 
to go. I wouldn't suggest someone else use a tool I haven't used (or 
written) myself.

If you've used it and found it worked on a drive with actual bad spots, 
you offered your information which is appropriate.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

