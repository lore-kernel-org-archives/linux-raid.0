From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 15:23:38 +0100
Message-ID: <a41oa2-fr7.ln1@news.it.uc3m.es>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es> <20050102194240.GE99565@caffreys.strugglers.net> <5h1ma2-asq.ln1@news.it.uc3m.es> <20050103003005.GG99565@caffreys.strugglers.net> <2rana2-0if.ln1@news.it.uc3m.es> <41D93657.7090908@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> Peter T. Breuer wrote:
> > This is always a VERY bad idea. /boot and /root want to be on as simple
> > and uncomplicated a system as possible. Moreover, they never change, so
> > what is the point of having a real time mirror for them? It would be
> > sufficient to copy them every day (which is what I do) at file system
> > level to another partition, if you want a spare copy for emergencies.
> 
> Raid1 (mirror) is the most "trivial" raid level out there, especially

Hi!

> having in mind that the underlying devices -- all of them -- contains
> (or should, in theory -- modulo the "50% chance of any difference
> being unnoticied" etc) exact copy of the filesystem.  Also, root (and
> /boot -- i for one have both /boot in root in a single small filesystem)
> do change -- not that often but often enouth so that "newaliases problem"
> (when you "forgot" to backup it after a change) happens from time to time.

Well, my experience is that anything "unusual" is bad:  sysadmins change
over the years;  the guy who services the system may not be the one that
built it;  the "rescue" cd or floppy he has may not have MD support
built into the kernel (and he probably will need a rescue cd just to get
support for a raid card, if the machine has hardware raid as well as or
instead of software raid).

Therefore, I have learned not to build a system that is more complicated
than the most simple human being that may administer it. This always
works - if it breaks AND they cannot fix it, then THEY get the blame.

So I "prefer" to not have a raided boot partition, but instead to rsync
the root partition every day to a spare on a differet disk, or/and at the
other end of the same disk. This also saves the system from sysadmin
gaffes - I don't WANT an instantaneous copy of every error made by the
humans.

This is not to say that I do not like your ideas, expressed here. I do.
I even agree with them.

It is just that when they mess up the root partition, I can point to
the bootloader entry that says "boot from spare root partition".

And let's not get into what they can do to the labelling on the
partition types - FD? Must be a mistake!


> After several years of expirience with alot of systems (and alot of various
> disk failure scenarios too: when you have many systems, you have good
> chances to see a failure ;), I now use very simple and (so far) reliable
> approach, which I explained here on this list before.  You have several
> (we use 2, 3 or 4) disks which are the same (or almost: eg some 36Gb

Well, whenever I buy anything, I buy two. I buy two _controller_ cards,
and tape the extra one inside the case. But of course I buy two
machines, so that is four cards ... .

And I betcha softraid sb has changed format ver the years. I am still
running P100s!

> disks are really 35Gb or 37Gb; in case they're differ, "extra" space
> on large disk isn't used); root and /boot are on small raid1 partition
> which is mirrored on *every* disk; swap is on raid1; the rest (/usr,

I like this - except of course that I rsync them, not raid them. I
don't mind if I have to reboot a server. Nobody will notice the tcp
outage and the other one of the pair will failover for it, albeit in
readonly mode, for the maximum of the few minutes required.

Your swap idea is crazy, but crazy enough to be useful. YES, there used
to be a swap bug which corrupted swap every so often (in 2.0? 2.2?) and
meant one had to swapoff and swapon again, having first cleared all
processes by an init 1 and back. Obviously that bug would bite whatever
you had as media, but it still is a nice idea to have raided memory
:-).


> /home, /var etc) are on raid5 arrays (maybe also raid0 for some "scratch"

I don't put /var on raid if I can help it. But there is nothing
particularly bad about it. It is just that /var is the most active
place and therefore the most likely to suffer damage of some kind, somehow.
And damaged raided partitions are really not nice. Raid does not
protect you against hardware corruption - on the contrary, it makes it
more difficult to spot and doubles the probabilities of it happening.

> space).  This way, you have "equal" drives, and *any* drive, including
> boot one, may fail at any time and the system will continue working
> as if all where working, including reboot (except of a (very rare in
> fact) failure scenario when your boot disk has failed MBR or other
> sectors required to boot, but "the rest" of that disk is working,
> in which case you'll need physical presence to bring the machine up).

That's actually not so. Over new year I accidently booted my home
server (222 days uptime!) and discovered its boot sector had evaporated.
Well, maybe I moved the kernels ..  anyway, it has no floppy and the
nearest boot cd was an hour's journey away in the cold, on new year.  Uh
uh.  It took me about 8 hrs, but I booted it via PXE DHCP TFTP
wake-on-lan and the wireless network, from my laptop, without leaving
the warm.

Next time I may even know how to do it beforehand :).

