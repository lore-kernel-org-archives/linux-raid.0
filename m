From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Good news / bad news - The joys of RAID
Date: Sat, 20 Nov 2004 23:33:13 -0500
Message-ID: <200411210433.iAL4XIN19967@www.watkins-home.com>
References: <037401c4cf3b$ee75bc90$030a0a0a@musicroom>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <037401c4cf3b$ee75bc90$030a0a0a@musicroom>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Klarzynski' <mark.k@computer-design.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Humm, the Maxtor spec I am looking at does not limit the duty cycle.  It
makes no reference at all.  I think it is reasonable to assume 24 hours per
day, unless they claim less.

The drive should fail on average of once per 114 years, but end of life is
3-5 years?

I did find this on the Maxtor web site:
No MTBF, but ARR of <1%.  I think they are saying if I had 100 drives less
than 1 failure per year.  That is a MTFB of more than 100 years.

Design life (min) 5 years.  So, the disk should last al least 5 years.  I
have no problem with this.  If this is running time, not time powered off.

No limits on duty cycle listed, so got to assume 24/7.

So, if I had 100 disks that lasted at least 5 years with less than 1 failure
per year...  I would be happy.  After all, in 5 years I could replace the
100 drives with 6 new drives with the same total capacity.  This is based on
drive size doubling every 1.5 years.  Of course my requirements double every
year! :)

http://maxtor.com/_files/maxtor/en_us/documentation/data_sheets/diamondmax_1
0_data_sheet.pdf

Now if someone made an affordable tape drive and tapes that could backup
200G per tape, that would be cool!

Guy

-----Original Message-----
From: Mark Klarzynski [mailto:mark.k@computer-design.co.uk] 
Sent: Saturday, November 20, 2004 3:03 PM
To: 'Guy'
Subject: RE: Good news / bad news - The joys of RAID

MTBF is statistic based upon the expected 'use' of the drive and the
replacement of the drive after its end of life (3-5 years)...

It's extremely complex and boring but the figure is only relative if the
drive is being used within an environment that matches those of the
calculations.

SATA / IDE drives have an MTBF similar to that of SCSI / Fibre. But this
is based upon their expected use... i.e. SCSI used to be [power on hours
= 24hr] [use = 8 hours].. whilst SATA used to be [power on = 8 hours]
and [use = 20 mins].

Regardless of what some people clam (usually those that only sell sata
based raids), the drives are not constructed the same in any way.

SATA's fail more within a raid environment (probably around 10:1)
because of the heavy use and also because they are not as intelligent...
therefore when they do not respond we have no way of interrogating them
or resetting them, whilst with scsi we do both. This means that a raid
controller / driver has no option to but simply fail the drive.

Maxtor lead the way in capacity and also reliability... I personal had
to recall countless earlier IBMs and replace them with maxtor.  But the
new generation of IBM's (Hitachi) have got it together.

So - I guess you are all right :) 







-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Guy
Sent: 20 November 2004 19:38
To: 'Mark Hahn'; linux-raid@vger.kernel.org
Subject: RE: Good news / bad news - The joys of RAID

I have had far more failures of Maxtor drives than any other.  I have
also
had problems with WD drives.  I know someone that had 4-6 IBM disks,
most of
which have failed.


I am talking about disks with 3 year warranties!  Based on the spec.
But
OEM disks have none.  You must return them to the PC manufacture.
Most of my failures were within 3 years, but beyond the warranty period
of
the system.  So the OEM issue has occurred too often.

I have had good luck with Seagate.

I use RAID, it is a must with the failure rate!
I do backup also, but RAID tends to save me.

Most people have a PC with 1 disk.  I don't understand RAID, and they
don't
understand that everything will be lost if the disk breaks!  They think
"Dell will just fix it".  But wrong, Dell will just replace it!  Big
difference.

Today's disks claim a MTBF of about 1,000,000 hours!  That's about 114
years.  So, if I had 10 disks I should expect 1 failure every 11.4
years.
That would be so cool!  But not in the real world.

Can you explain how the disks have a MTBF of 1,000,000 hours?  But fail
more
often than that?  Maybe I just don't understand some aspect of MTBF.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mark Hahn
Sent: Saturday, November 20, 2004 1:43 PM
To: linux-raid@vger.kernel.org
Subject: RE: Good news / bad news - The joys of RAID

> Never buy Maxtor drives again!

you imply that Maxtor drives are somehow inherently flawed.
can you explain why you think millions of people/companies
are naive idiots for continuing to buy Maxtor disks?

this sort of thing is just not plausible: Maxtor competes
with the other top-tier disk vendors with similar products
and prices and reliability.  yes, if you buy a 1-year disk,
you can expect it to have been less carefully tested, possibly
be of lower-end design and reliability, and to have been handle
more poorly by the supply chain.  thankfully, you don't have
to buy 1-year disks any more.

read the specs.  make sure your supply chain knows how to
handle disks.  make sure your disks are mounted correctly,
both mechanically and with enough airflow.  use raid and
some form of archiving/backups.  don't get hung up on which
of the 4-5 top-tier vendors makes your disk.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



