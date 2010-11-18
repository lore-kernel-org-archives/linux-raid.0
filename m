From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm
Date: Thu, 18 Nov 2010 14:17:18 +1100
Message-ID: <20101118141718.44c1837f@notabene.brown>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>
	<20101117141514.759d9eea@notabene.brown>
	<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>
	<20101118111149.7b5004a2@notabene.brown>
	<BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>
	<20101118122847.1530d86c@notabene.brown>
	<BAY148-w149179108DC6D340247236EF390@phx.gbl>
	<20101118133247.7ffa99d1@notabene.brown>
	<BAY148-w494B0F5EB60CC742DFC817EF390@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w494B0F5EB60CC742DFC817EF390@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Wed, 17 Nov 2010 22:03:41 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:

>=20
> > On Thu, 18 Nov 2010 13:32:47 +1100 <neilb@suse.de> wrote:
> > > ./mdadm -Ss
> > >
> > > mdadm: stopped /dev/md127
> > >
> > >
> > > ./mdadm -Asvvv
> > >
> > > mdadm: looking for devices for further assembly
> > > mdadm: no RAID superblock on /dev/dm-3
> > > mdadm: /dev/dm-3 has wrong uuid.
> > >  want UUID-084b969a:0808f5b8:6c784fb7:62659383
> > > Segmentation fault
> >
> > Try this patch instead please.
>=20
> Applied new patch and got:
>=20
> ./mdadm -Ss
>=20
> mdadm: stopped /dev/md127
>=20
>=20
> ./mdadm -Asvvv
> mdadm: looking for devices for further assembly
> mdadm: no RAID superblock on /dev/dm-3
> mdadm: /dev/dm-3 has wrong uuid.
> =A0want UUID-084b969a:0808f5b8:6c784fb7:62659383
> =A0tst=3D0x10dd010 sb=3D(nil)
> Segmentation fault

Sorry... I guess I should have tested it myself..

The
   if (tst) {

Should be
=20
   if (tst && content) {

NeilBrown


>=20
>=20
> Again tried various buffer sizes (segfault above was with char buf[20=
0];)
>=20
>=20
> if (ident->uuid_set && (!update || strcmp(update, "uuid")!=3D 0) &&
> =A0=A0=A0 (!tst || !tst->sb ||
> =A0=A0=A0=A0 same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)=
=3D=3D0)) {
> =A0=A0=A0=A0=A0=A0=A0 if (report_missmatch) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char buf[1<<16];
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ":=
 %s has wrong uuid.\n",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 devname);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, " want %s\n", __fname_fro=
m_uuid(ident->uuid, 0, buf, ':'));
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, " tst=3D%p sb=3D=
%p\n", tst, tst?tst->sb:NULL);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tst) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fp=
rintf(stderr, " have %s\n", __fname_from_uuid(content->uuid, 0, buf, ':=
'));
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 fprintf(stderr, " metadata=3D%s\n", tst->ss->name);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0 }
> =A0=A0=A0=A0=A0=A0=A0 goto loop;
> }
>=20
>  		 	   		 =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
