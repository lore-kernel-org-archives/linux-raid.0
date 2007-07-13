From: Neil Brown <neilb@suse.de>
Subject: Re: Man page patch (bold font for option names in MISC MODE section)
Date: Fri, 13 Jul 2007 15:37:56 +1000
Message-ID: <18071.4020.928807.59185@notabene.brown>
References: <20070114135620.GA18756@aym.net2.nerim.net>
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
> In the MISC MODE section in mdadm(8), the names of the options
> should be in bold.

Thanks.  I have applied this patch (only 6 months later....)

NeilBrown

>=20
> --=20
> Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
> Do not use this account for regular correspondence.
> See the URL above for contact information.
> In the MISC MODE section in mdadm(8), the names of the options should=
 be
> in bold.
>=20
>   -- AYM 2007-01-14
>=20
> diff -ur mdadm-2.6/mdadm.8 mdadm-2.6-man1/mdadm.8
> --- mdadm-2.6/mdadm.8	2006-12-21 07:11:01.000000000 +0100
> +++ mdadm-2.6-man1/mdadm.8	2007-01-14 14:50:25.000000000 +0100
> @@ -1363,14 +1363,14 @@
>  MISC mode includes a number of distinct operations that
>  operate on distinct devices.  The operations are:
>  .TP
> ---query
> +.B --query
>  The device is examined to see if it is
>  (1) an active md array, or
>  (2) a component of an md array.
>  The information discovered is reported.
> =20
>  .TP
> ---detail
> +.B --detail
>  The device should be an active md device.
>  .B   mdadm
>  will display a detailed description of the array.
> @@ -1404,7 +1404,7 @@
>  .RE
> =20
>  .TP
> ---examine
> +.B --examine
>  The device should be a component of an md array.
>  .B mdadm
>  will read the md superblock of the device and display the contents.
> @@ -1423,27 +1423,27 @@
>  config file to be examined.
> =20
>  .TP
> ---stop
> +.B --stop
>  The devices should be active md arrays which will be deactivated, as
>  long as they are not currently in use.
> =20
>  .TP
> ---run
> +.B --run
>  This will fully activate a partially assembled md array.
> =20
>  .TP
> ---readonly
> +.B --readonly
>  This will mark an active array as read-only, providing that it is
>  not currently being used.
> =20
>  .TP
> ---readwrite
> +.B --readwrite
>  This will change a
>  .B readonly
>  array back to being read/write.
> =20
>  .TP
> ---scan
> +.B --scan
>  For all operations except
>  .BR --examine ,
>  .B --scan
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
