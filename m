From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Tue, 04 Jan 2005 00:36:49 +0300
Message-ID: <41D9BAF1.10307@tls.msk.ru>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es> <20050102194240.GE99565@caffreys.strugglers.net> <5h1ma2-asq.ln1@news.it.uc3m.es> <20050103003005.GG99565@caffreys.strugglers.net> <2rana2-0if.ln1@news.it.uc3m.es> <41D93657.7090908@tls.msk.ru> <a41oa2-fr7.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a41oa2-fr7.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>>Peter T. Breuer wrote:
>>
>>>This is always a VERY bad idea. /boot and /root want to be on as simple
>>>and uncomplicated a system as possible....
[]
> Well, my experience is that anything "unusual" is bad:  sysadmins change
> over the years;  the guy who services the system may not be the one that
> built it;  the "rescue" cd or floppy he has may not have MD support
> built into the kernel (and he probably will need a rescue cd just to get
> support for a raid card, if the machine has hardware raid as well as or
> instead of software raid).

It is trivial to learn (or teach) that you can boot with root=/dev/sda1
instead of root=/dev/md1.  All our technicians knows that.  Indeed, most
will not be able to recover the system in most cases anyway IF root raid
will not start "by its own", but that's a different matter entirely.

Sometimes it may be a trivial case (like we had just a few months ago:
I asked our guy to go to the remote office to replace a drive and gave
him a replacement, which contained raid component in the first partition..
and "stupid boot code" (Mine!.. sort of ;) descided to bring THAT array
instead of the real raid array on original disks because the event
counter was greather.  So we ended up booting with
   root=/dev/sda1 ro init=/bin/sh
and just zeroing the partition in the new drive.. which I simple forgot
to do in the first place.  All by phone, it took about 5 minutes to
complete the whole task and bring the server up after the reboot that
he performed when went there.. total downtime was about 15 minutes.
After which, I logged into the system remotely, verified data integrity
of existing arrays and added the new disk to all the arrays -- while
the system was in production (just a bit slow) and our guy was having
some tea (or whatever... ;) before going back.

Having several root partitions is a good thing.  I rarely need to
tweak the boot process (that to say: it rarely fails, except of
several stupid cases like the above;  And when it fails, it is
even possible to bring the system up while on phone with any non-
technicial "monkey" from their remote office who don't even know
latin letters (we're in russia so english isn't our native language;
when describing what to do I sometimes tell to press "cyrillic"
keys on the keyboard to produce latin characters... ;)

And yes, any bug that "crashes" this damn root system will mess
with the whole thing, with all mirrors.. which is a fatal error,
so to say.  Well.. if you can't trust the processor for example
to correctly multiple 2*2 and want to use two (or more) processors
just to be sure one isn't lying.. such systems do exists too, but
hey, they aren't cheap at all... ;)

> Therefore, I have learned not to build a system that is more complicated
> than the most simple human being that may administer it. This always
> works - if it breaks AND they cannot fix it, then THEY get the blame.

Perhaps our conditions are a bit different.. who kows.
Raid1 IS simple -- both in implementation and in usage.
Our guys are trained very hard to ensure they will NOT try to mess things
up unless they're absolutely sure what they're doing.  And I don't care
who to blame (me or my technicians or whatever): we all will lose money
in case of serious problems (we're managing networks/servers for $customers,
they're paying us for the system to work with at most one business day
downtime in case of any problem, with all their data intact -- we're
speaking of remote locations here)... etc.. ;)

If you don't trust your guys to do right (or to ask and *understand*
when they don't know), or if your guys are doing mistakes all over --
perhaps it's a time to hire them off? ;)

> And let's not get into what they can do to the labelling on the
> partition types - FD? Must be a mistake!

BTW, letting the kernel to start arrays is somewhat.. wrong (i mean the
auto-detection and that "FD" type).  Again, I learned it the hard way ;)
The best is to have initrd and pass GUUID of your raid array into it
(this is what I *don't* do currently ;)

[]
> Well, whenever I buy anything, I buy two. I buy two _controller_ cards,
> and tape the extra one inside the case. But of course I buy two
> machines, so that is four cards ... .

Oh well... that all depends on the amount of $money.  We have several
"double-machines" too here, but only several.  The rest of systems
are single, with a single (usually onboard) scsi controller.

> And I betcha softraid sb has changed format ver the years. I am still
> running P100s!

It isn't difficult to re-create the arrays, even remotely (if you're
accurate enouth ofcourse).  Not that it is needed too often either... ;)

