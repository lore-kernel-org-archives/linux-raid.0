From: Steven Dake <sdake@mvista.com>
Subject: Re: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Mon, 27 Oct 2003 16:15:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067296529.4612.234.camel@persist.az.mvista.com>
References: <3F9D82F0.4000307@mvista.com>
	 <20031027210054.GR24286@marowsky-bree.de>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031027210054.GR24286@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Mark Bellon <mbellon@mvista.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2003-10-27 at 14:00, Lars Marowsky-Bree wrote:
> On 2003-10-27T13:41:20,
>    Mark Bellon <mbellon@mvista.com> said:
>=20
> > Initial availability of User-Space System Device Enumeration (uSDE)=
=20
> > package, version 0.74, can be found at http://sourceforge.net/proje=
cts/usde
>=20
> How does it relate to udev?
>=20
> > multipath-policy - handles the automatic provisioning of multipathi=
ng=20
> > for multiported storage devices.
>=20
> How does this integrate with DM, md, EVMS, LVM...?
>=20
Device mapper and the md layer generates hotplug events which are
managed by the framework.  There is no specific policy for these
subsystems, but they could be implemented...  With today's code, they
fall through and are exported as disks.  One good policy method that
could be implemented is to scan the lvm lv list and map the major/minor
to the real lv, and use that to name the device (instead of lvm naming
the device).  This hasn't been done but if your up for it, Mark can
probably help you.

One of the cool features that integrates with MD is that multiple paths
are automatically configured via the MD driver (similiar to the
automatic multipathing program I have written and posted to this list).=
=20
Basically that program was turned into a policy for the uSDE.

The code your looking for if you want to see how the multipath policy
works is in:
sde/programs/policy-methods/mass-storage/multipath

Thanks!
-steve

> Thanks,
>     Lars Marowsky-Br=C3=A9e <lmb@suse.de>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
