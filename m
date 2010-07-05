From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 13/33] create: respect domains/subsets during create process
Date: Mon, 5 Jul 2010 11:46:21 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3FF@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C1A@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C1A@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:27 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 13/33] create: respect domains/subsets during create pr=
ocess

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0Create.c |=A0=A0 29 +++++++++++++++++++++++++++++
=A01 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/Create.c b/Create.c
index b04388f..2ea4205 100644
--- a/Create.c
+++ b/Create.c
@@ -116,6 +116,8 @@ int Create(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0 char chosen_name[1024];
=A0=A0=A0=A0=A0 struct map_ent *map =3D NULL;
=A0=A0=A0=A0=A0 unsigned long long newsize;
+=A0=A0=A0=A0 struct domain_ent *base_de =3D NULL;
+=A0=A0=A0=A0 struct subset *base_ss;
=A0
=A0=A0=A0=A0=A0 int major_num =3D BITMAP_MAJOR_HI;
=A0
@@ -281,6 +283,8 @@ int Create(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0 info.array.working_disks =3D 0;
=A0=A0=A0=A0=A0 dnum =3D 0;
=A0=A0=A0=A0=A0 for (dv=3Ddevlist; dv && !have_container; dv=3Ddv->next=
, dnum++) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct domain_ent *de;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct subset *ss;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char *dname =3D dv->devname;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long long freesize;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (strcasecmp(dname, "missing")=3D=3D=
0) { @@ -343,6 +347,31 @@ int Create(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de =3D conf_get_domain(dname, (char *)s=
t->ss->name);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!de) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name =
": Can't determine domain of %s.",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dna=
me);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (st)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st-=
>ss->free_super(st);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ss =3D conf_get_subset(dname, st, de);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!base_de) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 base_de =3D de;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 base_ss =3D ss;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (verbose > 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, Name ": Base domain set for "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "device: %s\n", dname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (base_de !=3D de |=
| base_ss !=3D ss) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(verbose > 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 fprintf(stderr, Name ": %s does not belong to the same "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "domain/subset.\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 freesize /=3D 2; /* convert to K */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (chunk) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* round to chunk s=
ize */
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
