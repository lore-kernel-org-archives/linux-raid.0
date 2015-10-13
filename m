From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Subject: Re: Puzzled by raid 10 (f2) and raid 6 direct i/o read behaviour
Date: Tue, 13 Oct 2015 02:31:34 +0200
Message-ID: <CALtW_ag2r-L2qsFFY3fq+bbjRgDka3WptPqgP-b95r5uPyXjeQ@mail.gmail.com>
References: <CALtW_ajvFR0dnxyH3XBmuosM2J7vFEGU1AQiNEtoqjvT0HvYRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALtW_ajvFR0dnxyH3XBmuosM2J7vFEGU1AQiNEtoqjvT0HvYRA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46eeling stupid to reply to my own email, hopefully nobody started to =
write a
reply. Maybe someone else will find it useful. Problem comes down to la=
tency.
Second time this month that the same problem bites me :)

If one disk latency is 100us when issuing small reads with direct io an=
d
iodepth of 1 the same disk has to wait for other to complete their read=
s.
In a way this makes single disk latency x times the disk array.
This is also the reason why full stripe reads are (almost) full speed.
I/O gets submitted concurrently. I wonder why don't I see any improveme=
nt with
readahead, direct i/o doesn't use it?


Sorry if a wasted someones time, maybe someones will find it useful :)
Dragan

On Mon, Oct 12, 2015 at 10:59 PM, Dragan Milivojevi=C4=87
<galileo@pkm-inc.com> wrote:
> Hi all
>
> I'm currently building a NAS/SAN server and I'm not quite sure why I'=
m getting
> these results.
> I would appreciate if someone could give me a theoretical explanation=
 on why
> this is happening. Raid arrays were built from 7 drives with 128k chu=
nk.
> I'm mostly concerned with read speed and small block direct i/o.
>
> Full raid and test details are attached and also uploaded (for easy v=
iewing)
> at: http://pastebin.com/VeGr0Ehc
>
> Summary of results from a few tests:
>
> =3D=3D Hard disk, Sequential read, O_DIRECT
> ----
> bs:   4k, bw:  80833KB/s
> bs:  32k, bw: 152000KB/s
> bs: 128k, bw: 152809KB/s
> ----
>
> =3D=3D Hard disk, Sequential write, O_DIRECT
> ----
> bs:  16k, bw: 144392KB/s
> bs:  32k, bw: 145352KB/s
> bs: 128k, bw: 145433KB/s
> ----
>
> =3D=3D Raid 10 f2, chunk: 128k, Sequential read, O_DIRECT
> ----
> bs:   4k, bw:  78136KB/s, per disk bw:  11MB/s, disk avgrq-sz: 8
> bs:  32k, bw: 289847KB/s, per disk bw:  41MB/s, disk avgrq-sz: 64
> bs: 128k, bw: 409674KB/s, per disk bw:  57MB/s, disk avgrq-sz: 256
> bs: 256k, bw: 739344KB/s, per disk bw: 104MB/s, disk avgrq-sz: 256
> bs: 896k, bw: 981517KB/s, per disk bw: 133MB/s, disk avgrq-sz: 256
> ----
>
> =3D=3D Raid 6, chunk: 128k, Sequential read, O_DIRECT
> ----
> bs:    4k, bw:  46376KB/s, per disk bw:  6MB/s, disk avgrq-sz: 8
> bs:   32k, bw: 155531KB/s, per disk bw: 22MB/s, disk avgrq-sz: 64
> bs:  128k, bw: 182024KB/s, per disk bw: 26MB/s, disk avgrq-sz: 256
> bs:  256k, bw: 248591KB/s, per disk bw: 34MB/s, disk avgrq-sz: 256
> bs:  384k, bw: 299771KB/s, per disk bw: 40MB/s, disk avgrq-sz: 256
> bs:  512k, bw: 315374KB/s, per disk bw: 44MB/s, disk avgrq-sz: 256
> bs:  640k, bw: 296350KB/s, per disk bw: 44MB/s, disk avgrq-sz: 256
> bs: 1280k, bw: 543655KB/s, per disk bw: 75MB/s, disk avgrq-sz: 426
> bs: 2560k, bw: 618092KB/s, per disk bw: 83MB/s, disk avgrq-sz: 638
> ----
>
> =3D=3D Raid 6, chunk: 128k, Sequential read, Buffered
> ----
> bs: 2560k, bw: 690546KB/s, per disk bw: 96MB/s, disk avgrq-sz: 512
> ----
>
> =3D=3D Raid 6, chunk: 128k, Sequential write, O_DIRECT, stripe_cache_=
size: 32768
> ----
> bs:  640K, bw: 382778KB/s, per disk bw: 75MB/s, disk avgrq-sz: 256
> bs: 1280K, bw: 405909KB/s, per disk bw: 82MB/s, disk avgrq-sz: 512
> ----
>
> =3D=3D Raid 6, chunk: 128k, Sequential write, Buffered, stripe_cache_=
size: 32768
> ----
> bs: 1280k, bw: 730527KB/s, per disk bw: 135M/s, disk avgrq-sz: 1024
>
>
> As can be seen from single disk tests, hard drives are capable of ful=
l speed
> with 32k block size. What baffles me (especially with raid 10) is why=
 do
> I get such low speed with small request sizes?
>
> Even with full stripe reads performance is not at maximum. This is mo=
st
> obvious with raid6. If I get the theory correctly maximum read speed =
per disk
> in this configuration should be around 105Mb/s (0.7*150).
>
> With buffered reads I'm close to this figure so theory matches the re=
al
> performance with buffered reads.
>
> When thinking about writes one can easily grasp the theory behind ful=
l stripe
> writes and why block writes less than full stripe incur a performance=
 hit.
>
> I don really get why I'm getting a performance hit with reads. I get =
it that
> for every 7 chunks written to a single disk 2 of those will be parity=
=2E So when
> reading the disk I'm expecting a 30% hit?
>
> Raid 10 (f2) results confuse me even more. If I understand it correct=
ly parity
> is written at the end of disk so (in theory) there should be no perfo=
rmance
> hit with raid 10?
>
> I'm also seeing similar performance figures with real world usage (wi=
ndoze
> clients with iscsi and mpio). Per disk disk bw figures remind me more=
 of
> random then sequential i/o.
>
> The only theory that I came up with revolves around read request merg=
es and
> disk firmware. I'm seeing read request merges with fairly large block=
 sizes
> and even greater with buffered io. I'm not that familiar with kernel =
block
> internals so I'm seeking an authoritative answer.
>
> Can someone point our some docs that I can read or offer an explanati=
on?
>
> Thanks
> Dragan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
