From: "Zhou Wei" <zhouwei@nanjing-fnst.com>
Subject: patch for fixed raidtools device number bug
Date: Fri, 27 Feb 2004 13:22:04 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000701c3fcf1$a327ac70$7601a8c0@babycat>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0005_01C3FD34.B0C78BA0"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------=_NextPart_000_0005_01C3FD34.B0C78BA0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8sDQoNCkkgaGF2ZSBzb21lIHF1ZXN0aW9ucyBhYm91dCBkZXZpY2UgbnVtYmVyIGV4dGVu
c2lvbi4NCg0KSW4gTGludXgga2VybmVsIDIuNiwgZGV2aWNlIG51bWJlciB3aWxsIGJlIGV4dGVu
ZGVkIGZyb20gMTYtYml0IHRvIDMyLWJpdC4gQWxsIHV0aWxpdGllcyBhbmQgbGlicmFyaWVzIHNo
b3VsZCBtYWtlIGNvcnJlc3BvbmRpbmcgZXh0ZW5zaW9uIGZvciB0aGlzIG5ldyBmZWF0dXJlIGlu
IGtlcm5lbCAyLjYuIA0KDQpJIGZpbmQgdGhhdCAicmFpZHRvb2xzLTEuMDAuMy03IiB1c2VzIHN0
cnVjdHVyZSBkZXZfdCBhbmQgb3BlcmF0ZXMgdGhlIGRldmljZSBudW1iZXIgYXMgMTYtYml0Lg0K
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpsc3JhaWQuYyBsaW5lIDU5Og0KDQoj
ZGVmaW5lIE1BSk9SQklUUyA4DQojZGVmaW5lIE1JTk9SQklUUyA4DQojZGVmaW5lIE1BSk9SUyAo
MSA8PCBNQUpPUkJJVFMpDQojZGVmaW5lIE1JTk9SUyAoMSA8PCBNSU5PUkJJVFMpDQoNCkl0IGRl
ZmluZWQgbWFqb3IgZGV2aWNlIG51bWJlciBhbmQgbWlub3IgZGV2aWNlIG51bWJlciBhcyA4IGJp
dCwgYnV0IG5vdyBtYWpvciBkZXZpY2UgbnVtYmVyIGlzIDEyIGJpdCBhbmQgbWlub3IgZGV2aWNl
IGlzIDIwIGJpdC4NCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KQXR0YWNoZWQg
ZmlsZSBpcyBvdXIgcGF0Y2ggZm9yIGZpeGVkIHRoaXMgYnVnLCBwbGVhc2UgY2hlY2sgaXQgYW5k
IGdpdmUgdXMgeW91ciBhZHZpY2UsIHRoYW5rIHlvdS4NCg0KTG9va2luZyBmb3J3YXJkIHRvIGFu
c3dlcmluZy4NCg0KQmVzdCBSZWdhcmRzDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KWmhvdSBXZWkNCkRlcHQuIG9mIFRlY2hub2xvZ3kgYW5kIERl
dmVsb3BtZW50IA0KTmFuamluZyBGdWppdHN1IE5hbmRhIFNvZnR3YXJlIFRlY2guIENvLiwgTHRk
LihGTlNUKQ0KTm8uIDE2LTUsIEd1YW56aG91IFJkLiwgTmFuamluZywgUC5SLkNoaW5hIA0KUEhP
TkU6ICs4NisyNS02NjMwNTIzLTYzMw0KRlVKSVRTVSBJTlRFUk5BTDogNzk5NTUtNjMzDQpGQVg6
ICs4NisyNS0zMzE3Njg1IA0KTWFpbDogemhvdXdlaUBuYW5qaW5nLWZuc3QuY29tIA0KLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0=

------=_NextPart_000_0005_01C3FD34.B0C78BA0
Content-Type: application/octet-stream;
	name="lsraid.c.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lsraid.c.patch"

--- lsraid.c	2004-02-25 10:53:06.000000000 -0500
+++ lsraid.c	2004-02-26 15:24:25.000000000 -0500
@@ -56,10 +56,6 @@
 #define LSRAID_VERSION "0.7.0"
=20
 /* Imagine the fun when we get to different major,minor sizes :-) */
-#define MAJORBITS 8
-#define MINORBITS 8
-#define MAJORS (1 << MAJORBITS)
-#define MINORS (1 << MINORBITS)
=20
 /* Debugging for device scanning */
 #define SCAN_DEBUG 0
@@ -73,6 +69,7 @@
 typedef struct _LSRDir     LSRDir;
 typedef struct _LSRArray   LSRArray;
 typedef struct _LSRDisk    LSRDisk;
+typedef struct  _LSRDevtable LSRDevtable;
=20
=20
=20
@@ -95,6 +92,13 @@
     LSR_DEV_SCAN     =3D 1 << 4
 } LSRFlags;
=20
+struct  _LSRDevtable
+{
+	int major;
+	int minor;
+	char* name;
+	LSRDevtable* next, *prev;
+};
=20
=20
 /*
@@ -108,8 +112,7 @@
     struct list_head o_disks;   /* Disk names from parse_options */
     struct list_head arrays;    /* Anchor for list of arrays (a_list) =
*/
     struct list_head disks;     /* Anchor for list of disks (d_list) */