> All the drives are "symmetrical", usage patterns for all drives are
> the same, and due to usage of raid arrays, load is spread among them
> quite nicely.  You're free to reorder the drives in any way you want,
> to replace any of them (maybe rearranging the rest if you're
> replacing the boot drive) and so on.

You can do this hot? How? Oh, you must mean at reboot.

> Yes, root fs does not changes often, and yes it is small enouth
> (I use 1Gb, or 512Mb, or even 256Mb for root fs - not a big deal

Mine are always under 256MB, but I give 512MB.

> to allocate that space on every of 2 or 3 or 4 or 5 disks).  So
> it isn't quite relevant how fast the filesystem will be on writes,
> and hence it's ok to place it on raid1 composed from 5 components.

That is, uh, paranoid.

> The stuff just works, it is very simple to administer/support,
> and does all the "backups" automatically. 

Except that  it doesn't - backups are not raid images. Backups are
snapshots. Maybe you mean that.

> In case of some problem
> (yes I dislike any additional layers for critical system components
> as any layer may fail to start during boot etc), you can easily
> bring the system up by booting off the underlying root-raid partiton
> to repair the system -- all the utilities are here.  More, you can

Well, you could, and I could, but I doubt if the standard tech could.

> boot from one disk (without raid) and try to repair root fs on
> another drive (if things are really screwed up), and when you're
> done, bring the raid up on that repaired partition and add other
> drives to the array.

But why bother? If you didn't have raid there on root you wouldn't
need to repair it. Nothing is quite as horrible as having a
fubarred root partition.  That's why I also always have two! But I
don't see that having the copy made by raid rather than rsync wins
you anything in the situaton where you have to  reboot - rather, it
puts off that moment to a moment of your choosing, which may be good, 
but is not an unqualified bonus, given the cons.

> To summarize: having /boot and root on raid1 is a very *good* idea. ;)
> It saved our data alot of times in the past few years already.

No - it saved you from taking the system down at that moment in time.
You could always have rebooted it from a spare root partition whether
you had raid there or not.

> If you're worried about "silent data corruption" due to different
> data being read from different components of the raid array.. Well,
> first of all, we never saw that yet (we have quite good "testcase")

It's hard to see, and youhave to crash and come back up quite a lot to
make it probable. A funky scsi cable would help you see it!

> (and no, I'm not saying it's impossible ofcourse).  On rarely-changed
> filesystem, with real drives which does no silent remapping of an
> undeadable blocks to new place with the data on them becoming all-0s,

Yes, I agree. On rarely changing systems raid is a benefit, because
it enables you to carry on in case the unthinkable happens and one disk
vaporizes (while letting the rest of the system carry on, with much luck).
On rapidly changing systems like /var I start to get a little uneasy.
On /home I am quite happy with it. I wouldn't have it any other way
there..

> without drives with uncontrollable write caching (quite common for
> IDE drives) and things like that, and with real memory (ECC I mean),
> where you *know* what you're writing to each disk (yes, there's also
> another possible cause of a problem: software errors aka bugs ;),

