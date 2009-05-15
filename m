From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: Subject: [PATCH] mdadm: raid0: support chunks of 4K*n for raid0
Date: Fri, 15 May 2009 09:29:16 +0530
Message-ID: <921ca19c0905142059u3c16ca2bk6d830d1f74c58ee3@mail.gmail.com>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
	 <1242297833-13908-2-git-send-email-maan@systemlinux.org>
	 <fe4d072c76f1ce1d6b2b75f83766b1f0.squirrel@neil.brown.name>
	 <20090514121042.GH11504@skl-net.de>
	 <4743925b38e2d64317e0b6d7c8005a29.squirrel@neil.brown.name>
	 <1242321131.11444.23.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242321131.11444.23.camel@raz>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

I donot understand why this needs to be done in raid. Why should be the=
 raid
taking care of 4k*n data sets.

What I see of this patch is that it specifically checks for some sort
of 4K Boundaries.

Thanks,
Sujit

On Thu, May 14, 2009 at 10:42 PM, raz ben yehuda <raziebe@gmail.com> wr=
ote:
> Neil.
> I do not know what is policy for mdadm patches. I would thankful for =
some instructions.
> The bellow is the patch I applied to support raid0 chunk sizes 4K*n.
> ---
> --- mdadm.c =A0 =A0 (revision 16152)
> +++ mdadm.c =A0 =A0 (working copy)
> @@ -314,7 +314,8 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(2=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0chunk =3D strtol(optar=
g, &c, 10);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!optarg[0] || *c ||=
 chunk<4 || (chunk%4)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!optarg[0] || *c ||=
 chunk<4 || =A0(((chunk-1)&chunk) && level !=3D0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 || =A0(((chunk%4) && level =3D=3D0) )) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprint=
f(stderr, Name ": invalid chunk/rounding value: %s\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0optarg);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(2=
);
>
>
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
