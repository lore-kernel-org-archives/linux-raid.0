From: Beolach <beolach@gmail.com>
Subject: Re: RAID0 on disks with different sizes
Date: Mon, 15 Mar 2010 00:58:22 -0700
Message-ID: <aebf5d971003150058l66a84f4ak26b05b3c73a4d32c@mail.gmail.com>
References: <d19eda751003142326j7bfec447ne64cfa50e22f089c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d19eda751003142326j7bfec447ne64cfa50e22f089c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rj <ratnadeep@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 14, 2010 at 23:26, rj <ratnadeep@gmail.com> wrote:
> Hi,
>
> How does MD RAID0 layer support disks with different sizes?
> 1. Does it take the size of smallest disk and do the striping
> accordingly? =C2=A0This way there would be wastage of space in bigger
> disks.
> Or
> 2. Does it stripe across all the space of disks? This way, if stripin=
g
> is not possible for a disk because it has exhausted the space,
> striping will continue or remaining devices (although with
> compromising performance for these stripes because they have one disk
> less).
>
> What approach md chooses? Also, what approach is taken for RAID5 in s=
uch cases?
>

MD RAID0 follows #2; 4/5/6 follow #1.  From the man page for md:

   RAID0
<snip>
       If devices in the array are not all the same size, then once the=
 small=E2=80=90
       est device has been  exhausted,  the  RAID0  driver  starts  col=
lecting
       chunks  into smaller stripes that only span the drives which sti=
ll have
       remaining space.

   RAID1
<snip>
       All devices in a RAID1 array should be the same size.  If they a=
re not,
       then  only the amount of space available on the smallest device =
is used
       (any extra space on other devices is wasted).
<snip>

   RAID4
<snip>
       Unlike RAID0, RAID4 also requires that all stripes span all driv=
es,  so
       extra space on devices that are larger than the smallest is wast=
ed.
<snip>

My understanding is that this is why MD RAID0 does not yet support
--grow, while MD RAID456 does - since they take different striping
approaches, it's much harder to reuse the --grow algorithm.


Good luck,
Conway S. Smith
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
