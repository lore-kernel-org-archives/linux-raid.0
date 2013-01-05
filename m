From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be written?
Date: Sat, 5 Jan 2013 11:57:53 -0700
Message-ID: <EDB7C18C-1B3C-470C-81F9-EDBA81D1A0DF@colorremedies.com>
References: <20130104175458.GA3298@hellgate> <50E75CE2.8060105@hardwarefreak.com> <20130104234113.GA14799@hellgate> <20130105081533.GB18121@hellgate>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130105081533.GB18121@hellgate>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 5, 2013, at 1:15 AM, Andras Korn <korn@raidlist.elan.rulez.org> wrote:

> Replying to Chris Murphy:
> 
>> I would not do this, you eliminate not just some of the advantages, but
>> all of the major ones including self-healing.
> 
> I know; however, I get to use compression, convenient management, fast
> snapshots etc. If I later add an SSD I can use it as L2ARC.

You've definitely exchanged performance and resilience, for maybe possibly not sure about adding an SSD. An SSD that you're more likely to need because of the extra layers you're forcing this setup to use. Btrfs offers all of the features you list, except the SSD that you haven't even committed to, and you'd regain resilience and drop at least two layers that will negatively impact performance.

> Alas, too expensive. I built this server for a hobby/charity project, from
> disks I had lying around; buying enterprise grade hardware is out of the
> question.

All the more reason why simpler is better, and this is distinctly not simple. It's a FrankenNAS. You might consider arbitrarily yanking one of the disks, and seeing how the restore process works out for you.

> 
>> The only way ZFS can self-heal is if it directly manages its own mirrored
>> copies or its own parity. To use ZFS in the fashion you're suggesting I
>> think is pointless, so skip using md or LVM. And consider the list in
>> reverse order as best performing, with your idea off the list entirely.
> 
> It's not pointless (see above), just sub-optimal.

Pointless. You're going to take the COW and data checksumming performance hit for no reason. If you care so little about that, at least with Btrfs you can turn both of those off.

>> If it does, it adds maybe 2% overhead for encryption, although I can't

>> tell if you off hand if that's per disk.
> 
> Per encrypted device.

Really? You're sure? Explain to me the difference between six kworker threads each encrypting 100-150MB/s, and funneling 600MB/s - 1GB/s through one kworker thread. It seems you have a fixed amount of data per unit time that must be encrypted. 

> 
> The article, btw, doesn't mention some of the other differences between
> btrfs and zfs: for example, afaik, with btrfs the mount hierarchy has to
> mirror the pool hierarchy, whereas with zfs you can mount every fs anywhere.

And the use case for this is? You might consider esoteric and minor differences like this to be a good exchange f


> On the whole, btrfs "feels" a lot more experimental to me than zfsonlinux,
> which is actually pretty stable (I've been using it for more than a year
> now). There are occasional problems, to be sure, but it's getting better at
> a steady pace. I guess I like to live on the edge.

I have heard of exactly no one doing what you're doing, and I'd say that makes it far more experimental than Btrfs.

If by "feels" experimental, you mean many commits to new kernels and few backports, OK. I suggest you run on a UPS in either case, especially if you don't have the time to test your rebuild process.


>> If FreeBSD/OpenIndiana are no ops, the way to do it on Linux is, XFS on
>> nearline SATA or SAS SEDs, which have an order magnitude (at least) lower
>> UER than consumer crap, and hence less of a reason why you need to 2nd guess
>> the disks with a resilient file system.
> 
> Zfs doesn't appeal to me (only) because of its resilience. I benefit a lot
> from compression and snapshotting, somewhat from deduplication, somewhat
> from zfs send/receive, a lot from the flexible "volume management" etc. I
> will also later benefit from the ability to use an SSD as cache.

I'm glad you're demoting the importance of resilience since the way you're going to use it totally obviates its resilience to that of any other fs. You don't get dedup without an SSD, it's way too slow to be useable at all, and you need a large SSD to do a meaningful amount of dedup with ZFS and also have enough for caching. Discount send/receive because Btrfs has that, and I don't know what you mean by flexible volume management.


> 
>> But even though also experimental, I'd still use Btrfs before I'd use ZFS
>> on LUKS on Linux, just saying.
> 
> Perhaps you'd like to read https://lwn.net/Articles/506487/ and the
> admittedly somewhat outdated

The singular thing here is the SSD as ZIL or L2ARC, and that's something being worked on in the Linux VFS rather than make it a file system specific feature. If you look at all the zfsonlinux benchmarks, even SSD isn't enough to help ZFS depending on the task. So long as you've done your homework on the read/write patterns and made sure it's compatible with the capabilities of what you're designing, great. Otherwise it's pure speculation what on paper features (which you're not using anyway) even matter.

> http://rudd-o.com/linux-and-free-software/ways-in-which-zfs-is-better-than-btrfs
> for some reasons people might want to prefer zfs to btrfs.

Except that article is ideological b.s. that gets rather fundamental facts wrong. You can organize subvolumes however you want. You can rename them. You can move them. You can boot from them. That has always been the case, so the age of the article doesn't even matter.

It mostly sounds you like features that you're not even going to use from the outset, and won't use, but you want them anyway. Which is not the way to design storage. You design it for a task. If you really need the features you're talking about, you'd actually spend the time to sort out your FreeBSD/OpenIndiana problems.


Chris Murphy