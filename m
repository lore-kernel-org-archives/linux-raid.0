From: NeilBrown <neilb@suse.de>
Subject: Re: RAID0 DeviceDisappeared event happen when restart mdmonitor
 service
Date: Wed, 24 Oct 2012 13:10:40 +1100
Message-ID: <20121024131040.406ff1b9@notabene.brown>
References: <012401cd9260$141ca630$3c55f290$@com>
	<CA+res+TafD=pdpX-8bz8M4keGDO45Jd=W9VGSY+=douiqGPy5w@mail.gmail.com>
	<20120917124813.0bd260c3@notabene.brown>
	<CA+res+RvgxtHmYHw3DMCm7La9AFoCzxM93YLKJYvYy7EwBYyfw@mail.gmail.com>
	<016e01cd9483$d5690a70$803b1f50$@com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qj9w9NGIf+V9_ricsjuTEoH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <016e01cd9483$d5690a70$803b1f50$@com>
Sender: linux-raid-owner@vger.kernel.org
To: Johnson Yan <johnson_yan@usish.com>
Cc: 'Jack Wang' <jack.wang.usish@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qj9w9NGIf+V9_ricsjuTEoH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Sep 2012 11:23:40 +0800 "Johnson Yan" <johnson_yan@usish.com>
wrote:

> Hi Neil,
> Thank you for the clarification.
> I can remove the RAID0 MD's information from /etc/mdadm.conf to omit the =
monitor for RAID0, then so such event occurred when restart mdmonitor servi=
ce, but the system won't re-assemble these RAID0 MD after every system rebo=
ot.
> Do you have any good advice?

I do now...
I've just committed the following patch which should suppress the message.
It will be in mdadm-3.2.6 to be released soon.

NeilBrown





=46rom f1661bd71bec6a8ae1919dc32a227c6fb37843f2 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 24 Oct 2012 13:09:09 +1100
Subject: [PATCH] Monitor: don't complain about non-monitorable arrays in
 mdadm.conf

If we are asked to monitor a RAID0 or Linear - which cannot be
monitored - we complain with "Device Disappeared .... Wrong-Level".

However if the RAID0 or Linear is being requested because it is
in mdadm.conf then the message is inappropriate and confusing.

So track which arrays are added from the config file, and suppress
that message in that case.

Reported-by: "Johnson Yan" <johnson_yan@usish.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Monitor.c b/Monitor.c
index 69cd8e0..c4d57c3 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -37,6 +37,7 @@ struct state {
 	int err;
 	char *spare_group;
 	int active, working, failed, spare, raid;
+	int from_config;
 	int expected_spares;
 	int devstate[MAX_DISKS];
 	dev_t devid[MAX_DISKS];
@@ -178,6 +179,7 @@ int Monitor(struct mddev_dev *devlist,
 			st->next =3D statelist;
 			st->devnum =3D INT_MAX;
 			st->percent =3D RESYNC_UNKNOWN;
+			st->from_config =3D 1;
 			st->expected_spares =3D mdlist->spare_disks;
 			if (mdlist->spare_group)
 				st->spare_group =3D xstrdup(mdlist->spare_group);
@@ -475,7 +477,7 @@ static int check_array(struct state *st, struct mdstat_=
ent *mdstat,
 	 * have a device disappear than all of them that can
 	 */
 	if (array.level =3D=3D 0 || array.level =3D=3D -1) {
-		if (!st->err)
+		if (!st->err && !st->from_config)
 			alert("DeviceDisappeared", dev, "Wrong-Level", ainfo);
 		st->err =3D 1;
 		close(fd);



--Sig_/qj9w9NGIf+V9_ricsjuTEoH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIdOIDnsnt1WYoG5AQIvIQ/8CTR1rC3fflNwsfRQWmhW57IeUhKZrJAc
/9ZihRf0ctfxoic+MwREGJQFyON+bZSSzGKyCujAUXijYbbNsB6c+E46LGZE/Q3e
HVOGfY1dK4cdbxkwt7SkPE2gOr0+Q5rt8N7lF00FvZjyrh3loJjPihxpL/QYlQon
0Rzb9k06JvjBSZaykzM/l/teDO0t5ah1ksfu6LPrr8ct2KHFC8DLKyHubxh22P/g
Qm1OrLv6+wqRliY3lsbLmTLJwLDA112/ptwXE2bRlnRLVrxNbppQPO89VveBn2Oa
+UA//EdeSxGVACipW/4giWWmN0STpDVo5KDRy3aYyg8UjypXosNuZms3CcrF6VBd
uLHRp1Jgoz0Bl8Sb90kmrTODFhyvtK1iOWj8OHanX5qNPCAISQfn2sK30Y31joP+
0bPJHE8o93q8A7GNdsOrqvNd3AVLrSXg96QuIMS1amYY8ya9nc+iLlFK9hPByHb0
2sr1TYDY6ZWVno31f1aIFIhKpL2yaC8A7qyVTmGAQq09cHgccaStdMN0ITjistCt
uNmnhAkBKrNA42p4H+w6lou/MZtCKA8LvNMIdRi1zv6+ZeFMlBOuIHcdiHv3Du+m
MlrQZONCfJOADXFDRPtZN5usq0istLkYB7AYJbB+avxBqUl1WMiG6gyJvKK0mqS6
tUhMbmVfTKA=
=EmZs
-----END PGP SIGNATURE-----

--Sig_/qj9w9NGIf+V9_ricsjuTEoH--
