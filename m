From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID halting
Date: Sun, 5 Apr 2009 21:39:14 +0100
Message-ID: <18905.5874.850528.576631@tree.ty.sabi.co.uk>
References: <20090405185421.RJPR28081.cdptpa-omta04.mail.rr.com@Leslie>
	<49D903BA.8000000@anonymous.org.uk>
	<87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370904051300x531acb1fqb55319536333c01f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>>>>> The problem started immediately the last time I rebuilt
>>>>> the array and formatted it as Reiserfs, after moving the
>>>>> drives out of the old RAID chassis.

>>>> What file system were you using before ReiserFS?

>>> Several, actually. =A0Since the RAID array kept crashing, I
>>> had to re-create it numerous times.

>>>> your culprit is higher up the chain, ie the FS.

>>> I've suspected this may be the case from the outset.

>> I'm sorry? You've repeatedly had trouble with this system,
>> this array, you've tried several filesystems; do you think
>> they're *ALL* broken?

> I for one think it is very reasonable that Leslie may have
> experienced numerous different problems in the course of
> trying to put together a large scale raid system for video
> editing.

> But Leslie, maybe you do need to take a step back and review
> your overall design and see what major changes you could make
> that might help.

Very wise words. Because what the O.P. is trying to do is system
integration on a medium-large scale, and yet expects all the
bits (sw and hw) to snap together. While as you demonstrate to
know system integration means finding the few combinations of
sw/hw/fw that actually work, and work together.

Too many of the messages to this list are by people who have a
"syntactic" approach to systems integration (if the "syntax" is
formally valid, it ought to work...).

> I'm not really keeping up with things like video editing, but
> as someone else said XFS was specifically designed for that
> type of workload.

JFS not too bad either, and it is fairly robust too.

> You could also evaluate the different i/o elevators.

That's more about performance than reliability. Anyhow as to
performance many elevators have peculiar performance profiles
(as you report later for CFQ) and never mind their interaction
with insane "features" like plugging/unplugging in the block
layer. From many tests that I have seen, 'noop' should be the
default in most situations.

> If I were designing a system like you have for myself, I would
> get one of the major supported server distros.

That in my experience does not matter a lot, but it should be
tried. On one hand their kernels are usually quite a bit behind
the state of the hw, on the other their kernels tend to have
lots of useful bug fixes. On balance I am not sure which is more
important. However I like the API stability of major distributions.

> FYI: Some of the major problems going in the last year that
> make me willing to believe someone is having lots of unrelated
> issues in trying to build a system like Leslie's.

All these problems that you list below are typical of system
integration with lots of moving parts :-). Experiences teaches
people like you and me that to expect them. And there are people
at large scale sites that write up about them, for example:

  https://indico.desy.de/contributionDisplay.py?contribId=3D65&sessionI=
d=3D42&confId=3D257

> Reiser's main maintainer is in jail, recent versions of
> OpenSUSE croak if reiser is in use because they exercise code
> paths with serious bugs. (google "beagle opensuse reiser")

That the maintainer is in trouble is not so important; but
ReiserFS has indeed some bugs mostly because it is a bit
complicated.

> [ ... ] The latest Linus kernel has a lot ext3 patches in it
> that reduce the horrible latency to merely unacceptable.
> Linus and Ted Tso are now thinking the remaining problems are
> with the CFQ elevator. [ ... ]

I strongly suspect the block layer, which seems to do quite a
few misguided "optimizations" (even if not quite as awful as
some aspects of the VM subsystem).

> Seagate drives have been having major firmware issues for
> about a year.

That's the .11 series, but WD have had problems in the recent
past, and so have had other manufacturers. With ever increasing
fw complexity come many risks...

> Ext4 is claimed "production" but is getting major corruption
> bugzillas (and associated patches) weekly. [ ... ]

That is mostly however IIRC because of the ancient delayed write
feature and the fact that "userspace sucks", that is does not
use 'fsync'.

> Tejun Heo is the core eSata developer and he says not to trust
> any eSata cable a meter or longer. [ ... ]

Longer ATA/80 wire cables also have had problems for a long
time. Longer SATA and eSATA cables also problematic. But SAS
"splitter" cables seem to be usually pretty well shielded.

> Lot of reported problems turn out to be power supplies not
> designed to carry a Sata load.  Apparently sata drives are
> very demanding and many "good" power supplies don't cut the
> mustard.

That probably does not have much to do with SATA drives. It is
more like a combination of factors:

  * Many power supplies are poorly designed or built.

  * Modern hard disks draw a high peak current on startup, and
    many people do not realize that PSU rails have different
    power ratings, and do not stagger power up of many drives.

  * Cooling is often underestimated, with overheating of power
    and other components, especially in dense configurations.

Some of my recommendations:

* Use as simple a setup as you can. RAID10, no LVM, well tested
  file systems like JFS or XFS (or Lustre for extreme cases).

* Only use not-latest components that are reported to work well
  with the vintage of sw that you are using, and do extensive
  web searching as to which vintages of hw/fw/sw seem to work
  well together.

* Oversize by a good margin the power supplies and the cooling
  system, stagger drive startup, and monitor the voltages and
  the temperatures.

* Use disks of many different manufacturers in the same array.

* Run period tests against silent corruption.

The results can be rewarding; I have setup without too much
effort storage systems that deliver several hundred MB/s over
NFS, and a few GB/s over Lustre are also possible (but that
needs more careful thinking).

An example of a recent setup that worked pretty well: Dell
2900/2950 server, PERC 6s (not my favourites though), 2 Dell
MD1000 arrays, 30 750GB drives configured as 3 MD (sw) RAID10
arrays with a few spares, RHEL5/CentOS5, 10Gb/s Myri card.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
