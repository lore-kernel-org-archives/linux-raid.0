From: CoolCold <coolthecold@gmail.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Tue, 14 Feb 2012 01:40:25 +0400
Message-ID: <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
	<4F35E925.6000003@hardwarefreak.com>
	<CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
	<4F38FD5D.1010201@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F38FD5D.1010201@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 13, 2012 at 4:09 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 2/12/2012 2:16 PM, CoolCold wrote:
>> First of all, Stan, thanks for such detailed answer, I greatly appre=
ciate this!
>
> You're welcome. =A0You may or may not appreciate this reply. =A0It go=
t
> really long. =A0I tried to better explain the XFS+md linear array set=
up.
>
>> There are several reasons for this - 1) I've made decision to use LM=
V
>> for all "data" volumes (those are except /, /boot, /home , etc) =A02=
)
>> there will be mysql database which will need backups with snapshots =
3)
>
> So you need LVM for snaps, got it.
>
>> I often have several ( 0-3 ) virtual environments (OpenVZ based) whi=
ch
>> are living on ext3/ext4 (because of extensive metadata updates on xf=
s
>> makes it the whole machine slow) filesystem and different LV because
>> of this.
>
> This is no longer the case as of kernel 2.6.35+ with Dave Chinner's
> delayed logging patch. =A0It's enabled by default in 2.6.39+ and XFS =
now
> has equal or superior metadata performance to all other Linux
> filesystems. =A0This presentation is about an hour long, but it's sup=
er
> interesting and very informative:
> http://www.youtube.com/watch?v=3DFegjLbCnoBw
Yeah, I've seen that video and read LWN article (
http://lwn.net/Articles/476263/ )

>
>> Basing on current storage, estimations show (df -h / df -i ) average
>> file size is ~200kb . Inodes count is near 15 millions and it will b=
e
>> more.
>
> You definitely need the inode64 allocator with that many inodes. =A0Y=
ou
> need it anyway for performance.
>
>> I've just thought that may be I should change chunk size to 256kb,
>> just to let one file be read from one disk, this may increase latenc=
y
>> and increase throughput too.
>
> Why would you do that instead of simply using XFS on a linear array?
>
>> I've drawn nice picture from my head in my original post, it was:
>>
>> A1 A1 A2 A2 A3 A3 A4
>> A4 A5 A5 A6 A6 A7 A7
>> A8 A8 A9 A9 A10 A10 A11
>> A11 ...
>
>> So here is A{X} is chunk number on top of 7 disks. As you can see, 7
>> chunks write (A1 - A7) will fill two rows. And this will made 2 disk
>> head movements to write full stripe, though that moves may be very
>> near to each other. Real situation may differ of course, and I'm not
>> expert to make a bet too.
>
> xfs_info does shows some wonky numbers for sunit/swidth in your examp=
le
> output, but the overall number of write bytes is correct, at 448KB,
> matching the array's apparent 7*64KB. =A0This is double your average =
file
> size so you'll likely have many partial stripe writes. =A0And you won=
't
> get any advantage from device read ahead. =A0You'll actually be wasti=
ng
> buffer cache memory, since each disk will read an extra 128KB. =A0So =
if a
> stripe is actually across 7 spindles, for a single 200KB file read, t=
he
> kernel will read an additional 7*128KB=3D896KB of data into the buffe=
r
> cache. =A0Given the RAID layout and file access pattern, these extra
> caches sectors may not get used right away, simply wasting RAM. =A0To
> alleviate this you'd need to decrease
>
> /sys/block/sdX/queue/read_ahead_kb
>
> accordingly, down to something like 32KB or less, to prevent wasting
> RAM. =A0You may need to tweak other kernel block device queue paramet=
ers
> as well.
As wasting RAM is not good in any case, I'm worrying about disk seeks m=
ore.
On setup with raid10 of 7 drives, I see readahead of 448kb on raid devi=
ce:
root@datastor1:/# cat /sys/block/md3/queue/read_ahead_kb
448

