From: CoolCold <coolthecold@gmail.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 00:16:30 +0400
Message-ID: <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
	<4F35E925.6000003@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F35E925.6000003@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46irst of all, Stan, thanks for such detailed answer, I greatly apprec=
iate this!

On Sat, Feb 11, 2012 at 8:05 AM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 2/10/2012 9:17 AM, CoolCold wrote:
>> I've got server with 7 SATA drives ( Hetzner's XS13 to be precise )
>> and created mdadm's raid10 with two near copies, then put LVM on it.
>> Now I'm planning to create xfs filesystem, but a bit confused about
>> stripe width/stripe unit values.
>
> Why use LVM at all? =A0Snapshots? =A0The XS13 has no option for more =
drives
> so it can't be for expansion flexibility. =A0If you don't 'need' LVM =
don't
> use it. =A0It unnecessarily complicates your setup and can degrade
> performance.
There are several reasons for this - 1) I've made decision to use LMV
for all "data" volumes (those are except /, /boot, /home , etc)  2)
there will be mysql database which will need backups with snapshots 3)
I often have several ( 0-3 ) virtual environments (OpenVZ based) which
are living on ext3/ext4 (because of extensive metadata updates on xfs
makes it the whole machine slow) filesystem and different LV because
of this.

>
>> As drives count is 7 and copies count is 2, so simple calculation
>> gives me datadrives count "3.5" which looks ugly. If I understand th=
e
>> whole idea of sunit/swidth right, it should fill (or buffer) the ful=
l
>> stripe (sunit * data disks) and then do write, so optimization takes
>> place and all disks will work at once.
>
> Pretty close. =A0Stripe alignment is only applicable to allocation i.=
e new
> file creation, and log journal writes, but not file re-write nor read
> ops. =A0Note that stripe alignment will gain you nothing if your
> allocation workload doesn't match the stripe alignment. =A0For exampl=
e
> writing a 32KB file every 20 seconds. =A0It'll take too long to fill =
the
> buffer before it's flushed and it's a tiny file, so you'll end up wit=
h
> many partial stripe width writes.
Okay, got it - I've thinked in similar way.
>
>> My read load going be near random read ( sending pictures over http =
)
>> and looks like it doesn't matter how it will be set with sunit/swidt=
h.
>
> ~13TB of "pictures" to serve eh? =A0Average JPG file size will be
> relatively small, correct? =A0Less than 1MB? =A0No, stripe alignment =
won't
> really help this workload at all, unless you upload a million files i=
n
> one shot to populate the server. =A0In that case alignment will make =
the
> process complete more quickly.
Basing on current storage, estimations show (df -h / df -i ) average
file size is ~200kb . Inodes count is near 15 millions and it will be
more.
I've just thought that may be I should change chunk size to 256kb,
just to let one file be read from one disk, this may increase latency
and increase throughput too.

>
>> =A0 =A0 root@datastor1:~# cat /proc/mdstat
>> =A0 =A0 Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [rai=
d10]
>> =A0 =A0 md3 : active raid10 sdg5[6] sdf5[5] sde5[4] sdd5[3] sdc5[2] =
sdb5[1] sda5[0]
>> =A0 =A0 =A0 =A0 =A0 10106943808 blocks super 1.2 64K chunks 2 near-c=
opies [7/7] [UUUUUUU]
>> =A0 =A0 =A0 =A0 =A0 [>....................] =A0resync =3D =A00.8%
>> (81543680/10106943808) finish=3D886.0min speed=3D188570K/sec
>> =A0 =A0 =A0 =A0 =A0 bitmap: 76/76 pages [304KB], 65536KB chunk
>
>> Almost default mkfs.xfs creating options produced:
>>
>> =A0 =A0 root@datastor1:~# mkfs.xfs -l lazy-count=3D1 /dev/data/db -f
>> =A0 =A0 meta-data=3D/dev/data/db =A0 =A0 =A0 isize=3D256 =A0 =A0agco=
unt=3D32, agsize=3D16777216 blks
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sectsz=3D512 =A0 attr=3D2, projid32bit=3D0
>> =A0 =A0 data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 bsize=3D4096 =A0 blocks=3D536870912, imaxpct=3D5
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sunit=3D16 =A0 =A0 swidth=3D112 blks
>> =A0 =A0 naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4=
096 =A0 ascii-ci=3D0
>> =A0 =A0 log =A0 =A0 =A0=3Dinternal log =A0 =A0 =A0 =A0 =A0 bsize=3D4=
096 =A0 blocks=3D262144, version=3D2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sectsz=3D512 =A0 sunit=3D16 blks, lazy-count=3D1
>> =A0 =A0 realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D=
4096 =A0 blocks=3D0, rtextents=3D0
>>
>>
>> As I can see, it is created 112/16 =3D 7 chunks swidth, which correl=
ate
>> with my version b) , and I guess I will leave it this way.
>
> The default mkfs.xfs algorithms don't seem to play well with the
> mdraid10 near/far copy layouts. =A0The above configuration is doing a=
 7
