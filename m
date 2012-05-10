From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 14:59:11 +0000
Message-ID: <4FABD7BF.2020208@pocock.com.au>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FABC7C6.4030107@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Here is where Marcus and I part ways.  A very common report I see on
> this mailing list is people who have lost arrays where the drives all
> appear to be healthy.  Given the large size of today's hard drives,
> even healthy drives will occasionally have an unrecoverable read error.
> 
> When this happens in a raid array with a desktop drive without SCTERC,
> the driver times out and reports an error to MD.  MD proceeds to
> reconstruct the missing data and tries to write it back to the bad
> sector.  However, that drive is still trying to read the bad sector and
> ignores the controller.  The write is immediately rejected.  BOOM!  The
> *write* error ejects that member from the array.  And you are now
> degraded.
> 
> If you don't notice the degraded array right away, you probably won't
> notice until a URE on another drive pops up.  Once that happens, you
> can't complete a resync to revive the array.

What action would you recommend for someone running md on desktop drives
today?  Can md be configured in some way to avoid such a disaster?

> 
> Running a "check" or "repair" on an array without TLER will have the
> opposite of the intended effect: any URE will kick a drive out instead
> of fixing it.
> 
> In the same scenario with an enterprise drive, or a drive with SCTERC
> turned on, the drive read times out before the controller driver, the
> controller never resets the link to the drive, and the followup write
> succeeds.  (The sector is either successfully corrected in place, or
> it is relocated by the drive.)  No BOOM.

I tend to agree with that approach, and I think that is what Adaptec is
proposing in their FAQ

Presumably, if you really do need one of those sectors, the SCTERC
timeout can be extended (e.g. by disk recovery software) to try harder?


>>> - if a non-RAID SAS card is used, does it matter which card is chosen?
>>> Does md work equally well with all of them?
>>
>> Yes, I believe md raid would work equally well on all SAS HBAs,
>> however the cards themselves vary in performance. Some cards that have
>> simple RAID built-in can be flashed to a dumb card in order to reclaim
>> more card memory (LSI "IR mode" cards), but the performance gain is
>> generally minimal
> 
> Hardware RAID cards usually offer battery-backed write cache, which is
> very valuable in some applications.  I don't have a need for that kind
> of performance, so I can't speak to the details.  (Is Stan H.
> listening?)

BBWC is not just expensive, it also has an extra management overhead,
batteries need to have full discharges occasionally (at a time when
cache is off), routine battery replacement, etc
> 
> FWIW, I *always* use LVM on top of my arrays, simply for the flexibility
> to re-arrange layouts on-the-fly.  Any performance impact that has has
> never bothered my small systems.

I'm a big fan of volume managers too, each different type of data has
it's own LV, it makes it very easy to look at the data at a high level
and see how many GB used by photos, how many for software downloads,
each LV typically has a specific backup regimen.

