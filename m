From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Hot-replace for RAID5
Date: Tue, 15 May 2012 13:56:58 +0200
Message-ID: <CAAOsTSm3XFRbRpfatRi5tVdO1Jz_pHqb3RS6b7UyVNdDSnk8Fw@mail.gmail.com>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<CAAOsTSmi17VF2B5-4PJ9GNfxD-EQaY7LbL_8hwr1FvBoBj1VvA@mail.gmail.com>
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
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120515212820.14db2fd2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anyway increasing it to 5K did not help and drives don't seem to be
fully utilized.

Does the reshape work something like this:
- Read about X =3D (50M / N - 1 / stripe size) stripes from drives and
write them to the backup-file
- Reshape X stripes one by another sequentially
- Reshaping stripe by reading chunks from all drives, calculate Q,
writing all chunks back and doing I/O for next stripe only after
finishing previous one?

So after increasing stripe_cache_size the cache should hold stripes
after backing them and so reshaping should not need to read them from
drives again?

Cant the slow speed be caused by some synchronization issues? How are
the stripes read for writing them to backup-file? Is it done one by
one, so I/Os for next stripe are issued only after having read the
previous stripe completely? Are they issued in maximum parallel way
possible?

Patrik


On Tue, May 15, 2012 at 1:28 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 15 May 2012 13:16:42 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> Can I increase it during reshape by echo N >
>> /sys/block/mdX/md/stripe_cache_size?
>
> Yes.
>
>
>>
>> How is the size determined? I have only 1027 while having 8 GB syste=
m memory...
>
> Not very well.
>
> It is set to 256, or the minimum size needed to allow the reshape to =
proceed
> (which means about 4 chunks worth). =A0I should probably add some aut=
o-sizing
> but that sort of stuff is hard :-(
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
