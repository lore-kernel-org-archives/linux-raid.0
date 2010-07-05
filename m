From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 19/33] Assemble: assembly with domains - two runs for imsm
 spares
Date: Mon, 5 Jul 2010 11:47:38 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC40C@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C3B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C3B@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:34 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 19/33] Assemble: assembly with domains - two runs for i=
msm spares

UUID of an imsm spare matches any array but we are not able to decide i=
f the spare can be assembled with the array until we know this array's =
domain. Spares found before determining array's domain are marked and m=
atched in second run.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
=A0Assemble.c |=A0=A0 46 ++++++++++++++++++++++++++++++++++++----------
=A01 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index cc51428..a1ec8cb 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -168,6 +168,8 @@ int Assemble(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0 char *name =3D NULL;
=A0=A0=A0=A0=A0 int trustworthy;
=A0=A0=A0=A0=A0 char chosen_name[1024];
+=A0=A0=A0=A0 int run =3D 0;
+=A0=A0=A0=A0 int spare;
=A0
=A0=A0=A0=A0=A0 struct domain_ent *domain =3D NULL, *de;
=A0=A0=A0=A0=A0 struct subset *subset =3D NULL, *ss;
@@ -221,7 +223,9 @@ int Assemble(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0 if (verbose>0)
=A0=A0=A0=A0=A0 =A0=A0=A0 fprintf(stderr, Name ": looking for devices f=
or %s\n",
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 mddev ? mddev : "further as=
sembly");
-
+=A0=A0=A0=A0 run =3D 0;
+=A0=A0=A0=A0 spare =3D 0;
+second_run:
=A0=A0=A0=A0=A0 /* first walk the list of devices to find a consistent =
set
=A0=A0=A0=A0=A0 =A0* that match the criterea, if that is possible.
=A0=A0=A0=A0=A0 =A0* We flag the ones we like with 'used'.
@@ -234,8 +238,14 @@ int Assemble(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct stat stb;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct supertype *tst =3D dup_super(s=
t);
=A0
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tmpdev->used > 1) continue;
-
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tmpdev->used =3D=3D 2)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (run =3D=3D 1) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tmpdev->used !=3D=
 3)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmp=
dev->used =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ident->devices &&
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 !match_oneof(ident->devices=
, devname)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (report_missmatc=
h)
@@ -399,13 +409,22 @@ int Assemble(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ss =3D conf_get_sub=
set(devname, st, de);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!domain) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(report_missmatch) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 fprintf(stderr, Name ": Base domain set for "
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0 "device: =
%s\n",
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(memcmp(content->uuid, uuid_match_any,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0 sizeof(int[4])) !=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 if (report_missmatch) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name ": Base domain set =
for "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "device: %s\n", devnam=
e);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 domain =3D de;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 subset =3D ss;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } e=
lse{
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 /* imsm spares only
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 * we don't know if this spare can
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 * be used until we know domain
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 * so mark it for second run */
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 tmpdev->used =3D 3;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 spare =3D 1; /* set flag */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dom=
ain =3D de;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sub=
set =3D ss;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (domain !=3D de || subset !=3D ss) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 if (report_missmatch)
@@ -524,7 +543,8 @@ int Assemble(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmpdev->used =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tmpdev->used !=3D 3)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmpdev->used =3D 1;
=A0
=A0=A0=A0=A0=A0 loop:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tmpdev->content)
@@ -533,6 +553,12 @@ int Assemble(struct supertype *st, char *mddev,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tst->ss->free_super=
(tst);
=A0=A0=A0=A0=A0 }
=A0
+=A0=A0=A0=A0 /* We may have missed some spares before domain was deter=
mined */
+=A0=A0=A0=A0 if (run =3D=3D 0 && spare && domain) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 run =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto second_run;
+=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0 if (!st || !st->sb || !content)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 2;
=A0
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
