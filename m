From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Subject: Re: ANNOUNCE: mdadm 3.2.4 - A tool for managing Soft RAID under Linux
Date: Mon, 14 May 2012 22:57:03 +0200
Message-ID: <1714869.L4aqWfddyq@localhost>
References: <2598499.YYnUQlf0Se@localhost> <4FB16B68.3000201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB16B68.3000201@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 14 of May 2012 22:30:32 Jes Sorensen wrote:
> On 05/12/12 08:36, Pawe=C5=82 Sikora wrote:
> > fyi, this release contains a hidden strict-aliasing-violation bug [=
1].
> > please fix this correctly or build mdadm with -fno-strict-aliasing =
option.
> >=20
> > [1] http://www.spinics.net/lists/raid/msg37298.html
>=20
> If you provide a patch, you're more likely to get the issue fixed tha=
n
> by just telling other people to fix it for you.

i have sent you a revert request with a proper fix 3 months ago
and you have finally rejected it with "invalid commit message",
so feel free to keep broken mdadm sources as long as you wish :>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
