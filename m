From: Joe Williams <jwilliams315@gmail.com>
Subject: Re: increasing stripe_cache_size decreases RAID-6 read throughput
Date: Tue, 27 Apr 2010 10:18:36 -0700
Message-ID: <n2x11f0870e1004271018t742e933tba7e0d37428271f2@mail.gmail.com>
References: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
	 <20100427164126.2765f9e0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100427164126.2765f9e0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 26, 2010 at 11:41 PM, Neil Brown <neilb@suse.de> wrote:
> On Sat, 24 Apr 2010 16:36:20 -0700 Joe Williams <jwilliams315@gmail.c=
om> wrote:
>
> The whole 'queue' directory really shouldn't appear for md devices bu=
t for
> some very boring reasons it does.

But read_ahead for md0 is in the queue directory:

/sys/block/md0/queue/read_ahead_kb

I know you said read_ahead is irrelevant for the individual disk
devices like sdb, but I thought it was implied the read_ahead for md0
is significant.

>
>
>> Next question, is it normal for md0 to have no queue_depth setting?
>
> Yes. =A0The stripe_cache_size is conceptually a similar think, but on=
ly
> at a very abstract level.
>
>>
>> Are there any other parameters that are important to performance tha=
t
>> I should be looking at?
>

>> I was expecting a little faster sequential reads, but 191 MB/s is no=
t
>> too bad. I'm not sure why it decreases to 130-131 MB/s at larger
>> record sizes.
>
> I don't know why it would decrease either. =A0For sequential reads, r=
ead-ahead
> should be scheduling all the read requests and that actual reads shou=
ld just
> be waiting for the read-ahead to complete. =A0So there shouldn't be a=
ny
> variability - clearly there is. =A0I wonder if it is an XFS thing....
> care to try a different filesystem for comparison? =A0ext3?

I can try ext3. When I run mkfs.ext3, are there any parameters that I
should set to other than the default values?

>

> That is very weird, as reads don't use the stripe cache at all - when
> the array is not degraded and no overlapping writes are happening.
>
> And the stripe_cache is measured in pages-per-device. =A0So 2560 mean=
s
> 2560*4k for each device. There are 3 data devices, so 30720K or 60 st=
ripes.
>
> When you set stripe_cache_size to 16384, it would have consumed
> =A016384*5*4K =3D=3D 320Meg
> or 1/3 of your available RAM. =A0This might have affected throughput,
> I'm not sure.

Ah, thanks for explaining that! I set the stripe cache much larger
than I intended to. But I am a little confused about your
calculations. FIrst you multiply 2560 x 4K x 3 data devices to get the
total stripe_cache_size. But then you multiply 16384 x 4K x 5 devices
to get the RAM usage. Why multiply time 3 in the first case, and 5 in
the second? Does the stripe cache only cache data devices, or does it
cache all the devices in the array?

What stripe_cache_size value or values would you suggest I try to
optimize write throughput?

The default setting for stripe_cache_size was 256. So 256 x 4K =3D 1024=
K
per device, which would be two stripes, I think (you commented to that
effect earlier). But somehow the default setting was not optimal for
sequential write throughput. When I increased stripe_cache_size, the
sequential write throughput improved. Does that make sense? Why would
it be necessary to cache more than 2 stripes to get optimal sequential
write performance?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
