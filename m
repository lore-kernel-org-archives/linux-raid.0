From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be
 written?
Date: Sat, 5 Jan 2013 22:01:44 +0100
Message-ID: <20130105210144.GC16375@hellgate>
References: <20130104175458.GA3298@hellgate>
 <50E75CE2.8060105@hardwarefreak.com>
 <20130104234113.GA14799@hellgate>
 <20130105081533.GB18121@hellgate>
 <EDB7C18C-1B3C-470C-81F9-EDBA81D1A0DF@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <EDB7C18C-1B3C-470C-81F9-EDBA81D1A0DF@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 05, 2013 at 11:57:53AM -0700, Chris Murphy wrote:

> >> I would not do this, you eliminate not just some of the advantages, but
> >> all of the major ones including self-healing.
> > 
> > I know; however, I get to use compression, convenient management, fast
> > snapshots etc. If I later add an SSD I can use it as L2ARC.
> 
> You've definitely exchanged performance and resilience, for maybe possibly
> not sure about adding an SSD.

Oh, it's quite sure. I've ordered it already but it hasn't arrived yet. The
only question is when I'll have time to install it in the server.

> An SSD that you're more likely to need because of the extra layers you're
> forcing this setup to use.

Come on, that's FUD. I need the SSD because I have an I/O workload with many
random reads, too slow disks, too few spindles and too little RAM. It has
little to do with the number of layers. (Also, I arguably don't "need" the
SSD, but it will do a lot to improve interactive performance.)

> > Alas, too expensive. I built this server for a hobby/charity project, from
> > disks I had lying around; buying enterprise grade hardware is out of the
> > question.
> 
> All the more reason why simpler is better, and this is distinctly not
> simple. It's a FrankenNAS.

It may not be simple but it's something I have experience with, so it's
relatively simple for me to maintain and set up. With btrfs there'd been a
learning curve in addition to less flexibility in choosing mountpoints, for
example. Also, btrfs is completely new, whereas zfs is only new on Linux. I
don't trust btrfs yet (and reading kernel changelogs keeps me cautious).

The setup where a virtualised FreeBSD or OpenIndiana would've been a NAS for
the host, OTOH... that would have been positively Frankensteinian.

BTW, just to make you wince: two of the first "production" boxes I deployed
zfsonlinux on actually have mdraid-LUKS-LVM-zfs (and it works and is even
fast enough).

> You might consider arbitrarily yanking one of the disks, and seeing how
> the restore process works out for you.

I did that several times, worked fine (but took a while, of course).

> >> The only way ZFS can self-heal is if it directly manages its own mirrored
> >> copies or its own parity. To use ZFS in the fashion you're suggesting I
> >> think is pointless, so skip using md or LVM. And consider the list in
> >> reverse order as best performing, with your idea off the list entirely.
> > 
> > It's not pointless (see above), just sub-optimal.
> 
> Pointless. You're going to take the COW and data checksumming performance
> hit for no reason.

Not for no reason: I get cheap snapshots out of the COW thing, and dedup out
of checksumming (for a select few filesystems).

> If you care so little about that, at least with Btrfs
> you can turn both of those off.

For the record, I could turn off checksumming on zfs too. That's actually
not a bad idea, come to think of it, because most of my datasets really
don't benefit from it. Thanks.

> > Per encrypted device.
> 
> Really? You're sure? Explain to me the difference between six kworker
> threads each encrypting 100-150MB/s, and funneling 600MB/s - 1GB/s through
> one kworker thread. It seems you have a fixed amount of data per unit time
> that must be encrypted.

No, because if I encrypt each disk separately, I need to encrypt the same
piece of data 3 times (because I store 3 copies of everything). In the
current setup, replication occurs below the encryption layer.

> > The article, btw, doesn't mention some of the other differences between
> > btrfs and zfs: for example, afaik, with btrfs the mount hierarchy has to
> > mirror the pool hierarchy, whereas with zfs you can mount every fs anywhere.
> 
> And the use case for this is?

For example: I have two zpools, one encrypted and one not. Both contain
filesystems that get mounted under /srv. Of course this would be possible
with btrfs using workarounds like bind mounts and symlinks, but why should I
need a workaround?

