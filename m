From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] Manage.c: fix make everything compilation error
Date: Mon, 13 Aug 2012 11:56:19 +0200
Message-ID: <20120813095619.21893.87478.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

This patch fixes the following make everything compilation error:
Manage.c: In function =E2=80=98Manage_add=E2=80=99:
Manage.c:538: error: =E2=80=98dev_st=E2=80=99 may be used uninitialized=
 in this function
make: *** [mdadm.Os] Error 1

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index d5fc974..f83af65 100644
--- a/Manage.c
+++ b/Manage.c
@@ -535,7 +535,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *d=
v,
 	       char *update, unsigned long rdev, unsigned long long array_siz=
e)
 {
 	unsigned long long ldsize;
-	struct supertype *dev_st;
+	struct supertype *dev_st =3D NULL;
 	int j;
 	mdu_disk_info_t disc;
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
