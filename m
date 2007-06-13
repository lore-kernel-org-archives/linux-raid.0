From: "Thorsten Wolf" <T_Wolf@gmx.net>
Subject: Re: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Wed, 13 Jun 2007 13:45:53 +0200
Message-ID: <20070613114553.235550@gmx.net>
References: <20070612072408.19140@gmx.net>
 <18030.19615.898281.457910@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18030.19615.898281.457910@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,
hi everyone else.

I've been reading a lot about the mdadm tools lately, and I believe tha=
t it is possible, but I haven't found the right documentation yet.

Is it possible to re-mount the RAID I have from another Linux installat=
ion? Do I need more than the 'mdadm --detail --scan > /etc/mdadm.conf' =
info saved to another location (so I can re-import it)?

Regards,

Thorsten

> On Tuesday June 12, T_Wolf@gmx.net wrote:
> > Hello everyone.
> >=20
> > I've got a SLES9 SP3 running and I've been quite happy with it so f=
ar.
> >=20
> > Recently, I've created a 4 disk spanning RAID-5 on our company
> > server. Runs quite nice and we're happy with that too. I created
> > that RAID using the SLES mdadm (1.4 I believe) package.=20
> >=20
> > After discovering that there is a much newer mdadm out here (2.6.1)=
,
> > I decided to upgrade. It went just fine. Raid still running at 120
> > MB/sec.=20
> >=20
> > After adding a disk to the raid, which went fine as well...... BUT:
> >=20
> > The added disk /dev/sda1 shows up in /proc/mdstat, but does not hav=
e
> > the "spare (s)" flag.=20
> >=20
> > Plus... the --grow doesn't work...
> >=20
> > I get the: mdadm: /dev/md0: Cannot get array details from sysfs
> > error which has been discussed before. Can it be that this is cause=
d
> > by the 2.6.5-7.2xx Kernel? Any ideas?=20
>=20
> Yes.  All of your issues are caused by using a 2.6.5 based kernel.
> However even upgrading to SLES10 would not get you raid5-grow.  That
> came a little later.  You would need to compile a mainline kernel or
> wait for SLES11.
>=20
> NeilBrown

--=20
Contact me on ICQ: 7656468
skype://sysfried

Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!=20
Ideal f=FCr Modem und ISDN: http://www.gmx.net/de/go/smartsurfer
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
