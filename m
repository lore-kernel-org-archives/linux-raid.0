From: hank peng <pengxihan@gmail.com>
Subject: Re: about raid5 recovery when created
Date: Tue, 8 Dec 2009 21:49:48 +0800
Message-ID: <389deec70912080549h1b22489es612235ad29354d6b@mail.gmail.com>
References: <389deec70912080501u6c6bc90ei2d34ef245a1dae9e@mail.gmail.com>
	 <20091208131446.GA21130@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091208131446.GA21130@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/12/8 Robin Hill <robin@robinhill.me.uk>:
> On Tue Dec 08, 2009 at 09:01:23PM +0800, hank peng wrote:
>
>> Hi, all:
>> As we know, when a raid5 array is created, recovery will be going on
>> which involves some read, one xor and one write. Since there is no
>> real data in the disk at the time, besides, if I am willing to wait
>> for recovery to complete and then use this raid5, how about adding
>> support for a fast recovery method? Right now, what is in my mind is
>> zero all disks which belong to this raid5. I think it will increase
>> raid5 recovery speed when created and decrease CPU usage, since all
>> zero is also XORed.
>> What do raid developers think?
>>
> It'll decrease CPU usage but increase I/O - you're now needing to wri=
te
> to all disks. =C2=A0Most systems will be I/O limited rather than CPU =
limited,
> so the current approach works better. =C2=A0If you want to zero the d=
isks
> then do this before creating the array - you can then use --assume-cl=
ean
> to skip the resync process.
>
I think --assume-clean is used mostly when doing performance test and
can't be used when creating a raid5 array using new disk, because
later read and write operation make assumption that all stripe is
XORed. Correct me if I am wrong.

> Cheers,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>



--=20
The simplest is not all best but the best is surely the simplest!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
