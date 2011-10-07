From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: BUG: spinlock lockup while performing FS operations
Date: Thu, 6 Oct 2011 17:39:03 -0700
Message-ID: <CAA9_cmfSTgF5WxcAFMa+TgfN1166a=XZziToF1mSyP2LqX9ctQ@mail.gmail.com>
References: <4E8DA415.8090007@russia.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E8DA415.8090007@russia.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: =?KOI8-R?B?98HMxdLJyg==?= <paramonov@russia.ru>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org, axboe@kernel.dk, duaneg@dghda.com
List-Id: linux-raid.ids

On Thu, Oct 6, 2011 at 5:50 AM, =F7=C1=CC=C5=D2=C9=CA <paramonov@russia=
=2Eru> wrote:
> Hi!
>
> Faced with this problem. There are RAID5, assembled by mdadm (/dev/md=
127),
> which is divided into 2 partitions (md127p1 and md127p2). In both rei=
serfs.
> The
> second partition is exported via NFS. Everything works, the array is =
intact
> and
> fully synchronized. SMART says disks are healthy. But when copy too m=
any
> files
> all hangs and saves only the reset. After a reset of course runs fsck=
, and
> then
> synchronize the array.
>
> I have a brand new computer. Sleaze is not set. Motherboard gigabyte
> 870-UD3,
> Power Supply FSP 700W, memory 16Gb Kingston, CPU Phenom II X6 1090T.
>
> I =9Areported an error =9Aon =9Abugs.gentoo.org:
> https://bugs.gentoo.org/show_bug.cgi?id=3D385047
> Was =9Acompiling a custom kernel =9Awith support for =9Adebugging and=
 =9Adebug
> messages are =9Areceived.
> Duane Griffin =9Athen =9Asent me =9Aupstream.
>
> Now I have have BUG spinlock lockup on screen:
>
> Nov 26 13:34:46 localhost kernel: BUG: spinlock lockup on CPU#2, mc/7=
609,
> ffff880419c37200
> Oct =9A4 15:55:50 localhost kernel: BUG: spinlock lockup on CPU#3,
> flush-9:127/2391, ffff880419c37200
>
> Full log from /var/log/messages:

This is the full log?  I see other /var/log/messages excerpts from the
gentoo bugzilla.  Just wondering if there were any other warnings in
the log that precede the failure?

Can you attach the kernel configuration file to that bugzilla as well.

It sounds like you can reproduce it reliably.  Is this a recent
upgrade, or a new install?  If it was working before an upgrade we
might be able to bisect.

--
Dan