on linear raid (/dev/md6) over 3 mirrors (md3,md4,md5), I see 128kb
readahead and 128kb on individual raid arrays. If I understand
correctly, in first case any read request to /dev/md3 will cause
reading of the full stripe and make every drive to move heads?

>
> If you use a linear concat with XFS, you don't have to worry about an=
y
> of these issues because one file goes on one disk (spindle, mirror
> pair). =A0Read ahead works as it should, no stripe alignment issues,
> maximum performance for your small file workload.

>
>> Hundreds directories at least, yes.
>
> So as long as the most popular content is not put in a single directo=
ry
> or two that reside on the same disk causing an IO hotspot, XFS+linear
> will work very well for this workload. =A0The key is spreading the
> frequently accessed files across all the allocation groups. =A0But, i=
f the
> popular content all gets cache in RAM, it doesn't matter. =A0Any othe=
r
> content accesses will be random, so you're fine there.
I guess with only 12gb of ram, every access going to be random ;)

> Note that the
> first 4 directories you create will be in the first 4 AGs on the firs=
t
> disk, so don't concentrate all your frequently accessed stuff in the
> first 4 dirs. =A0With the XFS+linear setup I described before, you en=
d up
> with an on disk filesystem layout like this:
>
> =A0 =A0 =A0 =A0 ------- =A0 =A0 =A0 =A0 ------- =A0 =A0 =A0 =A0 -----=
--
> =A0 =A0 =A0 =A0| =A0AG1 =A0| =A0 =A0 =A0 | =A0AG5 =A0| =A0 =A0 =A0 | =
=A0AG9 =A0|
> =A0 =A0 =A0 =A0| =A0AG2 =A0| =A0 =A0 =A0 | =A0AG6 =A0| =A0 =A0 =A0 | =
=A0AG10 |
> =A0 =A0 =A0 =A0| =A0AG3 =A0| =A0 =A0 =A0 | =A0AG7 =A0| =A0 =A0 =A0 | =
=A0AG11 |
> =A0 =A0 =A0 =A0| =A0AG4 =A0| =A0 =A0 =A0 | =A0AG8 =A0| =A0 =A0 =A0 | =
=A0AG12 |
> =A0 =A0 =A0 =A0 ------- =A0 =A0 =A0 =A0 ------- =A0 =A0 =A0 =A0 -----=
--
> =A0 =A0 =A0 =A0 disk 1 =A0 =A0 =A0 =A0 =A0disk 2 =A0 =A0 =A0 =A0 =A0d=
isk 3
>
>
> This AG layout is a direct result of the linear array. =A0If this wer=
e a 3
> spindle striped array, each AG would span all 3 disks horizontally, a=
nd
> you'd have AGs 1-12 in a vertically column, one 3rd of each AG on eac=
h
> disk. =A0If you're thinking ahead you may already see one of the
> advantages of this setup WRT metadata performance.
Pretty clear & self-explaining picture, thanks.

>
> Using the inode64 allocator, directory creation will occur in allocat=
ion
> group order, putting the first 4 directories you create in the first
> four respective AGs on disk 1. =A0Directory 13 will be created in AG1=
, as
> will dir25 and dir37, and so on. =A0Each file created in a directory =
will
> reside within the AG where its parent dir resides.
>
> This is primarily what allows XFS+linear to have fantastic parallel
> small file random access performance.
>
>> After reading you ideas and refinements, I'm making conclusion that =
I
>> need to push others [team members] harder to remove mysql instances
>> from the static files serving boxes at all, to free RAM for least
>> dcache entries.
>
> That or simply limit the amount of memory mysql is allowed to allocat=
e.
> =A0If you're serving mostly static content, what's the database for? =
=A0User
> accounts and login processing? =A0Interactive forum like phpBB?
In short - database stores pages (contents) . There are several pros
for leaving database on every server - 1st) full servers independacies
2) if share database over the network, it going to cost additional
money for traffice payments (traffic may be billed even across
datacenters of the same hoster, when leaving switch )

