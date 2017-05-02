From: Nix <nix@esperi.org.uk>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Tue, 02 May 2017 11:02:34 +0100
Message-ID: <87efw7ink5.fsf@esperi.org.uk>
References: <590117CD.1000009@tesco.net>
        <22785.65375.947842.648174@quad.stoffel.home>
        <5492628.c8B43Z4h0G@matkor-lenovo>
        <22786.16524.435313.304834@quad.stoffel.home>
        <87o9veje3v.fsf@esperi.org.uk> <20170430182134.0e8c6dc0@natsu>
        <87fugpkhap.fsf@esperi.org.uk> <20170430214729.2a02cce5@natsu>
        <8737cojn54.fsf@esperi.org.uk> <20170502024657.6d33fd88@natsu>
        <6398208a-1345-bdec-4be6-a8bd98bfb089@youngman.org.uk>
        <20170502030307.4d7a77dd@natsu> <590822E2.1080009@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590822E2.1080009@youngman.org.uk> (Wols Lists's message of "Tue,
        2 May 2017 07:10:42 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Roman Mamedov <rm@romanrm.net>, John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2 May 2017, Wols Lists outgrape:

> On 01/05/17 23:03, Roman Mamedov wrote:
>>> > That's what I understood you to mean, but you are aware that SOME raid 
>>> > management still has to be done with echo > /sys/... ?
>>> > 
>>> > So mdadm isn't perfect, not  by a long chalk, yet :-)
>> Well, why not post some examples of what you find yourself doing often
>> via /sys, that's not available in mdadm (maybe as a new thread).
>
> I *should* do, rather than I *do* do, but your everyday general
> maintenance tasks, like scrubbing?

You can scrub with mdadm now. :) IIRC (I haven't started using it yet)
the syntax is something like

mdadm --misc --action=check /dev/md/my-array

or

mdadm --misc --action=repair /dev/md/my-array

(though frankly it has never been clear to me which is preferable for a
regular scrub. Probably check on a RAID-6, repair on a RAID-5 where such
failures are much more potentially catastrophic...)
