From: Doug Ledford <dledford@redhat.com>
Subject: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Mon, 6 Apr 2009 10:52:10 -0400
Message-ID: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-28-876808828"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid RAID <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-28-876808828
Content-Type: multipart/mixed; boundary=Apple-Mail-27-876808785


--Apple-Mail-27-876808785
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Originally, mdadm used /var/run/mdadm/mdadm.map file to store the  
temporary mappings of incrementally added devices to device names.   
Unfortunately, this breaks incremental assembly if used early in the  
booting process.  Specifically, root may still be read only.  Since  
incremental assembly is largely a udev specific feature, and udev  
needs a writable /dev tmpfs mount even when root is still read only,  
it's safer to put our mdadm.map file in /dev/md so that we can write  
to the map file no matter how early in the boot process we are  
attempting to use incremental assembly.


--Apple-Mail-27-876808785
Content-Disposition: attachment;
	filename=mdadm-3.0-mapfile.patch
Content-Type: application/octet-stream;
	x-unix-mode=0664;
	name="mdadm-3.0-mapfile.patch"
Content-Transfer-Encoding: 7bit

--- mdadm-3.0-devel3/Incremental.c.dev	2009-03-20 13:19:35.000000000 -0400
+++ mdadm-3.0-devel3/Incremental.c	2009-03-20 13:20:01.000000000 -0400
@@ -52,7 +52,7 @@ int Incremental(char *devname, int verbo
 	 *    a 'foreign' array.
 	 * 4/ Determine device number.
 	 * - If in mdadm.conf with std name, use that
-	 * - UUID in /var/run/mdadm.map  use that
+	 * - UUID in /dev/md/mdadm.map  use that
 	 * - If name is suggestive, use that. unless in use with different uuid.
 	 * - Choose a free, high number.
 	 * - Use a partitioned device unless strong suggestion not to.
@@ -67,7 +67,7 @@ int Incremental(char *devname, int verbo
 	 * - check one drive in array to make sure metadata is a reasonably
 	 *       close match.  Reject if not (e.g. different type)
 	 * - add the device
-	 * 6/ Make sure /var/run/mdadm.map contains this array.
+	 * 6/ Make sure /dev/md/mdadm.map contains this array.
 	 * 7/ Is there enough devices to possibly start the array?
 	 *     For a container, this means running Incremental_container.
 	 * 7a/ if not, finish with success.
@@ -315,7 +315,7 @@ int Incremental(char *devname, int verbo
 		}
 		info.array.working_disks = 1;
 		sysfs_free(sra);
-		/* 6/ Make sure /var/run/mdadm.map contains this array. */
+		/* 6/ Make sure /dev/md/mdadm.map contains this array. */
 		map_update(&map, fd2devnum(mdfd),
 			   info.text_version,
 			   info.uuid, chosen_name);
--- mdadm-3.0-devel3/mapfile.c.dev	2009-03-20 13:16:27.000000000 -0400
+++ mdadm-3.0-devel3/mapfile.c	2009-03-20 13:18:37.000000000 -0400
@@ -1,5 +1,5 @@
 /*
- * mapfile - manage /var/run/mdadm.map. Part of:
+ * mapfile - manage /dev/md/mdadm.map. Part of:
  * mdadm - manage Linux "md" devices aka RAID arrays.
  *
  * Copyright (C) 2006 Neil Brown <neilb@suse.de>
@@ -28,7 +28,7 @@
  *           Australia
  */
 
-/* /var/run/mdadm.map is used to track arrays being created in --incremental
+/* /dev/md/mdadm.map is used to track arrays being created in --incremental
  * more.  It particularly allows lookup from UUID to array device, but
  * also allows the array device name to be easily found.
  *
@@ -50,9 +50,9 @@ int map_write(struct map_ent *mel)
 	int err;
 	int subdir = 1;
 
-	f = fopen("/var/run/mdadm/map.new", "w");
+	f = fopen("/dev/md/mdadm/map.new", "w");
 	if (!f) {
-		f = fopen("/var/run/mdadm.map.new", "w");
+		f = fopen("/dev/md/mdadm.map.new", "w");
 		subdir = 0;
 	}
 	if (!f)
@@ -74,17 +74,17 @@ int map_write(struct map_ent *mel)
 	fclose(f);
 	if (err) {
 		if (subdir)
-			unlink("/var/run/mdadm/map.new");
+			unlink("/dev/md/mdadm/map.new");
 		else
-			unlink("/var/run/mdadm.map.new");
+			unlink("/dev/md/mdadm.map.new");
 		return 0;
 	}
 	if (subdir)
-		return rename("/var/run/mdadm/map.new",
-			      "/var/run/mdadm/map") == 0;
+		return rename("/dev/md/mdadm/map.new",
+			      "/dev/md/mdadm/map") == 0;
 	else
-		return rename("/var/run/mdadm.map.new",
-			      "/var/run/mdadm.map") == 0;
+		return rename("/dev/md/mdadm.map.new",
+			      "/dev/md/mdadm.map") == 0;
 }
 
 
@@ -93,9 +93,9 @@ static int lsubdir = 0;
 int map_lock(struct map_ent **melp)
 {
 	if (lfd < 0) {
-		lfd = open("/var/run/mdadm/map.lock", O_CREAT|O_RDWR, 0600);
+		lfd = open("/dev/md/mdadm/map.lock", O_CREAT|O_RDWR, 0600);
 		if (lfd < 0) {
-			lfd = open("/var/run/mdadm.map.lock", O_CREAT|O_RDWR, 0600);
+			lfd = open("/dev/md/mdadm.map.lock", O_CREAT|O_RDWR, 0600);
 			lsubdir = 0;
 		} else
 			lsubdir = 1;
@@ -118,9 +118,9 @@ void map_unlock(struct map_ent **melp)
 	if (lfd >= 0)
 		close(lfd);
 	if (lsubdir)
-		unlink("/var/run/mdadm/map.lock");
+		unlink("/dev/md/mdadm/map.lock");
 	else
-		unlink("/var/run/mdadm.map.lock");
+		unlink("/dev/md/mdadm.map.lock");
 	lfd = -1;
 }
 
@@ -149,15 +149,15 @@ void map_read(struct map_ent **melp)
 
 	*melp = NULL;
 
-	f = fopen("/var/run/mdadm/map", "r");
+	f = fopen("/dev/md/mdadm/map", "r");
 	if (!f)
-		f = fopen("/var/run/mdadm.map", "r");
+		f = fopen("/dev/md/mdadm.map", "r");
 	if (!f) {
 		RebuildMap();
-		f = fopen("/var/run/mdadm/map", "r");
+		f = fopen("/dev/md/mdadm/map", "r");
 	}
 	if (!f)
-		f = fopen("/var/run/mdadm.map", "r");
+		f = fopen("/dev/md/mdadm.map", "r");
 	if (!f)
 		return;
 

--Apple-Mail-27-876808785
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-27-876808785--

--Apple-Mail-28-876808828
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknaFxoACgkQQ9aEs6Ims9iAkACfTMa3f0iz2hzKOX+NaU431xqj
/WkAoOLPPIRUmvR0l1Ti+WHC1mndTWVS
=B4k3
-----END PGP SIGNATURE-----

--Apple-Mail-28-876808828--
