From: "NeilBrown" <neilb@suse.de>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Wed, 5 Aug 2009 18:18:04 +1000 (EST)
Message-ID: <a6e3025fb0b580973533be9eb64ad4c0.squirrel@neil.brown.name>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
    <20090730073554.GA17665@cthulhu.home.robinhill.me.uk>
    <20090730101846.GA17332@rap.rap.dk>
    <72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com>
    <20090731175455.GA11463@rap.rap.dk>
    <72dbd3150907311310s2ccfc379u2c23fe724007b9bb@mail.gmail.com>
    <20090801130043.GA24915@rap.rap.dk>
    <72dbd3150908010813n3aed3804s3a0c0265cb2c2c6d@mail.gmail.com>
    <20090801175734.GB27831@rap.rap.dk>
    <72dbd3150908041521q1d71994cl25159d5ec3e7f326@mail.gmail.com>
    <20090805074438.GB23696@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090805074438.GB23696@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: David Rees <drees76@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, August 5, 2009 5:44 pm, Keld J=F8rn Simonsen wrote:
> On Tue, Aug 04, 2009 at 03:21:28PM -0700, David Rees wrote:

>> Far layout, 4 disks, 2 copies
>> a b c d
>> 0 1 2 3
>> 4 5 6 7
>> 7 0 1 2
>> 3 4 5 6
>
> No, it is rather:
>
> Far layout, 4 disks, 2 copies
> a b c d
> 0 1 2 3
> 4 5 6 7
> 1 0 3 2
> 5 4 7 6

Actually it is

a b c d
0 1 2 3
4 5 6 7
3 0 1 2
7 4 5 6

NeilBrown

>
> Best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
