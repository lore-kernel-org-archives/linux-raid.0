From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: slow raid5 performance
Date: Sat, 20 Oct 2007 13:38:40 +0100
Message-ID: <18201.63184.178569.450538@base.ty.sabi.co.UK>
References: <13284909.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13284909.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Thu, 18 Oct 2007 16:45:20 -0700 (PDT), nefilim
>>> <thenephilim13@yahoo.com> said:

[ ... ]

> 3 x 500GB WD RE2 hard drives
> AMD Athlon XP 2400 (2.0Ghz), 1GB RAM
[ ... ]
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            1.01    0.00   55.56   40.40    0.00    3.03
[ ... ]
> which is pretty much what I see with hdparm etc. 32MB/s seems
> pretty slow for drives that can easily do 50MB/s each. Read
> performance is better around 85MB/s (although I expected
> somewhat higher).

> So it doesn't seem that PCI bus is limiting factor here

Most 500GB drives can do 60-80MB/s on the outer tracks
(30-40MB/s on the inner ones), and 3 together can easily swamp
the PCI bus. While you see the write rates of two disks, the OS
is really writing to all three disks at the same time, and it
will do read-modify-write unless the writes are exactly stripe
aligned. When RMW happens write speed is lower than writing to a
single disk.

> I see a lot of time being spent in the kernel.. and a
> significant iowait time.

The system time is because the Linux page cache etc. is CPU
bound (never mind RAID5 XOR computation, which is not that
big). The IO wait is because IO is taking place.

  http://www.sabi.co.uk/blog/anno05-4th.html#051114

Almost all kernel developers of note have been hired by wealthy
corporations who sell to people buying large servers. Then the
typical system that these developers may have and also target
are high ends 2-4 CPU workstations and servers, with CPUs many
times faster than your PC, and on those system the CPU overhead
of the page cache at speeds like yours less than 5%.

My impression is that something that takes less than 5% on a
developers's system does not get looked at, even if it takes 50%
on your system. The Linux kernel was very efficient when most
developers were using old cheap PCs themselves. "scratch your
itch" rules.

Anyhow, try to bypass the page cache with 'O_DIRECT' or test
with 'dd oflag=direct' and similar for an alterative code path.

> The CPU is pretty old but where exactly is the bottleneck?

Misaligned writes and page cache CPU time most likely.

