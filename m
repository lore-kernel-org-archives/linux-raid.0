From: NeilBrown <neilb@suse.com>
Subject: Re: [mdadm PATCH 4/4] Create: tell udev device is not ready when first created.
Date: Fri, 21 Apr 2017 07:35:49 +1000
Message-ID: <87mvbasqx6.fsf@notabene.neil.brown.name>
References: <149265560315.31004.3851231165281498425.stgit@noble> <149265600601.31004.323865505557190368.stgit@noble> <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20 2017, Jes Sorensen wrote:

> On 04/19/2017 10:40 PM, NeilBrown wrote:
>> When an array is created the content is not initializes,
>> so it could have remnants of an old filesystem or md array
>> etc on it.
>> udev will see this and might try to activate it, which is almost
>> certainly not what is wanted.
>>
>> So create a temporary udev rules files to set ENV{SYSTEMD_READY}=3D"0"
>> while the creation event is processed.  This is fairly uniformly
>> used to suppress actions based on the contents of the device.
>>
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  Create.c |    9 +++++++++
>>  lib.c    |   22 ++++++++++++++++++++++
>>  mdadm.h  |    2 ++
>>  3 files changed, 33 insertions(+)
>
> Neil,
>
> I have heard of this problem before, but I have some concerns about the=20
> solution. First of all, /run/udev/rules.d/ isn't a universal directory.=20
> At least Fedora doesn't have it, so we need to take that into account. I=
=20
> wasn't aware it was possible to create temporary udev rules like this.

Hmmm.. Debian doesn't have it either.  However I suspect that udev will
still try to read from the directory.  The man page explicitly lists it:

RULES FILES
       The udev rules are read from the files located in the system rules
       directory /usr/lib/udev/rules.d, the volatile runtime directory
       /run/udev/rules.d and the local administration directory
       /etc/udev/rules.d.  ....

So possibly mdadm would need to mkdir("/run/udev/rules.d", 0755) first.
The man page uses the term "volatile" rather than "temporary", but this
possibility does seem to be part of the design of udev.
=20

>
> Second, isn't this going to be racey if you have multiple arrays=20
> running? I am wondering if we cannot find a solution that relies on a=20
> permanently installed udev rule that we enable/disable with systemctl=20
> and use the device name as an argument?

There would only be a problematic race of an array as being created at
the same time that another array is being assembled.  Is that at all
likely?  They tend to happen at different parts of the usage cycle...  I
guess we shouldn't assume though.

I admit that blocking *all* arrays was a short cut.  We need to create
the udev rule before the new device is first activated, and keep it in
existence until after the array has been started and the fd on /dev/mdXX
has been closed - and then a bit more because udev doesn't respond
instantly.
In some cases we don't know the name of the md device until
create_mddev() chooses on with find_free_devnum().
So if we want to block udev from handling a device, we need to put the
block into effect (e.g. create the rules.d file) in mddev_create() just
before the call to open_dev_excl().

If we wanted an more permanent udev rule, we would need to record the
devices that should be ignored in the filesystem somewhere else.
Maybe in /run/mdadm.
e.g.

 KERNEL=3D=3D"md*", TEST=3D"/run/mdadm/creating-$kernel", ENV{SYSTEMD_READY=
}=3D"0"

Then we could have something like the following (untested) in mdadm.
Does that seem more suitable?

Thanks,
NeilBrown

=2D--
 Assemble.c    |  2 +-
 Build.c       |  2 +-
 Create.c      |  9 ++++++++-
 Incremental.c |  4 ++--
 lib.c         | 29 +++++++++++++++++++++++++++++
 mdadm.h       |  4 +++-
 mdopen.c      |  4 +++-
 7 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index b8285239354b..309841432ff5 100644
=2D-- a/Assemble.c
+++ b/Assemble.c
@@ -1459,7 +1459,7 @@ try_again:
 			name =3D strchr(name, ':')+1;
