From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: RAID5 reconstruction ?
Date: Sat, 30 May 2009 18:22:40 +0530
Message-ID: <921ca19c0905300552g7697e4c6of8c357d9b456ad0d@mail.gmail.com>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Are you talking about hardware raid or software raid.

I donot think hardware raid can by itself do much of the
book keeping.

Software Raid I think is different from having raid 0 to raid 1
to raid 2 to raid 3 to raid 4 to raid 5.

hope this is correct information.

Thanks,


On Sat, May 30, 2009 at 11:14 AM, SandeepKsinha <sandeepksinha@gmail.co=
m> wrote:
> Hi all,
>
> Say If I have a RAID 5 array of 50GB of five disks of 10GB each.
>
> I have data of 5GB. When a disk fails and replaced with a spare disk.
> Will the reconstruction happen only for the 5GB allocated disk blocks
> or it will happen for the whole disk size.
>
>
> Is it possible to make =A0reconstruction intelligent enough to keep i=
t optimized ?
>
> Thanks.
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> =93To learn is to change. Education is a process that changes the lea=
rner.=94
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
-- Sujit K M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
