From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID extremely slow
Date: Tue, 31 Jul 2012 23:16:24 -0400
Message-ID: <50189F88.9020805@tmr.com>
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org> <5010A386.4080209@familyross.net> <5010CEFF.5030606@familyross.net> <5012E717.9070808@tmr.com> <50130BEE.8080402@familyross.net> <8oq618ldps0ijt76cr3k6vovkksm4b9vsb@4ax.com> <5013A41E.5070500@familyross.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5013A41E.5070500@familyross.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Kevin Ross <kevin@familyross.net>
Cc: Grant Coady <gcoady.lk@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, Linux Kernel mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Kevin Ross wrote:
> On 07/27/2012 09:45 PM, Grant Coady wrote:
>> On Fri, 27 Jul 2012 14:45:18 -0700, you wrote:
>>
>>> On 07/27/2012 12:08 PM, Bill Davidsen wrote:
>>>> Have you set the io scheduler to deadline on all members of the array?
>>>> That's kind of "job one" on older kernels.
>>>>
>>> I have not, thanks for the tip, I'll look into that now.
>> Plus I disable the on-drive queuing (NCQ) during startup, right now
>> I don't have benchmarks to show the difference.  This on a six by 1TB
>> drive RAID6 array I built over a year ago on Slackware64-13.37:
>>
>> # cat /etc/rc.d/rc.local
>> ...
>> # turn off NCQ on the RAID drives by adjusting queue depth to 1
>> n=1
>> echo "rc.local: Disable RAID drives' NCQ"
>> for d in a b c d e f
>> do
>>          echo "  set NCQ depth to $n on sd${d}"
>>          echo $n>  /sys/block/sd${d}/device/queue_depth
>> done
>> ...
>>
>> Maybe you could try that?  See if it makes a difference.  My drives
>> are Seagate.
>>
>> Grant.
>>
>
> Does disabling NCQ improve performance?

Does for me!
>
> The suggestion to use kernel 3.4.6 has been working quite well so far, 
> hopefully that fixes the problem.  I'll know for sure in a few more days...
>
> Thanks!
> -- Kevin
>


-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010
