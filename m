From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 10:37:25 -0500
Message-ID: <565F1035.10800@turmel.org>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
 <20151202010745.GC9812@www5.open-std.org>
 <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
 <565F03F2.3070803@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>, Dallas Clement <dallas.a.clement@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/02/2015 10:28 AM, Robert Kierski wrote:
> Thanks for the response.
>=20
> Nice try... But, the reason I=E2=80=99m using the 3.18.4 kernel is th=
at it has the parallelization.  I've got group_thread_cnt set to 32.  I=
'm watching the CPU's with mpstat, and they're pretty much idle.  I'm a=
lso watching the system traces with perf.  It claims that only 11.9% of=
 my time is spent doing the xor.

Hmm. Ok.

> I've got my CS set at 128k.  I have noticed that if I set the CS to 3=
2k, the TP is about 2x.  I'm pretty sure the problem is that the 1M wri=
tes I'm doing are being broken into 4K pages, and then reassembled befo=
re going to disk.

I think you're right.  What is your stripe cache size?

> Also, this is independent of the IO Scheduler.  I've tried all 3 and =
got the same results.

If your stripe cache is too small, sequential writes with large chunks
can exhaust the cache before complete stripes are written, turning all
of those partial stripe writes into read-modify-write cycles.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
