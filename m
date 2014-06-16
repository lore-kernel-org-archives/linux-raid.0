From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Mon, 16 Jun 2014 14:02:17 -0700
Message-ID: <CAK2H+eeWHRB6Me3GtzQHMgFxH18wbHXa-iUf-_w-stuz3csV+A@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
	<539E5504.1080809@turmel.org>
	<CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
	<539EFF1C.3000009@turmel.org>
	<CADqA9ubBicDLwrdgOYNT04P0SO8pi+FK-ipjONY+59ThV0zGKw@mail.gmail.com>
	<539F4FD4.9070504@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <539F4FD4.9070504@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 16, 2014 at 1:13 PM, Phil Turmel <philip@turmel.org> wrote:
> On 06/16/2014 12:14 PM, Nuno Magalh=C3=A3es wrote:
<SNIP>
>
>> Other than tiobench, any other benchmarking tools you guys recommend=
?
>> (I've decided to just go slow and test every layer out before moving
>> to the next, i.e. 1st RAID, LVM, FSs, Xen, apps.)
>
> I'll leave that one for others. . .  Just don't expect dd to be very =
useful.

I'd not head of tiobench before. It seems quite out of date looking at
the website which suggests it hasn't been updated in 12 years.

Some alternatives, without recommendation, that I see others talking
about and that I've tried at least once:
fio
bonnie++
iozone

Again, without recommending anything and specifically noting that not
all of these are Linux=3Dbased, there's an interesting list at the
bottom of this link:

http://fsbench.filesystems.org/

HTH,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
