From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] md:Rewrite the md_write_start().
Date: Sun, 3 Jun 2012 14:11:40 -0700
Message-ID: <CAA9_cmd9CBe+GGduR7oiUvfDZagx=5NiTTUrG-HVmdqQYK_4xA@mail.gmail.com>
References: <201206021616382814001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206021616382814001@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jun 2, 2012 at 1:16 AM, majianpeng <majianpeng@gmail.com> wrote=
:
> Remove the judgement "bio_data_dir(bi) !=3D WRITE" in md_write_start(=
).Put
> it before call md_write_start.
>
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
> =A0drivers/md/md.c =A0 =A0 | =A0 =A04 +---
> =A0drivers/md/md.h =A0 =A0 | =A0 =A02 +-
> =A0drivers/md/raid1.c =A0| =A0 =A04 ++--
> =A0drivers/md/raid10.c | =A0 =A03 ++-
> =A0drivers/md/raid5.c =A0| =A0 =A03 ++-
> =A05 files changed, 8 insertions(+), 8 deletions(-)

If the deletions had outnumbered the insertions then maybe, but I
think just like kfree() allowing NULL pointers it's cleaner if the
caller need not worry.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
