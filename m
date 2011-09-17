From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: additional feature for linear
Date: Sat, 17 Sep 2011 11:20:32 -0400
Message-ID: <6385457414268580907@unknownmsgid>
References: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC_HdUr9DHt9uQGj=zJcgGvTknckfhyykDBX11XgX+wgOhHQUg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Henti Smith <henti@geekware.co.za>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2011-09-17, at 03:14, Henti Smith <henti@geekware.co.za> wrote:

> Would it not be possible to add functions to linear mode to mark this
> missing chunks as "bad blacks" and let the FS deal with it as such.

Linux RAID can already deal with such a problem IIRC but if the
filesystem superblock is missing or directory entries, you ain't going
no where. This kind of feature would require filesystem knowledge of
where the RAID split the device and would be better suited to a FS
like BTRFS which mirror superblock and metadata without any Linux
RAID.

Envoy=C3=A9 de mon appareil mobile.

J=C3=A9r=C3=B4me Poulin
Solutions G.A.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
