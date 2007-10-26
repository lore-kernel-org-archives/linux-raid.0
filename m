From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Software RAID when it works and when it doesn't
Date: Fri, 26 Oct 2007 18:12:37 +0200
Message-ID: <87fxzxzwga.fsf@informatik.uni-tuebingen.de>
References: <14526.1192571833@mdt.ecitele.com>
	<87bqaw5tqb.fsf@informatik.uni-tuebingen.de>
	<1192777672.16416.495.camel@w100> <471E79A5.5020607@tmr.com>
	<1193205003.23414.72.camel@w100> <471FA543.9090502@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471FA543.9090502@tmr.com> (Bill Davidsen's message of "Wed, 24
	Oct 2007 16:04:19 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Alberto Alonso <alberto@ggsys.net>, Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen <davidsen@tmr.com> writes:

> Alberto Alonso wrote:
>> On Tue, 2007-10-23 at 18:45 -0400, Bill Davidsen wrote:
>>
>>
>>> I'm not sure the timeouts are the problem, even if md did its own
>>> timeout, it then needs a way to tell the driver (or device) to stop
>>> retrying. I don't believe that's available, certainly not
>>> everywhere, and anything other than everywhere would turn the md
>>> code into a nest of exceptions.
>>>
>>>
>>
>> If we loose the ability to communication to that drive I don't see it
>> as a problem (that's the whole point, we kick it out of the array). So,
>> if we can't tell the driver about the failure we are still OK, md could
>> successfully deal with misbehaved drivers.
>
> I think what you really want is to notice how long the drive and
> driver took to recover or fail, and take action based on that. In
> general "kick the drive" is not optimal for a few bad spots, even if
> the drive recovery sucks.

Depending on the hardware you can still access a different disk while
another one is reseting. But since there is no timeout in md it won't
try to use any other disk while one is stuck.

That is exactly what I miss.

MfG
        Goswin
