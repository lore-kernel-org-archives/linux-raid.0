From: Phil Turmel <philip@turmel.org>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 09:51:02 -0400
Message-ID: <4FABC7C6.4030107@turmel.org>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: Daniel Pocock <daniel@pocock.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm afraid I have to disagree with Marcus ...

And other observations ...

On 05/09/2012 06:33 PM, Marcus Sorensen wrote:
> I can't speak to all of these, but...
> 
> On Wed, May 9, 2012 at 4:00 PM, Daniel Pocock <daniel@pocock.com.au> wrote:
>>
>>
>> There is various information about
>> - enterprise-class drives (either SAS or just enterprise SATA)
>> - the SCSI/SAS protocols themselves vs SATA
>> having more advanced features (e.g. for dealing with error conditions)
>> than the average block device
>>
>> For example, Adaptec recommends that such drives will work better with
>> their hardware RAID cards:
>>
>> http://ask.adaptec.com/cgi-bin/adaptec_tic.cfg/php/enduser/std_adp.php?p_faqid=14596
>> "Desktop class disk drives have an error recovery feature that will
>> result in a continuous retry of the drive (read or write) when an error
>> is encountered, such as a bad sector. In a RAID array this can cause the
>> RAID controller to time-out while waiting for the drive to respond."

Linux direct drivers will also time out in this case, although the
driver timeout is adjustable.  Default is 30 seconds, while desktop
drives usually keep trying to recover errors for minutes at a time.

>> and this blog:
>> http://www.adaptec.com/blog/?p=901
>> "major advantages to enterprise drives (TLER for one) ... opt for the
>> enterprise drives in a RAID environment no matter what the cost of the
>> drive over the desktop drive"

Unless you find drives that support SCTERC, which allows you to tell
the drives to use a more reasonable timeout (typically 7 seconds).

Unfortunately, SCTERC is not a persistent parameter, so it needs to be
set on every powerup (udev rule is the best).

>> My question..
>>
>> - does Linux md RAID actively use the more advanced features of these
>> drives, e.g. to work around errors?
> 
> TLER and its ilk simply give up quickly on errors. This may be good
> for a RAID card that otherwise would reset itself if it doesn't get a
> timely response from a drive, but it can be bad for md RAID. It
> essentially increases the chance that you won't be able to rebuild,
> you lose drive A of a 2 x 3TB RAID 1, and then during rebuild drive B
> has an error and the disk gives up after 7 seconds, rather than doing
> all of its fancy off-sector reads and whatever else it would normally
> do to save your last good copy.

Here is where Marcus and I part ways.  A very common report I see on
this mailing list is people who have lost arrays where the drives all
appear to be healthy.  Given the large size of today's hard drives,
even healthy drives will occasionally have an unrecoverable read error.

When this happens in a raid array with a desktop drive without SCTERC,
the driver times out and reports an error to MD.  MD proceeds to
reconstruct the missing data and tries to write it back to the bad
sector.  However, that drive is still trying to read the bad sector and
ignores the controller.  The write is immediately rejected.  BOOM!  The
*write* error ejects that member from the array.  And you are now
degraded.

If you don't notice the degraded array right away, you probably won't
notice until a URE on another drive pops up.  Once that happens, you
can't complete a resync to revive the array.

Running a "check" or "repair" on an array without TLER will have the
opposite of the intended effect: any URE will kick a drive out instead
of fixing it.

In the same scenario with an enterprise drive, or a drive with SCTERC
turned on, the drive read times out before the controller driver, the
controller never resets the link to the drive, and the followup write
succeeds.  (The sector is either successfully corrected in place, or
it is relocated by the drive.)  No BOOM.

>> - if a non-RAID SAS card is used, does it matter which card is chosen?
>> Does md work equally well with all of them?
> 
> Yes, I believe md raid would work equally well on all SAS HBAs,
> however the cards themselves vary in performance. Some cards that have
> simple RAID built-in can be flashed to a dumb card in order to reclaim
> more card memory (LSI "IR mode" cards), but the performance gain is
> generally minimal

Hardware RAID cards usually offer battery-backed write cache, which is
very valuable in some applications.  I don't have a need for that kind
of performance, so I can't speak to the details.  (Is Stan H.
listening?)

>> - ignoring the better MTBF and seek times of these drives, do any of the
>> other features passively contribute to a better RAID experience when
>> using md?
> 
> Not that I know of, but I'd be interested in hearing what others think.

They power up with TLER enabled, where the desktop drives don't.  You've
excluded the MTBF and seek performance as criteria, which I believe are
the only remaining advantages, and not that important to light-duty
users.

The drive manufacturers have noticed this, by the way.  Most of them
no longer offer SCTERC in their desktop products, as they want RAID
users to buy their more expensive (and profitable) drives.  I was burned
by this when I replaced some Seagate Barracuda 7200.11 1T drives (which
support SCTERC) with Seagate Barracude Green 2T drives (which don't).

Neither Seagate nor Western Digital offer any desktop drive with any
form of time-limited error recovery.  Seagate and WD were my "go to"
brands for RAID.  I am now buying Hitachi, as they haven't (yet)
followed their peers.  The "I" in RAID stands for "inexpensive",
after all.

>> - for someone using SAS or enterprise SATA drives with Linux, is there
>> any particular benefit to using md RAID, dmraid or filesystem (e.g.
>> btrfs) RAID (apart from the btrfs having checksums)?
> 
> As opposed to hardware RAID? The main thing I think of is freedom from
> vendor lock-in. If you lose your card you don't have to run around
> finding another that is compatible with the hardware RAID's on-disk
> metadata format that was deprecated last year. Last I checked,
> performance was pretty great with md, and you can get fancy and spread
> your array across multiple controllers and things like that. Finally,
> md RAID tends to have a better feature set than the hardware, for
> example N-disk mirrors. I like running a 3 way mirror over 2 way +
> hotspare.

Concur.  Software RAID's feature set is impressive, with great
performance.

FWIW, I *always* use LVM on top of my arrays, simply for the flexibility
to re-arrange layouts on-the-fly.  Any performance impact that has has
never bothered my small systems.

HTH,

Phil
