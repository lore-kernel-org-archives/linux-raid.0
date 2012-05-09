From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Wed, 9 May 2012 16:33:57 -0600
Message-ID: <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
References: <4FAAE8F1.8000600@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAAE8F1.8000600@pocock.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can't speak to all of these, but...

On Wed, May 9, 2012 at 4:00 PM, Daniel Pocock <daniel@pocock.com.au> wr=
ote:
>
>
> There is various information about
> - enterprise-class drives (either SAS or just enterprise SATA)
> - the SCSI/SAS protocols themselves vs SATA
> having more advanced features (e.g. for dealing with error conditions=
)
> than the average block device
>
> For example, Adaptec recommends that such drives will work better wit=
h
> their hardware RAID cards:
>
> http://ask.adaptec.com/cgi-bin/adaptec_tic.cfg/php/enduser/std_adp.ph=
p?p_faqid=3D14596
> "Desktop class disk drives have an error recovery feature that will
> result in a continuous retry of the drive (read or write) when an err=
or
> is encountered, such as a bad sector. In a RAID array this can cause =
the
> RAID controller to time-out while waiting for the drive to respond."
>
> and this blog:
> http://www.adaptec.com/blog/?p=3D901
> "major advantages to enterprise drives (TLER for one) ... opt for the
> enterprise drives in a RAID environment no matter what the cost of th=
e
> drive over the desktop drive"
>
> My question..
>
> - does Linux md RAID actively use the more advanced features of these
> drives, e.g. to work around errors?

TLER and its ilk simply give up quickly on errors. This may be good
for a RAID card that otherwise would reset itself if it doesn't get a
timely response from a drive, but it can be bad for md RAID. It
essentially increases the chance that you won't be able to rebuild,
you lose drive A of a 2 x 3TB RAID 1, and then during rebuild drive B
has an error and the disk gives up after 7 seconds, rather than doing
all of its fancy off-sector reads and whatever else it would normally
do to save your last good copy.

>
> - if a non-RAID SAS card is used, does it matter which card is chosen=
?
> Does md work equally well with all of them?

Yes, I believe md raid would work equally well on all SAS HBAs,
however the cards themselves vary in performance. Some cards that have
simple RAID built-in can be flashed to a dumb card in order to reclaim
more card memory (LSI "IR mode" cards), but the performance gain is
generally minimal

>
> - ignoring the better MTBF and seek times of these drives, do any of =
the
> other features passively contribute to a better RAID experience when
> using md?

Not that I know of, but I'd be interested in hearing what others think.

>
> - for someone using SAS or enterprise SATA drives with Linux, is ther=
e
> any particular benefit to using md RAID, dmraid or filesystem (e.g.
> btrfs) RAID (apart from the btrfs having checksums)?

As opposed to hardware RAID? The main thing I think of is freedom from
vendor lock-in. If you lose your card you don't have to run around
finding another that is compatible with the hardware RAID's on-disk
metadata format that was deprecated last year. Last I checked,
performance was pretty great with md, and you can get fancy and spread
your array across multiple controllers and things like that. Finally,
md RAID tends to have a better feature set than the hardware, for
example N-disk mirrors. I like running a 3 way mirror over 2 way +
hotspare.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
