From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: RAID 5 questions
Date: Sun, 01 Aug 2004 13:08:34 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <871xira72l.fsf@enki.rimspace.net>
References: <1091325475.2374.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1 Aug 2004, Ninti Systems wrote:
> I'm about to embark on building a RAID 5 Linux software array with 4
> disks (I've only ever built 2 disk RAID 1 arrays before).
>
> Q1: Is it true that Linux can't/shouldn't boot off a RAID 5 array?

Grub certainly can't boot of a software RAID-5 array, and I don't
believe that lilo can either.  This is because of these tools not
understanding the RAID-5 disk layout, not any other limitation.

> Q2: The four disks have identical manufacturer, model and size, but two
> are brand new while two have had NTFS filesystems on them. Accordingly,
> if I run hdparm -g on them, two disks have these specs:
>
> geometry = 2498/255/63, sectors = 40132503, start = 0
>
> while the other two disks have these specs:
>
> geometry = 39813/16/63, sectors = 40132503, start = 0
>
> Is this an issue with software RAID?

No. Software RAID, unlike hardware raid, cares only that you have enough
blocks on the disk. You don't need to match *any* other characteristic
of the disks, and not even that if you don't mind wasting a few bytes.

   Daniel
-- 
The PC is the LSD of the '90s.
        -- Timothy Leary, __Guardian_ (June 1, 1996)

