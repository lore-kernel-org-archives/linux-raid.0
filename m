From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 17:11:49 +0100
Message-ID: <87ziem3t8a.fsf@esperi.org.uk>
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
        <5a2d810b-85da-c224-133f-62eab291c161@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5a2d810b-85da-c224-133f-62eab291c161@thelounge.net> (Reindl
        Harald's message of "Tue, 9 May 2017 13:48:45 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2017, Reindl Harald verbalised:

> Am 09.05.2017 um 13:15 schrieb Nix:
>> (Or were you not running any long self-tests? That's at least as risky
>> as not scrubbing, IMNSHO.)
>
> no i do both regulary
>
> * smart short self-test daily
> * smart long self-test weekly
> * raid scrub weekly
>
> and no - doing a long-smart-test daily is not a good solution, the
> RAID10 array in my office makes *terrible noises* when the SMART

Agreed, though in my case not because of noise, but just because the
test takes fourteen hours and noticeably degrades disk performance while
it runs. I'm doing a long self-test monthly and frankly I'm wondering if
every three months is sufficient.

> well, that machine has not lost a single drive, a clone of it acting
> as homeserver 365/24/7 has lost a dozen in the same time....

A *dozen*?! In six years? Even with a big array you've been incredibly
unlucky, or you have young children and a corresponding disaster rate.
(Meanwhile, my last machine, with much-maligned WD GreenPower
variable-spin-rate disks, was completely happy for eight years, zero
failures, zero reallocations that I can see. I can only hope my new lot
are that good.)
