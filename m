From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Tue, 22 Mar 2011 05:00:40 -0500
Message-ID: <4D887348.3030902@hardwarefreak.com>
References: <4D835B2A.1000805@hardwarefreak.com> <20110318140509.GA26226@infradead.org> <4D837DAF.6060107@hardwarefreak.com> <20110319090101.1786cc2a@notabene.brown> <4D8559A2.6080209@hardwarefreak.com> <20110320144147.29141f04@notabene.brown> <AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com> <4D868C36.5050304@hardwarefreak.com> <20110321024452.GA23100@www2.open-std.org> <4D875E51.50807@hardwarefreak.com> <20110321221304.GA900@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110321221304.GA900@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Mdadm <linux-raid@vger.kernel.org>, Roberto Spadim <roberto@spadim.com.br>, NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 3/21/2011 5:13 PM:
> On Mon, Mar 21, 2011 at 09:18:57AM -0500, Stan Hoeppner wrote:
>> Keld J=F8rn Simonsen put forth on 3/20/2011 9:44 PM:
>>
>>> Are you then building the system yourself, and running Linux MD RAI=
D?
>>
>> No.  These specifications meet the needs of Matt Garman's analysis
>> cluster, and extend that performance from 6GB/s to 10GB/s.  Christop=
h's
>> comments about 10GB/s throughput with XFS on large CPU count Altix 4=
000
>> series machines from a few years ago prompted me to specify a single
>> chassis multicore AMD Opteron based system that can achieve the same
>> throughput at substantially lower cost.
>=20
> OK, But I understand that this is running Linux MD RAID, and not some
> hardware RAID. True?
>=20
> Or at least Linux MD RAID is used to build a --linear FS.
> Then why not use Linux MD to make the underlying RAID1+0 arrays?

Using mdadm --linear is a requirement of this system specification.  Th=
e
underlying RAID10 arrays can be either HBA RAID or mdraid.  Note my
recent questions to Neil regarding mdraid CPU consumption across 16
cores with 16 x 24 drive mdraid 10 arrays.

>>> Anyway, with 384 spindles and only 50 users, each user will have in
>>> average 7 spindles for himself. I think much of the time this would=
 mean=20
>>> no random IO, as most users are doing large sequential reading.=20
>>> Thus on average you can expect quite close to striping speed if you
>>> are running RAID capable of striping.=20
>>
>> This is not how large scale shared RAID storage works under a
>> multi-stream workload.  I thought I explained this in sufficient det=
ail.
>>  Maybe not.
>=20
> Given that the whole array system is only lightly loaded, this is how=
 I
> expect it to function. Maybe you can explain why it would not be so, =
if
> you think otherwise.

Using the term "lightly loaded" to describe any system sustaining
concurrent 10GB/s block IO and NFS throughput doesn't seem to be an
accurate statement.  I think you're confusing theoretical maximum
hardware performance with real world IO performance.  The former is
always significantly higher than the latter.  With this in mind, as wit=
h
any well designed system, I specified this system to have some headroom=
,
as I previously stated.  Everything we've discussed so far WRT this
system has been strictly parallel reads.

Now, if 10 cluster nodes are added with an application that performs
streaming writes, occurring concurrently with the 50 streaming reads,
we've just significantly increased the amount of head seeking on our
disks.  The combined IO workload is now a mixed heavy random read/write
workload.  This is the most difficult type of workload for any RAID
subsystem.  It would bring most parity RAID arrays to their knees.  Thi=
s
is one of the reasons why RAID10 is the only suitable RAID level for
this type of system.

>> In summary, concatenating many relatively low stripe spindle count
>> arrays, and using XFS allocation groups to achieve parallel scalabil=
ity,
>> gives us the performance we want without the problems associated wit=
h
>> other configurations.

> it is probably not the concurrency of XFS that makes the parallelism =
of
> the IO.=20

It most certainly is the parallelism of XFS.  There are some caveats to
the amount of XFS IO parallelism that are workload dependent.  But
generally, with multiple processes/threads reading/writing multiple
files in multiple directories, the device parallelism is very high.  Fo=
r
example:

