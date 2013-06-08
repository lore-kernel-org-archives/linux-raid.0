From: Steve Bergman <sbergman27@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sat, 8 Jun 2013 14:56:23 -0500
Message-ID: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

First of all, thank you to the people who took the time to help
illuminate this issue.

To summarize... for unknown reasons, the 4 port SATA controller on the
Dell PET-310 has an aggregate limitation of ~1.75 Gbit/s on the A&B
and C&D port pairs. Each port can provide more than that to a single
drive, but when trying to read or write both ports simultaneously,
each port in the pair gets  ~0.87Gbit/s. (Which is probably some
higher nominal value minus some overhead.)

The testing of (1) my workload, and (2) sequential read write, under
various RAID levels, filesystems, and chunk sizes got tedious, so I
decided to just automate the whole thing and let it run overnight. My
initial guess was that RAID5 might have some advantages in this
situation for sequential writes in that parity is less bandwidth
intensive for writes than is mirroring, and I almost always have
plenty of spare cpu cycles available. This turned out to be correct
for ext4. (xfs still liked RAID10.) The best numbers for sequential
read/write came from ext4 under 4-drive RAID5 at the default chunk
size of 512k. xfs did it's best under RAID10 with chunk sizes of
either 32k or 64k (which came out about the same), but was not able to
match the ext4 write performance, or even come close to the read
performance.

The more important testing was of my actual target work load, which
does a huge number of random writes building up a pair of files which
are each ~2GB. My suspicion was that RAID10 would yield the better
performance here, since this is not a bandwidth-bound workload. This
turned out to be correct for both ext4 and xfs. Here, the best
performance again came from ext4 at the default chunk size of 512k.
where the operation completed (including sync) in 11m24s, with xfs
doing best at a 32k chunk size, and completing in 13m07s.

With that established, I decided to focus on ext4 at 512k. For the
system volumes, delayed allocation is acceptable. However, for the
data partition, leaving delayed allocation turned on would be
irresponsible. (We have point of sale data being collected throughout
the day which could not be recovered from backup. The testing shows
that for this workload, mounting "nodelalloc" entails only a 7%
penalty in performance, which is quite acceptable (and still faster
than XFS).

So that pretty much nails down my configuration. RAID10 with 512k
chunks. ext4 mounted nodelalloc for the data volume. And ext4 mounted
at the defaults for everything else.

Now, that said... and though I don't really intend to engage in a long
thread over this... the subject of XFS's suitability for this kind of
work has come up, and I'll address the key points, since I do believe
in calling a spade a spade. Even if xfs had come out ahead on
performance, I would not have considered it for my data partition.
It's been said here that the major data loss bugs in xfs have been
fixed. And that's probably true. At least one would hope that after 13
years, the major data loss bugs would have been fixed. But xfs's data
integrity problems are not due to bugs, but due to fundamental design
decisions which cannot be changed at this point. And there is plenty
of recent evidence supporting the fact that xfs still has the same
data integrity problems it has always had. For example, this recent
report involving a very recent enterprise Linux version:

http://toruonu.blogspot.com/2012/12/xfs-vs-ext4.html

Simply Googling "xfs zero" and sorting by date yields pages and pages
of recent report hits.

The fundamental design philosophy issues for xfs are the assumptions that:

1. Metadata is more important than data. (A brain-dead concept, to start with.)

2. Data loss is acceptable as long as the metada is kept consistent.

3. Performance is only slightly less important than metadata, and far
more important than data.


More specifically, the data integrity design problems for xfs are (primarily):

1. It only journals metadata, and doesn't order data writes to ensure
that the data is always consistent with some valid state (even if it
isn't the latest state).

2. It uses delayed allocation, which is inherently unsafe, of it you
order writes ahead of the metadata. And you can't turn it off. (Please
correct me if I'm wrong about that. I'd like to know.)

#1 is a brick wall. There's not much that can be done. Regarding #2, I
think the xfs guys did model something on Ted T'so's ext4 patches to
2.6.30 which force fsyncs for certain common idioms. (Though I think I
heard that they did not adopt all of them. Not sure.) I do not
consider even that full patch set to be more than a band-aid.

But trusting important data to a store which employs either of the
above designs is just irresponsible, and in general, responsible
admins should never even consider it.

Regarding xfs performance, Dave Chinner made an interesting
presentation (at LinuxConf AU 2012, IIRC) in which he demonstrated the
metadata scalability work that the xfs team had done, which had made
it into RHEL 6.x. (It's on YT, if you missed it.) His slides did show
dramatic improvements. However, they also consistently showed ext4
blowing away xfs performance on fs_mark for everything test, up until
8 threads (which covers an awful lot of common workloads). So xfs
metadata performance isn't there yet, unless your workload involves 8
metadata intensive threads. To its credit, xfs did scale more or less
linearly, whereas ext4 (in whatever configuration her was using; he
didn't say.) started flagging somewhere between 5 & 8 threads.

There's no such thing as a "best filesystem". Horses for courses.
Above 16TB, xfs may (or may not) rule. Below that is (in general) ext4
territory, And we'll see how things work out for the featureful btrfs.
It's too early to guess, and my crystal ball is in the shop.

It's been suggested that I'm not familiar with the issues surrounding
ext3's ordered mode. In fact, I'm more familiar with the history than
anyone I've recently encountered. Back in '98 or '99, we didn't have
any journaling fs in Linux, and I was carefully following each and
every (relatively rare) post that Stephen Tweedie was making to lkml
and the linux-ext2 (IIRC) list. So I know the history. I know
Tweedie's thought process at the time. (Had an email exchange with him
about it once.) And so I recognize that T'so (and others?) have
managed an impressive rewriting of the history in a campaign to make
dangerous practices palatable to a modern audience. Ext3's aggressive
data-sync'ing behavior is no accident or side-effect. It was quite
deliberate and intentional. And ordered mode was not all about
security, but primarily about providing a sane level of data
integrity, with the security features being included for free. Tweedie
is a very meticulous and careful designer who understood (and
understands) that:

1. Data is more important than metadata.

2. Metadata is only important because it's required in order to work
with the data.

3. It's OK to provide data-endangering options to the system
administrator. But they should be turned *off* by default.

I get the impression that few people are aware of these aspects of
ext3's history and design. Probably fewer are aware that Tweedie
implemented the data=journal mode *before* he implemented the ordered
and writeback modes.

I can certainly see where ext3 design decisions would be a thorn in
the side of designers of less safe filesystems, as it does result in
programs which quickly show up their design misfeatures.

While getting things closer to right than xfs, ext4 falls short of
getting things really right by turning the dangerous delayed
allocation behavior on by default. It should have been left as a
performance optimization available to admins with workloads which
allowed for it.

Anyway, that's enough for me on this topic. Feel free to discuss among
yourselves. But the back and forth on this could go on for weeks (if
not more) and I don't care to allocate the time (delayed or not ;-)

Again, thank you for the discussion and info on the T310 and general SATA issue.

Sincerely,
Steve Bergman
(signing off)
