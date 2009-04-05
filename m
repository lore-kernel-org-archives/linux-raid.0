From: "David Lethe" <david@santools.com>
Subject: FW: RAID halting
Date: Sun, 5 Apr 2009 09:22:38 -0500
Message-ID: <F2C688D6A021E34CB81C0E631EF4C093017FF4E0@34093-C4-EVS1.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Lelsie Rhorer
Sent: Sunday, April 05, 2009 3:14 AM
To: linux-raid@vger.kernel.org
Subject: RE: RAID halting

> All of what you report is still consistent with delays caused by
having
> to remap bad blocks

I disagree.  If it happened with some frequency during ordinary reads,
then
I would agree.  If it happened without respect to the volume of reads
and
writes on the system, then I would be less inclined to disagree.

> The O/S will not report recovered errors, as this gets done internally
> by the disk drive, and the O/S never learns about it. (Queue depth

SMART is supposed to report this, and rarely the kernel log does report
a
block of sectors being marked bad by the controller.  I cannot speak to
the
notion SMART's reporting of relocated sectors and failed relocations may
not
be accurate, as I have no means to verify.

Actually, I should amend the first sentence, because while the ten
drives in
the array are almost never reporting any errors, there is another drive
in
the chassis which is chunking out error reports like a farm boy spitting
out
watermelon seeds.  I had a 320G drive in another system which was
behaving
erratically, so I moved it to the array chassis on this machine to
eliminate
it being a cable or the drive controller.  It's reporting blocks being
marked bad all over the place.

> Really, if this was my system I would run non-destructive read tests
on
> all blocks;

How does one do this?  Or rather, isn't this what the monthly mdadm
resync
does?

> along with the embedded self-test on the disk.  It is often

How does one do this?

> a lot easier and more productive to eliminate what ISN'T the problem
> rather than chase all of the potential reasons for the problem.

I agree, which is why I am asking for troubleshooting methods and
utilities.

The monthly RAID array resync started a few minutes ago, and it is
providing
some interesting results.  The number of blocks read / second is
consistently 13,000 - 24,000 on all ten drives.  There were no other
drive
accesses of any sort at the time, so the number of blocks written was
flat
zero on all drives in the array.  I copied the /etc/hosts file to the
RAID
array, and instantly the file system locked, but the array resync *DID
NOT*.
The number of blocks read and written per second continued to range from
13,000 to 24,000 blocks/second, with no apparent halt or slow-down at
all,
not even for one second.  So if it's a drive error, why are file system
reads halted almost completely, and writes halted altogether, yet drive
reads at the RAID array level continue unabated at an aggregate of more
than
130,000 blocks - 240,000 blocks (500 - 940 megabits) per second?  I
tried a
second copy and again the file system accesses to the drives halted
altogether.  The block reads (which had been alternating with writes
after
the new transfer proceses were implemented) again jumped to between
13,000
and 24,000.  This time I used a stopwatch, and the halt was 18 minutes
21
seconds - I believe the longest ever.  There is absolutely no way it
would
take a drive almost 20 minutes to mark a block bad.  The dirty blocks
grew
to more than 78 Megabytes.  I just did a 3rd cp of the /etc/hosts file
to
the array, and once again it locked the machine for what is likely to be
another 15 - 20 minutes.  I tried forcing a sync, but it also hung.

<Sigh>  The next three days are going to be Hell, again.  It's going to
be
all but impossible to edit a file until the RAID resync completes.  It's
often really bad under ordinary loads, but when the resync is underway,
it's
beyond absurd.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
======
Leslie: 
Respectfully, your statement, "SMART is supposed to report this" shows
you have no understanding of exactly what S.M.A.R.T. is and is not
supposed to report, nor do you know enough about hardware to make an
educated decision about what can and can not be contributing factors.
As such, you are not qualified to dismiss the necessity to run hardware
diagnostics.

A few other things - many SATA controller cards use poorly architected
bridge chips that spoof some of the ATA commands, so even if you *think*
you are kicking off one of the SMART subcommands, like the
SMART_IMMEDIATE_OFFLINE (op code d4h with the extended self test,
subcommand 2h), then it is possible, perhaps probable, they are never
getting run. -- yes, I am giving you the raw opcodes so you can look
them up and learn what they do.

You want to know how it is possible that frequency or size of reads can
be a factor? 
Do the math:
 * Look at the # of ECC bits you have on the disks (read the specs), and
compare that with the trillions of bytes you have.  How frequently can
you expect to have an unrecoverable ECC error based on that.
 * What percentage of your farm are you actually testing with the tests
you have run so far? Is it even close to being statistically
significant?
 * Do you know what physical blocks on each disk are being read/written
with the tests you mention? If you do not know, then how do you know
that the short tests are doing I/O on blocks that need to be repaired,
and subsequent tests run OK because those blocks were just repaired?
 * Did you look into firmware? Are the drives and/or firmware revisions
qualified by your controller vendor?  

I've been in the storage business for over 10 years, writing everything
from RAID firmware, configurators, disk diagnostics, test bench suites.
I even have my own company that writes storage diagnostics.  I think I
know a little more about diagnostics and what can and can not happen.
You said before that you do not agree with my statements earlier.  I
doubt that you will find any experienced storage professional that
wouldn't tell you to break it all down and run a full block-level DVT
before going further.  It could have all been done over the week-end if
you had the right setup, and then you would know a lot more than what
you know now.  

AT this point all you have done is tell people who suggest hardware is
the cause that they are wrong and then tell us why you think we are
wrong.  Frankly, be lazy and don't run diagnostics, you had just better
not be a government employee, or in charge of a database that contains
financial, medical, or other such information, and you have better be
running hot backups.

If you still refuse to run full block-level hardware test, then ask
yourself how much longer will you allow this to go on before you run
such a test, or are you just going to continue down this path waiting
for somebody to give you a magic command to type in that will fix
everything.

I am not the one who is putting my job on the line at best, and at
worst, is looking at a criminal violation for not taking appropriate
actions to protect certain data. I make no apology for beating you up on
this.  You need to hear it.



