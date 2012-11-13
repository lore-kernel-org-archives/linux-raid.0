From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] Grow.c: fix uninitialized variables compilation-time error
Date: Tue, 13 Nov 2012 13:29:43 +0100
Message-ID: <20121113122943.4041.51702.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

It fixes the following uninitialized variables compilation-time error:
WARN  - Grow.c: In function =E2=80=98reshape_array=E2=80=99:
WARN  - Grow.c:2413:21: error: =E2=80=98min_space_after=E2=80=99 may be=
 used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
WARN  - Grow.c:2376:39: note: =E2=80=98min_space_after=E2=80=99 was dec=
lared here
WARN  - Grow.c:2414:22: error: =E2=80=98min_space_before=E2=80=99 may b=
e used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
WARN  - Grow.c:2376:21: note: =E2=80=98min_space_before=E2=80=99 was de=
clared here
WARN  - cc1: all warnings being treated as errors
WARN  - make: *** [Grow.o] Error 1
It occurs during compilation of mdadm on Fedora 17.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4de8029..a526a65 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2373,7 +2373,7 @@ release:
 static void get_space_after(int fd, struct supertype *st, struct mdinf=
o *info)
 {
 	struct mdinfo *sra, *sd;
-	unsigned long long min_space_before, min_space_after;
+	unsigned long long min_space_before =3D 0, min_space_after =3D 0;
 	int first =3D 1;
=20
 	sra =3D sysfs_read(fd, 0, GET_DEVS);

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
