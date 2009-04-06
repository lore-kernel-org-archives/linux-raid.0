From: Doug Ledford <dledford@redhat.com>
Subject: [Patch] mdadm: fix compile warnings on ppc64
Date: Mon, 6 Apr 2009 10:59:00 -0400
Message-ID: <1FF86487-F8D6-454E-B9FF-0C187192F2C3@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-31-877219362"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid RAID <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-31-877219362
Content-Type: multipart/mixed; boundary=Apple-Mail-30-877219327


--Apple-Mail-30-877219327
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Simple patch to silence some compile warnings that only show up on  
64bit arches.


--Apple-Mail-30-877219327
Content-Disposition: attachment;
	filename=mdadm-3.0-cast.patch
Content-Type: application/octet-stream;
	x-unix-mode=0664;
	name="mdadm-3.0-cast.patch"
Content-Transfer-Encoding: 7bit

--- mdadm-3.0-devel3/super-ddf.c.orig	2009-03-10 01:39:41.000000000 -0400
+++ mdadm-3.0-devel3/super-ddf.c	2009-03-17 15:22:41.000000000 -0400
@@ -1062,9 +1062,9 @@
 			       map_num(ddf_sec_level, vc->srl) ?: "-unknown-");
 		}
 		printf("  Device Size[%d] : %llu\n", n,
-		       __be64_to_cpu(vc->blocks)/2);
+		       (unsigned long long)__be64_to_cpu(vc->blocks)/2);
 		printf("   Array Size[%d] : %llu\n", n,
-		       __be64_to_cpu(vc->array_blocks)/2);
+		       (unsigned long long)__be64_to_cpu(vc->array_blocks)/2);
 	}
 }
 
@@ -1111,7 +1111,8 @@
 		//printf("\n");
 		printf("       %3d    %08x  ", i,
 		       __be32_to_cpu(pd->refnum));
-		printf("%lluK ",  __be64_to_cpu(pd->config_size)>>1);
+		printf("%lluK ", 
+		       (unsigned long long)__be64_to_cpu(pd->config_size)>>1);
 		for (dl = sb->dlist; dl ; dl = dl->next) {
 			if (dl->disk.refnum == pd->refnum) {
 				char *dv = map_dev(dl->major, dl->minor, 0);

--Apple-Mail-30-877219327
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





--Apple-Mail-30-877219327--

--Apple-Mail-31-877219362
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknaGLQACgkQQ9aEs6Ims9iDYgCfZ3m783BocvQ6zgCKZvPq+0dF
OYQAoM43DKNl+u3SySfDa5q2HW/IWNGg
=h+D7
-----END PGP SIGNATURE-----

--Apple-Mail-31-877219362--
