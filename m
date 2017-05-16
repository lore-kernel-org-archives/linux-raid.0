From: Anthonys Lists <antlists@youngman.org.uk>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance
 with badblocks)
Date: Tue, 16 May 2017 17:11:58 +0100
Message-ID: <591B24CE.50805@youngman.org.uk>
References: <591314F4.2010702@youngman.org.uk>
 <87lgpyn5sf.fsf@notabene.neil.brown.name> <87vap2tlvq.fsf@esperi.org.uk>
 <5919B0AC.30705@youngman.org.uk>
 <7ba308d7-6954-8cd9-e623-93b940c5e370@turmel.org>
 <591AD58E.6090408@youngman.org.uk>
 <d1580b0f-c38d-17ce-3488-33135774ed92@turmel.org>
 <591B125A.1000307@youngman.org.uk>
 <1bccccd1-1ff8-1cb3-492e-42468a3c8a8f@turmel.org>
 <87efvosstq.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efvosstq.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/05/2017 16:51, Nix wrote:
> On 16 May 2017, Phil Turmel spake thusly:
>
>> >On 05/16/2017 10:53 AM, Wols Lists wrote:
>>> >>First thing we do is read the entire stripe.
>> >
>> >A substantial performance degradation, right out of the gate...
> I'm fairly sure Wol's intention is to do this as part of a check/repair
> operation. You don't want to run like this in normal usage! (Though I
> agree that it seems unclear whether you want to do this at all.)
It's not meant to be on by default. Imho, if the sysadmin switches it 
on, it's their lookout :-) Integrity over speed - some sysadmins might 
make that choice.

Cheers,
Wol
