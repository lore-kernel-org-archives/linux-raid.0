From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: LVM on raid10,f2 performance issues
Date: Mon, 19 Jan 2009 13:24:39 +0100
Message-ID: <49747107.8020607@rabbit.us>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk> <4935C4B3.2060404@gmail.com> <493654C7.2090909@ziu.info> <8CB47EBD70FE9E8-AC4-981@WEBMAIL-DG06.sim.aol.com> <20090119121724.GA23623@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090119121724.GA23623@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@dkuug.dk>
Cc: thomas62186218@aol.com, soltys@ziu.info, mauermann@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen wrote:
> Hmm,=20
>=20
> Why is the command
>=20
>  blockdev --setra 65536 /dev/md0
>=20
> really needed? I think the kernel should set a reasonable default her=
e.

The in-kernel default for a block device is 256 (128k) which is way too
low. the MD subsystems tries to be a bit smarter and assigns the md
device readahead according to the number of devices/raid level. For
streaming (i.e. file sever) these values are also too low. LVs can take
a readahead specification at creation time and use that, but this is
manual.

It is arguable what the typical workload is, but I would lean towards
big long linear reads (fileserver) vs short scattered ones (database).

The real solution to the problem was proposed a long time ago, and it
seems it got lost in the attic: http://lwn.net/Articles/155510/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
