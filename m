From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 22/33] Monitor: added function to get domain and subset of a
 disk
Date: Mon, 5 Jul 2010 11:49:05 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC419@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C43@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C43@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:36 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 22/33] Monitor: added function to get domain and subset=
 of a disk

=46or spare sharing.
Performs a check for failed status if required.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
=A0Monitor.c |=A0=A0 49 +++++++++++++++++++++++++++++++++++++++++++++++=
++
=A01 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index e16af2d..ed57af0 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -601,6 +601,55 @@ int check_disk_is_free(struct state *donor, int di=
sk_idx, int ext)
=A0=A0=A0=A0=A0 return disk_idx;
=A0}
=A0
+int get_disk_domain_and_subset(int devid, char *metadata_version, stru=
ct domain_ent **domain,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0=A0=A0 struct subset **subset, int fcheck) {
+=A0=A0=A0=A0 struct supertype *sty;
+=A0=A0=A0=A0 int fd;
+=A0=A0=A0=A0 char *devname =3D map_dev(major(devid), minor(devid), 1);
+
+=A0=A0=A0=A0 if (!devname)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 fd =3D open(devname, O_RDONLY);
+=A0=A0=A0=A0 if (fd < 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+
+=A0=A0=A0=A0 sty =3D guess_super(fd);
+=A0=A0=A0=A0 if (!sty) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 if (sty->ss->load_super(sty, fd, devname))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto fail;
+
+=A0=A0=A0=A0 /* check metadata for failed status*/
+=A0=A0=A0=A0 if (fcheck && disk_faulty(sty, major(devid), minor(devid)=
))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto fail;
+=A0=A0=A0=A0 close(fd);
+
+=A0=A0=A0=A0 *domain =3D conf_get_domain(strrchr(devname, '/'), metada=
ta_version);
+=A0=A0=A0=A0 if (*domain =3D=3D NULL) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *subset =3D NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto fail;
+=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 *subset =3D conf_get_subset(strrchr(devname, '/'), sty, *=
domain);
+=A0=A0=A0=A0 if (*subset =3D=3D NULL)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto fail;
+
+=A0=A0=A0=A0 sty->ss->free_super(sty);
+=A0=A0=A0=A0 free(sty);
+=A0=A0=A0=A0 return 1;
+
+fail:
+=A0=A0=A0=A0 if (fd >=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(fd);
+=A0=A0=A0=A0 sty->ss->free_super(sty);
+=A0=A0=A0=A0 free(sty);
+=A0=A0=A0=A0 return 0;
+}
+
=A0static void alert(char *event, char *dev, char *disc, char *mailaddr=
, char *mailfrom, char *cmd,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 int dosyslog)
=A0{
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
