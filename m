From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Hardware versus Software
Date: Fri, 21 May 2004 14:52:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405211852.i4LIqBB24688@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
To: "'Salyzyn, Mark'" <mark_salyzyn@adaptec.com>, 'Ricky Beam' <jfbeam@bluetronic.net>, 'Ben Edwards' <ben@serverone.co.uk>
Cc: 'Linux RAID List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I should have added...

There are other reasons for going to hardware raid.
Easy hot swap.  Some even indicate the bad drive with an LED.
Disk surface testing.
Bad block relocation.
Parity verification.
Mirror verification.
Able to create logical disks that seem like physical disks to the OS.
50% less IO bandwidth usage on a RAID1 system.
I am sure there are others.  But CPU load would not be a factor.

Not all hardware systems do all of the above.

Anyone else know how much CPU load you have during a rebuild?

Guy

-----Original Message-----
From: Guy [mailto:bugzilla@watkins-home.com] 
Sent: Friday, May 21, 2004 2:39 PM
To: 'Salyzyn, Mark'; 'Ricky Beam'; 'Ben Edwards'
Cc: 'Linux RAID List'
Subject: RE: Hardware versus Software

From what I have seen, the XOR logic does not use much CPU.  Less than 5% on
my 500Mhz P3 system during a rebuild of a 14 disk RAID5 array.  Rebuild rate
of about 5000K/sec per disk, or 70MB/sec total.  It would be hard to say
that a 5% load requires a CPU upgrade!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
Sent: Friday, May 21, 2004 1:45 PM
To: Ricky Beam; Ben Edwards
Cc: Linux RAID List
Subject: RE: Hardware versus Software

CPU utilization is certainly one of the metrics we try our best to
optimize for. When one drops CPU utilization on a server, one can opt
for a cooler running or cheaper main processor.

The XOR engine, DMA engines and Cache are the three feature assists that
allow a less meaty (read, lower cost, lower heat) processor on the HW
Raid cards and yet offer some added performance or cost advantages. The
more appropriate processing power is necessary when trying to keep the
heat down in a 1U enclosure for instance. Keeping the number of
interrupts down to the main CPU, especially if it is not a class of CPU
designed for I/O throughput such as the x86 designs, will keep the
context switching and CPU utilization to a minimum.

OS independent Boot ability, Configuration tools, Install ability, Boot
Redundancy, Hardware based Hot Swapping and years of Intellectual
Property and Experience have to add up to something ;-> It is extremely
difficult to qualify a product and tidily placing `ownership' of RAID
problems into one engineering entity with strict revision and quality
control turns into one main reasons HW RAID still represents a viable
solution in the enterprise space.

EMD was born out of the needs of the OEM clashing with the needs of the
many ;-/

Attempts have been made to use lower cost neutered HW (ie no hot swap
for instance) or SW solutions in the Enterprise space, the results have
been both costly and devastating.

Linux stands in the Enterprise, Desktop and Embedded space; it behoves
the engineer to take each space's needs on their own merits. For
instance, I probably would not use a HW RAID controller in an embedded
application unless I could measure cost savings or performance
improvements on the Host Processor that offset the cost of the added HW.
But in the Enterprise space I would require one of the HW features and
it would be a no brainer. There are no simple answers regardless.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ricky Beam
Sent: Friday, May 21, 2004 11:57 AM
To: Ben Edwards
Cc: Linux RAID List
Subject: Re: Hardware versus Software

On Wed, 19 May 2004, Ben Edwards wrote:
>... I would be very suprised if software raid was
>faster and if it is I wold think the card is either broke or rubish

Negative.  HW RAID cards may have specialized hardware for doing XOR
calculations.  However, no raid card currently on the market has a
3.2GHz
xeon at it's core.  Most are ARM (up to 750MHz?) or i960 (up to 66MHz)
based.
The system CPU can certainly out perform the tiny processors on the raid
card.  Of course, if it's doing raid calculations, it's not do general
computational work which is one reason to use hw raids.

--Ricky


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


