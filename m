From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 11/33] fix: IncrementalRemove leaves open handle
Date: Mon, 5 Jul 2010 11:45:59 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3FB@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C0C@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C0C@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:24 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 11/33] fix: IncrementalRemove leaves open handle

=46rom: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.=
com>

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski=
@intel.com>
---
=A0Incremental.c |=A0=A0=A0 5 ++++-
=A01 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c index 3501bc1..4455a89 10064=
4
--- a/Incremental.c
+++ b/Incremental.c
@@ -866,6 +866,7 @@ int Incremental_container(struct supertype *st, cha=
r *devname, int verbose,=A0 int IncrementalRemove(char *devname, int ve=
rbose)=A0 {
=A0=A0=A0=A0=A0 int mdfd;
+=A0=A0=A0=A0 int rv;
=A0=A0=A0=A0=A0 struct mdstat_ent *ent;
=A0=A0=A0=A0=A0 struct mddev_dev_s devlist;
=A0
@@ -890,7 +891,9 @@ int IncrementalRemove(char *devname, int verbose)
=A0=A0=A0=A0=A0 devlist.disposition =3D 'f';
=A0=A0=A0=A0=A0 Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
=A0=A0=A0=A0=A0 devlist.disposition =3D 'r';
-=A0=A0=A0=A0 return Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
+=A0=A0=A0=A0 rv =3D Manage_subdevs(ent->dev, mdfd, &devlist, verbose);
+=A0=A0=A0=A0 close(mdfd);
+=A0=A0=A0=A0 return rv;
=A0}
=A0
=A0/*
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