-    char ***devtable;           /* Table of known device names
-                                   (major, minor) -> name */
+	LSRDevtable* devtable;
 };
=20
 struct _LSRNamEnt
@@ -159,6 +162,8 @@
 /*
  * Prototypes
  */
+static char* getname(LSRContext* ctxt, int major, int minor);
+static int add_devtable(LSRContext* ctxt, int major, int minor, char* =
name);
 static void print_usage(int rc);
 static void print_usage_long();
 static void print_version();
@@ -213,7 +218,54 @@
 /*
  * Functions
  */
+static char* getname(LSRContext* ctxt, int major, int minor)
+{
+	LSRDevtable* head=3Dctxt->devtable;
+	ctxt->devtable=3Dctxt->devtable->next;
+	while(ctxt->devtable->name!=3D"")
+	{
+		if(ctxt->devtable->minor=3D=3Dminor)
+			if(ctxt->devtable->major=3D=3Dmajor)
+				break;
+		ctxt->devtable=3Dctxt->devtable->next;
+	}
+	if(ctxt->devtable->name!=3D"")
+	{
+		LSRDevtable* temp =3D ctxt->devtable;
+		ctxt->devtable=3Dhead;
+		return temp->name;
+	}
+	else
+	{
+		return NULL;
+	}
+}
=20
+static int add_devtable(LSRContext* ctxt, int major, int minor, char* =
name)
+{=09
+	int rc=3D0;
+	if(ctxt->devtable)
+	{
+		LSRDevtable* temp =3D (LSRDevtable*)malloc(sizeof(LSRDevtable));
+		if (!temp)
+		{
+			rc =3D -ENOMEM;
+		}
+		else
+		{
+			temp->major=3Dmajor;
+			temp->minor=3Dminor;
+			temp->name=3Dname;
+			ctxt->devtable->prev->next=3Dtemp;
+			temp->prev=3Dctxt->devtable->prev;
+			temp->next=3Dctxt->devtable;
+			ctxt->devtable->prev=3Dtemp;
+		}
+	}
+	else
+		rc =3D -ENOMEM;
+	return(rc);
+}
=20
 static void print_version()
 {
@@ -258,13 +310,17 @@
         INIT_LIST_HEAD(&ctxt->o_arrays);
         INIT_LIST_HEAD(&ctxt->disks);
         INIT_LIST_HEAD(&ctxt->arrays);
-        ctxt->devtable =3D (char ***)malloc(MAJORS * sizeof(char **));
+        ctxt->devtable =3D (LSRDevtable*)malloc(sizeof(LSRDevtable));
         if (!ctxt->devtable)
         {
             free(ctxt);
             return(NULL);
         }
-        memset(ctxt->devtable, 0, MAJORS * sizeof(char **));
+        ctxt->devtable->major=3D0;
+        ctxt->devtable->minor=3D0;
+        ctxt->devtable->name=3D"";
+        ctxt->devtable->next=3Dctxt->devtable;
+        ctxt->devtable->prev=3Dctxt->devtable;
     }
     return(ctxt);
 }  /* alloc_context() */
@@ -973,14 +1029,14 @@
         {
             fprintf(stderr,
                     "lsraid: Unable to allocate memory for information =
on device \"%s\": %s\n",
-                    ctxt->devtable[major][minor],
+			getname(ctxt,major,minor),
                     strerror(errno));
             return;
         }
     }
     proc_name[0] =3D '\0';
=20
-    dev_base =3D strrchr(ctxt->devtable[major][minor], '/');
+    dev_base =3D strrchr(getname(ctxt,major,minor), '/');
     if ((dev_base =3D=3D NULL) ||
         (dev_base[1] =3D=3D '\0'))
         return;
@@ -1013,11 +1069,11 @@
     {
         fprintf(stderr,
                 "lsraid: Unable to allocate memory for information on =
device \"%s\": %s\n",
-                ctxt->devtable[major][minor],
+		getname(ctxt,major,minor),
                 strerror(errno));
         return;
     }
-    ent->name =3D ctxt->devtable[major][minor];
+    ent->name =3D getname(ctxt,major,minor);
=20
     /* Should we add MD_MAJOR devices to o_disks too? */
     if (major =3D=3D MD_MAJOR)
