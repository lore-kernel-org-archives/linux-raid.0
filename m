From: =?ISO-8859-1?Q?Rapha=EBl_Rigo?= <raphael.rigo@twilight-hall.net>
Subject: [PATCH] Fix for "Booting from raid1 -- md: invalid raid superblock
 mag"
Date: Sun, 27 Nov 2005 22:22:20 +0100
Message-ID: <438A238C.6030403@twilight-hall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org, dstrang@shellpower.net
List-Id: linux-raid.ids

Hi,
here is a patch that fixes the problem described by David M. Stra.

The problem is that the array is first initialized with SET_ARRAY_INFO =
without
any specific parameter and the md driver uses the 0.90 behaviour by def=
ault.
So we must specify it's 1.0 superblock by doing another SET_ARRAY_INFO.

I'll correct if anything is wrong.

Regards,
Rapha=EBl Rigo

Signed-off-by: Rapha=EBl Rigo <raphael.rigo@twilight-hall.net>

--- linux-2.6.14.2/init/do_mounts_md.c.orig     2005-11-27 22:12:40.000=
000000 +0100
+++ linux-2.6.14.2/init/do_mounts_md.c  2005-11-27 22:20:54.000000000 +=
0100
@@ -218,6 +218,19 @@ static void __init md_setup_drive(void)
                                err =3D sys_ioctl(fd, ADD_NEW_DISK, (lo=
ng)&dinfo);
                        }
                } else {
+                       mdu_array_info_t ainfo;
+
+                       memset(&ainfo, 0, sizeof(ainfo));
+                       ainfo.major_version =3D 1;
+                       ainfo.minor_version =3D 0;
+
+                       err =3D sys_ioctl(fd, SET_ARRAY_INFO, (long)&ai=
nfo);
+                       if(err) {
+                               printk(KERN_WARNING
+                               "md: Cannot set array info for md%d\n",
+                               minor);
+                       }
+
                        /* persistent */
                        for (i =3D 0; i <=3D MD_SB_DISKS; i++) {
                                dev =3D devices[i];
@@ -225,7 +238,7 @@ static void __init md_setup_drive(void)
                                        break;
                                dinfo.major =3D MAJOR(dev);
                                dinfo.minor =3D MINOR(dev);
-                               sys_ioctl(fd, ADD_NEW_DISK, (long)&dinf=
o);
+                               err =3D sys_ioctl(fd, ADD_NEW_DISK, (lo=
ng)&dinfo);
                        }
                }
                if (!err)

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
