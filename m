From: Neil Brown <neilb@suse.de>
Subject: Re: Man page patch (manage mode options clarification)
Date: Fri, 13 Jul 2007 15:41:51 +1000
Message-ID: <18071.4255.138632.190115@notabene.brown>
References: <20070114202129.GA27074@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Majorel on Sunday January 14
Sender: linux-raid-owner@vger.kernel.org
To: Andre Majorel <aym-xunil@teaser.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 14, aym-xunil@teaser.fr wrote:
> This one is more debatable than the previous one. It attempts to
> clarify the synopses of the manage mode options.
>=20
> Those options take arguments so make that evident in the synopses.
>=20
> I'm not entirely sure about the wording. Comments welcome. Is it
> clearer than what we have now ?

I don't like it, though it is very possibly that the current text
could be improved.

I don't see the devices as arguments to the flags.  They are arguments
to "mdadm" and the flag say what it should do with the arguments.

Maybe it is a subtle difference.  Maybe I just need more people to say
"Neil is wrong, Andre is right"...  Maybe someone else will have an
even better idea....

Thanks anyway.

NeilBrown


>=20
> Before :
>=20
>   For Manage mode:
>      -a, --add
>             hot-add listed devices.
>=20
>      --re-add
>             re-add a device that was recently removed from an array.
>=20
>      -r, --remove
>             remove  listed  devices.  They must not be active.  i.e.
>             they should be failed or spare devices.
>=20
>      -f, --fail
>             mark listed devices as faulty.
>=20
>      --set-faulty
>             same as --fail.
>=20
> After :
>=20
>   For Manage mode:
>      -a, --add [component-device ...]
>             Hot-add  its  arguments to raid-device.  If no arguments
>             are given, this option is a no-op.
>=20
>      --re-add [component-device ...]
>             Re-add its arguments to raid-device.  The arguments must
>             be  devices  that  were recently removed from the array.
>             If no arguments are given, this option is a no-op.
>=20
>      -r, --remove [component-device ...]
>             Remove its arguments from  raid-device.   The  arguments
>             must  not be active, i.e. they should be failed or spare
>             devices.  If no arguments are given, this  option  is  a
>             no-op.
>=20
>      -f, --fail [component-device ...]
>             Mark  its  arguments  as  faulty.   If  no arguments are
>             given, this option is a no-op.
>=20
>      --set-faulty [component-device ...]
>             Same as --fail.
>=20
> --=20
> Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
> Do not use this account for regular correspondence.
> See the URL above for contact information.
> diff -ur mdadm-2.6-man1/mdadm.8 mdadm-2.6-man2/mdadm.8
> --- mdadm-2.6-man1/mdadm.8	2007-01-14 14:50:25.000000000 +0100
> +++ mdadm-2.6-man2/mdadm.8	2007-01-14 15:19:07.000000000 +0100
> @@ -13,7 +13,7 @@
> =20
>  .SH SYNOPSIS
> =20
> -.BI mdadm " [mode] <raiddevice> [options] <component-devices>"
> +.BI mdadm " [mode] <raid-device> [options] <component-devices>"
> =20
>  .SH DESCRIPTION
>  RAID devices are virtual devices created from two or more
> @@ -836,25 +836,30 @@
>  .SH For Manage mode:
> =20
>  .TP
> -.BR -a ", " --add
> -hot-add listed devices.
> +\fB\-a\fP, \fB\-\-add\fP [\fIcomponent-device\fP ...]
> +Hot-add its arguments to \fIraid-device\fP.
> +If no arguments are given, this option is a no-op.
> =20
>  .TP
> -.BR --re-add
> -re-add a device that was recently removed from an array.
> +\fB\-\-re\-add\fP [\fIcomponent-device\fP ...]
> +Re-add its arguments to \fIraid-device\fP.
> +The arguments must be devices that were recently removed from the ar=
ray.
> +If no arguments are given, this option is a no-op.
> =20
>  .TP
> -.BR -r ", " --remove
> -remove listed devices.  They must not be active.  i.e. they should
> -be failed or spare devices.
> +\fB\-r\fP, \fB\-\-remove\fP [\fIcomponent-device\fP ...]
> +Remove its arguments from \fIraid-device\fP.
> +The arguments must not be active, i.e. they should be failed or spar=
e devices.
> +If no arguments are given, this option is a no-op.
> =20
>  .TP
> -.BR -f ", " --fail
> -mark listed devices as faulty.
> +\fB\-f\fP, \fB\-\-fail\fP [\fIcomponent-device\fP ...]
> +Mark its arguments as faulty.
> +If no arguments are given, this option is a no-op.
> =20
>  .TP
> -.BR --set-faulty
> -same as --fail.
> +\fB\-\-set\-faulty\fP [\fIcomponent-device\fP ...]
> +Same as \fB\-\-fail\fP.
> =20
>  .P
>  Each of these options require that the first device list is the arra=
y
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