>>disks are really 35Gb or 37Gb; in case they're differ, "extra" space
>>on large disk isn't used); root and /boot are on small raid1 partition
>>which is mirrored on *every* disk; swap is on raid1; the rest (/usr,
> 
> I like this - except of course that I rsync them, not raid them. I
> don't mind if I have to reboot a server. Nobody will notice the tcp
> outage and the other one of the pair will failover for it, albeit in
> readonly mode, for the maximum of the few minutes required.

Depends alot of your usage patterns, or tasks running, or other
conditions (esp. physical presense).  I for one can't afford
rebooting many of them at all, for a very simple reason: many
of them are on a very bad dialups, and some are several 100s KMs
(or miles for that matter) away... ;)  And also most of the
boxes are running oracle with quite complex business rules,
they're calculating some reports which sometimes takes quite
some time to complete, esp at the end of the year.

For this very reason -- they're all quite far away from me,
out of reach -- I tend to ensure they WILL boot and will
be able to dial out and bring that damn tunnel so I can
log in and repair whatever is needed... ;)

> Your swap idea is crazy, but crazy enough to be useful. YES, there used
> to be a swap bug which corrupted swap every so often (in 2.0? 2.2?) and
> meant one had to swapoff and swapon again, having first cleared all
> processes by an init 1 and back. Obviously that bug would bite whatever
> you had as media, but it still is a nice idea to have raided memory
> :-).

It sounds crazy at the first look, I wrote just that.  But it
helps to ensure the system is running as if nothing happened.
I just receive email telling me node X has one array degraded,
I log in there remotely, diagnose the problem and do whatever
is needed (remapping the bad block, or arranging to send a guy
there with a replacement drive when there will be such a chance..
whatever).  The system continues working just fine for all that
time (UNLESS another drive fails too ofcourse -- all the raid5
arrays will be dead and "urgent help" will be needed in that
case -- at *that* time only it will be possible to reboot as
many times as needed).

The key point with my setup is that the system will continue
working in case of any single drive failure.  If I need more
protection, I'll use raid6 or raid10 (or raid1 on several
drives, whatever) so the system will continue working in case
of multiple drive failures.  But it will still be running,
giving me a time/chance to diagnose the prob and find good
schedule for our guys to come and fix things if needed --
maybe "right now", maybe "next week" or even "next month",
depending on the exact problem.

>>/home, /var etc) are on raid5 arrays (maybe also raid0 for some "scratch"
> 
> I don't put /var on raid if I can help it. But there is nothing
> particularly bad about it. It is just that /var is the most active
> place and therefore the most likely to suffer damage of some kind, somehow.
> And damaged raided partitions are really not nice. Raid does not
> protect you against hardware corruption - on the contrary, it makes it
> more difficult to spot and doubles the probabilities of it happening.

Heh.. In our case, the most active (and largest) filesystem is /oracle ;)
And yes I know using raid5 for a database isn't quite a good idea..
but that's entirely different topic (and nowadays, when raid5 checksumming
is very cheap in terms of cpu, maybe it isn't that bad anymore ;)

Yes raid5 is complex beast compared to raid1.  Yes, raid5 may not be
appropriate for some workloads.  And still -- yes, this all is about
a compromise in money one have and what he can afford to lose and
for what duration, and how much (money again, but in this our case
that'll be our money, not $client money) one can spend to fix the
problem IF it will need to be fixed the "hard way" (so far we have
two cases which required restoration the hard way, one was because
$client used cheap hardware instead of our recommendations and
non-ECC memory failed -- in that case, according to contract, it
was $client who paid for the restore; and second was due to
software error (oracle bug, now fixed), but we had "remote backup"
of the database (it's a large distributed system and the data is
replicated among several nodes), so I exported the "backup" and
just re-initialized their database.  And yes, we simulated various
recovery scenarios in our own office on a toy data, to be sure
we will be able to recover the thing the "hard way" if that'll
be needed).

>>space).  This way, you have "equal" drives, and *any* drive, including
>>boot one, may fail at any time and the system will continue working
>>as if all where working, including reboot (except of a (very rare in
>>fact) failure scenario when your boot disk has failed MBR or other
>>sectors required to boot, but "the rest" of that disk is working,
>>in which case you'll need physical presence to bring the machine up).
> 
> That's actually not so. Over new year I accidently booted my home
> server (222 days uptime!) and discovered its boot sector had evaporated.

Uh-oh.  So just replace the first and second (or third, 4th) disks
and boot from that... ;)  Yes that can happen -- after all, lilo may
have a bug, or a bios, or mbr code...  But that's again about whenever
you can afford to "trust the processor", above.  Yes again, there are
humans which tend to make mistakes (I made alot of mistakes in my
life, oh, alot of them!, once I even formatted the "wrong disk" and
lost half a year of our work.. and started doing some backups finally ;).
I don't think there's anything that can protect against human mistakes --
I mean humans who manage the system, not who use it.

