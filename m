From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: Extend raid 5
Date: Mon, 12 Jan 2004 10:57:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xr7y5bibu.fsf@kth.se>
References: <1704458665.20040112011155@gmx.de> <20040112021335.GF17845@matchmail.com>
 <200401121021.08498.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maarten v d Berg <maarten@vbvb.nl> writes:

> Hi Mike.  I read about LVM some time ago and decided to use that as
> it seemed to solve my problem of the ever-growing data volume I need
> to store.
>
> However, after the initial setup I quickly dropped the LVM idea
> again since it only _seemed_ to solve my problem. As I understand
> it, LVM allows the addition of extra volumes but it does nothing at
> the level of the filesystem which resides on top. So in order to
> effectively grow my filesystem, which is the ultimate goal of
> course, I'd need to delete the current FS and make a new -bigger-
> one. And last time I checked this definitely kills your data.
>
> Otherwise, adding a 40 GB physical volume to a 120 GB raid5 / LVM
> set just gives me one 120 GB partition and [room for] another 40 GB
> partition.  There is NO gain whatsoever using LVM here compared to
> when I would just have added a single 40GB disk all by itself
> without using LVM in the first place, is there ?
>
> This has always left me wondering.  Did I miss something (except
> using some alpha FS-resize code...) ?

Yes, ext2, ext3, xfs, jfs and reiserfs can all be extended without
destroying the data.  Some of them can be reduced, too.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
