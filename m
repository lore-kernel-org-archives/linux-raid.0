From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm
Date: Thu, 18 Nov 2010 11:11:49 +1100
Message-ID: <20101118111149.7b5004a2@notabene.brown>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>
	<20101117141514.759d9eea@notabene.brown>
	<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Wed, 17 Nov 2010 17:36:23 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:

>=20
> > On Wed, 17 Nov 2010 14:15:14 +1100 <neilb@suse.de> wrote:
> >
> > This looks wrong. mdadm should be looking for the container as list=
ed in
> > mdadm.conf and it should find a matching uuid on sda and sdb, but i=
t doesn't.
> >
> > Can you:
> >
> > mdadm -E /dev/sda /dev/sdb ; cat /etc/mdadm/mdadm.conf
> >
> > so I can compare the uuids?
> >
>=20
> Sure.
>=20
> # definitions of existing MD arrays ( So you don't have to scroll dow=
n :P )
>=20
>=20
> ARRAY metadata=3Dimsm UUID=3D084b969a:0808f5b8:6c784fb7:62659383
>=20
> ARRAY /dev/md/OneTB-RAID1-PV container=3D084b969a:0808f5b8:6c784fb7:6=
2659383 member=3D0 UUID=3Dae4a1598:72267ed7:3b34867b:9c56497a
>=20
=2E...
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 084b969a:0808f5b8:6c784fb7:6265=
9383
> [OneTB-RAID1-PV]:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : ae4a1598:72267ed7:3b34867b:9c56=
497a
=2E...
> # definitions of existing MD arrays
> ARRAY metadata=3Dimsm UUID=3D084b969a:0808f5b8:6c784fb7:62659383
> ARRAY /dev/md/OneTB-RAID1-PV container=3D084b969a:0808f5b8:6c784fb7:6=
2659383 member=3D0 UUID=3Dae4a1598:72267ed7:3b34867b:9c56497a

Yes, the uuids are definitely all correct.
This really should work.  I just tested a similar config and it worked
exactly as exported.
Weird.

Whatever version of mdadm are you running???
Can you try getting the latest (3.1.4) from
     http://www.kernel.org/pub/linux/utils/raid/mdadm/

and see how that works.
Just
    make
    ./mdadm -Asvv

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
