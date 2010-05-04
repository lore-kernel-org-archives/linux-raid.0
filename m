From: Joe Williams <jwilliams315@gmail.com>
Subject: Re: increasing stripe_cache_size decreases RAID-6 read throughput
Date: Mon, 3 May 2010 17:06:17 -0700
Message-ID: <k2k11f0870e1005031706id17d1b17q6e85485ab6e69b34@mail.gmail.com>
References: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
	 <20100427164126.2765f9e0@notabene.brown>
	 <n2x11f0870e1004271018t742e933tba7e0d37428271f2@mail.gmail.com>
	 <20100429143403.44bef7a1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100429143403.44bef7a1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 28, 2010 at 9:34 PM, Neil Brown <neilb@suse.de> wrote:
> On Tue, 27 Apr 2010 10:18:36 -0700
> Joe Williams <jwilliams315@gmail.com> wrote:

>> The default setting for stripe_cache_size was 256. So 256 x 4K =3D 1=
024K
>> per device, which would be two stripes, I think (you commented to th=
at
>> effect earlier). But somehow the default setting was not optimal for
>> sequential write throughput. When I increased stripe_cache_size, the
>> sequential write throughput improved. Does that make sense? Why woul=
d
>> it be necessary to cache more than 2 stripes to get optimal sequenti=
al
>> write performance?
>
> The individual devices have some optimal write size - possible one
> track or one cylinder (if we pretend those words mean something usefu=
l these
> days).
> To be able to fill that you really need that much cache for each devi=
ce.
> Maybe your drives work best when they are sent 8M (16 stripes, as you=
 say in
> a subsequent email) before expecting the first write to complete..
>
> You say you get about 250MB/sec, so that is about 80MB/sec per drive
> (3 drives worth of data).
> Rotational speed is what? =A010K? =A0That is 166revs-per-second.

Actually, 5400rpm.

> So about 500K per revolution.

About twice that, about 1 MB per revolution.

> I imagine you would need at least 3 revolutions worth of data in the =
cache,
> one that is currently being written, one that is ready to be written =
next
> (so the drive knows it can just keep writing) and one that you are in=
 the
> process of filling up.
> You find that you need about 16 revolutions (it seems to be about one
> revolution per stripe). =A0That is more than I would expect .... mayb=
e there is
> some extra latency somewhere.

So about 8 revolutions in the cache. 2 to 3 times what might be
expected to be needed for optimal performance. Hmmm.

16 stripes comes to 16*512KB per drive, or about 8MB per drive. At
about 100MB/s, that is about 80 msec worth of writing. I don't see
where 80 msec of latency might come from.

Could it be a quirk of NCQ? I think each HDD has an NCQ of 31. But 31
512 byte sectors is only 16KB. That does not seem relevant.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
