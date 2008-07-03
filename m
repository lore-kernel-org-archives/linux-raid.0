From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: "raid" versions of hard drives for software raid?
Date: Thu, 03 Jul 2008 11:06:54 -0500
Message-ID: <486CF91E.4090705@gmail.com>
References: <873amsqbag.fsf@uwo.ca> <486BE720.3090507@redhat.com>	<87tzf8ovll.fsf@uwo.ca> <87abgzvxxn.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87abgzvxxn.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Christensen wrote:
> Dan Christensen <jdc@uwo.ca> writes:
> 
>>> Dan Christensen wrote:
>>>> I'm looking at either the Western Digital 500G RE2 drives or the cheaper
>>>> 500G SE16 drives.  I have read that for use with a hardware raid card,
>>>> the RE2 drives are more appropriate, and I'm wondering if the same is
>>>> true for software raid.
>> The difference that is most commonly described, and that I should have
>> highlighted, is TLER: Time-Limited Error Recovery.  Apparently, the SE16
>> drives can take a long time to recover from an error (up to two minutes,
>> I believe), and hardware raid controllers can kick the drives out of the
>> array when it would instead be better for the drive to return a
>> read/write error and let the raid controller deal with it.
>>
>> My question is really whether this logic applies to linux software raid.
> 
> One more reference:
> 
>   http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery
> 
> It certainly sounds to me like TLER is also appropriate for software
> raid, so I'm going to go ahead and get the RE2 drives.
> 
> Dan

If you were trying to salvage as much data as possible off of a drive TLER would 
also be nice, since it would lower the time to get a bad sector error.

I don't really understand how much use it is to try that many times, the drive 
should be able to try 1x per rev, so at 7200, 120 times per second, I would 
wonder how many times that they get a good read after having failed the first 
120 times, much less after the first 7 seconds (960 failures) of trying, or even 
longer periods without TLER.

In fact I would think for a RAID drive one would want even lower than 7 seconds.

                                 Roger