> Well, maybe I moved the kernels ..  anyway, it has no floppy and the
> nearest boot cd was an hour's journey away in the cold, on new year.  Uh
> uh.  It took me about 8 hrs, but I booted it via PXE DHCP TFTP
> wake-on-lan and the wireless network, from my laptop, without leaving
> the warm.

Heh.
Well, I always have bootable cd or a floppy, just in case.  Not to say
I really used that at least once (but I do know it contains all tools
needed for boot and recovery).  Yes, shit happens (tm) too... ;)

>>All the drives are "symmetrical", usage patterns for all drives are
>>the same, and due to usage of raid arrays, load is spread among them
>>quite nicely.  You're free to reorder the drives in any way you want,
>>to replace any of them (maybe rearranging the rest if you're
>>replacing the boot drive) and so on.
> 
> You can do this hot? How? Oh, you must mean at reboot.

Yes -- here I was speaking about the "worst case", when boot fails
for whatever reason.  I never needed the "boot floppy" just because
of this: I can make any drive bootable just by changing the SCSI IDs,
and the system will not notice anything changed (it will in fact:
somewhere in dmesg you'll find "device xx was yy before" message
from md, that's basically all).  99% of the systems we manage don't
have hot-swap drives, so in case a drive have to be replaced, reboot
is needed anyway.  The nice thing is that I don't care which drive
is being replaced (except of the boot one -- in that case our guys
knows they have to set up another - any - drive as bootable), and
when system boots, I just do
   for f in 1 2 3 5 6 7 8 9; do
     mdadm --add /dev/md$f /dev/sdX$f
   done
(note the device numbering too: mdN is built of sd[abc..]N)
and be done with that (not really *that* simple, I prefer to
verify integrity of other drives before adding the new one,
but that's just details).

>>Yes, root fs does not changes often, and yes it is small enouth
>>(I use 1Gb, or 512Mb, or even 256Mb for root fs - not a big deal
> 
> Mine are always under 256MB, but I give 512MB.
> 
>>to allocate that space on every of 2 or 3 or 4 or 5 disks).  So
>>it isn't quite relevant how fast the filesystem will be on writes,
>>and hence it's ok to place it on raid1 composed from 5 components.
> 
> That is, uh, paranoid.

The point isn't about paranoia, it's about simplicitly.  Or symmetry,
which leads to that same simplicity again.  They're all the same and
can be used interchangeable, period.  For larger amount of disks,
such a layout may be not as practical, but it should work find with
up to, say, 6 disks (but I'm somewhat afraid to use raid5 with 6
components, as the chance to have two failed drives, which is "fatal"
for raid5, increases).

>>The stuff just works, it is very simple to administer/support,
>>and does all the "backups" automatically. 
> 
> Except that  it doesn't - backups are not raid images. Backups are
> snapshots. Maybe you mean that.

"Live" backups ;)... with all the human errors on them too.
Raid1 can't manage snapshots.

>>In case of some problem
>>(yes I dislike any additional layers for critical system components
>>as any layer may fail to start during boot etc), you can easily
>>bring the system up by booting off the underlying root-raid partiton
>>to repair the system -- all the utilities are here.  More, you can
[]
>>boot from one disk (without raid) and try to repair root fs on
>>another drive (if things are really screwed up), and when you're
>>done, bring the raid up on that repaired partition and add other
>>drives to the array.
> 
> But why bother? If you didn't have raid there on root you wouldn't
> need to repair it.

See above for a (silly) example -- wrong replacement disk ;)
And indeed that's silly example.  I once had another "test case"
to deal with, when my root raid was composed of 3 components
and each had different event counter, for whatever reason (I
don't remember the details already) -- raid1 was refusing to
start.  It was with 2.2.something kernel -- things changed
since that time alot, but the "testcase" still was here
(it happened on our test machine in office).

> Nothing is quite as horrible as having a
> fubarred root partition.  That's why I also always have two! But I
> don't see that having the copy made by raid rather than rsync wins
> you anything in the situaton where you have to  reboot - rather, it
> puts off that moment to a moment of your choosing, which may be good, 
> but is not an unqualified bonus, given the cons.

It helps keeping the machine running *and* bootable even after
losing the boot drive (for some reason our drives fails completely
most of the time, instead of developing bad sectors; so next reboot
(our remote offices have somewhat unstable power and gets rebooted
from time to time) will be from the 2nd drive...).  It saves you
from the "newaliases" problem ("forgot to rsync" maybe silly, but
even after a small change, remembering/repeating it after the recovery
again (if the crash happened before rsync but after the change) --
I'm lazy ;)  Yes this technique places more "load" on the administrator,
because every his mistake gets mirrored automatically and immediately...

There was a funny case with another box I installed for myself.
It's in NY, USA (I'm in Russia, remember?), and there's noone
at the colo facility who knows linux well enouth, and the box
in question has no serial console (esp bios support).  After
installing the system (there was some quick-n-dirty linux
"preinstalled" by the colo guys -- thanks god they created
two partitions (2nd one was swap), -- I loaded another distro
to the swap partition, rebooted and re-partitioned the rest
moving /var etc into real place... Fun by itself, but that's
not the point.  After successeful install, "in a hurry", I
did some equivalent of... rm -rf /* !  Just a typo, but WHAT
typo! ;)

I was doing all that from home over a dialup.  I hit Ctrl-C
when it wiped out /boot, /bin (mknod! chmod! cat!), /etc, /dev,
and started removing /home (which was quite large).  Damn fast
system!.. ;)  I had only one ssh window opened...

With the help from uudecode (wich is in /usr/bin) and alot of
cut-n-pasteing, I was able to create basic utilities on that
system -- took them from asmutils site.  Restored /dev somehow,
cut-n-pasted small wget, and slowly reinstalled the whole
system again (it's debian).  Took me 3 damn hours of a very
hard work to reinstall and configure and to ensure everything
is ok to reboot -- I had no other chance to correct any boot
mistakes, and, having in mind our bad phone lines, the whole
procedure was looking almost impossible.

I asked a friend of mine to log in before the reboot and to
check if everything looks ok and it will actually boot.  But
it just worked.  After that excersise, I was sleeping for more
than 12 hours in a row, because I was really tired.

That to say: ugh-oh, damn humans, there's nothing here to
protect the poor machines from them, they always will find
their ways to screw things up... ;)

Yes, having non-raid rsynced backup helps in that case,
and yes, such a case is damn rare...

Dunno whichever is "right".  After all, nothing stops to
have BOTH mirrored AND backed-up root filesystem... ;)

>>To summarize: having /boot and root on raid1 is a very *good* idea. ;)
>>It saved our data alot of times in the past few years already.
> 
> No - it saved you from taking the system down at that moment in time.
> You could always have rebooted it from a spare root partition whether
> you had raid there or not.

Quite a problem when the system is away from you... ;)

>>If you're worried about "silent data corruption" due to different
>>data being read from different components of the raid array.. Well,
>>first of all, we never saw that yet (we have quite good "testcase")
> 
> It's hard to see, and youhave to crash and come back up quite a lot to
> make it probable. A funky scsi cable would help you see it!

We did alot of testing by our own too.  Sure that's not cover every
possible case.  Yet all of the 200+ systems we manage are working
just fine since 1999, with no single "bad" failure so far (I already
mentioned 2 cases which aren't really count for obvious reasons).

[]
>>without drives with uncontrollable write caching (quite common for
>>IDE drives) and things like that, and with real memory (ECC I mean),
>>where you *know* what you're writing to each disk (yes, there's also
>>another possible cause of a problem: software errors aka bugs ;),
> 
> Indeed, and very frequent they are too.
> 
>>that case with different data on different drives becomes quite..
>>rare.  In order to be really sure, one can mount -o remount,ro /
>>and just compare all components of the root raid, periodically.
>>When there's more than 2 components on that array, it should be
>>easy to determine which drive is "lying" in case of any difference.
>>I do similar procedure on my systems during boot.
> 
> Well, voting is one possible procedure. I don't know if softraid does
> that anywhere, or attempts repairs.
> 
> Neil?

It does not do that.. yet.

>>>>There is nowhere that is not software RAID to put the journals, so
>>>
>>>Well, you can make somewhere. You only require an 8MB (one cylinder)
>>>partition.
>>
>>Note scsi disks in linux only supports up to 14 partitions, which
> 
> You can use lvm (device mapper). Admittedly I was thinking of IDE.

The same problem as with partitionable raid arrays, and with your
statement about simplicity: lvm layout may be quite complex and
quite difficult to repair *if* something goes really wrong.

And.. oh, no IDE please, thanks alot!.. :)

> If you like I can patch scsi for 63 partitions?

I did that once myself - patched 2.2.something to have 63 partitions
on scsi disks.  But had alot of problems with other software after
that, because some software assumes device 8,16 is sdb, and because
I always have to remember to boot the "right" kernel.

Nowadays, for me at least, things aren't that bad anymore.  I was
using (trying to anyway) raw devices with oracle instead of using
the filesystem (oracle works better that way because of no double-
caching in oracle and in the filesystem).  Now there's such a thing
as O_DIRECT which works just as good.  Still, we use 8 partitions
on most systems, and having single "journal partition" means we
will need 16 partitions which is more than linux allows.

>>[] I at least can reconstruct filesystem
>>image by reading chunks of data from appropriate places from
>>all drives and try to recover that image; with any additional
> 
> Now that is just perverse.

*If* things really goes wrong.  I managed to restore fubared
raid5 once this way, several years ago.  Not that the approach
is "practical" or "easy", but if you must and the bad has already
happened... ;)

[]
>>Again: instead of using a partition for the journal, use (another?)
>>raid array.  This way, the system will work if the drive wich
>>contains the journal fails.
> 
> But the journal will also contain corruptions if the whole system
> crashes, and is rebooted. You just spent several paragraphs (?) arguing
> so. Do you really want those rolled forward to complete? I would
> rather they were rolled back! I.e. that the journal were not there -
> I am in favour of a zero size journal, in other words, which only acts
> to guarantee atomicity of FS ops (FS code on its own may do that), but
> which does not contain data.

That's another case again.  Trust your cpu?  Trust the kernel?
If the system can go havoc for some random reason and throw your
(overwise prefectly valid) data away, there's nothing to protect
it.. except of good backup, and, ofcourse, fixing the damn bug.
And it's really irrelevant in this case whenever we have journal
at all or not.

If there IS a journal (my main reason to use it is that sometimes
ext2fs can't repair on reboot without prompting (which is about to
unacceptable to me because the system is remote and I need it to
boot and "phone home" for repair), while with ext3 we had no case
(yet) when it was unable to boot without human intervention), again,
in my "usage case", it should be safe against disk failures, ie,
the system should continue working the the drive where the journal
is gets lost or develops bad sectors.  For the same reason... ;)

>>[]
>>
>>And I also want to "re-reply" to the first your message in this
>>thread, where I was saying that "it's a nonsense that raid does
>>not preserve write ordering".  Ofcourse I mean not write ordering
>>but working write barriers (as Neil pointed out, md subsystem does
>>not implement write barriers directly but the concept is "emulated"
>>by linux block subsystem).  Write barriers should be sufficient to
>>implement journalling safely.
> 
> I am not confident that Neil did say so. I have not reexamined his
> post, but I got the impression that he hummed and hawed over that.
> I do not recall that he said that raid implements write barriers -
> perhaps he did. Anyway, I do not recall any code to handle "special"
> requests, which USED to be the kernel's barrier mechanism. Has that
> mechanism changed (it could have!)?

"Too bad" I haven't looked at the code *at all* (almost, really) ;)
I saw numerous discussions here and there, but it's difficult to
understand *that* amount of code with all the "edge cases".
I just "believe" there's some way to know the data has been written
and that it indeed has been written; and I know this is sufficient
to build a "safe" (in some sense) filesystem (or whatever) based on
this; and what ext3 IS that "safe" filesystem.  Just believe, that's
all... ;)

BTW, thanks for a good discussion.  Seriously.  It's very rare one
can see this level of expirience as you demonstrate.

/mjt
