From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [PATCH] getinfo_super1: when deciding whether the array is clean
 or dirty, compare sb->resync_offset against MaxSector and not against sb->size
Date: Mon, 6 Feb 2012 13:27:21 +0200
Message-ID: <CAGRgLy77y8801d-Sj=uXq75HrNZ6Xx3=hrC6hC8w2UPQ2OPaBw@mail.gmail.com>
References: <CAGRgLy6W4pJWQwuEwBWkjUq6+TzNaVs59RzLu6zLs7N2w69_MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6W4pJWQwuEwBWkjUq6+TzNaVs59RzLu6zLs7N2w69_MA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The commit message has been cut off. Here is the full message:

getinfo_super1: when deciding whether the array is clean or dirty,
compare sb->resync_offset against MaxSector and not against sb->size

With RAID6 resyncing and subsequent drive failures, it is possible to
reach the case, in which sb->resync_offset=3D=3Dsb->size. This happens
when resync is aborted due to drive failures, and immediately a
rebuild of a spare starts. In this case, mdadm was considered the
array as clean, while kernel was considering the array as dirty. It is
better for mdadm also to consider the array as dirty in this case.


On Mon, Feb 6, 2012 at 1:25 PM, Alexander Lyakas <alex.bolshoy@gmail.co=
m> wrote:
> From c1bc75c72f62c6583f17caa2d02a09dc72fbac74 Mon Sep 17 00:00:00 200=
1
> From: Alex Lyakas <alex@zadarastorage.com>
> Date: Mon, 6 Feb 2012 13:24:15 +0200
> Subject: [PATCH] getinfo_super1: when deciding whether the array is c=
lean or
> =A0dirty, compare sb->resync_offset against MaxSector and not
> =A0against sb->size
>
> With RAID6 resyncing and subsequent drive failures, it is possible to
> reach the case, in which sb->resync_offset=3D=3Dsb->size. This happen=
s
> when resync is aborted due to drive failures, a
>
> diff --git a/super1.c b/super1.c
> index 867aa58..c643bd3 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -573,7 +573,7 @@ static void getinfo_super1(struct supertype *st,
> struct mdinfo *info, char *map)
> =A0 =A0 =A0 =A0info->array.utime =3D __le64_to_cpu(sb->utime);
> =A0 =A0 =A0 =A0info->array.chunk_size =3D __le32_to_cpu(sb->chunksize=
)*512;
> =A0 =A0 =A0 =A0info->array.state =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__le64_to_cpu(sb->resync_offset) >=3D =
__le64_to_cpu(sb->size))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__le64_to_cpu(sb->resync_offset) !=3D =
MaxSector)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0? 1 : 0;
>
> =A0 =A0 =A0 =A0info->data_offset =3D __le64_to_cpu(sb->data_offset);
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
