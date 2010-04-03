From: Learner Study <learner.study@gmail.com>
Subject: Re: Linux Raid performance
Date: Fri, 2 Apr 2010 20:06:14 -0700
Message-ID: <p2n7efa8a7d1004022006v764c33b6p5a7760885c95b6db@mail.gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
	<20100331201539.GA19395@rap.rap.dk> <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
	<20100402110506.GA16294@rap.rap.dk> <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
	<l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com>
	<4BB69670.3040303@sauce.co.nz> <y2i5bdc1c8b1004021832x283f72f7uea429f24d79b6fa2@mail.gmail.com>
	<4BB69BE1.5090107@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB69BE1.5090107@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Mark Knecht <markknecht@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk, learner.study@gmail.com
List-Id: linux-raid.ids

Thanks to everyone for sharing their experiences...this was helpful.

I don't have luxury to have 16 SAS/SATA drives...I guess it would be
great if someone can share results with even higher number of
disks...I would like to know what is the max performance that can be
reached...I understand the theoretical is more like a couple of
Terabytes...but won't we get into some sort of linux file system
related or other kernel bottlenecks as we increase the # of disks?

On Fri, Apr 2, 2010 at 6:37 PM, Richard Scobie <richard@sauce.co.nz> wr=
ote:
> Mark Knecht wrote:
>
>> Richard,
>> =A0 =A0Good point. I was limited in my thinking to the sorts of arra=
ys I
>> might use at home being no wider than 3, 4 or 5 disks. However for o=
ur
>> N-wide array as N approaches infinity so do the cycles required to r=
un
>> it. I don think that applies to the OP but I don't know that.
>>
>
> I said I thought the busiest CPU was the parity generation one, but i=
n
> hindsight this cannot be correct, as it was almost maxed out at half =
the
> write speed the array achieved when it was empty.
>
> Regards,
>
> Richard
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