If you have 50 NFS clients all reading the same large 20GB file
concurrently, IO parallelism will be limited to the 12 stripe spindles
on the single underlying RAID array upon which the AG holding this file
resides.  If no other files in the AG are being accessed at the time,
you'll get something like 1.8GB/s throughput for this 20GB file.  Since
the bulk, if not all, of this file will get cached during the read, all
50 NFS clients will likely be served from cache at their line rate of
200MB/s, or 10GB/s aggregate.  There's that magic 10GB/s number again.
;)  As you can see I put some serious thought into this system
specification.

If you have all 50 NFS clients accessing 50 different files in 50
different directories you have no cache benefit.  But we will have file=
s
residing in all allocations groups on all 16 arrays.  Since XFS evenly
distributes new directories across AGs when the directories are created=
,
we can probably assume we'll have parallel IO across all 16 arrays with
this workload.  Since each array can stream reads at 1.8GB/s, that's
potential parallel throughput of 28GB/s, saturating our PCIe bus
bandwidth of 16GB/s.

Now change this to 50 clients each doing 10,000 4KB file reads in a
directory along with 10,000 4KB file writes.  The throughput of each 12
disk array may now drop by over a factor of approximately 128, as each
disk can only sustain about 300 head seeks/second, dropping its
throughput to 300 * 4096 bytes =3D 1.17MB/s.  Kernel readahead may help
some, but it'll still suck.

It is the occasional workload such as that above that dictates
overbuilding the disk subsystem.  Imagine adding a high IOPS NFS client
workload to this server after it went into production to "only" serve
large streaming reads.  The random workload above would drop the
performance of this 384 disk array with 15k spindles from a peak
streaming rate of 28.4GB/s to 18MB/s--yes, that's megabytes.

With one workload the disks can saturate the PCIe bus by almost a facto=
r
of two.  With an opposite workload the disks can only transfer one
14,000th of the PCIe bandwidth.  This is why Fortune 500 companies and
others with extremely high random IO workloads such as databases, and
plenty of cash, have farms with multiple thousands of disks attached to
database and other servers.

> It is more likely the IO system, and that would also work for
> other file system types, like ext4.=20

No.  Upper kernel layers doesn't provide this parallelism.  This is
strictly an XFS feature, although JFS had something similar (and JFS is
now all but dead), though not as performant.  BTRFS might have somethin=
g
similar but I've read nothing about BTRFS internals.  Because XFS has
simply been the king of scalable filesystems for 15 years, and added
great new capability along the way, all of the other filesystem
developers have started to steal ideas from XFS.   IIRC Ted T'so stole
some things from XFS for use in EXT4, but allocation groups wasn't one
of them.

> I do not see anything in the XFS allocation
> blocks with any knowledge of the underlying disk structure.=20

The primary structure that allows for XFS parallelism is
xfs_agnumber_t    sb_agcount

Making the filesystem with
mkfs.xfs -d agcount=3D16

creates 16 allocations groups of 1.752TB each in our case, 1 per 12
spindle array.  XFS will read/write to all 16 AGs in parallel, under th=
e
right circumstances, with 1 or multiple  IO streams to/from each 12
spindle array.  XFS is the only Linux filesystem with this type of
scalability, again, unless BTRFS has something similar.

> What the file system does is only to administer the scheduling of the
> IO, in combination with the rest of the kernel.

Given that XFS has 64xxx lines of code, BTRFS has 46xxx, and EXT4 has
29xxx, I think there's a bit more to it than that Keld. ;)  Note that
XFS has over twice the code size of EXT4.  That's not bloat but
features, one them being allocation groups.  If your simplistic view of
this was correct we'd have only one Linux filesystem.  Filesystem code
does much much more than you realize.

> Anyway, thanks for the energy and expertise that you are supplying to
> this thread.

High performance systems are one of my passions.  I'm glad to
participate and share.  Speaking of sharing, after further reading on
how the parallelism of AGs is done and some other related things, I'm
changing my recommendation to using only 16 allocation groups of 1.752T=
B
with this system, one AG per array, instead of 64 AGs of 438GB.  Using
64 AGs could potentially hinder parallelism in some cases.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
