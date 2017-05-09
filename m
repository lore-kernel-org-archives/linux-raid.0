From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 13:48:45 +0200
Message-ID: <5a2d810b-85da-c224-133f-62eab291c161@thelounge.net>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
 <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk>
 <e2196f02-2b94-8afb-06a0-9695d441c890@turmel.org>
 <871sry728q.fsf@esperi.org.uk>
 <e03e2dd0-7283-314d-b5d7-b7ffc5a9c039@thelounge.net>
 <87fuge5liz.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fuge5liz.fsf@esperi.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 09.05.2017 um 13:15 schrieb Nix:
> On 9 May 2017, Reindl Harald said:
> 
>> Am 09.05.2017 um 12:28 schrieb Nix:
>>> Honestly, scrubs are looking less and less desirable the more I talk
>>> about them. Massive worry inducers that don't actually spot problems in
>>> any meaningful sense (not even at the level of "there is a problem on
>>> this disk", just "there is a problem on this array")
>>
>> that is your opinion
>>
>> my expierience over years using md-arrays is that *everytime* smartd triggered a alert mail that a drive will fail soon it happened
>> while the scrub was running and so you can replace drives as soon as possible
> 
> What, it triggered a SMART warning while a scrub was running which SMART
> long self-tests didn't? That's depressing. You'd think SMART would be
> watching for errors while it's own tests were running!

different time of tests, different access metrics

i guess smarter people like both of us had a reason to develop scrub 
instead say "just let the drive do it at it's own

> (Or were you not running any long self-tests? That's at least as risky
> as not scrubbing, IMNSHO.)

no i do both regulary

* smart short self-test daily
* smart long self-test weekly
* raid scrub weekly

and no - doing a long-smart-test daily is not a good solution, the 
RAID10 array in my office makes *terrible noises* when the SMART test is 
running and after doing this every week the last 6 years (Power_On_Hours 
14786, Start_Stop_Count 1597) i would say they are normal but probably 
it's not good doing that operations all the time

well, that machine has not lost a single drive, a clone of it acting as 
homeserver 365/24/7 has lost a dozen in the same time....