=20
 		mdfd =3D create_mddev(mddev, name, ident->autof, trustworthy,
=2D				    chosen_name);
+				    chosen_name, 0);
 	}
 	if (mdfd < 0) {
 		st->ss->free_super(st);
diff --git a/Build.c b/Build.c
index 11ba12f4ae7d..665d9067b8d6 100644
=2D-- a/Build.c
+++ b/Build.c
@@ -109,7 +109,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	/* We need to create the device.  It can have no name. */
 	map_lock(&map);
 	mdfd =3D create_mddev(mddev, NULL, c->autof, LOCAL,
=2D			    chosen_name);
+			    chosen_name, 0);
 	if (mdfd < 0) {
 		map_unlock(&map);
 		return 1;
diff --git a/Create.c b/Create.c
index 6ca092449880..df1bc20c635b 100644
=2D-- a/Create.c
+++ b/Create.c
@@ -605,7 +605,7 @@ int Create(struct supertype *st, char *mddev,
=20
 	/* We need to create the device */
 	map_lock(&map);
=2D	mdfd =3D create_mddev(mddev, name, c->autof, LOCAL, chosen_name);
+	mdfd =3D create_mddev(mddev, name, c->autof, LOCAL, chosen_name, 1);
 	if (mdfd < 0) {
 		map_unlock(&map);
 		return 1;
@@ -620,6 +620,7 @@ int Create(struct supertype *st, char *mddev,
 			chosen_name);
 		close(mdfd);
 		map_unlock(&map);
+		udev_unblock();
 		return 1;
 	}
 	mddev =3D chosen_name;
@@ -1053,9 +1054,15 @@ int Create(struct supertype *st, char *mddev,
 		pr_err("not starting array - not enough devices.\n");
 	}
 	close(mdfd);
+	/* Give udev a moment to process the Change event caused
+	 * by the close.
+	 */
+	usleep(100*1000);
+	udev_unblock();
 	return 0;
=20
  abort:
+	udev_unblock();
 	map_lock(&map);
  abort_locked:
 	map_remove(&map, fd2devnm(mdfd));
diff --git a/Incremental.c b/Incremental.c
index 28f1f7734956..63ed4fa1a88d 100644
=2D-- a/Incremental.c
+++ b/Incremental.c
@@ -321,7 +321,7 @@ int Incremental(struct mddev_dev *devlist, struct conte=
xt *c,
=20
 		/* Couldn't find an existing array, maybe make a new one */
 		mdfd =3D create_mddev(match ? match->devname : NULL,
=2D				    name_to_use, c->autof, trustworthy, chosen_name);
+				    name_to_use, c->autof, trustworthy, chosen_name, 0);
=20
 		if (mdfd < 0)
 			goto out_unlock;
@@ -1605,7 +1605,7 @@ static int Incremental_container(struct supertype *st=
, char *devname,
 					    ra->name,
 					    c->autof,
 					    trustworthy,
=2D					    chosen_name);
+					    chosen_name, 0);
 		}
 		if (only && (!mp || strcmp(mp->devnm, only) !=3D 0))
 			continue;
diff --git a/lib.c b/lib.c
index b640634ef6f2..d8692cae813d 100644
=2D-- a/lib.c
+++ b/lib.c
@@ -163,6 +163,35 @@ char *fd2devnm(int fd)
 	return NULL;
 }
