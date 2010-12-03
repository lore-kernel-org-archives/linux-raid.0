From: Neil Brown <neilb@suse.de>
Subject: Re: turn off auto assembly
Date: Fri, 3 Dec 2010 12:30:09 +1100
Message-ID: <20101203123009.0aa23102@notabene.brown>
References: <4CF7F369.4090303@stud.tu-ilmenau.de>
	<slrnifg359.9qh.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnifg359.9qh.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2 Dec 2010 22:16:25 +0100 Mario 'BitKoenig' Holbe
<Mario.Holbe@TU-Ilmenau.DE> wrote:

> Stefan /*St0fF*/ H=FCbner <stefan.huebner@stud.tu-ilmenau.de> wrote:
> > Now I have the effect that upon plugging in drives that formerly we=
re
> > part of an array, the md_mod modules gets loaded and tries to
> > auto-assemble arrays.  This disturbs the diagnosis.
> > I've tried raid=3Dnoautodetect as kernel commandline, and I grepped=
 the
> > source for the MODULE_PARM_DESC macro, which yielded no (useful) re=
sult.
> >  This "automagic" behaviour happens since 2.6.36.
>=20
> Are you sure this autodetection is triggered by the module?
> And are you sure this behaviour is bound to this specific kernel
> version?
>=20
> In-Kernel auto-assembly is usually not active when md is compiled as
> module. Probably in your case this is some udev-triggered assembly?

s/usually not/never/

With a sufficiently recent mdadm, you can put
   AUTO -all

in mdadm.conf to disable auto-assembly.

Alternately, find the udev rule (/lib/udev/rules.d/64-md-something) and=
=20
comment out the bit where it runs "mdadm -I" or "mdadm --incremental".

NeilBrown


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