Or how about this? I want some subdirectories of /usr and /var to be on zfs,
in the same pool, with the rest being on xfs. (This might be possible with
btrfs; I don't know.)

In another case, I had a backup of a vserver (as in linux-vserver.org); the
host with the live instance failed and I had to create clones of some of the
backup snapshots, then mount them in various locations to be able to start
the vserver on the backup host. This was possible even though all were part
of the 'backup' pool. Flexibility is almost always a good thing.

> > On the whole, btrfs "feels" a lot more experimental to me than zfsonlinux,
> > which is actually pretty stable (I've been using it for more than a year
> > now). There are occasional problems, to be sure, but it's getting better at
> > a steady pace. I guess I like to live on the edge.
> 
> I have heard of exactly no one doing what you're doing, and I'd say that
> makes it far more experimental than Btrfs.

That's only if you work from the premise that there are magical interactions
between the various layers, which, while conceivable, my experience so far
doesn't confirm. (If you consider enough specifics, _every_ setup is
"experimental": at least the serial number of the hardware components likely
differs from the previous similar setup.)

> If by "feels" experimental, you mean many commits to new kernels and few
> backports, OK. I suggest you run on a UPS in either case, especially if
> you don't have the time to test your rebuild process.

Alas, no UPS. I make do with turning the write cache of my drives off. (But
the box survived numerous crashes caused by the first power supply being
just short of sufficient, which makes me relatively confident of the
resilience of the storage subsystem.)

> >> If FreeBSD/OpenIndiana are no ops, the way to do it on Linux is, XFS on
> >> nearline SATA or SAS SEDs, which have an order magnitude (at least) lower
> >> UER than consumer crap, and hence less of a reason why you need to 2nd guess
> >> the disks with a resilient file system.
> > 
> > Zfs doesn't appeal to me (only) because of its resilience. I benefit a lot
> > from compression and snapshotting, somewhat from deduplication, somewhat
> > from zfs send/receive, a lot from the flexible "volume management" etc. I
> > will also later benefit from the ability to use an SSD as cache.
> 
> I'm glad you're demoting the importance of resilience since the way you're
> going to use it totally obviates its resilience to that of any other fs.

I know.

> You don't get dedup without an SSD, it's way too slow to be useable at
> all,

That entirely depends. I have a few hundred MB of storage that I can dedup
very efficiently (ratio of maybe 5:1). While the space savings are
insignificant, the dedup table is also small and it fits into ARC easily. I
don't dedup it for the space savings on disk, but for the space savings in
cache.

> and you need a large SSD to do a meaningful amount of dedup with ZFS
> and also have enough for caching. Discount send/receive because Btrfs has
> that, and I don't know what you mean by flexible volume management.

The above wasn't about zfs vs. btrfs, it was about zfs vs. xfs on allegedly
better quality drives.

> >> But even though also experimental, I'd still use Btrfs before I'd use ZFS
> >> on LUKS on Linux, just saying.
> > 
> > Perhaps you'd like to read https://lwn.net/Articles/506487/ and the
> > admittedly somewhat outdated
> 
> The singular thing here is the SSD as ZIL or L2ARC, and that's something
> being worked on in the Linux VFS rather than make it a file system
> specific feature. If you look at all the zfsonlinux benchmarks, even SSD
> isn't enough to help ZFS depending on the task. So long as you've done
> your homework on the read/write patterns and made sure it's compatible
> with the capabilities of what you're designing, great. Otherwise it's pure
> speculation what on paper features (which you're not using anyway) even
> matter.

I have a fair amount of experience with zfsonlinux, both with and without
SSDs, and similar (but not identical) workloads. I have reason to believe
the SSD will help. (FWIW, it will also allow me to use an external bitmap
for my mdraid, which will also help.)

> > http://rudd-o.com/linux-and-free-software/ways-in-which-zfs-is-better-than-btrfs
> > for some reasons people might want to prefer zfs to btrfs.
> 
> It mostly sounds you like features that you're not even going to use from
> the outset, and won't use, but you want them anyway.

I have no idea what you mean. Maybe you're conflating our theoretical
argument over whether zfsonlinux might be preferable to btrfs at all, and
the one about whether I made the right choice in this specific instance?

Hmmm... hasn't this gotten somewhat off-topic? (And see how right I was in
not mentioning zfsonlinux when all I wanted to know was whether Linux RAID10
insisted on chunk-aligned writes? :)

-- 
                     Andras Korn <korn at elan.rulez.org>
      I tried sniffing Coke once, but the ice cubes got stuck in my nose.
