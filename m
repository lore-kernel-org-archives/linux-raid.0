From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 12:15:16 +0100
Message-ID: <87fuge5liz.fsf@esperi.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03e2dd0-7283-314d-b5d7-b7ffc5a9c039@thelounge.net> (Reindl
        Harald's message of "Tue, 9 May 2017 12:50:53 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2017, Reindl Harald said:

> Am 09.05.2017 um 12:28 schrieb Nix:
>> Honestly, scrubs are looking less and less desirable the more I talk
>> about them. Massive worry inducers that don't actually spot problems in
>> any meaningful sense (not even at the level of "there is a problem on
>> this disk", just "there is a problem on this array")
>
> that is your opinion
>
> my expierience over years using md-arrays is that *everytime* smartd triggered a alert mail that a drive will fail soon it happened
> while the scrub was running and so you can replace drives as soon as possible

What, it triggered a SMART warning while a scrub was running which SMART
long self-tests didn't? That's depressing. You'd think SMART would be
watching for errors while it's own tests were running!

(Or were you not running any long self-tests? That's at least as risky
as not scrubbing, IMNSHO.)
