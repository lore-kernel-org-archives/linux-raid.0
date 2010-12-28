From: hansbkk@gmail.com
Subject: Re: md-raid and block sizes
Date: Tue, 28 Dec 2010 18:29:26 +0700
Message-ID: <AANLkTin=-0CN-teD5p4H_nFbuZ944DVuDMku3FaD7uv7@mail.gmail.com>
References: <1293451228.3266.9.camel@Waves.darkmere>
	<AANLkTikWxCxVUO+O8MXRXRR7Y8R5xGC1Catv-EiNGcDj@mail.gmail.com>
	<1293525980.23780.2.camel@Waves.darkmere>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1293525980.23780.2.camel@Waves.darkmere>
Sender: linux-raid-owner@vger.kernel.org
To: "D.S. Ljungmark" <spider@skuggor.se>
Cc: doug@easyco.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This doesn't actually relate to the blocksize issue, but a caveat -
I've heard that these "green" drives are not suitable for use in a
RAID.

The specific issue is apparently that these drives spin down very
frequently, but most RAID implementations keep spinning them back up
again just as frequently (perhaps unnecessarily?), thus causing undue
wear and tear on the drives' mechanics and ultimately premature
failure.

Of course this could be spin from the vendors to get people to spend
more money on the "enterprise" level drives - I personally am a firm
believer in saving money by buying consumer-level hardware and using
the savings to buy extra redundancy.

It just so happens that I've bought a batch of Samsung 2TB drives for
a RAID6 I'm building, and it turns out they are quite similar to the
WDEARS, both in their use of "new format" 4K blocks and some of the
green features. I haven't yet detected any undue drive
stopping/starting, but then again they are so quite I'm not sure how
to check. . .

Confirmation or refutation of these thoughts would be most welcome.


On Tue, Dec 28, 2010 at 3:46 PM, D.S. Ljungmark <spider@skuggor.se> wro=
te:
> Thankyou,
> =A0This makes planning ahead a bit easier, and means that I "only" ha=
ve
> to worry about the traditional issues regarding block sizes, stripe a=
nd
> stride on "naked" disks in the array.
>
> Regards,
> =A0 Spid
>
> On Mon, 2010-12-27 at 10:59 -0800, Doug Dumitru wrote:
>> Mr. Ljungmark,
>>
>> The meta data is stored at the end of each raid device. =A0So if you=
 are
>> dealing with an "advanced partitioned" device, just make sure your
>> individual elements are stores with alignments that make sense. =A0N=
ormally,
>> this is just 'fdisk -u' and start the partition on a multiple of 8 s=
ectors
>> (start at 64).
>>
>> In terms of stripe sizes, they are all multiples of 4K pages anyway,=
 so it
>> is not really possible for them to be "wrong" in terms of drive form=
at
>> alignment.
>>
>> File systems should be 4K or multiples thereof. =A0It has been a whi=
le, but I
>> think only XFS really breaks this rule unless you overwrite the bloc=
k size
>> to 4K. =A0extn is fine.
>>
>> The same rules apply to most SSDs. =A0Most SSDs prefer 4K alignment =
because of
>> how the FTL (Flash Translation Layers) operate, even though <4K will
>> sometimes still work pretty well.
>>
>> Doug Dumitru
>> CTO EasyCo LLC
>>
>> On Mon, Dec 27, 2010 at 4:00 AM, D.S. Ljungmark <spider@skuggor.se> =
wrote:
>>
>> > Hello,
>> > =A0With the advent of the WD*EARS drives and the "advanced partiti=
oning"
>> > system that requires 4k blocks, I wanted to pop a quick question t=
o see
>> > how the md metadata is aligned and how it should be aligned to get
>> > proper performance out of the devices.
>> >
>> > So, For raid1, =A0I'll assume there is some metadata-overhead on t=
he
>> > drives, how large is this block? Will there be need to make a part=
ition
>> > on the md-device in order to get proper alignment of filesystem =3D=
>
>> > platters?
>> >
>> > for both raid1 and 5/6 levels, what are the appropiate stride-size=
s for
>> > ext3/4?
>> >
>> > For more advanced raid configurations (5-6), how should the ext3/4
>> > stripe size be configured?
>> >
>> >
>> > Yes, a lot of similarly naive questions, however, I'm asking mostl=
y
>> > because of how devices are changing from 512 to 4k sized blocks, w=
ith
>> > quite interesting changes in performance, and I wanted to figure o=
ut
>> > what is the current state of software raid. At which "level" of th=
e
>> > stack: (partition) raid (partition) filesystem , =A0do you have to=
 account
>> > for the block sizes in order to not degrade performance of the dev=
ices.
>> >
>> > ( In a perfect world I'd be able to purchase a stack of the device=
s and
>> > test for myself and come back with a report. However, money and ha=
rdware
>> > is a scarce resource ;)
>> >
>> > ps. =A0please keep me CC'd as I'm not subscribed to the list.
>> >
>> >
>> > // Spider
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
