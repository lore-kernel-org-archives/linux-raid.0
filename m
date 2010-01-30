From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: The huge different performance of sequential read between RAID0
	and RAID5
Date: Fri, 29 Jan 2010 23:03:27 -0800
Message-ID: <4877c76c1001292303x5d843f4djb155c7abe5085e60@mail.gmail.com>
References: <100eff551001271916y116de081la77982f4b5a03c73@mail.gmail.com>
	 <20100128070606.GD3098@boogie.lpds.sztaki.hu>
	 <100eff551001280631h7de01ba6n52d79fdfcea9445e@mail.gmail.com>
	 <20100128144118.GB17369@twister.selfip.org>
	 <100eff551001280655r2e173286nfca3dbf688609571@mail.gmail.com>
	 <20100128152755.GA23933@cthulhu.home.robinhill.me.uk>
	 <4877c76c1001282205m280049b8y34253fc8f5062d0f@mail.gmail.com>
	 <873a1p86vf.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <873a1p86vf.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 29, 2010 at 3:53 AM, Goswin von Brederlow <goswin-v-b@web.d=
e> wrote:
> Michael Evans <mjevans1983@gmail.com> writes:
>
>> On Thu, Jan 28, 2010 at 7:27 AM, Robin Hill <robin@robinhill.me.uk> =
wrote:
>>> On Thu Jan 28, 2010 at 09:55:05AM -0500, Yuehai Xu wrote:
>>>
>>>> 2010/1/28 Gabor Gombas <gombasg@sztaki.hu>:
>>>> > On Thu, Jan 28, 2010 at 09:31:23AM -0500, Yuehai Xu wrote:
>>>> >
>>>> >> >> md0 : active raid5 sdh1[7] sdg1[5] sdf1[4] sde1[3] sdd1[2] s=
dc1[1] sdb1[0]
>>>> >> >> =A0 =A0 =A0 631353600 blocks level 5, 64k chunk, algorithm 2=
 [7/6] [UUUUUU_]
>>>> > [...]
>>>> >
>>>> >> I don't think any of my drive fail because there is no "F" in m=
y
>>>> >> /proc/mdstat output
>>>> >
>>>> > It's not failed, it's simply missing. Either it was unavailable =
when the
>>>> > array was assembled, or you've explicitely created/assembled the=
 array
>>>> > with a missing drive.
>>>>
>>>> I noticed that, thanks! Is it usual that at the beginning of each
>>>> setup, there is one missing drive?
>>>>
>>> Yes - in order to make the array available as quickly as possible, =
it is
>>> initially created as a degraded array. =A0The recovery is then run =
to
>>> add in the extra disk. =A0Otherwise all disks would need to be writ=
ten
>>> before the array became available.
>>>
>>>> >
>>>> >> How do you know my RAID5 array has one drive missing?
>>>> >
>>>> > Look at the above output: there are just 6 of the 7 drives avail=
able,
>>>> > and the underscore also means a missing drive.
>>>> >
>>>> >> I tried to setup RAID5 with 5 disks, 3 disks, after each setup,
>>>> >> recovery has always been done.
>>>> >
>>>> > Of course.
>>>> >
>>>> >> However, if I format my md0 with such command:
>>>> >> mkfs.ext3 -b 4096 -E stride=3D16 -E stripe-width=3D*** /dev/XXX=
X, the
>>>> >> performance for RAID5 becomes usual, at about 200~300M/s.
>>>> >
>>>> > I suppose in that case you had all the disks present in the arra=
y.
>>>>
>>>> Yes, I did my test after the recovery, in that case, does the "mis=
sing
>>>> drive" hurt the performance?
>>>>
>>> If you had a missing drive in the array when running the test, then=
 this
>>> would definitely affect the performance (as the array would need to=
 do
>>> parity calculations for most stripes). =A0However, as you've not ac=
tually
>>> given the /proc/mdstat output for the array post-recovery then I do=
n't
>>> know whether or not this was the case.
>>>
>>> Generally, I wouldn't expect the RAID5 array to be that much slower=
 than
>>> a RAID0. =A0You'd best check that the various parameters (chunk siz=
e,
>>> stripe cache size, readahead, etc) are the same for both arrays, as
>>> these can have a major impact on performance.
>>>
>>> Cheers,
>>> =A0 =A0Robin
>>> --
>>> =A0 =A0 ___
>>> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin=
@robinhill.me.uk> |
>>> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>>> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 |
>>>
>>
>> A more valid test that could be run would follow:
>>
>> Assemble all the test drives as a raid-5 array (you can zero the
>> drives any way you like and then --assume-clean if they really are a=
ll
>> zeros) and let the resync complete.
>>
>> Run any tests you like.
>>
>> Stop and --zero-superblock on the array.
>>
>> Create a striped array (raid 0) using all but one of the test drives=
=2E
>>
>> Since you dropped the drive's worth of storage that would be dedicat=
ed
>> to parity in the raid-5 setup you're now benchmarking the same numbe=
r
>> of /data/ storage drives; but have saved one drive's worth of recove=
ry
>> data (at cost of risking your data if any single drive fails).
>>
>> Still, run the same benchmarks.
>>
>> Why is this valid instead of throwing all the drives at it in raid-0
>> mode as well? =A0It provides the same resulting storage size.
>>
>>
>> What I suspect you'll find is very similar read performance and
>> measurably, though perhaps tolerable, worse write performance from
>> raid-5.
>
> In raid5 mode each drive will read 5*64k data and then skip 64k and
> repeat. And skipping such a small chunk of data means waiting till it
> has rotated below the head. So each drive only gives 5/6th of its lin=
ear
> speed. As a result the 6 disks raid5 should be 5/6th of the speed of =
a 5
> disk raid0 assuming the controler and bus are fast enough.
>
> A larger chunk size can mean skipping the parity chunk skips a
> cylinder. But larger chunk size makes it less likely reads are spread
> over all/multiple disks. So you might loose more than you gain.
>
> MfG
> =A0 =A0 =A0 =A0Goswin
>
>

That is true assuming a very large sequential read (buffered video
streams and other very large files).  However while each drive will
only have an apparent performance of 5/6 in the case of a 6 drive raid
6 array that is still 5/6 * 6 =3D 5 drives raid zero equivalent; which
is also the size of usable data storage.  All the more reason to say:

Read performance of N+1 drives in raid 5 should be roughly equivalent
to N drives in raid 0 (obviously in the best case).

In the worst case, raid 5 produces data; while raid 0 times out and
fails to read any data.

The main area of performance difference between raid 5 and raid 0 is
seen on /writes/ which is where you pay for the insurance in the
complexity of keeping the stripe clean.  At /least/ reading any
changed chunks, plus parity chunk, calculating parity, and writing all
of that back to the drives; OR writing all the data-chunks and the
newly calculated parity chunk.  Thus describing why larger writes see
less overall degrade in performance and smaller writes seem so much
worse in comparison.  There's also the extra drive used as insurance.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
