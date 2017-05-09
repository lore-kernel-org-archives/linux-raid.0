From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 11:40:54 +0100
Message-ID: <87wp9q5n49.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <591171BD.3060707@hesbynett.no> <87efvy73n9.fsf@esperi.org.uk>
        <9306fd68-4eeb-f487-a500-27050050af98@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9306fd68-4eeb-f487-a500-27050050af98@fnarfbargle.com> (Brad
        Campbell's message of "Tue, 9 May 2017 18:28:20 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: David Brown <david.brown@hesbynett.no>, Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2017, Brad Campbell stated:

> On 09/05/17 17:58, Nix wrote:
>>  md doesn't repair the corruption, even though on RAID-6 it could.
>
> Patches are *always* welcome.

Oh good. I might well look at that.

>> but one wonders how many disks actually *do* this. It's hard to
>> tell because sector sparing is so quiet: it's not always even reflected
>> in the SMART data, AIUI.
>
> Decent SAS drvies do it routinely *and* they tell you in the SMART
> data how long it has been since the last scrub, how long it is until
> the next scrub and how many errors it has silently corrected over the
> drive life. You get what you pay for.

Enterprise SATA drives appear similar except that they don't do the
scrubbing automatically: you have to trigger a SMART self-test. (I'm
wondering if that's enough, and perhaps I can ignore RAID scrubbing
entirely, except that if something *does* go wrong I won't know.)

Of course I haven't yet owned a drive that has ever deigned to give a
nonzero sector-sparing value in any of its SMART info, and I've been
using allegedly-enterprise drives (first SCSI, then SATA) for about
fifteen years now. I've had disk failures without warning, and
non-failed disks with both read and write errors that would not go away,
but that SMART reallocation value just stayed stuck at zero through all
of it. I'm wondering if smartctl is even reading the right field, but
it's hard to imagine how it couldn't be...
