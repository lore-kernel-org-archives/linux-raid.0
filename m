From: "Majed B." <majedb@gmail.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Tue, 13 Oct 2009 17:04:12 +0300
Message-ID: <70ed7c3e0910130704l1f1f7f0ar66271d85295c667b@mail.gmail.com>
References: <hb1udb$6t1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hb1udb$6t1$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: ap23563m@gmx.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So what you want to do is have 3 partitions where you have /, /boot & t=
he rest?

=46or desktop usage it's OK to use that setup since you won't be writin=
g
to / and the other segments a lot at the same time.

If you're running an application which writes a lot of data to / and
you require to read/write a lot of data of the rest of the disk, it
will conflict and slow things down a lot.

Basically, you're partitioning each disk and making each partition
belong to an array. So if the collective partitions of Array1 are busy
with something and the partitions of Array2 are also busy, you'll slow
down because you're reading/writing to/from the same disk from two
different partitions.

On Tue, Oct 13, 2009 at 4:13 PM, Antonio Perez <ap23563m@gmx.com> wrote=
:
> If I'm posting to the wrong group, sorry. just point to the RTFM link=
=2E
>
> This post is about setting up a Debian box with four disks (size shou=
ld not
> be important, me thinks), let's assume that a Raid 5 is the correct t=
ype for
> the intended use.
>
> Keeping aside LVM and/or layering of md (just for simplicity), and ta=
king
> into account that /boot, / and maybe other areas should go in a Raid =
1
> configuration, for booting reliability. I have three questions that p=
erhaps
> you could help to clarify:
>
> 1.- Should the "rest of the disk" be only one partition?
> I have read that making several partitions and setting several md dis=
ks:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sd[a..d]2 --> md1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sd[a..d]3 --> md2
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sd[a..d]4 --> md3
> would help with the rebuild time of each md, which sounds correct. It=
 is
> also proposed that the md on the outer area of the disk would be fast=
er
> allowing for better control of performance, assigning faster mds to t=
he more
> used filesystems.
>
> However, and this I don't know, those sda[2..4] are not really differ=
ent
> devices (spindles) and reads to one md would conflict (or not?) with =
reads
> to the other mds.
>
> Setting the whole disk as one partition would prevent any conflict bu=
t would
> take longer to rebuild and files would be spread over the whole area =
of the
> disk.
>
> I really don't know the internals of md well enough to tell what adva=
ntages
> and problems one setup has over the other.
>
> 2.- On the Raid 1: How many sectors to copy? 63?
> On an update of grub code, core.img could change, which means that th=
e first
> 63 sectors (to be on the safe side) of the disk which gets the update=
 should
> be copied to the other 3 disks.
> Or is it that the md code would mirror sectors 1-62 and only the MBR =
needs
> to be manually mirroed?
>
> 2.- Is there a recomended way to trigger the said copy of question 2?
> Where should a call to copy the MBR should be placed? On update-grub?
>
> TIA
>
> --
> Antonio Perez
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