>
>> About avoiding striping - later in the text.
>
>> Hetzner's guys were pretty fast on chaning failed disks (one - two
>> days after claim) so I may try without spares I guess... I just wann=
a
>> use more independent spindles here,
>
> If the box came with only 6 data drives would you be asking them to a=
dd
> a seventh? =A0I believe you have a personality type that makes that 7=
th
> odd drive an itch you must simply scratch. ;) =A0"It's there so I MUS=
T use
> it!" =A0Make it your snap target then. =A0It'll keep tape/etc IO off =
the
> array when you backup the snaps. =A0There, itch scratched. ;)
>
>>> That will give you 12 allocation groups of 750GB each, 4 AGs per
>>> effective spindle. =A0Using too many AGs will cause excessive head =
seeking
>>> under load, especially with a low disk count in the array. =A0The m=
kfs.xfs
>>> agcount default is 4 for this reason. =A0As a general rule you want=
 a
>>> lower agcount when using low RPM drives (5.9k, 7.2k) and a higher
>>> agcount with fast drives (10k, 15k).
>> Good to know such details!
>
> There's a little black magic to manual AG creation, but that's the
> basics. =A0But it depends quite a bit on the workload.
>
>> So, as I could understand, you are assuming that "internal striping"
>> by using AGs of XFS will be better than MD/LVM striping here? Never
>> thought of XFS in this way and it is interesting point.
>
> Most people know very very little about XFS, which is ironic given it=
's
> capabilities dwarf those of EXT, Reiser, JFS, etc. =A0That will start=
 to
> change as Red Hat and other distros make it the default filesystem.
>
> There is no striping involved as noted in my diagram and explanation
> above. =A0This is an md _linear_ array. =A0You've probably never read=
 of the
> md --linear option. =A0Nobody (few) uses it because they've simply ha=
d
> "striping, striping, striping" drilled into their skulls, and they us=
e
> EXT filesystems, which absolutely REQUIRE striping to get decent
> performance. =A0XFS has superior technology, has since the 90s, and d=
oes
> not necessarily require striping to get decent performance. =A0As alw=
ays,
> it depends on the workload and access pattern.
By striping, in general, I mean common idea of distributing data in
portions over several devices, not the real granularity of bytes. So
if one dir keeps data on DISK1, another dir on DISK2 and so on, I'm
calling it "striped over DISK1, DISK2..."

>
> http://linux.die.net/man/4/md
>
> And I'm sure you've never read about XFS internal structure:
>
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-=
US/html/Allocation_Groups.html
No, didn't met that link before, thanks. I'm sneaking around on #xfs @
freenode, reading something useful sometimes, though.

>
> XFS + md linear array-- Let me repeat this so there is no
> misunderstanding, that we're talking about one of many possible XFS
> configurations: =A0 *XFS + md linear array* =A0is extremely fast for =
the
> highly parallel small file random access workload because it:
>
> 1. =A0Eliminates the complexities and buffering delays of data alignm=
ent
> to an md striped array. =A0While fast and trivial, these operations a=
dd
> more and more overhead as the workload increases. =A0At high IOPS the=
y are
> longer trivial. =A0Here, XFS instead simply sends the data directly t=
o md,
> which calculates the sector offset in the linear array and writes the
> blocks to disk.
>
> 2. =A0mdraid doesn't have to perform any striping offset calculations=
=2E
> Again, while trivial, these calculations add overhead as workload
> increases. =A0And unlike the linear and RAID0 drivers, the mdraid10 d=
river
> has a single master thread, meaning absolute IO performance can be
> limited by a single CPU if there are enough fast disks in the RAID10
> array and the CPUs in the system aren't fast enough to keep up. =A0Se=
arch
> to list archives for instances of this issue.
>
> 3. =A0I already mentioned the disk read ahead advantage vs mdraid10. =
=A0It
> can be significant, in terms of file access latency, and memory
> consumption due to wasted buffer cache space. =A0If one is using a
> hardware RAID solution this advantage disappears, as the read ahead h=
its
> the RAID cache one per request. =A0It's no longer per drive as with m=
draid
> because Linux treats the hardware RAID as a single block device. =A0I=
t
> can't see the individual drives behind the controller, in this regard
> anyway, thus doesn't perform read ahead on each drive.
>
> 4. =A0Fewer disk seeks for metadata reads are required. =A0With a str=
iped
> array + XFS a single metadata lookup can potentially cause a seek on
> every spindle in the array because each AG and its metadata span all
> spindles in the stripe. =A0Withe XFS + linear a given metadata lookup=
 for