@@ -1058,45 +1114,26 @@
=20
         if (*name && major)
         {
-            if (!ctxt->devtable[major])
-            {
-                ctxt->devtable[major] =3D
-                    (char **)malloc(MINORS * sizeof(char *));
-                if (!ctxt->devtable[major])
-                {
-                    rc =3D -ENOMEM;
-                    break;
-                }
-                memset(ctxt->devtable[major], 0,
-                       MINORS * sizeof(char *));
-            }
-
-            if (ctxt->devtable[major][minor])
+            if(getname(ctxt,major,minor))
                 continue;
=20
-            /*
-             * This is all '/dev' specific.  If it isn't found there,
-             * it is going to fall back to /dev scanning (think=20
-             * /dev/usb/disk1 or something in devfs).  This heuristic
-             * should probably check whatever devfs puts together
-             * for 'hda1 in /proc/partitions', but I don't know what
-             * devfs does, and I don't much care right now.
-             */
-            ctxt->devtable[major][minor] =3D
-                (char *)malloc((strlen(name) + strlen("/dev/") + 1) *
-                               sizeof(char));
-            if (!ctxt->devtable[major][minor])
+            char* tempstr =3D (char *)malloc((strlen(name) + =
strlen("/dev/") + 1) *
+                           sizeof(char));
+            if(!tempstr)
                 continue;
-            sprintf(ctxt->devtable[major][minor], "/dev/%s", name);
-
-            rc =3D stat(ctxt->devtable[major][minor], &stat_buf);
-            if ((rc !=3D 0) && (!S_ISBLK(stat_buf.st_mode)))
-            {
-                free(ctxt->devtable[major][minor]);
-                ctxt->devtable[major][minor] =3D NULL;
-            }
-            else if (ctxt->flags & LSR_DEV_SCAN)
-                maybe_add_device(ctxt, major, minor);
+            sprintf(tempstr, "/dev/%s", name);
+=09
+            rc =3D stat(tempstr, &stat_buf);
+        	if ((rc !=3D 0) && (!S_ISBLK(stat_buf.st_mode)))
+        	{
+            	free(tempstr);
+            	tempstr=3D NULL;
+        	}
+        	else if (ctxt->flags & LSR_DEV_SCAN)
+        	{
+                if(add_devtable(ctxt,major,minor,tempstr)=3D=3D0)
+                	maybe_add_device(ctxt, major, minor);
+        	}
         }
     }
=20
@@ -1241,26 +1278,15 @@
         {
             major =3D major(stat_buf.st_rdev);
             minor =3D minor(stat_buf.st_rdev);
-            if (!ctxt->devtable[major])
+            if(getname(ctxt,major,minor))
+                continue;
+
+            char* tempstr =3D (char *)malloc((strlen(name) + 1) * =
sizeof(char));
+            if(tempstr)
             {
-                ctxt->devtable[major] =3D
-                    (char **)malloc(MINORS * sizeof(char *));
-                if (!ctxt->devtable[major])
-                {
-                    /* FIXME: what error if any? rc =3D -ENOMEM; */
-                    continue;
-                }
-                memset(ctxt->devtable[major], 0,
-                       MINORS * sizeof(char *));
+                strcpy(tempstr, name);
+                add_devtable(ctxt,major,minor,tempstr); =20
             }
-
-            if (ctxt->devtable[major][minor])
-                continue;
-           =20
-            ctxt->devtable[major][minor] =3D
-                (char *)malloc((strlen(name) + 1) * sizeof(char));
-            if (ctxt->devtable[major][minor])
-                strcpy(ctxt->devtable[major][minor], name);
         }
     }
=20
@@ -1298,14 +1324,14 @@
     if (!major)
         return(-EINVAL);
=20
-    if (ctxt->devtable[major] && ctxt->devtable[major][minor])
+    if(getname(ctxt,major,minor))
         goto out;
=20
     if (!loaded_partitions)
     {
         load_partitions(ctxt);
         loaded_partitions =3D 1;
-        if (ctxt->devtable[major] && ctxt->devtable[major][minor])
+        if(getname(ctxt,major,minor))
             goto out;
     }
=20
@@ -1313,15 +1339,15 @@
     {
         scan_slash_dev(ctxt);
         scanned_dev =3D 1;
-        if (ctxt->devtable[major] && ctxt->devtable[major][minor])
+        if(getname(ctxt,major,minor))
             goto out;
     }
=20
     rc =3D -ENOENT;
=20
 out:
-    if (ctxt->devtable[major])
-        *name =3D ctxt->devtable[major][minor];
+    if(getname(ctxt,major,minor))
+        *name=3Dgetname(ctxt,major,minor);
     return(rc);
 }  /* find_device() */
=20
@@ -1398,7 +1424,6 @@
=20
 static void clean_context(LSRContext *ctxt)
 {
-    int i;
     struct list_head *pos, *n;
     LSRArray *array;
     LSRDisk *disk;
@@ -1426,10 +1451,13 @@
     }
     if (ctxt->devtable)
     {
-        for (i =3D 0; i < MAJORS; i++)
-            if (ctxt->devtable[i])
-                free(ctxt->devtable[i]);
-        free(ctxt->devtable);
+        LSRDevtable* head=3Dctxt->devtable;
+        do
+        {
+            LSRDevtable* temp=3Dctxt->devtable;
+            ctxt->devtable=3Dctxt->devtable->next;
+            free(temp);
+        }while(ctxt->devtable !=3D head);
     }
     free(ctxt);
 }  /* clean_context() */
@@ -2613,6 +2641,7 @@
  * Main program
  */
=20
+#ifndef TESTING	/*for FNST testing*/
 int main(int argc, char *argv[])
 {
     int i;
@@ -2653,3 +2682,4 @@
     clean_context(ctxt);
     return(0);
 }  /* main() */
+#endif /*TESTING*/

------=_NextPart_000_0005_01C3FD34.B0C78BA0--

