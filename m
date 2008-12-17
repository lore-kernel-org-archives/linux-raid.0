From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: raid10 far layout outperforms offset at writing? (was: Help with
 chunksize on raid10 -p o3 array)
Date: Wed, 17 Dec 2008 13:50:24 +0100
Message-ID: <4948F590.2050007@rabbit.us>
References: <20081217124154.GA5406@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081217124154.GA5406@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen wrote:
> I found this old message:
>=20
>> Peter Rabbitson
>> Mon, 19 Mar 2007 06:14:38 -0800
>>
>=20
> The links were not valid anymore. I wanted to see the results and=20
> possibly include the results in the performance wiki page
> I would appreciate some new links here.

I apologize, I don't have the data available anymore.


> Furthermore some comments to the post: My take on o3 vs f3 is that bo=
th
> in theory and practice f3 should be much faster for sequential readin=
g,
> as the layout is equivalent to raid0. For random reading and sequenti=
al
> and random writing f3 and o3 (and the same goes for the more normal f=
2
> vs o2) should be about the same, especially when a filesystem and
> its associated elevator algorithm is employed.

Yes, this is what I also concluded since I wrote this email. I am in th=
e
process of upgrading my raid setup, and while I am at it I am leaving
5GB blank partitions at the start of all my workstations spindles, so I
can get some real testing at night. I will share my methodology with th=
e
list before I commence testing (which should take about 20 days the way
I am planing it).

But first comes the vacation - happy holidays to you too guys.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
