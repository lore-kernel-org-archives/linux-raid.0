From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 06/33] Updates to udev rules and ReadMe.c for incremental
 --grab support
Date: Mon, 5 Jul 2010 11:44:35 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3EC@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C06@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C06@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46rom: Czarnowska, Anna=20
Sent: Monday, July 05, 2010 11:23 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowsk=
i, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciec=
hanowski, Ed; dledford@redhat.com
Subject: [PATCH 06/33] Updates to udev rules and ReadMe.c for increment=
al --grab support

=46rom: Doug Ledford <dledford@redhat.com>

Update Makefile to install new udev early rules, update ReadMe.c for ne=
w options to pass to incremental mode, update udev rules file for new o=
ptions.

=A0=A0=A0 Signed-off-by: Doug Ledford <dledford@redhat.com>
---
=A0Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 3 ++-
=A0ReadMe.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 14 ++++++++------
=A0udev-early-md.rules |=A0=A0 28 ++++++++++++++++++++++++++++
=A03 files changed, 38 insertions(+), 7 deletions(-)=A0 create mode 100=
644 udev-early-md.rules

diff --git a/Makefile b/Makefile
index 3af1665..354554c 100644
--- a/Makefile
+++ b/Makefile
@@ -232,7 +232,8 @@ install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
=A0=A0=A0=A0=A0 $(INSTALL) -D -m 644 md.4 $(DESTDIR)$(MAN4DIR)/md.4
=A0=A0=A0=A0=A0 $(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/=
mdadm.conf.5
=A0
-install-udev: udev-md-raid.rules
+install-udev: udev-md-raid.rules udev-early-md.rules
+=A0=A0=A0=A0 $(INSTALL) -D -m 644 udev-early-md.rules=20
+$(DESTDIR)/lib/udev/rules.d/05-md-early.rules
=A0=A0=A0=A0=A0 $(INSTALL) -D -m 644 udev-md-raid.rules $(DESTDIR)/lib/=
udev/rules.d/64-md-raid.rules
=A0
=A0uninstall:
diff --git a/ReadMe.c b/ReadMe.c
index 355aa64..5b59369 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -87,11 +87,11 @@ char Version[] =3D Name " - v3.1.2 - 10th March 201=
0\n";
=A0 */
=A0
=A0char short_options[]=3D
-=A0=A0=A0=A0 "-ABCDEFGIQhVXWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1ty=
ge:";
+=A0=A0=A0=A0 "-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1t=
yge:";
=A0char short_bitmap_options[]=3D
-=A0=A0=A0=A0 "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1t=
yge:";
+=A0=A0=A0=A0 "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1=
tyge:";
=A0char short_bitmap_auto_options[]=3D
-=A0=A0=A0=A0 "-ABCDEFGIQhVXWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1=
tyge:";
+=A0=A0=A0=A0 "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow=
1tyge:";
=A0
=A0struct option long_options[] =3D {
=A0=A0=A0=A0 {"manage",=A0=A0=A0 0, 0, '@'},
@@ -169,7 +169,7 @@ struct option long_options[] =3D {
=A0
=A0=A0=A0=A0 /* For Detail/Examine */
=A0=A0=A0=A0 {"brief",=A0=A0=A0 =A0 0, 0, 'b'},
-=A0=A0=A0 {"export",=A0=A0 =A0 0, 0, 'Y'},
+=A0=A0=A0 {"export",=A0=A0 =A0 0, 0, 'Y'}, /* used for Incremental now=
 too */
=A0=A0=A0=A0 {"sparc2.2",=A0 0, 0, Sparc22},
=A0=A0=A0=A0 {"test",=A0=A0=A0=A0=A0 0, 0, 't'},
=A0
@@ -246,8 +246,8 @@ char OptionHelp[] =3D
=A0"=A0 --verbose=A0=A0=A0=A0 -v=A0=A0 : Be more verbose about what is =
happening\n"
=A0"=A0 --quiet=A0=A0=A0=A0=A0=A0 -q=A0=A0 : Don't print un-necessary m=
essages\n"
=A0"=A0 --brief=A0=A0=A0=A0=A0=A0 -b=A0=A0 : Be less verbose, more brie=
f\n"
-"=A0 --export=A0=A0=A0=A0=A0 -Y=A0=A0 : With --detail, use key=3Dvalue=
 format for easy\n"
-"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 im=
port into environment\n"
+"=A0 --export=A0=A0=A0=A0=A0 -Y=A0=A0 : With --detail, --examine, and =
--incremental use\n"
+"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ke=
y=3Dvalue format for easy import into environment\n"
=A0"=A0 --force=A0=A0=A0=A0=A0=A0 -f=A0=A0 : Override normal checks and=
 be more forceful\n"
=A0"\n"
=A0"=A0 --assemble=A0=A0=A0 -A=A0=A0 : Assemble an array\n"
@@ -560,6 +560,8 @@ char Help_incr[] =3D
=A0"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0: take it for t=
he purpose listed in said DOMAIN line.\n"
=A0"=A0 --fail=A0=A0=A0=A0=A0 -f=A0 : First fail (if needed) and then r=
emove device from\n"
=A0"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : any array tha=
t it is a member of.\n"
+"=A0 --export=A0=A0=A0=A0=A0 -Y=A0 : Output the results in a format th=
at is consumable as\n"
+"=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 : environme=
nt variables by udev.=A0 Only used with --grab.\n"
=A0;
=A0
=A0char Help_config[] =3D
diff --git a/udev-early-md.rules b/udev-early-md.rules new file mode 10=
0644 index 0000000..176ad61
--- /dev/null
+++ b/udev-early-md.rules
@@ -0,0 +1,28 @@
+# do not edit this file, it will be overwritten on update
+
+SUBSYSTEM!=3D"block", GOTO=3D"md_end"
+ACTION!=3D"add|change", GOTO=3D"md_end"
+# We only care about constituent devices, md arrays are handled in the=
=20
+later # rules file KERNEL=3D=3D"md*", GOTO=3D"md_end"
+# If this is already labeled as an md device, we will get it later in=20
+the # incremental rules assembly section=20
+ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ENV{rd_NO_MDIMSM}!=3D"?*", GOT=
O=3D"md_end"
+ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", GOTO=3D"md_end"
+# Does this device belong to a path which we are configured to "own"?
+# For now, we don't have a good way to differentiate that inside of a =
#=20
+udev rule, so we are using a really big hammer and just calling mdadm =
#=20
+in incremental mode with the flag that indicates that mdadm should onl=
y=20
+# do something with this device if it determines that it should own it=
=2E
+# That allows us to program in whatever smarts are needed into mdadm, =
#=20
+but at the expense of running mdadm on every blk device add|change=20
+event :-( IMPORT{program}=3D"/sbin/mdadm -I --new-device $tempnode"
+ENV{MD_OWNED}!=3D"?*", GOTO=3D"md_end"
+# We owned the device, so have udev reset the database info in case we=
=20
+# changed it IMPORT{program}=3D"/sbin/blkid -o udev -p $tempnode"
+OPTIONS+=3D"link_priority=3D100"
+ENV{ID_FS_USAGE}=3D=3D"filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=3D=
=3D"?*", SYMLINK+=3D"disk/by-uuid/$env{ID_FS_UUID_ENC}"
+ENV{ID_FS_USAGE}=3D=3D"filesystem|other", ENV{ID_FS_LABEL_ENC}=3D=3D"?=
*", SYMLINK+=3D"disk/by-label/$env{ID_FS_LABEL_ENC}"
+
+LABEL=3D"md_end"
--
1.6.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
