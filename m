From: Doug Dumitru <doug@easyco.com>
Subject: Re: md-raid and block sizes
Date: Mon, 27 Dec 2010 11:02:50 -0800
Message-ID: <AANLkTim_vvdzYpdgQitK0942h-cW-q14MLhooSoaBOeL@mail.gmail.com>
References: <1293451228.3266.9.camel@Waves.darkmere>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1293451228.3266.9.camel@Waves.darkmere>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mr. Ljungmark,

The meta data is stored at the end of each raid device.  So if you are
dealing with an "advanced partitioned" device, just make sure your
individual elements are stores with alignments that make sense.
Normally, this is just 'fdisk -u' and start the partition on a
multiple of 8 sectors (start at 64).

In terms of stripe sizes, they are all multiples of 4K pages anyway,
so it is not really possible for them to be "wrong" in terms of drive
format alignment.

=46ile systems should be 4K or multiples thereof.  It has been a while,
but I think only XFS really breaks this rule unless you overwrite the
block size to 4K.  extn is fine.

The same rules apply to most SSDs.  Most SSDs prefer 4K alignment
because of how the FTL (Flash Translation Layers) operate, even though
<4K will sometimes still work pretty well.


On Mon, Dec 27, 2010 at 4:00 AM, D.S. Ljungmark <spider@skuggor.se> wro=
te:
>
> Hello,
> =A0With the advent of the WD*EARS drives and the "advanced partitioni=
ng"
> system that requires 4k blocks, I wanted to pop a quick question to s=
ee
> how the md metadata is aligned and how it should be aligned to get
> proper performance out of the devices.
>
> So, For raid1, =A0I'll assume there is some metadata-overhead on the
> drives, how large is this block? Will there be need to make a partiti=
on
> on the md-device in order to get proper alignment of filesystem =3D>
> platters?
>
> for both raid1 and 5/6 levels, what are the appropiate stride-sizes f=
or
> ext3/4?
>
> For more advanced raid configurations (5-6), how should the ext3/4
> stripe size be configured?
>
>
> Yes, a lot of similarly naive questions, however, I'm asking mostly
> because of how devices are changing from 512 to 4k sized blocks, with
> quite interesting changes in performance, and I wanted to figure out
> what is the current state of software raid. At which "level" of the
> stack: (partition) raid (partition) filesystem , =A0do you have to ac=
count
> for the block sizes in order to not degrade performance of the device=
s.
>
> ( In a perfect world I'd be able to purchase a stack of the devices a=
nd
> test for myself and come back with a report. However, money and hardw=
are
> is a scarce resource ;)
>
> ps. =A0please keep me CC'd as I'm not subscribed to the list.
>
>
> // Spider
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
