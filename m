From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Wed, 16 May 2012 07:51:19 +0200
Message-ID: <CAAOsTS=qSr7+m0-ERNL455o0O49hHoeksfjSbdCRdoEH4-Bmkg@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FACBCCC.4060802@hesbynett.no>
	<CAAOsTSmwcXPhHqQ3QyS0_8ijXaC3E4bGtWJn1wrwRFeUpxu8tQ@mail.gmail.com>
	<CAAOsTSmS6uFFe1e1y+39fxHOEFWZEsM7thcPwoeV6FTNiPkM_Q@mail.gmail.com>
	<20120513091901.5265507f@notabene.brown>
	<CAAOsTSk7dDcMGGJgAJ6GSDU2WpsJPTS3Vb80WKy6CObwtemfgQ@mail.gmail.com>
	<CAAOsTSkVwCkY3YAKPTDFo2uZoG6S6Et0DYtDzk+QNfy+N3kMag@mail.gmail.com>
	<20120514081523.2f38dbb8@notabene.brown>
	<CAAOsTSm3aQFydumTfAVr2DQZoxcENvzpfyS8zbNdxUcnFsDkpQ@mail.gmail.com>
	<CAAOsTSkTXy0zP0OBBOPg7+=nc0Acshz2jrsB8fTF55VNeUEHxg@mail.gmail.com>
	<20120515204322.4ee77ea4@notabene.brown>
	<CAAOsTSmMrs2bHDbFrND4-iaxwrTA0WySd_AVaK+KXZ-XZsysag@mail.gmail.com>
	<20120515212820.14db2fd2@notabene.brown>
	<CAAOsTSm3XFRbRpfatRi5tVdO1Jz_pHqb3RS6b7UyVNdDSnk8Fw@mail.gmail.com>
	<20120515221313.7610372d@notabene.brown>
	<CAAOsTSn1+jtViRE-9f7YpMduZ9avBfWMC72vHF_NFC0kjF-hRg@mail.gmail.com>
	<20120516084730.0b30fe31@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120516084730.0b30fe31@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 16, 2012 at 12:47 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 15 May 2012 21:39:10 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> BTW thank you very much for the fix for layout=3Dpreserve. As soon a=
s
>> current reshape finishes, I am going to other arrays.
>>
>> Are regressions in 2.3.4 serious and so to which version I should
>> apply the patch? Or when you looked at the code, should
>> layout=3Dleft-symmetric-6 work in 2.3.2?
>
> Regression isn't dangerous, just inconvenient (--add often doesn't wo=
rk).
> --layout=3Dleft-symmetric-6 will work on 2.3.2, providing the current=
 layout
> of the array is "left symmetric" which I think is the default, but yo=
u should
> check.

OK, thanks. Yes, the layout of my arrays is left-symmetric.

>
> NeilBrown
>
>>
>> In regard reshaping speed, estimation when doing things a lot more
>> sequentially gives much higher speeds. Lets say 48 MB backup, 6 driv=
es
>> with 80 MB/s sequential speed. If you do reshaping like this:
>> - Read 8 MB sequential from each drive in parallel, 0.1 s
>> - Then write it to backup, 48/80 =3D 0.6 s
>> - Calculate Q for something like 48 MB (guessing 0.05 s) and writing
>> it back to diff drives in parallel in 0.1 s. Because it is in the
>> cache and you are only writing =A0in this phase (?), there is not ba=
ck
>> and forth seeking and rotational latency applies only couple of time=
s
>> altogether, lets say 0.02.
>> - Update superblock and move header back, two worst seeks, 0.03 s (I
>> dont know how often do you update superblocks?)
>>
>> you process 8 MB in cca 0.9 s, so speed in this scenario should be c=
ca 9 MB/s.
>>
>> I guess the main real difference when you logically doing it in
>> stripes can be that when you waiting for completion of writing chunk=
s
>> (are you waiting for real completion of writes?), the difference
>> between first and last drive is often long enough to need wait one o=
r
>> more rotations for writing another stripe. If that is the case, you
>> need add cca 128 * lets say 1.5 * 0.005 s =3D 0.64 s and so we are d=
own
>> to cca 4.3 MB/s theoretically.
>>
>> Patrik
>>
>> On Tue, May 15, 2012 at 2:13 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Tue, 15 May 2012 13:56:58 +0200 Patrik Horn=EDk <patrik@dsl.sk>=
 wrote:
>> >
>> >> Anyway increasing it to 5K did not help and drives don't seem to =
be
>> >> fully utilized.
>> >>
>> >> Does the reshape work something like this:
>> >> - Read about X =3D (50M / N - 1 / stripe size) stripes from drive=
s and
>> >> write them to the backup-file
>> >> - Reshape X stripes one by another sequentially
>> >> - Reshaping stripe by reading chunks from all drives, calculate Q=
,
>> >> writing all chunks back and doing I/O for next stripe only after
>> >> finishing previous one?
>> >>
>> >> So after increasing stripe_cache_size the cache should hold strip=
es
>> >> after backing them and so reshaping should not need to read them =
from
>> >> drives again?
>> >>
>> >> Cant the slow speed be caused by some synchronization issues? How=
 are
>> >> the stripes read for writing them to backup-file? Is it done one =
by
>> >> one, so I/Os for next stripe are issued only after having read th=
e
>> >> previous stripe completely? Are they issued in maximum parallel w=
ay
>> >> possible?
>> >
>> > There is as much parallelism as I could manage.
>> > The backup file is divided into 2 sections.
>> > Write to one, =A0then the other, then invalidate the first and wri=
te to it etc.
>> > So while one half is being written, the data in the other half is =
being
>> > reshaped in the array.
>> > Also the stripe reads are scheduled asynchronously and as soon as =
a stripe is
>> > fully available, the Q is calculated and they are scheduled for wr=
ite.
>> >
>> > The slowness is due to continually having to seek back a little wa=
y to over
>> > write what has just be read, and also having to update the metadat=
a each time
>> > to record where we are up to.
>> >
>> > NeilBrown
>> >
>> >
>> >>
>> >> Patrik
>> >>
>> >>
>> >> On Tue, May 15, 2012 at 1:28 PM, NeilBrown <neilb@suse.de> wrote:
>> >> > On Tue, 15 May 2012 13:16:42 +0200 Patrik Horn=EDk <patrik@dsl.=
sk> wrote:
>> >> >
>> >> >> Can I increase it during reshape by echo N >
>> >> >> /sys/block/mdX/md/stripe_cache_size?
>> >> >
>> >> > Yes.
>> >> >
>> >> >
>> >> >>
>> >> >> How is the size determined? I have only 1027 while having 8 GB=
 system memory...
>> >> >
>> >> > Not very well.
>> >> >
>> >> > It is set to 256, or the minimum size needed to allow the resha=
pe to proceed
>> >> > (which means about 4 chunks worth). =A0I should probably add so=
me auto-sizing
>> >> > but that sort of stuff is hard :-(
>> >> >
>> >> > NeilBrown
>> >> >
>> >
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
