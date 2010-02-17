From: david@lang.hm
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 14:21:30 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1002171420520.4721@asgard.lang.hm>
References: <201002140251.59668.volkerarmin@googlemail.com> <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm> <20100217181016.GA14983@emergent.ellipticsemi.com> <201002171927.07051.volkerarmin@googlemail.com> <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm> <20100217185105.GA15614@emergent.ellipticsemi.com> <alpine.DEB.2.00.1002171317080.4721@asgard.lang.hm> <20100217213741.GA16938@emergent.ellipticsemi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100217213741.GA16938@emergent.ellipticsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 17 Feb 2010, Nick Bowler wrote:

> On 13:17 Wed 17 Feb     , david@lang.hm wrote:
>> On Wed, 17 Feb 2010, Nick Bowler wrote:
>>
>>> On 10:41 Wed 17 Feb     , david@lang.hm wrote:
>>>> On Wed, 17 Feb 2010, Nick Bowler wrote:
>>>>> It takes about half a second for mdadm to assemble my root array, is
>>>>> that what you're referring to?
>>>>>
>>>>> I assume that kernel auto-assembly is no faster, although I've never
>>>>> used it.  Regardless, half a second isn't very long to wait.
>>>>
>>>> If you are aiming for a 5-second boot time it's 10% of your total boot
>>>> time. That's a lot for a feature that's not needed.
>>>
>>> Only if the kernel auto-assembly takes zero time, which it obviously
>>> does not.
>>
>> the assembly time would probably be the same, but the initramfs being
>> proposed did not include that time either.
>
> This was the *only* time that was included.  Quoting myself:
>
>> It takes about half a second for mdadm to assemble my root array

sorry, I misunderstood, I thought you were referring to the time added by 
using the initramfs itself.

David Lang
