From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: issue with internal bitmaps
Date: Tue, 18 Jul 2006 09:34:35 -0400
Message-ID: <44BCE36B.1040500@tmr.com>
References: <20060706141207.GC21642@percy.comedia.it> <17581.35762.452409.927246@cse.unsw.edu.au> <44BBDC93.6050603@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BBDC93.6050603@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

> Neil Brown wrote:
>
>> On Thursday July 6, bluca@comedia.it wrote:
>>  
>>
>>> hello, i just realized that internal bitmaps do not seem to work
>>> anymore.
>>>   
>>
>>
>> I cannot imagine why.  Nothing you have listed show anything wrong
>> with md...
>>
>> Maybe you were expecting
>>   mdadm -X /dev/md100
>> to do something useful.  Like -E, -X must be applied to a component
>> device.  Try
>>   mdadm -X /dev/sda1
>>
> To take this from the other end, why should -X apply to a component? 
> Since the components can and do change names, and you frequently 
> mention assembly by UUID, why aren't the component names determined 
> from the invariant array name when mdadm wants them, instead of having 
> a user or script check the array to get the components?

Boy, I didn't say that well... what I meant to suggest is that when -E 
or -X are applied to the array as a whole, would it not be useful to 
itterate them over all of the components rather than than looking for 
non-existant data in the array itself?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

