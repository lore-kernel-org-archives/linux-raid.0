From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: RAID1 always resyncs at boot???
Date: Sat, 29 Nov 2003 22:31:37 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0311292206580.13188-100000@sweetums.bluetronic.net>
References: <hp1ps8.7u9xet@mail.drtebi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hp1ps8.7u9xet@mail.drtebi.com>
To: drtebi@drtebi.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 27 Nov 2003 drtebi@drtebi.com wrote:
>Trying to mark the drive faulty and add it back in (as described in the man
>page) does not work. But I suppose that couldn't, since it's already faulty.

Of course, you could remove it completely (RAID doesn't even know it exists)
and proceed.  I would suggest this followed by a zero'ing (dd if=/dev/zero)
of the suspect drive.  If you still see errors, check it's warantee status.

>However, if I do the "unplugged concert" again, and the RAID fails to
>reconstruct again, what do you suggest? Try another power supply? Give it up,
>spend $200 more on SCSI drives? ...

No, buy more cheap IDE drives.  One chooses IDE because they are cheap
with the understanding they will need to be replaced about once every one
to two years.  Your mileage may vary... I've been around computers for
20 years; I've never seen a SCSI drive bad right out of the box.  I've
seen dozens of still-born IDE drives. (and at least one that should never
have been boxed. the low-level format of that drive failed, why they
put a controller on it and sold it is beyond me.)

Personally, when I care about the bits, I'll gladly pay more for drives
that have actually been tested and certified to last more than a week.
However, most people only see $$$ and don't see the headaches that
come from lost data.

--Ricky


