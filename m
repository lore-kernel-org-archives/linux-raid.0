From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 03:14:27 -0500
Message-ID: <20090405081431.VFVL1944.cdptpa-omta02.mail.rr.com@Leslie>
References: <F2C688D6A021E34CB81C0E631EF4C093017FF4C3@34093-C4-EVS1.exchange.rackspace.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2C688D6A021E34CB81C0E631EF4C093017FF4C3@34093-C4-EVS1.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> All of what you report is still consistent with delays caused by having
> to remap bad blocks

I disagree.  If it happened with some frequency during ordinary reads, then
I would agree.  If it happened without respect to the volume of reads and
writes on the system, then I would be less inclined to disagree.

> The O/S will not report recovered errors, as this gets done internally
> by the disk drive, and the O/S never learns about it. (Queue depth

SMART is supposed to report this, and rarely the kernel log does report a
block of sectors being marked bad by the controller.  I cannot speak to the
notion SMART's reporting of relocated sectors and failed relocations may not
be accurate, as I have no means to verify.

Actually, I should amend the first sentence, because while the ten drives in
the array are almost never reporting any errors, there is another drive in
the chassis which is chunking out error reports like a farm boy spitting out
watermelon seeds.  I had a 320G drive in another system which was behaving
erratically, so I moved it to the array chassis on this machine to eliminate
it being a cable or the drive controller.  It's reporting blocks being
marked bad all over the place.

> Really, if this was my system I would run non-destructive read tests on
> all blocks;

How does one do this?  Or rather, isn't this what the monthly mdadm resync
does?

> along with the embedded self-test on the disk.  It is often

How does one do this?

> a lot easier and more productive to eliminate what ISN'T the problem
> rather than chase all of the potential reasons for the problem.

I agree, which is why I am asking for troubleshooting methods and utilities.

The monthly RAID array resync started a few minutes ago, and it is providing
some interesting results.  The number of blocks read / second is
consistently 13,000 - 24,000 on all ten drives.  There were no other drive
accesses of any sort at the time, so the number of blocks written was flat
zero on all drives in the array.  I copied the /etc/hosts file to the RAID
array, and instantly the file system locked, but the array resync *DID NOT*.
The number of blocks read and written per second continued to range from
13,000 to 24,000 blocks/second, with no apparent halt or slow-down at all,
not even for one second.  So if it's a drive error, why are file system
reads halted almost completely, and writes halted altogether, yet drive
reads at the RAID array level continue unabated at an aggregate of more than
130,000 blocks - 240,000 blocks (500 - 940 megabits) per second?  I tried a
second copy and again the file system accesses to the drives halted
altogether.  The block reads (which had been alternating with writes after
the new transfer proceses were implemented) again jumped to between 13,000
and 24,000.  This time I used a stopwatch, and the halt was 18 minutes 21
seconds - I believe the longest ever.  There is absolutely no way it would
take a drive almost 20 minutes to mark a block bad.  The dirty blocks grew
to more than 78 Megabytes.  I just did a 3rd cp of the /etc/hosts file to
the array, and once again it locked the machine for what is likely to be
another 15 - 20 minutes.  I tried forcing a sync, but it also hung.

<Sigh>  The next three days are going to be Hell, again.  It's going to be
all but impossible to edit a file until the RAID resync completes.  It's
often really bad under ordinary loads, but when the resync is underway, it's
beyond absurd.

