From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: The huge different performance of sequential read between RAID0  and RAID5
Date: Fri, 29 Jan 2010 12:53:24 +0100
Message-ID: <873a1p86vf.fsf@frosties.localdomain>
References: <100eff551001271916y116de081la77982f4b5a03c73@mail.gmail.com>
	<20100128070606.GD3098@boogie.lpds.sztaki.hu>
	<100eff551001280631h7de01ba6n52d79fdfcea9445e@mail.gmail.com>
	<20100128144118.GB17369@twister.selfip.org>
	<100eff551001280655r2e173286nfca3dbf688609571@mail.gmail.com>
	<20100128152755.GA23933@cthulhu.home.robinhill.me.uk>
	<4877c76c1001282205m280049b8y34253fc8f5062d0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1001282205m280049b8y34253fc8f5062d0f@mail.gmail.com>
	(Michael Evans's message of "Thu, 28 Jan 2010 22:05:47 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> On Thu, Jan 28, 2010 at 7:27 AM, Robin Hill <robin@robinhill.me.uk> w=
rote:
>> On Thu Jan 28, 2010 at 09:55:05AM -0500, Yuehai Xu wrote:
>>
>>> 2010/1/28 Gabor Gombas <gombasg@sztaki.hu>:
>>> > On Thu, Jan 28, 2010 at 09:31:23AM -0500, Yuehai Xu wrote:
>>> >
>>> >> >> md0 : active raid5 sdh1[7] sdg1[5] sdf1[4] sde1[3] sdd1[2] sd=
c1[1] sdb1[0]
>>> >> >> =A0 =A0 =A0 631353600 blocks level 5, 64k chunk, algorithm 2 =
[7/6] [UUUUUU_]
>>> > [...]
>>> >
>>> >> I don't think any of my drive fail because there is no "F" in my
>>> >> /proc/mdstat output
>>> >
>>> > It's not failed, it's simply missing. Either it was unavailable w=
hen the
>>> > array was assembled, or you've explicitely created/assembled the =
array
>>> > with a missing drive.
>>>
>>> I noticed that, thanks! Is it usual that at the beginning of each
>>> setup, there is one missing drive?
>>>
>> Yes - in order to make the array available as quickly as possible, i=
t is
>> initially created as a degraded array. =A0The recovery is then run t=
o
>> add in the extra disk. =A0Otherwise all disks would need to be writt=
en
>> before the array became available.
>>
>>> >
>>> >> How do you know my RAID5 array has one drive missing?
>>> >
>>> > Look at the above output: there are just 6 of the 7 drives availa=
ble,
>>> > and the underscore also means a missing drive.
>>> >
>>> >> I tried to setup RAID5 with 5 disks, 3 disks, after each setup,
>>> >> recovery has always been done.
>>> >
>>> > Of course.
>>> >
>>> >> However, if I format my md0 with such command:
>>> >> mkfs.ext3 -b 4096 -E stride=3D16 -E stripe-width=3D*** /dev/XXXX=
, the
>>> >> performance for RAID5 becomes usual, at about 200~300M/s.
>>> >
>>> > I suppose in that case you had all the disks present in the array=
=2E
>>>
>>> Yes, I did my test after the recovery, in that case, does the "miss=
ing
>>> drive" hurt the performance?
>>>
>> If you had a missing drive in the array when running the test, then =
this
>> would definitely affect the performance (as the array would need to =
do
>> parity calculations for most stripes). =A0However, as you've not act=
ually
>> given the /proc/mdstat output for the array post-recovery then I don=
't
>> know whether or not this was the case.
>>
>> Generally, I wouldn't expect the RAID5 array to be that much slower =
than
>> a RAID0. =A0You'd best check that the various parameters (chunk size=
,
>> stripe cache size, readahead, etc) are the same for both arrays, as
>> these can have a major impact on performance.
>>
>> Cheers,
>> =A0 =A0Robin
>> --
>> =A0 =A0 ___
>> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@=
robinhill.me.uk> |
>> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 |
>>
>
> A more valid test that could be run would follow:
>
> Assemble all the test drives as a raid-5 array (you can zero the
> drives any way you like and then --assume-clean if they really are al=
l
> zeros) and let the resync complete.
>
> Run any tests you like.
>
> Stop and --zero-superblock on the array.
>
> Create a striped array (raid 0) using all but one of the test drives.
>
> Since you dropped the drive's worth of storage that would be dedicate=
d
> to parity in the raid-5 setup you're now benchmarking the same number
> of /data/ storage drives; but have saved one drive's worth of recover=
y
> data (at cost of risking your data if any single drive fails).
>
> Still, run the same benchmarks.
>
> Why is this valid instead of throwing all the drives at it in raid-0
> mode as well?  It provides the same resulting storage size.
>
>
> What I suspect you'll find is very similar read performance and
> measurably, though perhaps tolerable, worse write performance from
> raid-5.

In raid5 mode each drive will read 5*64k data and then skip 64k and
repeat. And skipping such a small chunk of data means waiting till it
has rotated below the head. So each drive only gives 5/6th of its linea=
r
speed. As a result the 6 disks raid5 should be 5/6th of the speed of a =
5
disk raid0 assuming the controler and bus are fast enough.

A larger chunk size can mean skipping the parity chunk skips a
cylinder. But larger chunk size makes it less likely reads are spread
over all/multiple disks. So you might loose more than you gain.

MfG
        Goswin

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
