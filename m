From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: correct unlocking of map file
Date: Mon, 3 Oct 2011 08:56:54 +1100
Message-ID: <20111003085654.06783c0e@notabene.brown>
References: <20110929075520.5470.28705.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lebjLKCtE4vwjRyz8rCkxBB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929075520.5470.28705.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/lebjLKCtE4vwjRyz8rCkxBB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Sep 2011 09:55:20 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> 1. Three missing map_unlock() calls were added.
> 2. Map file's lock must be released by an explicit LOCK_UN operation,
>    because duplicated (e.g. created by fork()) descriptors
>    inherit the lock. As a result child process which inherits open
>    descriptors with lock can block another process of mdadm.

Thanks.  However I don't like the second bit.  I really don't want the lock
fd to be handed down to the children at all - it is messy.

So I've change it to explicitly close the lock fd on fork.

Thanks,
NeilBrown


commit cc700db34f6fb565b37f4edf7fe7fe40a5f2745b
Author: Lukasz Dorau <lukasz.dorau@intel.com>
Date:   Mon Oct 3 08:55:02 2011 +1100

    fix: correct unlocking of map file
   =20
    1. Three missing map_unlock() calls were added.
    2. Map file must be unlocked on fork, else child will hold lock.
   =20
    Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index b7234e4..90b84d7 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2265,6 +2265,7 @@ started:
 	default:
 		return 0;
 	case 0:
+		map_fork();
 		break;
 	}
=20
@@ -2421,6 +2422,7 @@ int reshape_container(char *container, char *devname,
 		printf(Name ": multi-array reshape continues in background\n");
 		return 0;
 	case 0: /* child */
+		map_fork();
 		break;
 	}
=20
diff --git a/Incremental.c b/Incremental.c
index 791ad85..a3e05a7 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1469,6 +1469,7 @@ static int Incremental_container(struct supertype *st=
, char *devname,
 					"Cannot activate array(s).\n");
 		/* free container data and exit */
 		sysfs_free(list);
+		map_unlock(&map);
 		return 2;
 	}
=20
@@ -1532,6 +1533,7 @@ static int Incremental_container(struct supertype *st=
, char *devname,
 					fprintf(stderr, Name ": array %s/%s is "
 						"explicitly ignored by mdadm.conf\n",
 						match->container, match->member);
+				map_unlock(&map);
 				return 2;
 			}
 			if (match)
@@ -1547,6 +1549,7 @@ static int Incremental_container(struct supertype *st=
, char *devname,
 		if (mdfd < 0) {
 			fprintf(stderr, Name ": failed to open %s: %s.\n",
 				chosen_name, strerror(errno));
+			map_unlock(&map);
 			return 2;
 		}
=20
diff --git a/mapfile.c b/mapfile.c
index ff1e973..997f095 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -159,6 +159,18 @@ void map_unlock(struct map_ent **melp)
 	lf =3D NULL;
 }
=20
+void map_fork(void)
+{
+	/* We are forking, so must close the lock file.
+	 * Don't risk flushing anything though.
+	 */
+	if (lf) {
+		close(fileno(lf));
+		fclose(lf);
+		lf =3D NULL;
+	}
+}
+
 void map_add(struct map_ent **melp,
 	    int devnum, char *metadata, int uuid[4], char *path)
 {
diff --git a/mdadm.h b/mdadm.h
index 8dd37d9..9165f7a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -427,6 +427,7 @@ extern void map_add(struct map_ent **melp,
 		    int devnum, char *metadata, int uuid[4], char *path);
 extern int map_lock(struct map_ent **melp);
 extern void map_unlock(struct map_ent **melp);
+extern void map_fork(void);
=20
 /* various details can be requested */
 enum sysfs_read_flags {

--Sig_/lebjLKCtE4vwjRyz8rCkxBB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOiN4mG5fc6gV+Wb0RAua8AKDSDvckyO9O3U8xJzpLWz4CT4in2ACgt74F
ATxbrJDZHol1TqveodkzNDI=
=602b
-----END PGP SIGNATURE-----

--Sig_/lebjLKCtE4vwjRyz8rCkxBB--