> a file generates one seek in only one AG on one spindle.
Mmm, clear, got it.

>
> There are other advantages but I'm getting tired of typing. ;) =A0If
> you're truly curious and wish to learn there is valuable information =
in
> the mdraid kernel documentation, as well as at xfs.org. =A0You probab=
ly
> won't find much on this specific combination, but you can learn enoug=
h
> about each mdraid and xfs to better understand why this combo works.
> This stuff isn't beginner level reading, mind you. =A0You need a pret=
ty
> deep technical background in Linux and storage technology. =A0Which i=
s
> maybe why I've done such a poor job explaining this. ;)
>
>> P.S. As I've got 2nd server of the same config, may be i'll have tim=
e
>> and do fast & dirty tests of stripes vs AGs.
>
> Fast and dirty tests will not be sufficient to know how either will
> perform with your actual workload. =A0And if by fast & dirty you mean
> something like
>
> $ dd if=3D/dev/md2 of=3D/dev/null bs=3D8192 count=3D800000
>
> then you will be superbly disappointed. =A0What makes the XFS linear =
array
> very fast with huge amounts of random small file IO makes it very slo=
w
> with large single file reads/writes, because each file resides on a
> single spindle, limiting you to ~120MB/s. =A0Again, this is not strip=
ed
> RAID. =A0This linear array setup is designed for maximum parallel sma=
ll
> file throughput. =A0So if you want to see those "big dd" numbers that=
 make
> folks salivate, you'd need something like
>
> dd if=3D/mountpt/directory1/bigfile.test of=3D/dev/null &
> dd if=3D/mountpt/directory5/bigfile.test of=3D/dev/null &
> dd if=3D/mountpt/directory9/bigfile.test of=3D/dev/null &
>
Okay, this is clear.

> and then sum the 3 results. =A0Again, XFS speed atop the linear array
> comes from concurrent file access, which is exactly what your stated
> workload is, and thus why I recommended this setup. =A0To properly te=
st
> this synthetically may likely require something other than vanilla
> benchies such as bonnie or iozone.

Yes, by "quick & dirty" test I usually mean iozone tests like "iozone
-s 1g -I -i 0 -i 1 -i 2 -r 64 -t 16 -F file1 file2 file3 file4 file5
file6 file7 file8 file9 file10 file11 file12 file13 file14 file15
file16" or at least "dd if=3D/db of=3D/dev/null iflag=3Ddirect bs=3D512=
k". May
be will try fs_mark, mentioned by Dave Chinner.

I'm writing down results here (not agregated form, just raw data) -
https://docs.google.com/document/d/1PXRCjcVWaxzFCOFFbv812gDUkcMk2-lvpeH=
dtroN1uw/edit

While doing this dirty tests, I've seen found that linear md over 3
subvolumes doesn't support barriers and XFS states this:
=46eb 13 21:39:41 sigma2 kernel: [22336.925917] Filesystem "md6":
Disabling barriers, trial barrier write failed
though this doesn't help on iozone random write tests

>
> I would recommend copying 48k of those actual picture files evenly
> across 12 directories, for 4K files per dir. =A0Then use something li=
ke
> curl-loader with a whole lot of simulated clients to hammer on the
> files. =A0This allows you to test web server performance and IO
> performance simultaneously.

Yes, this will be more realistic, of course.

>
> --
> Stan



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