> spindle stripe of 64KB, for a 448KB total stripe size. =A0This doesn'=
t
> seem correct, as I don't believe a 7 drive RAID10 near is giving you =
7
> spindles of stripe width. =A0I'm no expert on the near/far layouts, s=
o I
> could be wrong here. =A0If a RAID0 stripe would yield a 7 spindle str=
ipe
> width, I don't see how a RAID10/near would also be 7. =A0A straight R=
AID10
> with 8 drives would give a 4 spindle stripe width.

I've drawn nice picture from my head in my original post, it was:

A1 A1 A2 A2 A3 A3 A4
A4 A5 A5 A6 A6 A7 A7
A8 A8 A9 A9 A10 A10 A11
A11 ...

So here is A{X} is chunk number on top of 7 disks. As you can see, 7
chunks write (A1 - A7) will fill two rows. And this will made 2 disk
head movements to write full stripe, though that moves may be very
near to each other. Real situation may differ of course, and I'm not
expert to make a bet too.

>
>> So, I'll be glad if anyone can review my thoughts and share yours.
>
> To provide you with any kind of concrete real world advice we need mo=
re
> details about your write workload/pattern. =A0In absence of that, and
> given what you've already stated, that the application is "sending
> pictures over http", then this seems to be a standard static web serv=
er
> workload. =A0In that case disk access, especially write throughput, i=
s
> mostly irrelevant, as memory capacity becomes the performance limitin=
g
> factor. =A0Given that you have 12GB of RAM for Apache/nginx/Lighty an=
d
> buffer cache, how you setup the storage probably isn't going to make =
a
> big difference from a performance standpoint.
Yes, this is standard static webserver workload with nginx as frontend
with almost only reads.


>
> That said, for this web server workload, you'll be better off it you
> avoid any kind of striping altogether, especially if using XFS. =A0Yo=
u'll
> be dealing with millions of small picture files I assume, in hundreds=
 or
> thousands of directories? =A0In that case play to XFS' strengths. =A0=
Here's
> how you do it:
Hundreds directories at least, yes.
After reading you ideas and refinements, I'm making conclusion that I
need to push others [team members] harder to remove mysql instances
from the static files serving boxes at all, to free RAM for least
dcache entries.

About avoiding striping - later in the text.

>
> 1. =A0You chose mdraid10/near strictly because you have 7 disks and w=
anted
> to use them all. =A0You must eliminate that mindset. =A0Redo the arra=
y with
> 6 disks leaving the 7th as a spare (smart thing to do anyway). =A0Wha=
t can
> you really to with 10.5TB that you can't with 9TB?
Hetzner's guys were pretty fast on chaning failed disks (one - two
days after claim) so I may try without spares I guess... I just wanna
use more independent spindles here, but I'll think about your
suggestion one more time, thanks.

>
> 2. =A0Take your 6 disks and create 3 mdraid1 mirror pairs--don't use
> partitions as these are surely Advanced Format drives. =A0Now take th=
ose 3
> mdraid mirror devices and create a layered mdraid --linear array of t=
he
> three. =A0The result will be a ~9TB mdraid device.
>
> 3. =A0Using a linear concat of 3 mirrors with XFS will yield some
> advantages over a striped array for this picture serving workload.
> Format the array with:
>
> /$ mkfs.xfs -d agcount=3D12 /dev/mdx
>
> That will give you 12 allocation groups of 750GB each, 4 AGs per
> effective spindle. =A0Using too many AGs will cause excessive head se=
eking
> under load, especially with a low disk count in the array. =A0The mkf=
s.xfs
> agcount default is 4 for this reason. =A0As a general rule you want a
> lower agcount when using low RPM drives (5.9k, 7.2k) and a higher
> agcount with fast drives (10k, 15k).
Good to know such details!

>
> Directories drive XFS parallelism, with each directory being created =
in
> a different AG, allowing XFS to write/read 12 files in parallel (far =
in
> excess of the IO capabilities of the 3 drives) without having to worr=
y
> about stripe alignment. =A0Since your file layout will have many hund=
reds
> or thousands of directories and millions of files, you'll get maximum
> performance from this setup.

So, as I could understand, you are assuming that "internal striping"
by using AGs of XFS will be better than MD/LVM striping here? Never
thought of XFS in this way and it is interesting point.

>
> As I said, if I understand your workload correctly, array/filesystem
> layout probably don't make much difference. =A0But if you're after
> something optimal and less complicated, for piece of mind, etc, this =
is
> a better solution than the 7 disk RAID10 near layout with XFS.
>
> Oh, and don't forget to mount the XFS filesystem with the inode64 opt=
ion
> in any case, lest performance will be much less than optimal, and you
> may run out of directory inodes as the FS fills up.
Okay.

>
> Hope this information was helpful.
Yes, very helpful and refreshing, thanks for you comments!

P.S. As I've got 2nd server of the same config, may be i'll have time
and do fast & dirty tests of stripes vs AGs.
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
