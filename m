From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 32/33] Fix the count of member devices in mdstat_read
 function.
Date: Mon, 5 Jul 2010 11:51:15 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC435@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C67@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C67@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:45 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 32/33] Fix the count of member devices in mdstat_read f=
unction.

=46rom: Marcin Labun <marcin.labun@intel.com>

Correction of the number of container or volume member devices (devcnt =
in struct mdstat_ent). The number after the last devices was counted to=
wards member of devices.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
=A0mdstat.c |=A0=A0 10 ++++++----
=A01 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index 01a126b..5b9d997 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -94,19 +94,20 @@ static void free_member_devnames(struct dev_member =
*m)
=A0=A0=A0=A0=A0 }
=A0}
=A0
-static void add_member_devname(struct dev_member **m, char *name)
+static int add_member_devname(struct dev_member **m, char *name)
=A0{
=A0=A0=A0=A0=A0 struct dev_member *new;
=A0=A0=A0=A0=A0 char *t;
=A0
=A0=A0=A0=A0=A0 if ((t =3D strchr(name, '[')) =3D=3D NULL)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* not a device */
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0
=A0=A0=A0=A0=A0 new =3D malloc(sizeof(*new));
=A0=A0=A0=A0=A0 new->name =3D strndup(name, t - name);
=A0=A0=A0=A0=A0 new->next =3D *m;
=A0=A0=A0=A0=A0 *m =3D new;
+=A0=A0=A0=A0 return 0;
=A0}
=A0
=A0void free_mdstat(struct mdstat_ent *ms) @@ -207,8 +208,9 @@ struct m=
dstat_ent *mdstat_read(int hold, int start)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (in_devs =
&& strcmp(w, "blocks")=3D=3D0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
n_devs =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (in_devs) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ent=
->devcnt++;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 add=
_member_devname(&ent->members, w);
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(add_member_devname(&ent->members, w) =3D=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 ent->devcnt++;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
f (strncmp(w, "md", 2)=3D=3D0) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 /* This has an md device as a component.
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =A0* If that device is already in the
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
