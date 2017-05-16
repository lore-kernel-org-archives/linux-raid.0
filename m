From: Nix <nix@esperi.org.uk>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance with badblocks)
Date: Tue, 16 May 2017 16:51:45 +0100
Message-ID: <87efvosstq.fsf@esperi.org.uk>
References: <591314F4.2010702@youngman.org.uk>
        <87lgpyn5sf.fsf@notabene.neil.brown.name>
        <87vap2tlvq.fsf@esperi.org.uk> <5919B0AC.30705@youngman.org.uk>
        <7ba308d7-6954-8cd9-e623-93b940c5e370@turmel.org>
        <591AD58E.6090408@youngman.org.uk>
        <d1580b0f-c38d-17ce-3488-33135774ed92@turmel.org>
        <591B125A.1000307@youngman.org.uk>
        <1bccccd1-1ff8-1cb3-492e-42468a3c8a8f@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1bccccd1-1ff8-1cb3-492e-42468a3c8a8f@turmel.org> (Phil Turmel's
        message of "Tue, 16 May 2017 11:31:16 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16 May 2017, Phil Turmel spake thusly:

> On 05/16/2017 10:53 AM, Wols Lists wrote:
>> First thing we do is read the entire stripe.
>
> A substantial performance degradation, right out of the gate...

I'm fairly sure Wol's intention is to do this as part of a check/repair
operation. You don't want to run like this in normal usage! (Though I
agree that it seems unclear whether you want to do this at all.)

However, the existence of raid6check, which is new enough that I'd not
noticed it (not being installed by default doesn't help there, as does
the lack of mention of autorepair mode in the manpage), makes this
entire conversation/argument moot, as far as I can see. If you're really
concerned, stick raid6check in early userspace, like mdadm, so you can
recover from *anything*. :)

The requirement to run raid6check by hand is no more annoying than the
requirement to run scrubs by hand: userspace is clearly a better place
for this sort of rare obscurity than the kernel, though it's a minor
shame raid6check can't tell md that the block device has changed so you
wouldn't need to impair availability by taking the array down after
fixing things. (Still, this is likely to be needed so rarely that it's
completely unimportant.)

-- 
NULL && (void)
