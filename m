From: Steven Dake <sdake@mvista.com>
Subject: Re: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Tue, 28 Oct 2003 11:12:07 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067364727.4612.359.camel@persist.az.mvista.com>
References: <3F9D82F0.4000307@mvista.com>
	 <20031027210054.GR24286@marowsky-bree.de> <3F9D8AAA.7010308@mvista.com>
	 <20031028110034.GG30725@marowsky-bree.de>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031028110034.GG30725@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Mark Bellon <mbellon@mvista.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2003-10-28 at 04:00, Lars Marowsky-Bree wrote:
> On 2003-10-27T14:14:18,
>    Mark Bellon <mbellon@mvista.com> said:
>=20
> > The uSDE and udev are simlar in some respects. The uSDE allows for=20
> > complete control of the policy handling a device - not just its nam=
ing.=20
>=20
> Well, so could udev in theory, and I had this plan to enhance it to d=
o
> so for the specific case of multipathing one day in the not too dista=
nt
> future (ie, before q1/04).
>=20
> In as far as I can see, udev and uSDE really do not have too differen=
t
> goals. Competition is good, but only if they explore distinct approac=
hes
> ;-)
>=20
There are several distinct approaches which have been enumerated in
other mails.

Since this point has not been addressed, I'd like to focus on the major
difference in philosophy.

SDE places all policy in the hands of the policy developer in a seperat=
e
policy program.  udev places the policies in the main processing loop o=
f
the system, effectively implementing whatever policy is desired by the
udev maintainers.

Without seperating policies from the core executive of device naming
system, the core of udev suffers from the same issues as placing policy
in the kernel suffers.   Lack of maintainability, lack of user-defined
functionality, bloat, etc.

> > >How does this integrate with DM, md, EVMS, LVM...?
> > As devices appear in sysfs the uSDE reacts to them via their hotplu=
g=20
> > events. The policy for each device handles any device issues includ=
ing=20
> > dealing with any device nodes.  It is possible to track and maintai=
n=20
> > multiported devices and automatically provide multipath devices nod=
es=20
> > for instance.
>=20
> Yes, I know that, I was asking whether you had done any discussion wi=
th
> the EVMS2 folks for example to have a policy plugin to interact with
> EVMS2 accordingly and do the magic.
>=20
>=20
No but this is definately a good idea.
Thanks!
-steve
>=20
> Sincerely,
>     Lars Marowsky-Br=C3=A9e <lmb@suse.de>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
