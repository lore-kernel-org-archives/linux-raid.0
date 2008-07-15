From: thomas62186218@aol.com
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 12:50:57 -0400
Message-ID: <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080715163932.GA23164@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: keld@dkuug.dk, monkeyiq@users.sourceforge.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Ben,

Nice reporting on the benchmarks. It would be helpful though to run=20
these tests without a file system involved, using a block level=20
benchmark utility like fio or similar to really measure the RAID=20
performance in isolation. While you did use a file system in both your=20
hardware and software RAID tests, before directly implicating software=20
RAID, it makes sense to isolate it as much as possible in the testing=20
by eliminating the file system for benchmarks.

Thanks again for the report!
-Thomas


-----Original Message-----
=46rom: Keld J=C3=B8rn Simonsen <keld@dkuug.dk>
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
Sent: Tue, 15 Jul 2008 9:39 am
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup










On Wed, Jul 16, 2008 at 12:06:09AM +1000, Ben Martin wrote:
> Hi,
>   Apologies if posting this here is inappropriate but a recent articl=
e
> of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> card and might be of interest to list members:
>
> http://www.linux.com/feature/140734

It is (at least to me) very interesting to see comparisons on HW vs SW
raid.

I think tho, that you give it some bias not testing the best
configurations for Linux SW raid. For example raid10, the f2 and o2
layouts are faster than n2, and you don't know if Adaptec has some kind
of improved layout.

It would be interesting=20
if you could enhance your article with=20
benchmarks
on raid10, f2 and o2 layouts. I think they would outperform HW raid, at
least on input. And I would like to see how they perform on outout and
rewrite, with ext3 and xfs. We do have some tests, but many of them are
without a file system layer.

I would also welcome test with mobo HW RAID - Many mobo's today come
with some HW raid functionality, and many people would be in the
situation of whether to choose a HW or SW configuration.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
