From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: about raid5 recovery when created
Date: Wed, 9 Dec 2009 00:30:41 -0800
Message-ID: <4877c76c0912090030r266337afs394ecec463555258@mail.gmail.com>
References: <389deec70912080501u6c6bc90ei2d34ef245a1dae9e@mail.gmail.com>
	 <20091208131446.GA21130@cthulhu.home.robinhill.me.uk>
	 <389deec70912080549h1b22489es612235ad29354d6b@mail.gmail.com>
	 <20091208135600.GB21130@cthulhu.home.robinhill.me.uk>
	 <389deec70912080603w47d7fda3jf021af169ac1c48c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec70912080603w47d7fda3jf021af169ac1c48c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 8, 2009 at 6:03 AM, hank peng <pengxihan@gmail.com> wrote:
> 2009/12/8 Robin Hill <robin@robinhill.me.uk>:
>> On Tue Dec 08, 2009 at 09:49:48PM +0800, hank peng wrote:
>>
>>> 2009/12/8 Robin Hill <robin@robinhill.me.uk>:
>>> > On Tue Dec 08, 2009 at 09:01:23PM +0800, hank peng wrote:
>>> >
>>> >> Hi, all:
>>> >> As we know, when a raid5 array is created, recovery will be goin=
g on
>>> >> which involves some read, one xor and one write. Since there is =
no
>>> >> real data in the disk at the time, besides, if I am willing to w=
ait
>>> >> for recovery to complete and then use this raid5, how about addi=
ng
>>> >> support for a fast recovery method? Right now, what is in my min=
d is
>>> >> zero all disks which belong to this raid5. I think it will incre=
ase
>>> >> raid5 recovery speed when created and decrease CPU usage, since =
all
>>> >> zero is also XORed.
>>> >> What do raid developers think?
>>> >>
>>> > It'll decrease CPU usage but increase I/O - you're now needing to=
 write
>>> > to all disks. =A0Most systems will be I/O limited rather than CPU=
 limited,
>>> > so the current approach works better. =A0If you want to zero the =
disks
>>> > then do this before creating the array - you can then use --assum=
e-clean
>>> > to skip the resync process.
>>> >
>>> I think --assume-clean is used mostly when doing performance test a=
nd
>>> can't be used when creating a raid5 array using new disk, because
>>> later read and write operation make assumption that all stripe is
>>> XORed. Correct me if I am wrong.
>>>
>> You're correct - that's why I said to zero all the disks first so th=
e
>> XOR data is all correct.
>>
> I think this function is better to be implemented in kernel raid
> layer, not in user space(for example using dd command).
> In this way, we can get good performance and lower cpu usage, also, w=
e
> can make this function be part of raid code so that it can be managed
> by mdadm
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
>
>
> --
> The simplest is not all best but the best is surely the simplest!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

How about documenting this better?  'zeroing all underlying devices
then creating with --assume-clean' will be clean because the parity
algorithm is even (or similar to 'even parity')?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
