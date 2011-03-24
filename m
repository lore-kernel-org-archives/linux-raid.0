From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: high throughput storage server?
Date: Thu, 24 Mar 2011 05:07:53 -0300
Message-ID: <AANLkTin7W9XSDMrhah2j9R53J8UHm0W0YbV6A7EKVt1N@mail.gmail.com>
References: <4D837DAF.6060107@hardwarefreak.com>
	<20110319090101.1786cc2a@notabene.brown>
	<4D8559A2.6080209@hardwarefreak.com>
	<20110320144147.29141f04@notabene.brown>
	<AANLkTi=2k2=YuZAggonLfKmRFxFd-rXvNo=xkpqWyQNU@mail.gmail.com>
	<4D868C36.5050304@hardwarefreak.com>
	<20110321024452.GA23100@www2.open-std.org>
	<4D875E51.50807@hardwarefreak.com>
	<20110321221304.GA900@www2.open-std.org>
	<20110322094658.GA21078@cthulhu.home.robinhill.me.uk>
	<20110322101403.GA9329@www2.open-std.org>
	<4D89B519.3020907@hardwarefreak.com>
	<AANLkTinONtwNh9KZKe98FL+u2GV_Fqaf1zR8eMyEDGBp@mail.gmail.com>
	<4D8ADC00.5010709@hardwarefreak.com>
	<20110324173343.7d0491d8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110324173343.7d0491d8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Mdadm <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

i will read xfs again, but check, if i'm thinking wrong or right...

i see two ideas about raid0 (i/o rate vs many users)

first lets think that raid0 is somethink like a harddisk firmware....
the problem: we have many plastes/heads and just one arm.

a hard disk =3D many plates+many heads+ only one arm to move heads(mayb=
e
in future we can use many arms in only one harddisk!)
plates=3Dmany sectors=3Dmany bits (harddisk works like NOR memories, on=
ly
with bits, not with bytes or pages like NAND memories, for bytes it
must head based (stripe) or many reads (time consuming) )

firmware will use:
raid0 stripe =3D> make group of bits from diferent plates/heads
(1,2,3,4,5) a 'block/byte/character' unit (if you have 8heads you can
read a byte with only one 'read all heads bits' command, and merge
bits from head1,2,3,4,5,6,7,8 and get a byte, it can be done in
parallel like raid0 stripe do on linux software raid, with only 1
cycle of read)
raid0 linear =3D> read many bits from a plate to create a 'sector' of
bits (a 'block unit' too) this can only be done in sequential read
(many cycles of read); wait read of bit1 to read bit2,3,4,5,6,7,8,9...
different from stripe where you send many reads after all reads will
merge bits to get a byte)

-----
it's like a 3Ghz cpu with 1 core vs 1Ghz cpu with 3 cores, what's fast?
if you need just 1 cycle of cpu, 3ghz is faster
the problem with harddisk is just one: random reads.
think about a mix of ssd and harddisks (there's some disks that have
it! did you tried? they are nice! there's a bcache and one facebook
linux kernel module to emulate this at o.s.) you will not have the
random read problem, since ssd is very good for random read
-----
the only magics i think a filesystem can do is:
1)online compression - think about 32MB blocks, and if read 12MB
compressed information you can have 32MB of uncompressed information,
if you want more information you will need to jump to sector of next
32MB block, you could use stripe at raid0 here to allow second disk to
be used and don't wait access time of first disk
2)group of similar file access (i think it's what xfs call about
allocation groups). could be done by statistics about: acesstime, read
rate, write rate, filesize, create/delete file rate, file type
(symbolick links, directory, files, devices, pipes, etc), metadata,
journaling
3)how device works: good for write, good for read, good for sequencial
read (few arms-stripe), good for random read(ssd), good for multi task
(many arms-linear)
----------------

reading about harddisks informations at database forums/blogs
(intensive disk users)...
harddisks work better with big blocks since it will get a small
acesstime to read more information...
read rate =3D bytes read / total time.
total time =3D accesstime+read time.
accesstime=3Darm positioning+disk positioning,
read time=3Ddisk speed (7200rpm, 10krpm, 15krpm...) and sector nits per
disk revolution for harddisks.

thinking about this... sequencial reads are fast, random reads are slow

how to optimise random reads? read ahead, raid0 (a arm for each group o=
f sector)
how filesystem can optimize random reads? try to not fragment most
access file, put they close, convert random reads use to cache
sequencial information, use of statistic of most read, most write,
file size, create/delete rate, etc to select betters candidates of
futures use (preditive idea)

i think it's all filesystem and raid0 could do

2011/3/24 NeilBrown <neilb@suse.de>:
> On Thu, 24 Mar 2011 00:52:00 -0500 Stan Hoeppner <stan@hardwarefreak.=
com>
> wrote:
>
>> If you write a file much smaller than the stripe size, say a 1MB fil=
e,
>> to the filesystem atop this wide RAID10, the file will only be strip=
ed
>> across 16 of the 192 spindles, with 64KB going to each stripe member=
, 16
>> filesystem blocks, 128 sectors. =A0I don't know about mdraid, but wi=
th
>> many hardware RAID striping implementations the remaining 176 disks =
in
>> the stripe will have zeros or nulls written for their portion of the
>> stripe for this file that is a tiny fraction of the stripe size.
>
> This doesn't make any sense at all. =A0No RAID - hardware or otherwis=
e - is
> going to write zeros to most of the stripe like this. =A0The RAID doe=
sn't even
> know about the concept of a file, so it couldn't.
> The filesystem places files in the virtual device that is the array, =
and the
> RAID just spreads those blocks out across the various devices.
>
> There will be no space wastage.
>
> If you have a 1MB file, then there is no way you can ever get useful =
192-way
> parallelism across that file. =A0Bit if you have 192 1MB files, then =
they will
> be spread even across your spindles some how (depending on FS and RAI=
D level)
> and if you have multiple concurrent accessors, they could well get cl=
ose to
> 192-way parallelism.
>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
