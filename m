From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: high throughput storage server?
Date: Tue, 22 Mar 2011 12:01:29 +0100
Message-ID: <20110322110129.GB9329@www2.open-std.org>
References: <4D837DAF.6060107@hardwarefreak.com> <20110319090101.1786cc2a@notabene.brown> <4D8559A2.6080209@hardwarefreak.com> <20110320144147.29141f04@notabene.brown> <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com> <4D868C36.5050304@hardwarefreak.com> <20110321024452.GA23100@www2.open-std.org> <4D875E51.50807@hardwarefreak.com> <20110321221304.GA900@www2.open-std.org> <4D887348.3030902@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D887348.3030902@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Mdadm <linux-raid@vger.kernel.org>, Roberto Spadim <roberto@spadim.com.br>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

On Tue, Mar 22, 2011 at 05:00:40AM -0500, Stan Hoeppner wrote:
> Keld J=F8rn Simonsen put forth on 3/21/2011 5:13 PM:
> > On Mon, Mar 21, 2011 at 09:18:57AM -0500, Stan Hoeppner wrote:
> >> Keld J=F8rn Simonsen put forth on 3/20/2011 9:44 PM:
> >>
> >>> Anyway, with 384 spindles and only 50 users, each user will have =
in
> >>> average 7 spindles for himself. I think much of the time this wou=
ld mean=20
> >>> no random IO, as most users are doing large sequential reading.=20
> >>> Thus on average you can expect quite close to striping speed if y=
ou
> >>> are running RAID capable of striping.=20
> >>
> >> This is not how large scale shared RAID storage works under a
> >> multi-stream workload.  I thought I explained this in sufficient d=
etail.
> >>  Maybe not.
> >=20
> > Given that the whole array system is only lightly loaded, this is h=
ow I
> > expect it to function. Maybe you can explain why it would not be so=
, if
> > you think otherwise.
>=20
> Using the term "lightly loaded" to describe any system sustaining
> concurrent 10GB/s block IO and NFS throughput doesn't seem to be an
> accurate statement.  I think you're confusing theoretical maximum
> hardware performance with real world IO performance.  The former is
> always significantly higher than the latter.  With this in mind, as w=
ith
> any well designed system, I specified this system to have some headro=
om,
> as I previously stated.  Everything we've discussed so far WRT this
> system has been strictly parallel reads.

The disks themselves should be cabable of doing about 60 GB/s so 10 GB/=
s
is only a 15 % use of the disks. And most of the IO is concurrent
sequential reading of big files.

> Now, if 10 cluster nodes are added with an application that performs
> streaming writes, occurring concurrently with the 50 streaming reads,
> we've just significantly increased the amount of head seeking on our
> disks.  The combined IO workload is now a mixed heavy random read/wri=
te
> workload.  This is the most difficult type of workload for any RAID
> subsystem.  It would bring most parity RAID arrays to their knees.  T=
his
> is one of the reasons why RAID10 is the only suitable RAID level for
> this type of system.

Yes, I agree. And that is why I also suggest you use a mirrored raid in
the form of Linux MD RAID 10, F2, for better striping performance and d=
isk
access performance than traditional RAID1+0.

Anyway the system was not specified to have additional 10 heavy writing=
 processes.

> >> In summary, concatenating many relatively low stripe spindle count
> >> arrays, and using XFS allocation groups to achieve parallel scalab=
ility,
> >> gives us the performance we want without the problems associated w=
ith
> >> other configurations.
>=20
> > it is probably not the concurrency of XFS that makes the parallelis=
m of
> > the IO.=20
>=20
> It most certainly is the parallelism of XFS.  There are some caveats =
to
> the amount of XFS IO parallelism that are workload dependent.  But
> generally, with multiple processes/threads reading/writing multiple
> files in multiple directories, the device parallelism is very high.  =
=46or
> example:
>=20
> If you have 50 NFS clients all reading the same large 20GB file
> concurrently, IO parallelism will be limited to the 12 stripe spindle=
s
> on the single underlying RAID array upon which the AG holding this fi=
le
> resides.  If no other files in the AG are being accessed at the time,
> you'll get something like 1.8GB/s throughput for this 20GB file.  Sin=
ce
> the bulk, if not all, of this file will get cached during the read, a=
ll
> 50 NFS clients will likely be served from cache at their line rate of
> 200MB/s, or 10GB/s aggregate.  There's that magic 10GB/s number again=
=2E
> ;)  As you can see I put some serious thought into this system
> specification.
>=20
> If you have all 50 NFS clients accessing 50 different files in 50
> different directories you have no cache benefit.  But we will have fi=
les
> residing in all allocations groups on all 16 arrays.  Since XFS evenl=
y
> distributes new directories across AGs when the directories are creat=
ed,
> we can probably assume we'll have parallel IO across all 16 arrays wi=
th
> this workload.  Since each array can stream reads at 1.8GB/s, that's
> potential parallel throughput of 28GB/s, saturating our PCIe bus
> bandwidth of 16GB/s.

