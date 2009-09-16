From: "Majed B." <majedb@gmail.com>
Subject: Re: Assemble and Stop array
Date: Wed, 16 Sep 2009 10:54:38 +0300
Message-ID: <70ed7c3e0909160054n7cad5615p6cbd5d0a72438b8e@mail.gmail.com>
References: <20090915233517830.IGLE14103@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090915233517830.IGLE14103@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you tried assembling the drives on another Linux box? Try using a =
LiveCD.
Which kernel are you running?
Which distribution?

On Wed, Sep 16, 2009 at 2:35 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I'm still trying to wrap my mind around tw=
o items.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0One is stopping an array. =C2=A0From time =
to time I need to stop an array
> for some reason, but I am persistently having trouble doing so. =C2=A0=
It doesn't
> always happen, and sometimes when it does I can free it up by doing
> `exportfs -ua` and `umount -l /xxxxx`, but other times it simply cann=
ot be
> done and my only recourse is to reboot the system. =C2=A0These are si=
mple RAID5
> or RAID6 arrays on raw drives with a single file system formatted on =
the
> unpartitioned array. =C2=A0None of the drives are used for booting or=
 for swap,
> there is no loop device and lsof shows no open files, but mdadm -S st=
ill
> fails with a device busy error. =C2=A0Every time it has happened, a s=
imple umount
> command without the -l switch fails, but a "lazy" umount appears to w=
ork,
> with the exception that sometimes I still cannot stop the array. =C2=A0=
Clearly,
> the NFS export is sometimes the culprit, but not always. =C2=A0What e=
lse can it
> be?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0The second item is assembling an array whi=
ch was formerly stopped.
> By my reading, `mdadm --assemble --scan` should work, but it doesn't.=
 =C2=A0It
> keeps telling me no devices are found for the array. =C2=A0Here is a =
sample from
> one of the /etc/mdadm/mdadm.conf files:
>
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>
> # auto-create devices with Debian standard permissions
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR lrhorer@satx.rr.com
>
> # This file was auto-generated on Fri, 21 Nov 2008 22:35:30 -0600
> # by mkconf $Id$
> PROGRAM /usr/bin/mdadm_notify
> DEVICE /dev/sd[a-j]
> ARRAY /dev/md/0 level=3Draid6 metadata=3D1.2 num-devices=3D10
> UUID=3D5ff10d73:a096195f:7a646bba:a68986ca name=3DRAID-Server:0
>
> When I manually assemble the array, I wind up having to re-create the=
 bitmap
> file, as well.
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
