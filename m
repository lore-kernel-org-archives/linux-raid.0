From: "Adam Goryachev" <mailinglists@websitemanagers.com.au>
Subject: Re: Best size partition for a mdadm array
Date: Mon, 27 May 2013 19:11:32 +1000
Message-ID: <8b038c62bf256249769a7dc0bf565db4.squirrel@webmail.websitemanagers.com.au>
References: <CAOsORH9X6L+EZY5DEDfwbWkHPgL6Oz9yGC1JWf0nejLckVJg=w@mail.gmail.com>
    <51A2D4A5.6000907@smartguide.com.au>
    <CAOsORH-atqXVkkn+YWH+Q0pO0ZCKvRL3EWUpxa6h-GfsxsjdcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOsORH-atqXVkkn+YWH+Q0pO0ZCKvRL3EWUpxa6h-GfsxsjdcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Bolandrina <andrea.bola@yahoo.it>
Cc: Tudor Holton <tudor@smartguide.com.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 27, 2013 18:38, Andrea Bolandrina wrote:
> Hi Tudor.
>
> All disks I have report the same size, even though they are different
> brand/model

Discussion on this list in the past would suggest the manufacturers have
agreed to make equal sized drives in future, so this shouldn't really be
an issue for 2TB drives or larger.

> If the 2 WD RED bahave as they should I might buy some more as soon as
> the others fail,
> otherwise I will try something different (that's why I want to keep
> the system as flexible as possible).

Why not just put a 2G swap partition at the end of each drive, if needed,
you can reduce the swap partition on the new drive if it is a bit smaller
than the rest, you have up to 2G of flexibility.... (or 1G etc..) This
means the space isn't wasted overall, but there is no issue if you need to
make it a bit smaller/larger/etc...

> The 2 samsung SMART infos are already "screaming for help" and,
> actually, a third Samsung already failed last year.
> Terrible drives, terrible support from Samsung that replaced the drive
> (still under warranty) with a refurbished one that failed within 10
> days from arrival.

Personally, apart from a "batch" of WD Caviar Black drives that all failed
within a week, of had really good experience with them, and also the WD
RE4 drives.... I haven't yet tried the red, but would be interested to
hear how you go.

Regards,
Adam

