From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under Linux
Date: Mon, 14 May 2012 22:30:32 +0200
Message-ID: <4FB16B68.3000201@redhat.com>
References: <2598499.YYnUQlf0Se@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2598499.YYnUQlf0Se@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/12/12 08:36, Pawe=C5=82 Sikora wrote:
> fyi, this release contains a hidden strict-aliasing-violation bug [1]=
=2E
> please fix this correctly or build mdadm with -fno-strict-aliasing op=
tion.
>=20
> [1] http://www.spinics.net/lists/raid/msg37298.html

If you provide a patch, you're more likely to get the issue fixed than
by just telling other people to fix it for you.

Thanks,
Jes
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
