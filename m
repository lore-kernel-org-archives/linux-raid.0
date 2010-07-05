From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 33/33] Try exclusive open on a spare device before it is
 added to another container.
Date: Mon, 5 Jul 2010 11:51:24 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC436@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C6B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C6B@irsmsx504.ger.corp.intel.com>
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
Subject: [PATCH 33/33] Try exclusive open on a spare device before it i=
s added to another container.

=46rom: Marcin Labun <marcin.labun@intel.com>

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
=A0Monitor.c |=A0=A0 48 +++++++++++++++++++++++++++++++++++------------=
-
=A01 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 932a2bc..a1ae67f 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -534,8 +534,9 @@ int Monitor(mddev_dev_t devlist,
=A0=A0=A0=A0=A0 return 0;
=A0}
=A0
-static int move_spare(struct state *st2, struct state *st1, int i, cha=
r *mailaddr,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 char *mailfrom, char *a=
lert_cmd, int dosyslog)
+static int move_spare(struct state *st2, struct state *st1, int i,=20
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 char *mailaddr, char *m=
ailfrom, char *alert_cmd,=20
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 int dosyslog)
=A0
=A0{
=A0=A0=A0=A0=A0 struct mddev_dev_s devlist;
@@ -570,20 +571,41 @@ static int move_spare(struct state *st2, struct s=
tate *st1, int i, char *mailadd
=A0
=A0=A0=A0=A0=A0 devlist.disposition =3D 'r';
=A0=A0=A0=A0=A0 if (Manage_subdevs(st2->devname, from_fd, &devlist, -1)=
 =3D=3D 0) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devlist.disposition =3D 'a';
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (Manage_subdevs(st1->devname, to_fd,=
 &devlist, -1) =3D=3D 0) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st2->devid[i] =3D 0;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ping_manager(st2->dev=
name);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ping_manager(st1->dev=
name);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 alert("MoveSpare", st=
1->devname, st2->devname, mailaddr,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 mailf=
rom, alert_cmd, dosyslog);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(from_fd);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(to_fd);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int dfd;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dfd =3D open(dv, O_RDWR|O_EXCL);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (dfd < 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Er=
ror: Exclusive open on device %s failed\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dv)=
;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devlist.disposition =3D=
 'a';
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (Manage_subdevs(st=
2->devname, from_fd, &devlist,=20
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0 -1) !=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr,=20
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "Error: Adding back spare device %s"
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "to container %s failed!\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 st2->devname, dv);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Manage_subdevs(st2->d=
evname, from_fd, &devlist, -1);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devlist.disposition =3D=
 'a';
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (Manage_subdevs(st=
1->devname, to_fd, &devlist,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0 -1) =3D=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st2=
->devid[i] =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pin=
g_manager(st2->devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pin=
g_manager(st1->devname);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ale=
rt("MoveSpare", st1->devname, st2->devname,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=
=A0=A0=A0=A0 mailaddr, mailfrom, alert_cmd, dosyslog);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 clo=
se(from_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 clo=
se(to_fd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (Manage_sub=
devs(st2->devname, from_fd,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 &devlist, -1) !=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr,=20
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "Error: Adding back spare device"
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "%s to container %s failed!\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 st2->devname, dv);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 /* Failed to add spare to new container */
=A0=A0=A0=A0=A0 close(from_fd);
=A0=A0=A0=A0=A0 close(to_fd);
=A0=A0=A0=A0=A0 return 0;
--=20
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
