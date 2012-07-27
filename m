From: Kevin Ross <kevin@familyross.net>
Subject: Re: RAID extremely slow
Date: Thu, 26 Jul 2012 20:17:53 -0700
Message-ID: <50120861.5020605@familyross.net>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org>   <5010A386.4080209@familyross.net>   <1343355303.29938.5.camel@obelisk.thedillows.org>  <1343355430.29938.6.camel@obelisk.thedillows.org>  <5011FA45.7030407@familyross.net> <1343356044.29938.7.camel@obelisk.thedillows.org> <5012028C.9080107@familyross.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5012028C.9080107@familyross.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Dillow <dave@thedillows.org>
Cc: Phil Turmel <philip@turmel.org>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2012 07:53 PM, Kevin Ross wrote:
> On 07/26/2012 07:27 PM, David Dillow wrote:
>> On Thu, 2012-07-26 at 19:17 -0700, Kevin Ross wrote:
>>> On 07/26/2012 07:17 PM, David Dillow wrote:
>>>> On Thu, 2012-07-26 at 22:15 -0400, David Dillow wrote:
>>>>> If you can, upgrade to the latest 3.4 stable kernel (3.4.6 right 
>>>>> now).
>>>>> As far as I can see, the latest 3.2 stable does not contain the 
>>>>> delayed
>>>>> stripe fix.
>>>> And I was looking at the wrong version; 3.2.24 does indeed have the 
>>>> fix.
>>>>
>>> I'm running 3.2.21, does that contain the fix?
>> No, that was the one I looked at. It is commit
>> c0159c780e8d42309d04e83271986274d3880826.
>>
>
> Okay, I grabbed 3.4.4 from Debian experimental, and I'm running with 
> that now.  Hopefully this fixes the problem.
>
> Thanks for your help!
> -- Kevin

Just noticed I need 3.4.5 or later.  Doh!  I'll grab a vanilla kernel 
from kernel.org and build it.

Thanks!
-- Kevin
