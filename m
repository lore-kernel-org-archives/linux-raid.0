From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: How to recreate a dmraid RAID array with mdadm
Date: Wed, 17 Nov 2010 21:05:40 -0500
Message-ID: <BAY148-w149179108DC6D340247236EF390@phx.gbl>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>,<20101117141514.759d9eea@notabene.brown>,<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>,<20101118111149.7b5004a2@notabene.brown>,<BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>,<20101118122847.1530d86c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118122847.1530d86c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


> On Thu, 18 Nov 2010 12:28:47 +1100 <neilb@suse.de> wrote:
> >
> > I am running the same version, from a Debian Squeeze package which =
I presume is the same.
> >
> > mdadm -V
> >
> > mdadm - v3.1.4 - 31st August 2010
>
> Yes, should be identical to what I am running.
> >
> > >
> > > and see how that works.
> > > Just
> > > make
> > > ./mdadm -Asvv
> >
> > Regardless, I did recompile (attached is the make output -- no erro=
rs) and got similar mdadm output:
> >
> > ./mdadm -Asvv
> > mdadm: looking for devices for further assembly
> > mdadm: no RAID superblock on /dev/md126p1
> > mdadm: /dev/md126p1 has wrong uuid.
> > mdadm: no RAID superblock on /dev/md/OneTB-RAID1-PV
> > mdadm: /dev/md/OneTB-RAID1-PV has wrong uuid
> ....
> > mdadm: cannot open device /dev/sdb: Device or resource busy
> > mdadm: /dev/sdb has wrong uuid.
> > mdadm: cannot open device /dev/sda: Device or resource busy
> > mdadm: /dev/sda has wrong uuid.
>
> The arrays are clearly currently assembled. Trying to assemble them a=
gain is
> not likely to produce a good result :-) I should have said to "./mdad=
m -Ss"
> first.
>
> Could you apply this patch and then test again with:
>
> ./mdadm -Ss
> ./mdadm -Asvvv
>

Applied the patch:

if (ident->uuid_set && (!update || strcmp(update, "uuid")!=3D 0) &&
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (!tst || !tst=
->sb ||
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 same_uuid(=
content->uuid, ident->uuid, tst->ss->swapuuid)=3D=3D0)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 if (report_missmatch) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 char buf[200];
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": %s has wrong uuid.\n",
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devname);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 fprintf(stderr, " want %s\n", __fname_from_uuid(ident->uuid, 0, =
buf, ':'));
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 fprintf(stderr, " have %s\n", __fname_from_uuid(content->uuid, 0=
, buf, ':'));
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 fprintf(stderr, " metadata=3D%s\n", tst->ss->name);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 g=
oto loop;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }


And got:

=2E/mdadm -Ss

mdadm: stopped /dev/md127


=2E/mdadm -Asvvv

mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/dm-3
mdadm: /dev/dm-3 has wrong uuid.
=A0want UUID-084b969a:0808f5b8:6c784fb7:62659383
Segmentation fault


I took the liberty of extending the char buffer to 2000 bytes/chars and=
 64K (1<<16) but got the same segfaults.


-M
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
