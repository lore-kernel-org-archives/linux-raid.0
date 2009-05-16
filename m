From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: RAID4 and RAID5 Code
Date: Sat, 16 May 2009 10:02:05 +0530
Message-ID: <37d33d830905152132w4abe803bk2c066d90fbf4ce8e@mail.gmail.com>
References: <37d33d830905140957q6e180d89v4cd4a21d23471481@mail.gmail.com>
	 <4A0D9384.1020805@zytor.com>
	 <37d33d830905150914v5d780e44s6cc2174944530ddb@mail.gmail.com>
	 <4A0DB688.7050301@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A0DB688.7050301@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: hpa@zytor.com, vger majordomo for lists <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 16, 2009 at 12:08 AM, Maurice Hilarius <maurice@harddata.co=
m> wrote:
> SandeepKsinha wrote:
>
> ..
>
> RAID 4 vs RAID 5
> Actually debatable. They have their own pros and cons and especially
> where you don't consider the physical properties of disk.
> Addition of new disk, differences in speed of disks, etc.. create
> bottlenecks especially in case of RAID5.
>
> Except hot spot issue with RAID 4, I find it better than all others.
> Also, most of the proprietary solutions from IBM, Adaptec and NetApp
> suggest RAID4 as compared to others.
>
> No offenses please, this is just an opinion.
>
>
> In a lot of=A0 uses, RAID4 is actually preferable.
> Putting all parity data on one disk allows us to "cheat" and use a fa=
ster
> drive for that parity disk.
> Thus we can gain some performance over RAID5 or 6.
>
> To avoid the risk factor increase, we can use a more reliable AND fas=
ter
> disk/interface for that parity device.
>
> For reads we gain a fair bit of performance by doing this.
>
> Further, we may "cheat" by using a single larger parity disk.
> By doing so, if we add more data disks, we still have reserve space f=
or
> growth on the larger parity disk.
>
> Yes, our write rates are lousy, but for some uses this is OK.
> Yes, rebuilds are slow too..
>
What makes you think that the rebuilds are slower?

>
>
> --
> With our best regards,
>
> Maurice W. Hilarius=A0=A0=A0=A0=A0=A0=A0=A0 Telephone: 01-780-456-977=
1
> Hard Data Ltd.=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 FAX:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 01-780-456-9772
> 11060 - 166 Avenue=A0=A0=A0=A0=A0=A0=A0=A0 email:maurice@harddata.com
> Edmonton, AB, Canada =A0=A0=A0=A0 T5X 1Y3



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
