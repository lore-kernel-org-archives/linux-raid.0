From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Mon, 03 Jan 2005 15:11:03 +0300
Message-ID: <41D93657.7090908@tls.msk.ru>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es> <20050102194240.GE99565@caffreys.strugglers.net> <5h1ma2-asq.ln1@news.it.uc3m.es> <20050103003005.GG99565@caffreys.strugglers.net> <2rana2-0if.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2rana2-0if.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
[]
>>Let's focus on the personal machine of mine for now since it uses
>>Linux software RAID and therefore on-topic here.  It has /boot on a
>>small RAID-1,
> 
> This is always a VERY bad idea. /boot and /root want to be on as simple
> and uncomplicated a system as possible. Moreover, they never change, so
> what is the point of having a real time mirror for them? It would be
> sufficient to copy them every day (which is what I do) at file system
> level to another partition, if you want a spare copy for emergencies.

Raid1 (mirror) is the most "trivial" raid level out there, especially
having in mind that the underlying devices -- all of them -- contains
(or should, in theory -- modulo the "50% chance of any difference
being unnoticied" etc) exact copy of the filesystem.  Also, root (and
/boot -- i for one have both /boot in root in a single small filesystem)
do change -- not that often but often enouth so that "newaliases problem"
(when you "forgot" to backup it after a change) happens from time to time.

After several years of expirience with alot of systems (and alot of various
disk failure scenarios too: when you have many systems, you have good
chances to see a failure ;), I now use very simple and (so far) reliable
approach, which I explained here on this list before.  You have several
(we use 2, 3 or 4) disks which are the same (or almost: eg some 36Gb
disks are really 35Gb or 37Gb; in case they're differ, "extra" space
on large disk isn't used); root and /boot are on small raid1 partition
which is mirrored on *every* disk; swap is on raid1; the rest (/usr,
/home, /var etc) are on raid5 arrays (maybe also raid0 for some "scratch"
space).  This way, you have "equal" drives, and *any* drive, including
boot one, may fail at any time and the system will continue working
as if all where working, including reboot (except of a (very rare in
fact) failure scenario when your boot disk has failed MBR or other
sectors required to boot, but "the rest" of that disk is working,
in which case you'll need physical presence to bring the machine up).
All the drives are "symmetrical", usage patterns for all drives are
the same, and due to usage of raid arrays, load is spread among them
quite nicely.  You're free to reorder the drives in any way you want,
to replace any of them (maybe rearranging the rest if you're
replacing the boot drive) and so on.

Yes, root fs does not changes often, and yes it is small enouth
(I use 1Gb, or 512Mb, or even 256Mb for root fs - not a big deal
to allocate that space on every of 2 or 3 or 4 or 5 disks).  So
it isn't quite relevant how fast the filesystem will be on writes,
and hence it's ok to place it on raid1 composed from 5 components.
The stuff just works, it is very simple to administer/support,
and does all the "backups" automatically.  In case of some problem
(yes I dislike any additional layers for critical system components
as any layer may fail to start during boot etc), you can easily
bring the system up by booting off the underlying root-raid partiton
to repair the system -- all the utilities are here.  More, you can
boot from one disk (without raid) and try to repair root fs on
another drive (if things are really screwed up), and when you're
done, bring the raid up on that repaired partition and add other
drives to the array.

To summarize: having /boot and root on raid1 is a very *good* idea. ;)
It saved our data alot of times in the past few years already.

If you're worried about "silent data corruption" due to different
data being read from different components of the raid array.. Well,
first of all, we never saw that yet (we have quite good "testcase")
(and no, I'm not saying it's impossible ofcourse).  On rarely-changed
filesystem, with real drives which does no silent remapping of an
undeadable blocks to new place with the data on them becoming all-0s,
without drives with uncontrollable write caching (quite common for
IDE drives) and things like that, and with real memory (ECC I mean),
where you *know* what you're writing to each disk (yes, there's also
another possible cause of a problem: software errors aka bugs ;),
that case with different data on different drives becomes quite..
rare.  In order to be really sure, one can mount -o remount,ro /
and just compare all components of the root raid, periodically.
When there's more than 2 components on that array, it should be
easy to determine which drive is "lying" in case of any difference.
I do similar procedure on my systems during boot.

>>There is nowhere that is not software RAID to put the journals, so
> 
> Well, you can make somewhere. You only require an 8MB (one cylinder)
> partition.

Note scsi disks in linux only supports up to 14 partitions, which
isn't sometimes sufficient even without additional partitions for
journal.  When you have large amount of disks (so having that
"fully-symmetrical" layout as I described above becomes impractical),
you can use one set of drives for data and another set of drives
for journal for that data.  When you only have 4 (or less) drives...

And yes I'm aware of mdp devices (partitions inside the raid
arrays).. but that's just another layer "which may fail": if
raid5 array won't start, I at least can reconstruct filesystem
image by reading chunks of data from appropriate places from
all drives and try to recover that image; with any additional
structure inside the array (and the lack of "loopP" aka partitioned
loop devices) it becomes more and more tricky to recover any
data (from this point of view, raid1 is the niciest raid level ;)

Again: instead of using a partition for the journal, use (another?)
raid array.  This way, the system will work if the drive wich
contains the journal fails.  Note above about swap: in all my
systems, swap is also on raid (raid1 in this case).  At the first
look, that can be a nonsense: having swap on raid.  But we had
enouth cases when due to a failed drive swap becomes corrupt
(unreadable really), and the system goes havoc, *damaging*
other data which was unaffected by the disk failure!  With
swap on raid1, the system continues working if any drive
fails, which is good.  (Older kernels, esp. 2.2.* series,
had several probs with swap on raid, but that has been fixed
now; there where other bugs fixed too (incl. bugs in ext3fs)
so there should be no such damage to other data due to
unreadable swap.. hopefully.  But I can't trust my systems
anymore after seeing (2 times in 4 years) what can happen with
the data...)

[]

And I also want to "re-reply" to the first your message in this
thread, where I was saying that "it's a nonsense that raid does
not preserve write ordering".  Ofcourse I mean not write ordering
but working write barriers (as Neil pointed out, md subsystem does
not implement write barriers directly but the concept is "emulated"
by linux block subsystem).  Write barriers should be sufficient to
implement journalling safely.

/mjt
