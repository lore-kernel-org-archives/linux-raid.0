From: "Majed B." <majedb@gmail.com>
Subject: Re: Swapping a disk without degrading an array
Date: Mon, 25 Jan 2010 15:25:58 +0300
Message-ID: <70ed7c3e1001250425n6b6136ddr261a95042584df72@mail.gmail.com>
References: <1264421475.30742.49.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264421475.30742.49.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Micha=C5=82_Sawicz?= <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

There's a technique called active spare, and is already available on
some hardware RAID controllers. It keeps the hot spare in sync with
the array, such that in an event of a disk failure, the spare kicks-in
immediately without wasting time for a resync.

I think what you're proposing is similar to the following scenario:
array0: (assume raid5): disk0, disk1, disk2, disk3(spare)
array1: (raid1): disk0, disk3

Though I'm not sure if it's feasible to nest raids or have a disk to
be a member of 2 arrays at the same time.

I think it was proposed before, but I donno about its priority.

2010/1/25 Micha=C5=82 Sawicz <michal@sawicz.net>:
> Hi list,
>
> This is something I've discussed on IRC and we achieved a conclusion
> that this might be useful, but somewhat limited use-case count might =
not
> warrant the effort to be implemented.
>
> What I have in mind is allowing a member of an array to be paired wit=
h a
> spare while the array is on-line. The spare disk would then be filled
> with exactly the same data and would, in the end, replace the active
> member. The replaced disk could then be hot-removed without the array
> ever going into degraded mode.
>
> I wanted to start a discussion whether this at all makes sense, what =
can
> be the use cases etc.
>
> --
> Cheers
> Micha=C5=82 (Saviq) Sawicz
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