Indeed, and very frequent they are too.

> that case with different data on different drives becomes quite..
> rare.  In order to be really sure, one can mount -o remount,ro /
> and just compare all components of the root raid, periodically.
> When there's more than 2 components on that array, it should be
> easy to determine which drive is "lying" in case of any difference.
> I do similar procedure on my systems during boot.

Well, voting is one possible procedure. I don't know if softraid does
that anywhere, or attempts repairs.

Neil?

> >>There is nowhere that is not software RAID to put the journals, so
> > 
> > Well, you can make somewhere. You only require an 8MB (one cylinder)
> > partition.
> 
> Note scsi disks in linux only supports up to 14 partitions, which

You can use lvm (device mapper). Admittedly I was thinking of IDE.

If you like I can patch scsi for 63 partitions?

> isn't sometimes sufficient even without additional partitions for
> journal.  When you have large amount of disks (so having that
> "fully-symmetrical" layout as I described above becomes impractical),
> you can use one set of drives for data and another set of drives
> for journal for that data.  When you only have 4 (or less) drives...
> 
> And yes I'm aware of mdp devices (partitions inside the raid
> arrays).. but that's just another layer "which may fail": if
> raid5 array won't start, I at least can reconstruct filesystem
> image by reading chunks of data from appropriate places from
> all drives and try to recover that image; with any additional

Now that is just perverse.

> structure inside the array (and the lack of "loopP" aka partitioned
> loop devices) it becomes more and more tricky to recover any
> data (from this point of view, raid1 is the niciest raid level ;)

Agree.

> Again: instead of using a partition for the journal, use (another?)
> raid array.  This way, the system will work if the drive wich
> contains the journal fails.

But the journal will also contain corruptions if the whole system
crashes, and is rebooted. You just spent several paragraphs (?) arguing
so. Do you really want those rolled forward to complete? I would
rather they were rolled back! I.e. that the journal were not there -
I am in favour of a zero size journal, in other words, which only acts
to guarantee atomicity of FS ops (FS code on its own may do that), but
which does not contain data.

> Note above about swap: in all my
> systems, swap is also on raid (raid1 in this case).  At the first
> look, that can be a nonsense: having swap on raid.  But we had
> enouth cases when due to a failed drive swap becomes corrupt
> (unreadable really), and the system goes havoc, *damaging*
> other data which was unaffected by the disk failure!  With

Yes, this used to be quite common when swap had that size bug.

> swap on raid1, the system continues working if any drive
> fails, which is good.  (Older kernels, esp. 2.2.* series,
> had several probs with swap on raid, but that has been fixed
> now; there where other bugs fixed too (incl. bugs in ext3fs)
> so there should be no such damage to other data due to
> unreadable swap.. hopefully.  But I can't trust my systems
> anymore after seeing (2 times in 4 years) what can happen with
> the data...)
> 
> []
> 
> And I also want to "re-reply" to the first your message in this
> thread, where I was saying that "it's a nonsense that raid does
> not preserve write ordering".  Ofcourse I mean not write ordering
> but working write barriers (as Neil pointed out, md subsystem does
> not implement write barriers directly but the concept is "emulated"
> by linux block subsystem).  Write barriers should be sufficient to
> implement journalling safely.

I am not confident that Neil did say so. I have not reexamined his
post, but I got the impression that he hummed and hawed over that.
I do not recall that he said that raid implements write barriers -
perhaps he did. Anyway, I do not recall any code to handle "special"
requests, which USED to be the kernel's barrier mechanism. Has that
mechanism changed (it could have!)?

What is the write barrier mechanism in the 2.6 series (and what was it
in 2.4? I don't recall one at all)?

I seem to recall that Neil said instead that raid acks writes only after
they have been carried out on all components, which Stephen said was
sufficient for ext3. OTOH we do not know if it is sufficient for
reiserfs, xfs, jfs, etc.

Peter

