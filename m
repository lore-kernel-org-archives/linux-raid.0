From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be
 written?
Date: Sat, 5 Jan 2013 09:15:33 +0100
Message-ID: <20130105081533.GB18121@hellgate>
References: <20130104175458.GA3298@hellgate>
 <50E75CE2.8060105@hardwarefreak.com>
 <20130104234113.GA14799@hellgate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130104234113.GA14799@hellgate>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Replying to Chris Murphy:

> > The filesystem is the "application": it's zfsonlinux. I'm putting it on
> > RAID10 instead of using the disks natively because I want to encrypt it
> > using LUKS, and encrypting each disk separately seemed wasteful of CPU (I
> > only have 3 cores).
> > 
> > I realize that I forsake some of the advantages of zfs by putting it on an
> > mdraid array.
> 
> I would not do this, you eliminate not just some of the advantages, but
> all of the major ones including self-healing.

I know; however, I get to use compression, convenient management, fast
snapshots etc. If I later add an SSD I can use it as L2ARC.

I have considered the benefits and disadvantages and I think my choice was
the right one.

> dmcrypt/LUKS (ZFS on encrypted logical device)
> ecryptfs (encrypted fs on top of ZFS)

I know of ecryptfs but I don't know how mature it is or how well it would
work on top of zfs (which it certainly hasn't been tested with). I have a
fair amount of experience with LUKS though.

I considered and rejected it due to my lack of experience with it. Perhaps
I'll get the chance to play with it sometime so I can deploy it with
confidence later.

> Nearline (or enterprise) drives that have self-encryption

Alas, too expensive. I built this server for a hobby/charity project, from
disks I had lying around; buying enterprise grade hardware is out of the
question.
 
> The only way ZFS can self-heal is if it directly manages its own mirrored
> copies or its own parity. To use ZFS in the fashion you're suggesting I
> think is pointless, so skip using md or LVM. And consider the list in
> reverse order as best performing, with your idea off the list entirely.

It's not pointless (see above), just sub-optimal.

> Three cores? Does it have AES-NI?

No. It's a Phenom II X3 705e.

> If it does, it adds maybe 2% overhead for encryption, although I can't
> tell if you off hand if that's per disk.

Per encrypted device. If I had encrypted the six disks separately, I'd be
running six encryption threads, and encrypting each piece of data in
triplicate. And without AES-NI, it's more like 10% when there are many
writes.

> Also, it's worth reading this, to hopefully ensure the backup system isn't
> also experimental.
> 
> http://confessionsofalinuxpenguin.blogspot.com/2012/09/btrfs-vs-zfsonlinux-how-do-they-compare.html

Thanks, I've read it. I actually did try FreeBSD first, but it kept locking
up if it had more than one CPU AND there was a lot of I/O going on. My idea
was to build a FreeBSD based storage appliance in a VM (because I can't run
all my stuff on FreeBSD directly), and export the VM's zfs to Linux (maybe
in another VM, maybe the host), but it just didn't work. OpenIndiana failed
in a similar but not identical way. I don't know enough about either system
to be able to troubleshoot them effectively and no time, right now, to
learn.

The article, btw, doesn't mention some of the other differences between
btrfs and zfs: for example, afaik, with btrfs the mount hierarchy has to
mirror the pool hierarchy, whereas with zfs you can mount every fs anywhere.
On the whole, btrfs "feels" a lot more experimental to me than zfsonlinux,
which is actually pretty stable (I've been using it for more than a year
now). There are occasional problems, to be sure, but it's getting better at
a steady pace. I guess I like to live on the edge.

> I mean, think about it another way. You value the data, apparently, enough
> to encrypt it. But then you're willing to basically f around with the data
> by using a "nailing jello to a tree" approach for a file system. Quite
> honestly you should consider doing this on FreeBSD or OpenIndiana where
> there's native support for encryption, and for ZFS, no nail and jello
> required. People who care about their data, and need/want a resilient file
> system, do it on one of those two OSs.

You're conflating two distinct meanings of "value". I encrypt my data for
reasons of privacy, not confidentiality: I don't want other people to
automatically have access to it if they have my disks - for example, because
the server is stolen, or because I've disposed of a defective disk without
securely erasing it first.

OTOH, the data does not have particularly high business value. Losing it
would be inconvenient, but not a big deal.

> If FreeBSD/OpenIndiana are no ops, the way to do it on Linux is, XFS on
> nearline SATA or SAS SEDs, which have an order magnitude (at least) lower
> UER than consumer crap, and hence less of a reason why you need to 2nd guess
> the disks with a resilient file system.

Zfs doesn't appeal to me (only) because of its resilience. I benefit a lot
from compression and snapshotting, somewhat from deduplication, somewhat
from zfs send/receive, a lot from the flexible "volume management" etc. I
will also later benefit from the ability to use an SSD as cache.

> But even though also experimental, I'd still use Btrfs before I'd use ZFS
> on LUKS on Linux, just saying.

Perhaps you'd like to read https://lwn.net/Articles/506487/ and the
admittedly somewhat outdated
http://rudd-o.com/linux-and-free-software/ways-in-which-zfs-is-better-than-btrfs
for some reasons people might want to prefer zfs to btrfs.

-- 
                     Andras Korn <korn at elan.rulez.org>
                  Remember: Rape and pillage, and THEN burn!
