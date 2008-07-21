From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Mon, 21 Jul 2008 12:58:28 -0400
Message-ID: <4884C034.6020502@tmr.com>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <1216180685.5633.364.camel@sam.localdomain> <20080716044718.GA7626@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080716044718.GA7626@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Ben Martin <monkeyiq@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Wed, Jul 16, 2008 at 01:58:05PM +1000, Ben Martin wrote:
>  =20
>> On Tue, 2008-07-15 at 18:39 +0200, Keld J=F8rn Simonsen wrote:
>>    =20
>>> On Wed, Jul 16, 2008 at 12:06:09AM +1000, Ben Martin wrote:
>>>      =20
>> One interesting question about the r10 layouts, if f2/o2 perform bet=
ter
>> than n2 why is the default for creation still n2? Just like mkfs.xfs
>> determining the raid chunk and stripe size for you (assuming you don=
't
>> use LVM to circumvent this, gah!), shouldn't mdadm select the "faste=
st"
>> --layout as the default for RAID-10?
>>    =20
>
> Perhaps. I think Neil first implemented "near", and more or less at t=
he same
> time "far" - but to him the main thing was "near". This was 2.6.9. Th=
en
> in 2.6.18 he implemented "offset".  In the early days the
> characteristics of each layout were not well known. It is only in the
> last year or so I have seen benchmarks with n2, f2 and o2.


I admit that I have done "raw device performance" benchmarks with n2 an=
d=20
f2, and neglected o2 completely, so I rely on other's work. However, I=20
am most often bitten by raid5 issues, so I have been paying most=20
attention to them.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
