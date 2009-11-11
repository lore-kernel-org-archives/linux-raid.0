From: "Majed B." <majedb@gmail.com>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 12:31:44 +0300
Message-ID: <70ed7c3e0911110131o3819013fkf2d5096cfbb8d8c4@mail.gmail.com>
References: <70ed7c3e0911102122l3565cfat7a35a8a649237f56@mail.gmail.com>
	<20091111081325702.LZCS6968@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111081325702.LZCS6968@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> mount -t ext2 /dev/hda4 /etc/mdadm/bitmap

I would suggest you mount the partition using UUID, just in case one
day the disk decided to change its name, like what happened to me a
while back.

On Wed, Nov 11, 2009 at 11:13 AM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
>> If you have a temporary space for your data, I'd suggest you move it
>> out and go for an internal bitmap solution. It certainly beats the
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0For 8 Terabytes of data? =C2=A0No, I don't=
=2E =C2=A0I'm also not really keen on
> interrupting the system ( in whatever fashion ) for six to eight days=
 while
> I copy the data out and back or taking the primary copy offline while=
 I
> re-do the array just so I can implement an internal bitmap. =C2=A0It'=
s much
> easier to handle the external situation one way or the other.
>
>> patch work you're going to have to do on the startup scripts (and
>> every time you update mdadm, or the distro).
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0That's why I am leaning strongly toward th=
e lower value script,
> which in fact I have already done. =C2=A0Of course, it's also trivial=
 to disable
> it. =C2=A0Updating mdadm or the distro won't affect the mount script.=
 =C2=A0At most I
> would only have to rename the link, and then only if the mdadm startu=
p link
> gets re-numbered, which is unlilkely. =C2=A0Creating the following sc=
ript and one
> symlink to it are hardly "patchwork" in any significant sense:
>
> #! /bin/sh
> # Explicitly mount /dev/hda4 prior to running mdadm so the write-inte=
nt
> # bitmap will be available to mdadm
>
> echo Mounting RAID bitmap...
> mount -t ext2 /dev/hda4 /etc/mdadm/bitmap
>
>
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
