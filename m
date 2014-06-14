From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Sat, 14 Jun 2014 16:56:08 -0500
Message-ID: <539CC4F8.90905@hardwarefreak.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Nuno_Magalh=E3es?= <nunomagalhaes@eu.ipp.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/14/2014 4:01 PM, Nuno Magalh=E3es wrote:
=2E..
> This is a desktop system, nothing
> mission-critical, but i'd like it to be reasonably tailored to the
> hardware and intended usage, and have questions about default values.

[snip]

Everything begins and ends with the workload.  The proper chunk and
stripe sizes are dictated by the write patterns of your workload, i.e.
the mix of applications running on the system, not the type/size of
disks you have.

If you're writing lots of small files then you'll typically want a smal=
l
chunk size.  If you use a large chunk size with small files you'll get =
a
hot spot on one or more drives in the array due to filesystem alignment=
=2E
 Hot spot means one disk sees lots of activity while the other(s) sit
idle.  This defeats the purpose of striping.

If you're working predominantly with large media files you'll want a
large chunk/stripe for data transfer efficiency from the platters with
the fewest seeks.  If you have a mixed workload with small and large
files, it's best to use a small chunk size, such as 32 or 64KB.


All of that stated, your filesystem setup, specifically write barrier
support and journal mode, along with those slow disk spindles, will be =
a
much more significant impediment to performance than your chunk size.

Cheers,

Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
