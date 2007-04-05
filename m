From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid6 rebuild
Date: Thu, 05 Apr 2007 09:54:14 -0400
Message-ID: <4614FF86.3020007@tmr.com>
References: <20070404194638.GB3712@xi.wantstofly.org> <e9c3a7c20704042022p6088bdcdl97740d2a95818caf@mail.gmail.com> <20070405055030.GA6978@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070405055030.GA6978@xi.wantstofly.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Dan Williams <dan.j.williams@intel.com>, mingo@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lennert Buytenhek wrote:
> On Wed, Apr 04, 2007 at 08:22:00PM -0700, Dan Williams wrote:
>
>   
>>> While my RAID6 array was rebuilding after one disk had failed (which
>>> I replaced), a second disk failed[*], and this caused the rebuild
>>> process to start over from the beginning.
>>>
>>> Why would the rebuild need to start over from the beginning in this
>>> case?  Why couldn't it just continue from where it was?
>>>       
>> I believe it is because raid5 and raid6 share the same error handler
>> which sets MD_RECOVERY_ERR after losing any disk.  It should probably
>> not set this flag in 1-disk lost raid6 case, but I might be
>> overlooking something else.
>>     
>
> Right, so you're saying that it's probably a bug rather than an
> intentional 'feature'?

No, I would say it's a "reviewable design decision" To be pedantic (as I 
often am), a bug really means that unintended results are generated. In 
this case I think the code functions as intended, but might be able to 
safely take some other action.

I confess, I would feel safer with my data if the rebuild started over, 
I would like to be sure that when it (finally) finishes the data are 
valid. If you replaced the 2nd drive, then a full rebuild would be 
required in any case, to get ALL drives valid.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

