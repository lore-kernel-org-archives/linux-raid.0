From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: very strange raid10,f2 performance
Date: Sat, 1 May 2010 20:40:59 -0500
Message-ID: <r2wcccedfc61005011840u26c6814cg7f317f5e710893ef@mail.gmail.com>
References: <k2mcccedfc61004211002p24f1bd21xdead3e501766553f@mail.gmail.com>
	<20100430224642.GB7127@rap.rap.dk> <n2lcccedfc61004301835ofb5285b2g4e73a5181a0d6f77@mail.gmail.com>
	<20100501083608.GA28178@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100501083608.GA28178@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, May 1, 2010 at 3:36 AM, Keld Simonsen <keld@keldix.com> wrote:
> On Fri, Apr 30, 2010 at 08:35:50PM -0500, Jon Nelson wrote:
>> On Fri, Apr 30, 2010 at 5:46 PM, Keld Simonsen <keld@keldix.com> wro=
te:
>> > On Wed, Apr 21, 2010 at 12:02:46PM -0500, Jon Nelson wrote:
>> >> I was helping somebody else diagnose some issues, and decided to =
run
>> >> comparitive tests on my own raid (raid10,f2).
>> >>
>> >> The raid10,f2 (md0) is the only physical device backing a volume
>> >> group, which is then carved into a bunch of (primarily) ext4
>> >> filesystems.
>> >> The kernel is 2.6.31.12 (openSUSE) on a Quad Processor AMD Phenom=
 9150e system.
>> >> The raid is two Western Digital Caviar Blue drives (WDC WD5000AAK=
S-00V1A0).
>> >>
>> >> The problem: really, really bad I/O performance under certain cir=
cumstances.
>> >>
>> >> When using an internal bitmap and *synchronous* I/O, applications=
 like
>> >> dd report 700-800 kB/s.
>> >> When not using a bitmap at all, and synchronous I/O, dd reports 2=
=2E5
>> >> MB/s (but dstat shows 14MB/s?)
>> >> Without a bitmap and async I/O (but with fdatasync) I get 65MB/s.
>> >> *With* a bitmap and using async. I/O (but with fdatasync) I get m=
ore
>> >> like 65MB/s.
>> >>
>> >> The system has 3GB of memory and I'm testing with dd if=3D/dev/ze=
ro
>> >> of=3Dsomefile bs=3D4k count=3D524288.
>> >>
>> >> I'm trying to understand why the synchronous I/O is so bad, but e=
ven
>> >> so I was hoping for more. 65MB/s seems *reasonable* given the
>> >> raid10,f2 configuration and all of the seeking that such a
>> >> configuration involves (when writing).
>> >>
>> >> The other very strange thing is that the I/O patterns seem very
>> >> strange. I'll see 14MB/s very consistently as reported by dstat
>> >> (14MB/s for each sda, sdb, and md0) for 10-15 seconds and then I'=
ll
>> >> see it drop, sometimes to just 3 or 4 MB/s, for another 10 second=
s,
>> >> and then the pattern repeats. =A0What's going on here? With absol=
utely
>> >> no other load on the system, I would have expected to see somethi=
ng
>> >> much more consistent.
>> >
>> > Hmm, not much response to this.
>> > The only idea I have for now is misalignment between raid and LVM =
boundaries.
>>
>> These aren't 4K disks (as far as I know), so I'm not sure what you
>> mean by alignment issues.
>> Using 255 heads, 63 sectors per track:
>>
>> /dev/sda1 starts on sector 63 and ends on sector 7807589
>> /dev/sda2 starts on sector 11711385 and ends on sector 482528340
>
> I dont know much about this, and I have not tested it, but try to
> make LVM and raid on sector numbers divisionable by the raid block si=
ze.
>
>> /dev/sdb is partitioned the same
>> /dev/sda2 and /dev/sdb2 form the raid10,f2.
>>
>> > Were your dd's done on the raw devices, or via a file system?

Raw devices (actually, /dev/raid/test).

>> Raw (logical) devices carved out of the volume group.

I completely re-did the raid. Now both devices are partitioned thusly:

/dev/sda1   *          63     9960299     4980118+  fd  Linux raid auto=
detect
/dev/sda2         9960300   976768064   483403882+  fd  Linux raid auto=
detect

The raid is using a 1MiB chunk size, metadata 1.0, and I noted that
the physical volume I created was created with also a 1MB data
alignment.  As far as I know, this should all be aligned properly, but
I'm not really sure what I am doing with the partition alignment.

No matter how bad the alignment, however, 6.1MB/s synchronous writes
is super bad.

Your test using 'cat' is, IMO, totally invalid as it is neither
synchronous nor does it make use of fdatasync. I'm not looking to get
into benchmarking here, however -- I just want to understand _why_ the
performance is _so_ bad.  'dstat' reports 15MB/s (as consistent as the
day is long) output to /dev/sda2, /dev/sdb2, and /dev/md2.  Writing to
an ext4 filesystem (with synchronous I/O) I get *1.9* MiB/s.  When
doing I/O that is non-synchronous, but still using fdatasync, I get
I/O rates that I would expect -- 96MiB/s.

When I use a block size of 1MiB and write synchronously, I see rates
more like 45 MiB/s.

I'm also rather surprised to see *read* rates that (per disk) are more
like 60MB/s. I thought the point of raid10,f2 is to produce reads from
the outermost portions of the disk. When I read from /dev/sda or
/dev/sdb I get more like 130MiB/s (decreasing slowly as I get closer
to the inner tracks).

So I've verified the disks perform as expected but logical volumes
carved from a volume group backed by the raid do not.  So I decide to
check read speeds from the raid itself.  After dropping caches, I
average about 220MiB/s reading from /dev/md2.  I feel, therefore, that
the problem is LVM, but how?

Summary:

1. /dev/sd{a,b} both perform great (read speeds of 110MiB/s)
2. /dev/md2 (a raid10,f2 made from /dev/sda2 and /dev/sdb2) has great
*read* speeds.  I can't check the write speeds as /dev/md2 is used as
the backing store for a volume group.
3. logical volumes carved from the volume group have _ok_ performance
in async. I/O (with fdatasync), but synchronous I/O is _really_ bad.
Read speeds are also not nearly as good as they could be.

I feel as though I've gathered sufficient evidence that the problem
isn't the raid code or the disk but LVM.  Where do I go from here?




--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
