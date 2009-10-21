From: Stephane Bunel <stephane.bunel@forumdesimages.fr>
Subject: mdadm --detail showing annoying device
Date: Wed, 21 Oct 2009 16:17:16 +0200
Message-ID: <4ADF17EC.6090606@forumdesimages.fr>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan> <20091019030456.GS9464@discord.disaster> <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan> <20091020003358.GW9464@discord.disaster> <alpine.DEB.2.00.0910200431290.21878@p34.internal.lan> <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm a newbie in the mdadm world. I defined some udev rules to make disk=
=20
staticly named according to the bus/host/target. I.e. /dev/sda become=20
/dev/raid_disk0. So nothing very special with that, it's just a conveni=
ent way=20
to assign disk name to it's physical location.

#ls -la /dev/raid*
brw-rw---- 1 root disk 8,  0 2009-10-16 18:12 /dev/raid_disk0
brw-rw---- 1 root disk 8, 16 2009-10-16 18:12 /dev/raid_disk1

A RAID1 (/dev/md0) is assembled over this two disk.
When looking for detailed information, mdadm show annoying device name =
in=20
place of /dev/raid_disk*:

---8x---
#mdadm --detail /dev/md0
/dev/md0:
         Version : 0.90
   Creation Time : Tue Oct 13 12:53:54 2009
      Raid Level : raid1
      Array Size : 488386496 (465.76 GiB 500.11 GB)
   Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Wed Oct 21 15:16:09 2009
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : 3fea95a0:e1b8a341:3b119117:e416f62b
          Events : 0.1526

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/char/21:0
        1       8       16        1      active sync   /dev/char/21:1
---8x---


Looking in the source code of mdadm I found that the device name select=
ion=20
rule is (too) simply: select the shortest name in case of multiple=20
possibility. So '/dev/char/21:0' being shorter than '/dev/raid_disk0', =
mdadm=20
display '/dev/char...'. It's annoying for me to see a CHAR (/dev/char/.=
=2E.)=20
device to represent a hard disk (wich is is a block device of course). =
The=20
purpose of the following patch is to handle the directory part to alway=
s=20
prefere the name that is closer to /dev. In case of equality, the short=
er name=20
wins.


---8x---
#./mdadm --detail /dev/md0
/dev/md0:
         Version : 0.90
   Creation Time : Tue Oct 13 12:53:54 2009
      Raid Level : raid1
      Array Size : 488386496 (465.76 GiB 500.11 GB)
   Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Wed Oct 21 15:30:34 2009
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : 3fea95a0:e1b8a341:3b119117:e416f62b
          Events : 0.1526

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/raid_disk0
        1       8       16        1      active sync   /dev/raid_disk1
---8x---


=46ell free to refactor the code. The last time I wrote C code I still =
had hair=20
on my head ;-)


---8x---
--- /var/tmp/mdadm_snapshot/util.c    2009-10-20 04:50:23.000000000 +02=
00
+++ /var/tmp/mdadm_dirlevel/util.c    2009-10-20 13:13:32.000000000 +02=
00
@@ -507,6 +507,38 @@
  #endif /* HAVE_FTW */
  #endif /* HAVE_NFTW */

+char *select_by_directory_level(char *current, char *registered)
+{
+        unsigned int current_level =3D 0;
+        unsigned int registered_level =3D 0;
+
+        unsigned int level(char *pathname)
+        {
+                unsigned int count =3D 0;
+                char *p =3D pathname;
+
+                while ( (p =3D strchr( p, '/' )) ) {
+                        count++;
+                        p++;
+                }
+
+                return( count );
+        }
+
+        current_level =3D level( current );
+        registered_level =3D level( registered );
+
+        if (  current_level < registered_level )
+                return current;
+
+        if ( current_level =3D=3D registered_level )
+                if ( strlen( strrchr( current, '/')) <
+                     strlen( strrchr( registered,'/')) )
+                        return current;
+
+        return registered;
+}
+
  /*
   * Find a block device with the right major/minor number.
   * If we find multiple names, choose the shortest.
@@ -544,14 +576,18 @@
          if (p->major =3D=3D major &&
              p->minor =3D=3D minor) {
              if (strncmp(p->name, "/dev/md/",8) =3D=3D 0) {
-                if (preferred =3D=3D NULL ||
-                    strlen(p->name) < strlen(preferred))
-                    preferred =3D p->name;
-            } else {
-                if (regular =3D=3D NULL ||
-                    strlen(p->name) < strlen(regular))
-                    regular =3D p->name;
-            }
+                                if (preferred =3D=3D NULL)
+                                        preferred =3D p->name;
+                                else
+                                        preferred =3D
select_by_directory_level(
+                                                        p->name,
preferred );
+                        } else {
+                                if (regular =3D=3D NULL )
+                                        regular =3D p->name;
+                                else
+                                        regular =3D select_by_director=
y_level(
+                                                        p->name, regul=
ar );
+                        }
          }
      if (!regular && !preferred && !did_check) {
          devlist_ready =3D 0;
---8x---



St=E9phane Bunel.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
