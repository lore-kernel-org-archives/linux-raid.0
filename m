From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm
Date: Thu, 18 Nov 2010 13:32:47 +1100
Message-ID: <20101118133247.7ffa99d1@notabene.brown>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>
	<20101117141514.759d9eea@notabene.brown>
	<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>
	<20101118111149.7b5004a2@notabene.brown>
	<BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>
	<20101118122847.1530d86c@notabene.brown>
	<BAY148-w149179108DC6D340247236EF390@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w149179108DC6D340247236EF390@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Wed, 17 Nov 2010 21:05:40 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:


> ./mdadm -Ss
>=20
> mdadm: stopped /dev/md127
>=20
>=20
> ./mdadm -Asvvv
>=20
> mdadm: looking for devices for further assembly
> mdadm: no RAID superblock on /dev/dm-3
> mdadm: /dev/dm-3 has wrong uuid.
> =A0want UUID-084b969a:0808f5b8:6c784fb7:62659383
> Segmentation fault

Try this patch instead please.

NeilBrown

diff --git a/Assemble.c b/Assemble.c
index afd4e60..11e6238 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -344,9 +344,17 @@ int Assemble(struct supertype *st, char *mddev,
 		if (ident->uuid_set && (!update || strcmp(update, "uuid")!=3D 0) &&
 		    (!tst || !tst->sb ||
 		     same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)=3D=3D0=
)) {
-			if (report_missmatch)
+			if (report_missmatch) {
+				char buf[200];
 				fprintf(stderr, Name ": %s has wrong uuid.\n",
 					devname);
+				fprintf(stderr, " want %s\n", __fname_from_uuid(ident->uuid, 0, bu=
f, ':'));
+				fprintf(stderr, " tst=3D%p sb=3D%p\n", tst, tst?tst->sb:NULL);
+				if (tst) {
+					fprintf(stderr, " have %s\n", __fname_from_uuid(content->uuid, 0,=
 buf, ':'));
+					fprintf(stderr, " metadata=3D%s\n", tst->ss->name);
+				}
+			}
 			goto loop;
 		}
 		if (ident->name[0] && (!update || strcmp(update, "name")!=3D 0) &&

 		 	   		 =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
