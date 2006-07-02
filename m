From: Luca Berra <bluca@comedia.it>
Subject: [PATCH] enable auto=yes by default when using udev
Date: Mon, 3 Jul 2006 00:45:50 +0200
Message-ID: <20060702224549.GD12733@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Hello,
the following patch aims at solving an issue that is confusing a lot of
users.
when using udev, device files are created only when devices are
registered with the kernel, and md devices are registered only when
started.
mdadm needs the device file _before_ starting the array.
so when using udev you must add --auto=yes to the mdadm commandline or
to the ARRAY line in mdadm.conf

following patch makes auto=yes the default when using udev

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-2.5.1-autof.patch"

* Sat Jun 24 2006 Luca Berra <bluca@vodka.it>
- automatically create devices if using udev

--- mdadm-2.5.1/mdadm.c.autof	2006-06-02 01:51:01.000000000 -0400
+++ mdadm-2.5.1/mdadm.c	2006-06-24 05:17:45.000000000 -0400
@@ -857,6 +857,13 @@
 		fputs(Usage, stderr);
 		exit(2);
 	}
+
+	/* if we are using udev and auto is not set, mdadm will almost
+	 * certainly fail, so we force it here.
+	 */
+	if (autof == 0 && access("/dev/.udevdb",F_OK) == 0)
+		autof=2;
+
 	/* Ok, got the option parsing out of the way
 	 * hopefully it's mostly right but there might be some stuff
 	 * missing
@@ -873,7 +880,7 @@
 			fprintf(stderr, Name ": an md device must be given in this mode\n");
 			exit(2);
 		}
-		if ((int)ident.super_minor == -2 && autof) {
+		if ((int)ident.super_minor == -2 && autof > 2 ) {
 			fprintf(stderr, Name ": --super-minor=dev is incompatible with --auto\n");	
 			exit(2);
 		}

--6TrnltStXW4iwmi0--
