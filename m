From: Peter.Seiderer@gmx.de
Subject: Bugfix: mkraid
Date: Fri, 11 Jul 2003 17:13:27 +0200 (MEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6298.1057936407@www40.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

the following patch is a bugfix for mkraid (from raidtools-1.00.3).

It fixes that a call 'mkraid /dev/md5' will check if /dev/md5 is active=
 and
not
if the last entry from the config file is active.

--- raidtools-1.00.3/mkraid.c_orig      2003-07-11 16:49:23.000000000 +=
0200
+++ raidtools-1.00.3/mkraid.c   2003-07-11 17:15:24.000000000 +0200
@@ -219,7 +219,7 @@
     while (*args) {
        for (p =3D cfg_head; p; p =3D p->next) {
            if (strcmp(p->md_name, *args)) continue;
-           if (check_active(cfg))=20
+           if (check_active(p))=20
                goto abort;
            if (force_flag) {
                fprintf(stderr, "DESTROYING the contents of %s in 5 sec=
onds,
Ctrl-C if unsure!\n", *args);


And another little patch for against SEGV when called with a very long
cmdline (e.g.
/dev/md_this_is_very_long_md_device_and_longer_than_MAX_LINE_LENGTH_)

--- raidtools-1.00.3/raid_io.c_orig     2003-07-11 16:09:43.000000000 +=
0200
+++ raidtools-1.00.3/raid_io.c  2003-07-11 17:15:25.000000000 +0200
@@ -522,7 +522,7 @@
=20
        if ((ch =3D strstr(p->md_name, "/md")) =3D=3D NULL)
                return 0;
-       strcpy(buffer, ch+1);
+       strncpy(buffer, MAX_LINE_LENGTH, ch+1);
        if ((fp =3D fopen("/proc/mdstat", "r")) =3D=3D NULL)
                return 0;
        while (1) {


Peter

--=20
+++ GMX - Mail, Messaging & more  http://www.gmx.net +++

Jetzt ein- oder umsteigen und USB-Speicheruhr als Pr=E4mie sichern!

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
