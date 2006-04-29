From: "Dennis Stout" <stoutman@gmail.com>
Subject: RFC: PATCH
Date: Sat, 29 Apr 2006 00:47:02 -0800
Message-ID: <3e1c369e0604290147t27cfc031n2fc25ceb49da2b99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_6171_23900021.1146300422635"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_6171_23900021.1146300422635
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

It was annoying to me to have to edit the output of mdadm -Escb
partitions in order to get a working mdadm.conf file so I wrote a
patch that allows the output of the above command to be used directly
as a config file.

Probably still wise to poke the config file before using it in a
production system, but that goes for anything.

Dennis Stout

Enclosed: mdadm-2.1-Examine_output_fix-1.patch (637bytes)

------=_Part_6171_23900021.1146300422635
Content-Type: application/octet-stream;
	name=mdadm-2.1-Examine_output_fix-1.patch
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_emlozqhw
Content-Disposition: attachment; filename="mdadm-2.1-Examine_output_fix-1.patch"

Author:  Dennis Stout
Date:  2006-04-27
Initial Package Version:  2.1
Description:  Allows mdadm -Esbc partitions output to be used directly as a config file


--- mdadm-2.1/Examine.c	2005-09-04 16:54:55.000000000 -0800
+++ mdadm-2.1-new/Examine.c	2006-04-27 13:46:51.000000000 -0800
@@ -132,10 +132,10 @@
 			ap->st->ss->brief_examine_super(ap->super);
 			if (ap->spares) printf("   spares=%d", ap->spares);
 			if (brief > 1) {
-				printf("   devices");
+				printf("DEVICE ");
 				for (d=dl_next(ap->devs); d!= ap->devs; d=dl_next(d)) {
 					printf("%c%s", sep, d);
-					sep=',';
+					sep=' ';
 				}
 			}
 			free(ap->super);











------=_Part_6171_23900021.1146300422635--
