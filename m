From: NeilBrown <neilb@suse.de>
Subject: Re: External bitmap, questions
Date: Sat, 19 Feb 2011 15:49:24 +1100
Message-ID: <20110219154924.2218c87c@notabene.brown>
References: <AANLkTinb3TvJr_-GPjMhXsyA-zwkf45GRAfpb7+Xio6H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinb3TvJr_-GPjMhXsyA-zwkf45GRAfpb7+Xio6H@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 19 Feb 2011 00:47:10 +0000 Mathias Bur=E9n <mathias.buren@gmail=
=2Ecom>
wrote:

> Hi,
>=20
> >From the mdadm manual:
>=20
> "-b, --bitmap=3D
> [...]
> Note: external bitmaps are only known to work on ext2 and ext3.
> Storing bitmap files on other filesystems may result in serious
> problems."
>=20
> I was planning to store the external bitmap on an ext4 partition. Wil=
l
> this be a problem, or is the warning there because it hasn't been
> tested enough but no problems found?

External bitmaps use 'BMAP' to find where the file lives on the device =
and
then writes directly to the device - not through the filesystem.

So as long as there is no tail-packing to block migration happening it =
should
work fine.

I haven't looked inside ext4 but I am fairly confident that external bi=
tmaps
will work properly.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