Hmm, yes RAID1+0 can probably only stream read at 1.8 GB/s. Linux MD
RAID10,F2 can stream read at around 3.6 GB/s, on an array of 24
spindles 15000 rpm, given that each spindle is capable of stream
reading at about 150 MB/s.

> Now change this to 50 clients each doing 10,000 4KB file reads in a
> directory along with 10,000 4KB file writes.  The throughput of each =
12
> disk array may now drop by over a factor of approximately 128, as eac=
h
> disk can only sustain about 300 head seeks/second, dropping its
> throughput to 300 * 4096 bytes =3D 1.17MB/s.  Kernel readahead may he=
lp
> some, but it'll still suck.
>=20
> It is the occasional workload such as that above that dictates
> overbuilding the disk subsystem.  Imagine adding a high IOPS NFS clie=
nt
> workload to this server after it went into production to "only" serve
> large streaming reads.  The random workload above would drop the
> performance of this 384 disk array with 15k spindles from a peak
> streaming rate of 28.4GB/s to 18MB/s--yes, that's megabytes.

Yes, random reading can diminish performance a lot.
If the mix of random/sequential reading is still with a good sequential
part, then I tink the system should still perform well. I think we lack
measurements for things like that, for maybe incremental sequential
reading speed on a non-saturated file system. I am not sure on how to
define such measures, tho.

> With one workload the disks can saturate the PCIe bus by almost a fac=
tor
> of two.  With an opposite workload the disks can only transfer one
> 14,000th of the PCIe bandwidth.  This is why Fortune 500 companies an=
d
> others with extremely high random IO workloads such as databases, and
> plenty of cash, have farms with multiple thousands of disks attached =
to
> database and other servers.

Or use SSD.

> > It is more likely the IO system, and that would also work for
> > other file system types, like ext4.=20
>=20
> No.  Upper kernel layers doesn't provide this parallelism.  This is
> strictly an XFS feature, although JFS had something similar (and JFS =
is
> now all but dead), though not as performant.  BTRFS might have someth=
ing
> similar but I've read nothing about BTRFS internals.  Because XFS has
> simply been the king of scalable filesystems for 15 years, and added
> great new capability along the way, all of the other filesystem
> developers have started to steal ideas from XFS.   IIRC Ted T'so stol=
e
> some things from XFS for use in EXT4, but allocation groups wasn't on=
e
> of them.
>=20
> > I do not see anything in the XFS allocation
> > blocks with any knowledge of the underlying disk structure.=20
>=20
> The primary structure that allows for XFS parallelism is
> xfs_agnumber_t    sb_agcount
>=20
> Making the filesystem with
> mkfs.xfs -d agcount=3D16
>=20
> creates 16 allocations groups of 1.752TB each in our case, 1 per 12
> spindle array.  XFS will read/write to all 16 AGs in parallel, under =
the
> right circumstances, with 1 or multiple  IO streams to/from each 12
> spindle array.  XFS is the only Linux filesystem with this type of
> scalability, again, unless BTRFS has something similar.
>=20
> > What the file system does is only to administer the scheduling of t=
he
> > IO, in combination with the rest of the kernel.
>=20
> Given that XFS has 64xxx lines of code, BTRFS has 46xxx, and EXT4 has
> 29xxx, I think there's a bit more to it than that Keld. ;)  Note that
> XFS has over twice the code size of EXT4.  That's not bloat but
> features, one them being allocation groups.  If your simplistic view =
of
> this was correct we'd have only one Linux filesystem.  Filesystem cod=
e
> does much much more than you realize.

Oh, well, of cause the file system does a lot of things. And I have don=
e
a number of designs and patches to a number of file systems during the =
years.
But I was talking about the overall picture. The CPU power should not b=
e the
bottleneck, the bottleneck is the IO. So we use the kernel code to
administer the IO in the best possible way.  I am also using XFS for
many file systems, but I am also using EXT3, and I think I get
about the same results for the systems I do, which are also a mostly
sequential reading of many big files concurrently (a ftp server).

> > Anyway, thanks for the energy and expertise that you are supplying =
to
> > this thread.
>=20
> High performance systems are one of my passions.  I'm glad to
> participate and share.  Speaking of sharing, after further reading on
> how the parallelism of AGs is done and some other related things, I'm
> changing my recommendation to using only 16 allocation groups of 1.75=
2TB
> with this system, one AG per array, instead of 64 AGs of 438GB.  Usin=
g
> 64 AGs could potentially hinder parallelism in some cases.

Thank you again for your insights
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
