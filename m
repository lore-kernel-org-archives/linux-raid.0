From: Phil Turmel <philip@turmel.org>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Thu, 30 Jun 2011 09:34:03 -0400
Message-ID: <4E0C7B4B.7090404@turmel.org>
References: <4E0C5539.4030000@gmx.de> <4E0C5E47.5090604@anonymous.org.uk> <4E0C6CC4.3030506@turmel.org> <4E0C7196.1070307@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C7196.1070307@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2Fyc3RlbiBSw7Zta2U=?= <k.roemke@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/30/2011 08:52 AM, Karsten R=C3=B6mke wrote:

[...]

>> This will end up with four drives' capacity, with parity intersperse=
d, on five drives.  No spare.
>>
>>>> That's what I want, but I reached it more or less by random.
>>>> Where is my "think-error" (in german).
> No - that's not what I want, but it seems first to be the right way.
> After my posting before put the raid back to lvm I do mdadm --detail
> and see, that the capacity cant't match, I have around 16 GB, I expec=
ted
> 12 GB - so I decided to stop my experiments - until I get a hint, whi=
ch
> comes very fast.

So the first layout is the one you wanted.  Each drive is ~4GB ?  Or is=
 this just a test setup?

>> I hope this helps you decide which layout is the one you really want=
=2E
> If you think you want the first layout, you should also consider raid=
6 (dual redundancy).
> There's a performance penalty, but your data would be significantly s=
afer.
> I have to say, I haved looked at  raid 6 only at a glance.
> Are there any experiences in which percentage the performance penalty=
 is to expect?

I don't have percentages to share, no.  They would vary a lot based on =
number of disks and type of CPU.  As an estimate though, you can expect=
 raid6 to be about as fast as raid5 when reading from a non-degraded ar=
ray.  Certain read workloads could even be faster, as the data is sprea=
d over more spindles.  It will be slower to write in all cases.  The ex=
tra "Q" parity for raid6 is quite complex to calculate.  In a single di=
sk failure situation, both raid5 and raid6 will use the "P" parity to r=
econstruct the missing information, so their single-degraded read perfo=
rmance will be comparable.  With two disk failures, raid6 performance p=
lummets, as every read requires a complete inverse "Q" solution.  Of co=
urse, two disk failures in raid5 stops your system.  So running at a cr=
awl, with data intact, is better than no data.

You should also consider the odds of failure during rebuild, which is a=
 serious concern for large raid5 arrays.  This was discussed recently o=
n this list:

http://marc.info/?l=3Dlinux-raid&m=3D130754284831666&w=3D2

If your CPU has free cycles, I suggest you run raid6 instead of raid5+s=
pare.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
