From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Converting from Raid 5 to 6
Date: Mon, 24 Oct 2011 15:11:33 +0100
Message-ID: <CADNH=7H90HX58zh8mSH54FdFgh46umEscj89t372PZjj9DnHtg@mail.gmail.com>
References: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Busby <michael.a.busby@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 October 2011 14:11, Michael Busby <michael.a.busby@gmail.com> wro=
te:
> At the moment i have a raid5 setup with 5 disks, i am looking=C2=A0to=
 add a
> 6th disk and change from raid 5 to raid 6
>
> having looked at Neil's site i have found the following command, and
> just want to double check this is still the recommend way of
> converting
>
> mdadm --grow /dev/md0 --level=3D6 --raid-disks=3D6 --backup-file=3D/h=
ome/md.backup
>
> also would i need to add the extra disk before or after the command?
>
> cheers
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Hi,

I grew my 6 disk RAID5 to a 7 disk RAID6. First, add the drive. Then
partition it as required. Then add the drive to the array (I think
it'll become a spare?). Then you can grow it.

Make sure you're using the latest mdadm tools available.

Regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
