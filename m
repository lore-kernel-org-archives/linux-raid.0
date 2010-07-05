From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 05/33] Partition action support in DOMAIN line
Date: Mon, 5 Jul 2010 11:43:59 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3E8@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C05@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C05@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:23 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 05/33] Partition action support in DOMAIN line

=46rom: Doug Ledford <dledford@redhat.com>

Add the table and program options for partition action and make them a =
requirement.
Stub entries for making partition handling be done via an indirection l=
ayer so we can easily support different partitioning methods required f=
or different platforms.
Modify config parsing and domain struct to use a partition handler entr=
y instead of just a program name.

=A0=A0=A0 Signed-off-by: Doug Ledford <dledford@redhat.com>
---
=A0Incremental.c |=A0=A0 17 ++++++++++++---
=A0config.c=A0=A0=A0=A0=A0 |=A0=A0 59 +++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++-
=A0mdadm.h=A0=A0=A0=A0=A0=A0 |=A0=A0 20 +++++++++++++++++++
=A0util.c=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 59 +++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++
=A04 files changed, 150 insertions(+), 5 deletions(-)

diff --git a/Incremental.c b/Incremental.c index d1d9ee1..ca70a35 10064=
4
--- a/Incremental.c
+++ b/Incremental.c
@@ -947,7 +947,7 @@ static int IncrementalNewDisk(char *devname, int ve=
rbose, int export,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 str=
uct domain_ent *domain)
=A0{
=A0=A0=A0=A0=A0 struct stat stb;
-=A0=A0=A0=A0 int dfd;
+=A0=A0=A0=A0 int dfd, rv;
=A0
=A0=A0=A0=A0=A0 dfd =3D dev_open_check(devname, O_RDONLY|O_EXCL, &stb);
=A0=A0=A0=A0=A0 if (dfd < 0)
@@ -960,16 +960,25 @@ static int IncrementalNewDisk(char *devname, int =
verbose, int export,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 1;
=A0=A0=A0=A0=A0 }
+
+=A0=A0=A0=A0 if (domain->handler->check_table(dfd, verbose, export, do=
main) =3D=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 /*
=A0=A0=A0=A0=A0 =A0* OK, at this point we have a valid block device wit=
hout a
-=A0=A0=A0=A0 * superblock.=A0 If we aren't in force mode, then don't u=
se the
+=A0=A0=A0=A0 * superblock, the partition table doesn't match, and we a=
re a
+=A0=A0=A0=A0 * partition domain.=A0 If we aren't in force mode, then d=
on't use the
=A0=A0=A0=A0=A0 =A0* device unless it's "clean", meaning no filesystems=
, no lvm,
=A0=A0=A0=A0=A0 =A0* no anything.=A0 The requirement here is that both =
the first and
=A0=A0=A0=A0=A0 =A0* last 4k of the device must be one of three pattern=
s: 0x00, 0x5a,
=A0=A0=A0=A0=A0 =A0* or 0xff.
=A0=A0=A0=A0=A0 =A0*/
-
-=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if (check_clean(dfd) || force(domain)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rv =3D domain->handler->write_table(dfd=
, verbose, export, domain);
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 close(dfd);
+=A0=A0=A0=A0 return rv;
=A0}
=A0
=A0/*
diff --git a/config.c b/config.c
index bd80cd6..b429968 100644
--- a/config.c
+++ b/config.c
@@ -707,6 +707,10 @@ void free_domain(struct domain_ent *de)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(dp->path);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(dp);
=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0 if (de->spare_group)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(de->spare_group);
+=A0=A0=A0=A0 if (de->table)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(de->table);
=A0=A0=A0=A0=A0 free(de);
=A0}
=A0
@@ -715,7 +719,7 @@ void domainline(char *line)
=A0=A0=A0=A0=A0 char *w;
=A0=A0=A0=A0=A0 struct domain_ent *de;
=A0=A0=A0=A0=A0 struct domain_path *path, *prev_path;
-=A0=A0=A0=A0 int offset, a_seen=3D0, m_seen=3D0, sg_seen=3D0;
+=A0=A0=A0=A0 int offset, a_seen=3D0, m_seen=3D0, sg_seen=3D0, p_seen=3D=
0, t_seen=3D0;
=A0
=A0=A0=A0=A0=A0 de =3D malloc(sizeof(struct domain_ent));
=A0=A0=A0=A0=A0 if (!de) {
@@ -725,6 +729,8 @@ void domainline(char *line)
=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 de->paths =3D NULL;
=A0=A0=A0=A0=A0 de->spare_group =3D NULL;
+=A0=A0=A0=A0 de->handler =3D NULL;
+=A0=A0=A0=A0 de->table =3D NULL;
=A0=A0=A0=A0=A0 de->action =3D incremental;
=A0=A0=A0=A0=A0 de->st =3D NULL;
=A0=A0=A0=A0=A0 de->next =3D NULL;
@@ -804,6 +810,45 @@ void domainline(char *line)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
ree_domain(de);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 r=
eturn;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (strncasecmp("program=3D", w,=
 8) =3D=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int i =3D 0;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct partition_hand=
ler *h =3D partition_list[i];
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!p_seen)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p_s=
een =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, Name ": only one program=3D "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "entry allowed per domain line, "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "ignoring\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 while(h) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(strncasecmp(w+8, h->match, strlen(h->match)) =3D=3D 0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 break;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 h =3D=
 partition_list[++i];
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!h) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, Name ": failed to recognize "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "program %s\n", w+8);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fre=
e_domain(de);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de->handler =3D h;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (strncasecmp("table=3D", w, 6=
) =3D=3D 0) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!t_seen)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 t_s=
een =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, Name ": only one table=3D "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "entry allowed per domain line, "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "ignoring\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 con=
tinue;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 de->table =3D strdup(=
w+6);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!de->table) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fpr=
intf(stderr, Name ": failed to allocate "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 "memory for table\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fre=
e_domain(de);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret=
urn;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Nam=
e ": unrecognized option %s on "
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
domain line\n", w);
@@ -852,6 +897,18 @@ void domainline(char *line)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free_domain(de);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!de->table || !de->handler) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name =
": partition action requires "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "bo=
th a table and program setting.\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free_domain(de);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (de->handler->validate(de)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, Name =
": partition table file failed "
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "va=
lidation.\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free_domain(de);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0 de->next =3D domain_list;
=A0=A0=A0=A0=A0 domain_list =3D de;
diff --git a/mdadm.h b/mdadm.h
index 3862853..509ee9f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -295,6 +295,17 @@ enum domain_actions {=A0 #define action(domain) ((=
domain)->action & action_mask)=A0 #define force(domain) ((domain)->acti=
on & force)
=A0
+struct domain_ent;
+
+extern struct partition_handler {
+=A0=A0=A0=A0 char=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *match; /* st=
ring we match in mdadm.conf */
+=A0=A0=A0=A0 int =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (*validate)(s=
truct domain_ent *domain);
+=A0=A0=A0=A0 int =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (*check_table=
)(int dfd, int verbose, int export,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0 struct domain_ent *domain);
+=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (*write_tab=
le)(int dfd, int verbose, int export,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0 struct domain_ent *domain); } *partitio=
n_list[];
+
=A0struct domain_ent {
=A0=A0=A0=A0=A0 char=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *spare_grou=
p; /* only set this in monitor mode
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0when we know what arrays we
@@ -308,6 +319,14 @@ struct domain_ent {
=A0=A0=A0=A0=A0 int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 action;
=A0=A0=A0=A0=A0 struct supertype=A0 *st;
=A0=A0=A0=A0=A0 struct domain_ent *next;
+=A0=A0=A0=A0 struct partition_handler=A0=A0=A0=A0=A0 *handler; /* only=
 used when action is
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0=A0=A0 partition, this is the program
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0=A0=A0 to call to actually partition
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0=A0=A0 the drive */
+=A0=A0=A0=A0 char=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *table; /* Th=
is is the location of a file to
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0 pass to the partition program,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0 used both for setting and checking
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0 the partitions on drives */
=A0};
=A0
=A0/* structures read from config file */
@@ -876,6 +895,7 @@ extern int parse_layout_faulty(char *layout);=A0 ex=
tern int check_ext2(int fd, char *name);=A0 extern int check_reiser(int=
 fd, char *name);=A0 extern int check_raid(int fd, char *name);
+extern int check_clean(int fd);
=A0extern int check_partitions(int fd, char *dname, unsigned long long =
freesize);
=A0
=A0extern int get_mdp_major(void);
diff --git a/util.c b/util.c
index b93e21d..169f804 100644
--- a/util.c
+++ b/util.c
@@ -536,6 +536,35 @@ int check_raid(int fd, char *name)
=A0=A0=A0=A0=A0 return 1;
=A0}
=A0
+int check_clean(int dfd)
+{
+=A0=A0=A0=A0 void *head, *tail, *pattern;
+=A0=A0=A0=A0 int i=3D0, head_clean=3D0, tail_clean=3D0;
+=A0=A0=A0=A0 unsigned char patterns[]=3D{0x00,0x5a,0xff};
+
+=A0=A0=A0=A0 head =3D malloc(4096);
+=A0=A0=A0=A0 tail =3D malloc(4096);
+=A0=A0=A0=A0 pattern =3D malloc(4096);
+=A0=A0=A0=A0 if (!head || !tail || !pattern)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if (lseek(dfd, 0, SEEK_SET) =3D=3D -1)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if (read(dfd, head, 4096) !=3D 4096)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if (lseek(dfd, -4096, SEEK_END) =3D=3D -1)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 if (read(dfd, tail, 4096) !=3D 4096)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
+=A0=A0=A0=A0 while (i < 3) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 memset(pattern, patterns[i++], 4096);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (memcmp(head, pattern, 4096) =3D=3D =
0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 head_clean++;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (memcmp(tail, pattern, 4096) =3D=3D =
0)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tail_clean++;
+=A0=A0=A0=A0 }
+=A0=A0=A0=A0 return (head_clean && tail_clean);
+}
+
=A0int ask(char *mesg)
=A0{
=A0=A0=A0=A0=A0 char *add =3D "";
@@ -1746,3 +1775,33 @@ char *get_devpath_from_devname(char *devname)
=A0=A0=A0=A0=A0 closedir(by_path);
=A0=A0=A0=A0=A0 return NULL;
=A0}
+
+static int sfdisk_validate(struct domain_ent *domain) {
+=A0=A0=A0=A0 return 0;
+}
+
+static int sfdisk_check_table(int dfd, int verbose, int export,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 struc=
t domain_ent *domain)
+{
+=A0=A0=A0=A0 return 0;
+}
+
+static int sfdisk_write_table(int dfd, int verbose, int export,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0 struc=
t domain_ent *domain)
+{
+=A0=A0=A0=A0 return 0;
+}
+
+static struct partition_handler sfdisk_handler =3D {
+=A0=A0=A0=A0 .match=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D "sfdisk",
+=A0=A0=A0=A0 .validate=A0=A0 =3D sfdisk_validate,
+=A0=A0=A0=A0 .check_table=A0=A0=A0=A0=A0 =3D sfdisk_check_table,
+=A0=A0=A0=A0 .write_table=A0=A0=A0=A0=A0 =3D sfdisk_write_table,
+};
+
+struct partition_handler *partition_list[] =3D {
+=A0=A0=A0=A0 &sfdisk_handler,
+=A0=A0=A0=A0 NULL
+};
+
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
