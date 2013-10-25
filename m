From: Phil Turmel <philip@turmel.org>
Subject: Re: Enable SCTERC in the kernel?
Date: Fri, 25 Oct 2013 08:29:50 -0400
Message-ID: <526A643E.9000400@turmel.org>
References: <1969984.qn2lKzvFd6@eseries.newtech.fi> <20131025214252.1929c7f1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131025214252.1929c7f1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, dag@newtech.fi
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/25/2013 06:42 AM, NeilBrown wrote:
> On Fri, 25 Oct 2013 11:51 +0300 Dag Nygren <dag@newtech.fi> wrote:
> 
>>
>> Hi all!
>>
>> Just run into the standard problem by not having SCTERC enabled
>> for my drives due to a spelling mistake in my rc.local script
>> setting the parameters and started wondering:
>>
>> - What if the md module automatically set this during assembly
>> of the RAID? - In the kernel module itself. It could always set it,
>> if the set failed we could spit out a kernel warning that the used
>> drive might not be the best as a RAID device. Would there be any ill
>> effects from this?
>> - And ditto for the device time-out.
>>
>> This would definitely make md work a lot better for people. I have a
>> strange feeling that most don't know the parameter needs setting...

No strange feeling at all.  Most of my posts to this list are helping
people bitten by it.

> I don't think it is appropriate for the kernel to automatically set such
> things.  However it might be appropriate for mdadm to do it when assembling
> or creating the array.
> 
> I'm happy to review and  possibly accept patches.

This is a wonderful idea, as it could possibly help people stuck on
older kernels.  I'll take a look at doing this myself.

Phil
