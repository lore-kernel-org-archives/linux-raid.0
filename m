From: david@lang.hm
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 10:41:34 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
References: <201002140251.59668.volkerarmin@googlemail.com> <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm> <20100217181016.GA14983@emergent.ellipticsemi.com> <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100217183703.GA15446@emergent.ellipticsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 17 Feb 2010, Nick Bowler wrote:

> On 19:27 Wed 17 Feb     , Volker Armin Hemmann wrote:
>> On Mittwoch 17 Februar 2010, Nick Bowler wrote:
>>> On 09:41 Wed 17 Feb     , david@lang.hm wrote:
>>>> for a distro that is trying to make one kernel image run on every
>>>> possible type of hardware features like initramfs (and udev, modeules,
>>>> etc) are wonderful.
>>>>
>>>> however for people who run systems that are known ahead of time and
>>>> static (and who build their own kernels instead of just relying on the
>>>> distro default kernel), all of this is unnessesary complication, which
>>>> leaves more room for problems to creep in.
>>>
>>> Such people can easily construct an initramfs containing busybox and
>>> mdadm with a shell script hardcoded to mount their root fs and run
>>> switch_root.  It's a ~10 minute jobbie that only needs to be done once.
>>
>> and even better when you don't have to do that one time job at all.
>
> But people who are building their own kernels are already doing a
> (much harder, imo) one time job of configuring their kernels.
>
>> btw, what about additional delay?
>
> It takes about half a second for mdadm to assemble my root array, is
> that what you're referring to?
>
> I assume that kernel auto-assembly is no faster, although I've never
> used it.  Regardless, half a second isn't very long to wait.

If you are aiming for a 5-second boot time it's 10% of your total boot 
time. That's a lot for a feature that's not needed.

David Lang
