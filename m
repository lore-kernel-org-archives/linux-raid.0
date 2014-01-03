From: Dimitri John Ledkov <xnox@debian.org>
Subject: Re: Why 4k native drives haven't arrived
Date: Fri, 3 Jan 2014 11:27:43 +0000
Message-ID: <CANBHLUjceX=NOqwdWWSGS3w=GrJaVt1OvH0PMrgQ5Ce30O+Smg@mail.gmail.com>
References: <52C61807.6050906@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C61807.6050906@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3 January 2014 01:53, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Until someone demonstrates otherwise I will continue to state that 4K
> native drives are still not on the open market.  And the reason for this
> is quite logical if given a moment of thought.
>
> Advanced Format 512e drives, drives with 4K native sectors but 512B
> sectors presented to the host, fully accomplished the goal of the
> spinning disk drive manufacturers.  That goal was simply to pack more
> data per platter, on average about 11% more, by reducing the amount of
> bits consumed for ECC.  I.e. they can sell a lager capacity drive using
> the same hardware as a native 512 byte/sector drive, or with some drive
> capacities, reduce the number of platters while maintaining the same
> capacity, thus reducing component and production cost, and hopefully
> retail price.
>
> The physical sector size presented to the host is irrelevant to the
> drive manufacturers, given the singular goal above.  Switching to a
> native 4K sector does not benefit the manufacturers.  At the current
> time it actually will cause them tremendous problems.
>
> If they were to put 4K native drives on the market today, many millions
> of Windows XP users would buy the drives, ignoring, or simply not
> reading far enough to find the "4K native" warnings.  They then return
> the drives when they don't work, causing great ill will, bad reviews
> tarnishing manufacturers' reputations, and decreasing repeat business.
> Thus native 4K drives will not be on the open market until the
> manufacturers are comfortable that most legacy machines have been
> retired, eliminating the possibility of the scenario above.
>

I'm confused how Windows XP is relevant to the latest top-grade server
hard-drives. And vice versa =)

I would have thought it's more likely for Windows XP users not to buy
hardware components, given that clearly those users are not upgrade
savy in any shape or form.
And even if one would buy a 4k native drive, i would have thought
there'd be other obstacles in trying it out e.g. not having a SATA
port =) considering it was created two years after Windows XP =) or
since a 4k native drive is likely to be 2TB+ in size, GPT support is
required to address the whole drive...

The target market of 4k native drives at the moment is not consumer
market, where SSDs are dominating as "premium" components.
Instead the target market for 4k native drives is server / enterprise
with never-decreasing storage requirements.

FYI here is Microsoft policy with respect to native 4k support matrix:
http://support.microsoft.com/kb/2510009

> The first units of native 4K drives will be, or possibly already have
> been, to OEMs who exercise control over which systems and disk arrays in
> which the drives will be installed.  This prevents such a problem in the
> enterprise space, as purchasers typically rely on their vendors to do
> compatibility matching.  Enterprise OEMs have long maintained such
> product compatibility databases.
>

Most Segate/Baracuda units of capacities close to 1TB and higher are
4k native. And since ~2010-2012 there has been an ever increasing
amount of request for support of native 4k in linux installers which
is as good indication of the uptake as it gets.

I guess eventually it will also tickle down to more conventional
hardware setups.

-- 
Regards,

Dimitri.