=20
+/* When we create a new array, we don't want the content to
+ * be immediately examined by udev - it is probably meaningless.
+ * So create /run/udev/rules.d/01-mdadm-create.rules to tell udev
+ * that the device isn't ready.
+ */
+static char block_path[] =3D "/run/mdadm/creating-%s";
+static char *unblock_path =3D NULL;
+void udev_block(char *devnm)
+{
+	int fd;
+	char *path =3D NULL;
+
+	xasprintf(&path, block_path, devnm);
+	fd =3D open(path, O_CREAT|O_RDWR, 0600);
+	if (fd >=3D 0) {
+		close(fd);
+		unblock_path =3D path;
+	} else
+		free(path);
+}
+
+void udev_unblock(void)
+{
+	if (unblock_path)
+		unlink(unblock_path);
+	free(unblock_path);
+	unblock_path =3D NULL;
+}
+
 /*
  * convert a major/minor pair for a block device into a name in /dev, if p=
ossible.
  * On the first call, walk /dev collecting name.
diff --git a/mdadm.h b/mdadm.h
index f1f643c794d4..187e60050068 100644
=2D-- a/mdadm.h
+++ b/mdadm.h
@@ -1522,7 +1522,7 @@ extern char *get_md_name(char *devnm);
 extern char DefaultConfFile[];
=20
 extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
=2D			char *chosen);
+			char *chosen, int block_udev);
 /* values for 'trustworthy' */
 #define	LOCAL	1
 #define	LOCAL_ANY 10
@@ -1556,6 +1556,8 @@ extern char *stat2kname(struct stat *st);
 extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
 extern char *fd2devnm(int fd);
+extern void udev_block(char *devnm);
+extern void udev_unblock(void);
=20
 extern int in_initrd(void);
=20
diff --git a/mdopen.c b/mdopen.c
index 82b97fc90339..1dbcdcddb9f6 100644
=2D-- a/mdopen.c
+++ b/mdopen.c
@@ -135,7 +135,7 @@ void make_parts(char *dev, int cnt)
  */
=20
 int create_mddev(char *dev, char *name, int autof, int trustworthy,
=2D		 char *chosen)
+		 char *chosen, int block_udev)
 {
 	int mdfd;
 	struct stat stb;
@@ -414,6 +414,8 @@ int create_mddev(char *dev, char *name, int autof, int =
trustworthy,
 				make_parts(chosen, parts);
 		}
 	}
+	if (block_udev)
+		udev_block(devnm);
 	mdfd =3D open_dev_excl(devnm);
 	if (mdfd < 0)
 		pr_err("unexpected failure opening %s\n",
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj5KbUACgkQOeye3VZi
gbkifw//Uf8rtCWHE/AEh9TDJnZub0jERhIO5vaJfZF41m3OcAQhiFSr/cmVgPJ3
xQlFIufs1txfLtyl5yO8TXNuWbLsfY8iaOLruyIgou5LmSv57sRGao7tEiStbKy/
thKGTLn4+Yi7bW7qSUmhjQly8SIvb3ltmGi2LJzPzYJ/L2+v3bSxl/dNyk18HPZ/
5sCPTJ9yy03AihwgU6Ni6LAD1+0U8g1ysz0Mr/V4RbBtDbOh112ujX5YBC2fDzTv
AI0gbEF30gPGNRUSrmUk+XjJOnx8KiC576gqtjMEQqsX5VH4QMk9HDaR4mB5ZGdj
9fwaJAi9afp624LbUu4menwuQffBjwI4t/8YTxDUfE5iZvPgmIjQjbl2sfR1QxkQ
DjFo6NEUZ2rCa0wtRxXf5IP8SjuV0m5SqU2KwuupF7KvzVjXzJZ4ek/jgVTpuwRE
G1jvXifLTkQSbK2u2lMP+5t23R5YH5BLLYy5U6a9q5tQrX4D0HYGPg70PbV48VdY
cJvt5iYgDXQUmAI2H5h+al797FDQ25llCfu/SpILVNVnDfciJr4Ko3SODVhv2smO
bWbsgt1LOPPd6Z3WZ3ZuxEOi2xmfiHiHNijJdVj+jhytUub1H4zg+5OD0230bzmT
XlUhTesMirddOGup5BghBBQ2Mym2+pfeZF3/1G8X0H3TGZ5AfD0=
=rsLI
-----END PGP SIGNATURE-----
--=-=-=--
