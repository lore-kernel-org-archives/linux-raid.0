From: Nagilum <nagilum@nagilum.org>
Subject: Re: Problem re-shaping RAID6
Date: Mon, 14 Jun 2010 12:47:23 +0200
Message-ID: <20100614124723.84152dz5al8096f4@cakebox.homeunix.net>
References: <AANLkTikv3JPbto1F2YYmRx0HNP7cgFh3gj6dHekCt1SE@mail.gmail.com>
 <20100614091518.2492a9db@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100614091518.2492a9db@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


----- Message from neilb@suse.de ---------
     Date: Mon, 14 Jun 2010 09:15:18 +1000
     From: Neil Brown <neilb@suse.de>
  Subject: Re: Problem re-shaping RAID6
       To: J=E9r=F4me Poulin <jeromepoulin@gmail.com>
       Cc: linux-raid <linux-raid@vger.kernel.org>


> Thanks.
> I fixed this bug a slightly different way
>
> -               blocks =3D ochunk/512 * nchunk/512 * odata * ndata / =
a;
> +               blocks =3D (ochunk/512) * (nchunk/512) * odata * ndat=
a / a;
>
>
> See
> http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D200871adf9e15=
d5ad985f28c349fd89c386ef48a

Those static numbers always make my nose wrinkle.
Don't we have the blocksize somewhere already? I'm also concerned what =
=20
happens when true 4k sectors are used..



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 =
#
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 =
#
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   =
#
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux =
#
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 =
#
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
