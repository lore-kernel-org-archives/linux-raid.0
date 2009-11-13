From: "Wojcik, Artur" <artur.wojcik@intel.com>
Subject: [patch 1/1][mdadm] Fix needed to enable RAID device creation on SAS
 devices.
Date: Fri, 13 Nov 2009 10:43:18 +0000
Message-ID: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Neil,
Please add this patch to your repository in order to correct problems with RAID creation on SAS devices. The sysfs paths for SAS devices are longer then 50 characters and lots of functions assume that 50 characters should be enough. This problem is especially visible when creating RAID on SAS devices installed behind an expander. The patch will exchange some unsecure functions with secure versions, too.

Regards,
Artur

diff --git a/Detail.c b/Detail.c
index e2cf028..6124d52 100644
--- a/Detail.c
+++ b/Detail.c
@@ -408,13 +408,13 @@ This is pretty boring
                        printf("  Member Arrays :");

                        while (dir && (de = readdir(dir)) != NULL) {
-                               char path[200];
+                               char path[PATH_MAX];
                                char vbuf[1024];
                                int nlen = strlen(sra->sys_name);
                                int dn;
                                if (de->d_name[0] == '.')
                                        continue;
-                               sprintf(path, "/sys/block/%s/md/metadata_version",
+                               snprintf(path, PATH_MAX, "/sys/block/%s/md/metadata_version",
                                        de->d_name);
                                if (load_sys(path, vbuf) < 0)
                                        continue;
diff --git a/platform-intel.c b/platform-intel.c
index d568ca6..8b11f29 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -44,15 +44,15 @@ void free_sys_dev(struct sys_dev **list)
 struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 {
        /* search sysfs for devices driven by 'driver' */
-       char path[256];
-       char link[256];
+       char path[PATH_MAX];
+       char link[PATH_MAX];
        char *c;
        DIR *driver_dir;
        struct dirent *de;
        struct sys_dev *head = NULL;
        struct sys_dev *list = NULL;

-       sprintf(path, "/sys/bus/%s/drivers/%s", bus, driver);
+       snprintf(path, PATH_MAX, "/sys/bus/%s/drivers/%s", bus, driver);
        driver_dir = opendir(path);
        if (!driver_dir)
                return NULL;
@@ -60,7 +60,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
                /* is 'de' a device? check that the 'subsystem' link exists and
                 * that its target matches 'bus'
                 */
-               sprintf(path, "/sys/bus/%s/drivers/%s/%s/subsystem",
+               snprintf(path, PATH_MAX, "/sys/bus/%s/drivers/%s/%s/subsystem",
                        bus, driver, de->d_name);
                if (readlink(path, link, sizeof(link)) < 0)
                        continue;
@@ -85,7 +85,7 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
                }

                /* generate canonical path name for the device */
-               sprintf(path, "/sys/bus/%s/drivers/%s/%s",
+               snprintf(path, PATH_MAX, "/sys/bus/%s/drivers/%s/%s",
                        bus, driver, de->d_name);
                list->path = canonicalize_file_name(path);
                list->next = NULL;
@@ -96,13 +96,13 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)

 __u16 devpath_to_vendor(const char *dev_path)
 {
-       char path[strlen(dev_path) + strlen("/vendor") + 1];
+       char path[PATH_MAX];
        char vendor[7];
        int fd;
        __u16 id = 0xffff;
        int n;

-       sprintf(path, "%s/vendor", dev_path);
+       snprintf(path, PATH_MAX, "%s/vendor", dev_path);

        fd = open(path, O_RDONLY);
        if (fd < 0)
@@ -202,9 +202,9 @@ const struct imsm_orom *find_imsm_orom(void)

 char *devt_to_devpath(dev_t dev)
 {
-       char device[40];
+       char device[PATH_MAX];

-       sprintf(device, "/sys/dev/block/%d:%d/device", major(dev), minor(dev));
+       snprintf(device, PATH_MAX, "/sys/dev/block/%d:%d/device", major(dev), minor(dev));
        return canonicalize_file_name(device);
 }

diff --git a/super-intel.c b/super-intel.c
index 9a99d60..561645c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -882,7 +882,7 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
                char vendor[64];
                char buf[1024];
                int major, minor;
-               char *device;
+               char device[PATH_MAX];
                char *c;
                int port;
                int type;
@@ -898,20 +898,12 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
                        continue;
                }

-               /* retrieve the scsi device type */
-               if (asprintf(&device, "/sys/dev/block/%d:%d/device/xxxxxxx", major, minor) < 0) {
-                       if (verbose)
-                               fprintf(stderr, Name ": failed to allocate 'device'\n");
-                       err = 2;
-                       break;
-               }
-               sprintf(device, "/sys/dev/block/%d:%d/device/type", major, minor);
+               snprintf(device, PATH_MAX, "/sys/dev/block/%d:%d/device/type", major, minor);
                if (load_sys(device, buf) != 0) {
                        if (verbose)
                                fprintf(stderr, Name ": failed to read device type for %s\n",
                                        path);
                        err = 2;
-                       free(device);
                        break;
                }
                type = strtoul(buf, NULL, 10);
@@ -920,7 +912,7 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
                if (!(type == 0 || type == 7 || type == 14)) {
                        vendor[0] = '\0';
                        model[0] = '\0';
-                       sprintf(device, "/sys/dev/block/%d:%d/device/vendor", major, minor);
+                       snprintf(device, PATH_MAX, "/sys/dev/block/%d:%d/device/vendor", major, minor);
                        if (load_sys(device, buf) == 0) {
                                strncpy(vendor, buf, sizeof(vendor));
                                vendor[sizeof(vendor) - 1] = '\0';
@@ -929,7 +921,7 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
                                        *c-- = '\0';

                        }
-                       sprintf(device, "/sys/dev/block/%d:%d/device/model", major, minor);
+                       snprintf(device, PATH_MAX, "/sys/dev/block/%d:%d/device/model", major, minor);
                        if (load_sys(device, buf) == 0) {
                                strncpy(model, buf, sizeof(model));
                                model[sizeof(model) - 1] = '\0';
@@ -953,9 +945,9 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
                                case 12: sprintf(buf, "raid"); break;
                                default: sprintf(buf, "unknown");
                                }
-               } else
+               } else {
                        buf[0] = '\0';
-               free(device);
+               }

                /* chop device path to 'host%d' and calculate the port number */
                c = strchr(&path[hba_len], '/');
@@ -1576,18 +1568,18 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 static void fd2devname(int fd, char *name)
 {
        struct stat st;
-       char path[256];
-       char dname[100];
+       char path[PATH_MAX];
+       char dname[PATH_MAX];
        char *nm;
        int rv;

        name[0] = '\0';
        if (fstat(fd, &st) != 0)
                return;
-       sprintf(path, "/sys/dev/block/%d:%d",
+       snprintf(path, PATH_MAX, "/sys/dev/block/%d:%d",
                major(st.st_rdev), minor(st.st_rdev));

-       rv = readlink(path, dname, sizeof(dname));
+       rv = readlink(path, dname, PATH_MAX);
        if (rv <= 0)
                return;

diff --git a/sysfs.c b/sysfs.c
index 35dfbd4..071340f 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -59,14 +59,14 @@ void sysfs_free(struct mdinfo *sra)

 int sysfs_open(int devnum, char *devname, char *attr)
 {
-       char fname[50];
+       char fname[PATH_MAX];
        int fd;
        char *mdname = devnum2devname(devnum);

        if (!mdname)
                return -1;

-       sprintf(fname, "/sys/block/%s/md/", mdname);
+       snprintf(fname, PATH_MAX, "/sys/block/%s/md/", mdname);
        if (devname) {
                strcat(fname, devname);
                strcat(fname, "/");
@@ -100,12 +100,7 @@ void sysfs_init(struct mdinfo *mdi, int fd, int devnum)

 struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
 {
-       /* Longest possible name in sysfs, mounted at /sys, is
-        *  /sys/block/md_dXXX/md/dev-XXXXX/block/dev
-        *  /sys/block/md_dXXX/md/metadata_version
-        * which is about 41 characters.  50 should do for now
-        */
-       char fname[50];
+       char fname[PATH_MAX];
        char buf[1024];
        char *base;
        char *dbase;
@@ -124,7 +119,7 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
                return NULL;
        }

-       sprintf(fname, "/sys/block/%s/md/", sra->sys_name);
+       snprintf(fname, PATH_MAX, "/sys/block/%s/md/", sra->sys_name);
        base = fname + strlen(fname);

        sra->devs = NULL;
@@ -376,14 +371,14 @@ unsigned long long get_component_size(int fd)
         * This returns in units of sectors.
         */
        struct stat stb;
-       char fname[50];
+       char fname[PATH_MAX];
        int n;
        if (fstat(fd, &stb)) return 0;
        if (major(stb.st_rdev) != get_mdp_major())
-               sprintf(fname, "/sys/block/md%d/md/component_size",
+               snprintf(fname, PATH_MAX, "/sys/block/md%d/md/component_size",
                        (int)minor(stb.st_rdev));
        else
-               sprintf(fname, "/sys/block/md_d%d/md/component_size",
+               snprintf(fname, PATH_MAX, "/sys/block/md_d%d/md/component_size",
                        (int)minor(stb.st_rdev)>>MdpMinorShift);
        fd = open(fname, O_RDONLY);
        if (fd < 0)
@@ -399,11 +394,11 @@ unsigned long long get_component_size(int fd)
 int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
                  char *name, char *val)
 {
-       char fname[50];
+       char fname[PATH_MAX];
        int n;
        int fd;

-       sprintf(fname, "/sys/block/%s/md/%s/%s",
+       snprintf(fname, PATH_MAX, "/sys/block/%s/md/%s/%s",
                sra->sys_name, dev?dev->sys_name:"", name);
        fd = open(fname, O_WRONLY);
        if (fd < 0)
@@ -428,11 +423,11 @@ int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,

 int sysfs_uevent(struct mdinfo *sra, char *event)
 {
-       char fname[50];
+       char fname[PATH_MAX];
        int n;
        int fd;

-       sprintf(fname, "/sys/block/%s/uevent",
+       snprintf(fname, PATH_MAX, "/sys/block/%s/uevent",
                sra->sys_name);
        fd = open(fname, O_WRONLY);
        if (fd < 0)
@@ -445,10 +440,10 @@ int sysfs_uevent(struct mdinfo *sra, char *event)
 int sysfs_get_fd(struct mdinfo *sra, struct mdinfo *dev,
                       char *name)
 {
-       char fname[50];
+       char fname[PATH_MAX];
        int fd;

-       sprintf(fname, "/sys/block/%s/md/%s/%s",
+       snprintf(fname, PATH_MAX, "/sys/block/%s/md/%s/%s",
                sra->sys_name, dev?dev->sys_name:"", name);
        fd = open(fname, O_RDWR);
        if (fd < 0)
@@ -574,18 +569,18 @@ int sysfs_set_array(struct mdinfo *info, int vers)

 int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int in_sync)
 {
-       char dv[100];
-       char nm[100];
+       char dv[PATH_MAX];
+       char nm[PATH_MAX];
        char *dname;
        int rv;

-       sprintf(dv, "%d:%d", sd->disk.major, sd->disk.minor);
+       snprintf(dv, PATH_MAX, "%d:%d", sd->disk.major, sd->disk.minor);
        rv = sysfs_set_str(sra, NULL, "new_dev", dv);
        if (rv)
                return rv;

        memset(nm, 0, sizeof(nm));
-       sprintf(dv, "/sys/dev/block/%d:%d", sd->disk.major, sd->disk.minor);
+       snprintf(dv, PATH_MAX, "/sys/dev/block/%d:%d", sd->disk.major, sd->disk.minor);
        rv = readlink(dv, nm, sizeof(nm));
        if (rv <= 0)
                return -1;
@@ -615,8 +610,8 @@ int sysfs_disk_to_sg(int fd)
         * scsi_generic interface
         */
        struct stat st;
-       char path[256];
-       char sg_path[256];
+       char path[PATH_MAX];
+       char sg_path[PATH_MAX];
        char sg_major_minor[8];
        char *c;
        DIR *dir;
@@ -626,7 +621,7 @@ int sysfs_disk_to_sg(int fd)
        if (fstat(fd, &st))
                return -1;

-       snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/device",
+       snprintf(path, PATH_MAX, "/sys/dev/block/%d:%d/device",
                 major(st.st_rdev), minor(st.st_rdev));

        dir = opendir(path);
@@ -662,7 +657,7 @@ int sysfs_disk_to_sg(int fd)
        c++;
        major = strtol(sg_major_minor, NULL, 10);
        minor = strtol(c, NULL, 10);
-       snprintf(path, sizeof(path), "/dev/.tmp.md.%d:%d:%d",
+       snprintf(path, PATH_MAX, "/dev/.tmp.md.%d:%d:%d",
                 (int) getpid(), major, minor);
        if (mknod(path, S_IFCHR|0600, makedev(major, minor))==0) {
                        fd = open(path, O_RDONLY);
@@ -678,7 +673,7 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
 {
        /* from an open block device, try to retrieve it scsi_id */
        struct stat st;
-       char path[256];
+       char path[PATH_MAX];
        char *c1, *c2;
        DIR *dir;
        struct dirent *de;
@@ -686,7 +681,7 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
        if (fstat(fd, &st))
                return 1;

-       snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/device",
+       snprintf(path, PATH_MAX, "/sys/dev/block/%d:%d/device",
                 major(st.st_rdev), minor(st.st_rdev));

        dir = opendir(path);
@@ -734,10 +729,10 @@ int sysfs_unique_holder(int devnum, long rdev)
         */
        DIR *dir;
        struct dirent *de;
-       char dirname[100];
+       char dirname[PATH_MAX];
        char l;
        int found = 0;
-       sprintf(dirname, "/sys/dev/block/%d:%d/holders",
+       snprintf(dirname, PATH_MAX, "/sys/dev/block/%d:%d/holders",
                major(rdev), minor(rdev));
        dir = opendir(dirname);
        errno = ENOENT;
diff --git a/util.c b/util.c
index a9e2504..95db3fa 100644
--- a/util.c
+++ b/util.c
@@ -1279,7 +1279,7 @@ int open_container(int fd)
        /* 'fd' is a block device.  Find out if it is in use
         * by a container, and return an open fd on that container.
         */
-       char path[256];
+       char path[PATH_MAX];
        char *e;
        DIR *dir;
        struct dirent *de;
@@ -1290,7 +1290,7 @@ int open_container(int fd)

        if (fstat(fd, &st) != 0)
                return -1;
-       sprintf(path, "/sys/dev/block/%d:%d/holders",
+       snprintf(path, PATH_MAX, "/sys/dev/block/%d:%d/holders",
                (int)major(st.st_rdev), (int)minor(st.st_rdev));
        e = path + strlen(path);

@@ -1399,8 +1399,8 @@ int devname2devnum(char *name)

 int stat2devnum(struct stat *st)
 {
-       char path[30];
-       char link[200];
+       char path[PATH_MAX];
+       char link[PATH_MAX];
        char *cp;
        int n;

@@ -1414,7 +1414,7 @@ int stat2devnum(struct stat *st)
                 * /sys/dev/block/%d:%d link which must look like
                 * ../../block/mdXXX/mdXXXpYY
                 */
-               sprintf(path, "/sys/dev/block/%d:%d", major(st->st_rdev),
+               snprintf(path, PATH_MAX, "/sys/dev/block/%d:%d", major(st->st_rdev),
                        minor(st->st_rdev));
                n = readlink(path, link, sizeof(link)-1);
                if (n <= 0)
@@ -1440,42 +1440,50 @@ int fd2devnum(int fd)

 int mdmon_running(int devnum)
 {
-       char path[100];
+       char path[PATH_MAX];
        char pid[10];
-       int fd;
-       int n;
-       sprintf(path, "/var/run/mdadm/%s.pid", devnum2devname(devnum));
+       int fd, n;
+       char *devname = devnum2devname(devnum);
+       if (devname) {
+               snprintf(path, PATH_MAX, "/var/run/mdadm/%s.pid", devname);
+               free(devname);
+       } else {
+               return 0;
+       }
        fd = open(path, O_RDONLY, 0);
-
-       if (fd < 0)
+       if (fd < 0) {
                return 0;
+       }
        n = read(fd, pid, 9);
        close(fd);
-       if (n <= 0)
+       if (n <= 0) {
                return 0;
-       if (kill(atoi(pid), 0) == 0)
-               return 1;
-       return 0;
+       }
+       return (kill(atoi(pid), 0) == 0);
 }

 int signal_mdmon(int devnum)
 {
-       char path[100];
+       char path[PATH_MAX];
        char pid[10];
-       int fd;
-       int n;
-       sprintf(path, "/var/run/mdadm/%s.pid", devnum2devname(devnum));
+       int fd, n;
+       char *devname = devnum2devname(devnum);
+       if (devname) {
+               sprintf(path, "/var/run/mdadm/%s.pid", devname);
+               free(devname);
+       } else {
+               return 0;
+       }
        fd = open(path, O_RDONLY, 0);
-
-       if (fd < 0)
+       if (fd < 0) {
                return 0;
+       }
        n = read(fd, pid, 9);
        close(fd);
-       if (n <= 0)
+       if (n <= 0) {
                return 0;
-       if (kill(atoi(pid), SIGUSR1) == 0)
-               return 1;
-       return 0;
+       }
+       return (kill(atoi(pid), SIGUSR1) == 0);
 }

 int start_mdmon(int devnum)
@@ -1484,7 +1492,7 @@ int start_mdmon(int devnum)
        int len;
        pid_t pid;
        int status;
-       char pathbuf[1024];
+       char pathbuf[PATH_MAX];
        char *paths[4] = {
                pathbuf,
                "/sbin/mdmon",
@@ -1495,7 +1503,7 @@ int start_mdmon(int devnum)
        if (check_env("MDADM_NO_MDMON"))
                return 0;

-       len = readlink("/proc/self/exe", pathbuf, sizeof(pathbuf));
+       len = readlink("/proc/self/exe", pathbuf, PATH_MAX);
        if (len > 0) {
                char *sl;
                pathbuf[len] = 0;


