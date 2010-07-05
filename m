From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 01/33] [hotunplug] we are testing mdstat, not ent which is
 undefined at this point
Date: Mon, 5 Jul 2010 11:35:05 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3BA@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893BF9@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893BF9@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi. Sending on behalf of Anna. She couldn't send to l-r directly.

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:21 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 01/33] [hotunplug] we are testing mdstat, not ent which=
 is undefined at this point

=46rom: Doug Ledford <dledford@redhat.com>

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
=A0mdstat.c |=A0=A0=A0 6 +++---
=A01 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index 58d349d..3bb74fa 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -348,9 +348,9 @@ struct mdstat_ent *mdstat_by_component(char *name)
=A0=A0=A0=A0=A0 while (mdstat) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct dev_member *m;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct mdstat_ent *ent;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ent->metadata_version &&
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 strncmp(ent->metadata_version=
, "external:", 9) =3D=3D 0=A0=A0=A0=A0 &&
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 is_subarray(ent->metadata_ver=
sion+9))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (mdstat->metadata_version &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 strncmp(mdstat->metadata_vers=
ion, "external:", 9) =3D=3D 0 &&
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0 is_subarray(mdstat->metadata_=
version+9))
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* don't return sub=
arrays, only containers */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else for (m =3D mdstat->members; m; m=
 =3D m->next) {
--=20
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
