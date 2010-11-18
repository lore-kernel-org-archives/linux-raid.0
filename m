From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: How to recreate a dmraid RAID array with mdadm
Date: Wed, 17 Nov 2010 22:03:41 -0500
Message-ID: <BAY148-w494B0F5EB60CC742DFC817EF390@phx.gbl>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>,<20101117141514.759d9eea@notabene.brown>,<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>,<20101118111149.7b5004a2@notabene.brown>,<BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>,<20101118122847.1530d86c@notabene.brown>,<BAY148-w149179108DC6D340247236EF390@phx.gbl>,<20101118133247.7ffa99d1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118133247.7ffa99d1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


> On Thu, 18 Nov 2010 13:32:47 +1100 <neilb@suse.de> wrote:
> > ./mdadm -Ss
> >
> > mdadm: stopped /dev/md127
> >
> >
> > ./mdadm -Asvvv
> >
> > mdadm: looking for devices for further assembly
> > mdadm: no RAID superblock on /dev/dm-3
> > mdadm: /dev/dm-3 has wrong uuid.
> >  want UUID-084b969a:0808f5b8:6c784fb7:62659383
> > Segmentation fault
>
> Try this patch instead please.

Applied new patch and got:

=2E/mdadm -Ss

mdadm: stopped /dev/md127


=2E/mdadm -Asvvv
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/dm-3
mdadm: /dev/dm-3 has wrong uuid.
=A0want UUID-084b969a:0808f5b8:6c784fb7:62659383
=A0tst=3D0x10dd010 sb=3D(nil)
Segmentation fault


Again tried various buffer sizes (segfault above was with char buf[200]=
;)


if (ident->uuid_set && (!update || strcmp(update, "uuid")!=3D 0) &&
=A0=A0=A0 (!tst || !tst->sb ||
=A0=A0=A0=A0 same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)=3D=
=3D0)) {
=A0=A0=A0=A0=A0=A0=A0 if (report_missmatch) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char buf[1<<16];
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": %=
s has wrong uuid.\n",
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
evname);
=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, " want %s\n", __fname_from_=
uuid(ident->uuid, 0, buf, ':'));
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, " tst=3D%p sb=3D%p=
\n", tst, tst?tst->sb:NULL);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tst) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpri=
ntf(stderr, " have %s\n", __fname_from_uuid(content->uuid, 0, buf, ':')=
);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
printf(stderr, " metadata=3D%s\n", tst->ss->name);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 goto loop;
}

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
