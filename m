From: Artur Wojcik <artur.wojcik@intel.com>
Subject: [mdadm PATCH] imsm: support for Intel(R) SAS controller.
Date: Tue, 16 Feb 2010 15:52:11 +0100
Message-ID: <1266331931.27861.6.camel@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

This patch adds support for SAS controller(s) built in Intel(R) Patsburg
chipset. The patch is for IMSM metadata only.

The patch maintains compatibility between Linux and Windows IMSM RAID
stacks - Windows IMSM does not allow arrays to span on devices attached to
different storage controllers.

Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
---
 platform-intel.c |   89 ++++++++--------
 platform-intel.h |   12 ++
 super-intel.c    |  296 ++++++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 287 insertions(+), 110 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 30f7914..31639c3 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -41,7 +41,7 @@ void free_sys_dev(struct sys_dev **list)
        }
 }

-struct sys_dev *find_driver_devices(const char *bus, const char *driver)
+static struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 {
        /* search sysfs for devices driven by 'driver' */
        char path[292];
@@ -51,6 +51,14 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
        struct dirent *de;
        struct sys_dev *head = NULL;
        struct sys_dev *list = NULL;
+       enum sys_dev_type type;
+
+       if (strcmp(driver, "isci_mod") == 0)
+               type = SYS_DEV_SAS;
+       else if (strcmp(driver, "ahci") == 0)
+               type = SYS_DEV_SATA;
+       else
+               type = SYS_DEV_UNKNOWN;

        sprintf(path, "/sys/bus/%s/drivers/%s", bus, driver);
        driver_dir = opendir(path);
@@ -74,6 +82,13 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
                if (strncmp(bus, c+1, strlen(bus)) != 0)
                        continue;

+               sprintf(path, "/sys/bus/%s/drivers/%s/%s",
+                       bus, driver, de->d_name);
+
+               /* if it's not Intel device skip it. */
+               if (devpath_to_vendor(path) != 0x8086)
+                       continue;
+
                /* start / add list entry */
                if (!head) {
                        head = malloc(sizeof(*head));
@@ -88,11 +103,11 @@ struct sys_dev *find_driver_devices(const char *bus, const char *driver)
                        break;
                }

-               /* generate canonical path name for the device */
-               sprintf(path, "/sys/bus/%s/drivers/%s/%s",
-                       bus, driver, de->d_name);
+               list->type = type;
                list->path = canonicalize_file_name(path);
                list->next = NULL;
+               if ((list->pci_id = strrchr(list->path, '/')) != NULL)
+                       list->pci_id++;
        }
        closedir(driver_dir);
        return head;
@@ -122,23 +137,34 @@ __u16 devpath_to_vendor(const char *dev_path)
        return id;
 }

-static int platform_has_intel_ahci(void)
+struct sys_dev *find_intel_devices(void)
 {
-       struct sys_dev *devices = find_driver_devices("pci", "ahci");
-       struct sys_dev *dev;
-       int ret = 0;
-
-       for (dev = devices; dev; dev = dev->next)
-               if (devpath_to_vendor(dev->path) == 0x8086) {
-                       ret = 1;
-                       break;
-               }
-
-       free_sys_dev(&devices);
-
-       return ret;
+       struct sys_dev *ahci, *isci;
+
+       isci = find_driver_devices("pci", "isci_mod");
+       ahci = find_driver_devices("pci", "ahci");
+
+       if (!ahci) {
+               ahci = isci;
+       } else {
+               struct sys_dev *elem = ahci;
+               while (elem->next)
+                       elem = elem->next;
+               elem->next = isci;
+       }
+       return ahci;
 }

+static int platform_has_intel_devices(void)
+{
+       struct sys_dev *devices;
+       devices = find_intel_devices();
+       if (devices) {
+               free_sys_dev(&devices);
+               return 1;
+       }
+       return 0;
+}

 static struct imsm_orom imsm_orom;
 static int scan(const void *start, const void *end)
@@ -185,7 +211,7 @@ const struct imsm_orom *find_imsm_orom(void)
                return &imsm_orom;
        }

-       if (!platform_has_intel_ahci())
+       if (!platform_has_intel_devices())
                return NULL;

        /* scan option-rom memory looking for an imsm signature */
@@ -212,20 +238,6 @@ char *devt_to_devpath(dev_t dev)
        return canonicalize_file_name(device);
 }

-static char *diskfd_to_devpath(int fd)
-{
-       /* return the device path for a disk, return NULL on error or fd
-        * refers to a partition
-        */
-       struct stat st;
-
-       if (fstat(fd, &st) != 0)
-               return NULL;
-       if (!S_ISBLK(st.st_mode))
-               return NULL;
-
-       return devt_to_devpath(st.st_rdev);
-}

 int path_attached_to_hba(const char *disk_path, const char *hba_path)
 {
@@ -253,14 +265,3 @@ int devt_attached_to_hba(dev_t dev, const char *hba_path)
        return rc;
 }

-int disk_attached_to_hba(int fd, const char *hba_path)
-{
-       char *disk_path = diskfd_to_devpath(fd);
-       int rc = path_attached_to_hba(disk_path, hba_path);
-
-       if (disk_path)
-               free(disk_path);
-
-       return rc;
-}
-
diff --git a/platform-intel.h b/platform-intel.h
index bbdc9f9..df6c78f 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -115,15 +115,23 @@ static inline int imsm_orom_has_chunk(const struct imsm_orom *orom, int chunk)
        return !!(orom->sss & (1 << (fs - 1)));
 }

+enum sys_dev_type {
+       SYS_DEV_UNKNOWN = 0,
+       SYS_DEV_SAS,
+       SYS_DEV_SATA
+};
+
 struct sys_dev {
+       enum sys_dev_type type;
        char *path;
+       char *pci_id;
        struct sys_dev *next;
 };

-struct sys_dev *find_driver_devices(const char *bus, const char *driver);
+struct sys_dev *find_intel_devices(void);
 __u16 devpath_to_vendor(const char *dev_path);
 void free_sys_dev(struct sys_dev **list);
 const struct imsm_orom *find_imsm_orom(void);
-int disk_attached_to_hba(int fd, const char *hba_path);
 char *devt_to_devpath(dev_t dev);
 int path_attached_to_hba(const char *disk_path, const char *hba_path);
+const char *get_sys_dev_type(enum sys_dev_type);
diff --git a/super-intel.c b/super-intel.c
index 8e20a81..2331570 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -233,6 +233,13 @@ struct intel_dev {
        int index;
 };

+struct intel_hba {
+       enum sys_dev_type type;
+       char *path;
+       char *pci_id;
+       struct intel_hba *next;
+};
+
 /* internal representation of IMSM metadata */
 struct intel_super {
        union {
@@ -263,7 +270,7 @@ struct intel_super {
        struct dl *add; /* list of disks to add while mdmon active */
        struct dl *missing; /* disks removed while we weren't looking */
        struct bbm_log *bbm_log;
-       const char *hba; /* device path of the raid controller for this metadata */
+       struct intel_hba *hba; /* device path of the raid controller for this metadata */
        const struct imsm_orom *orom; /* platform firmware support */
        struct intel_super *next; /* (temp) list for disambiguating family_num */
 };
@@ -308,6 +315,132 @@ struct imsm_update_add_disk {
        enum imsm_update_type type;
 };

+static const char *_sys_dev_type[] = {
+       [SYS_DEV_UNKNOWN] = "Unknown",
+       [SYS_DEV_SAS] = "SAS",
+       [SYS_DEV_SATA] = "SATA"
+};
+
+const char *get_sys_dev_type(enum sys_dev_type type)
+{
+       if (type < SYS_DEV_UNKNOWN)
+               type = SYS_DEV_UNKNOWN;
+       else if (type > SYS_DEV_SATA)
+               type = SYS_DEV_SATA;
+
+       return _sys_dev_type[type];
+}
+
+static struct intel_hba * alloc_intel_hba(struct sys_dev *device)
+{
+       struct intel_hba *result = malloc(sizeof(*result));
+       if (result) {
+               result->type = device->type;
+               result->path = strdup(device->path);
+               result->next = NULL;
+               if (result->path && (result->pci_id = strrchr(result->path, '/')) != NULL)
+                       result->pci_id++;
+       }
+       return result;
+}
+
+static struct intel_hba * find_intel_hba(struct intel_super *super, struct sys_dev *device)
+{
+       struct intel_hba *result;
+       for (result = super->hba; result; result = result->next) {
+               if (result->type == device->type && strcmp(result->path, device->path) == 0)
+                       break;
+       }
+       return result;
+}
+
+static char *diskfd_to_devpath(int fd)
+{
+       /* return the device path for a disk, return NULL on error or fd
+        * refers to a partition
+        */
+       struct stat st;
+
+       if (fstat(fd, &st) != 0)
+               return NULL;
+       if (!S_ISBLK(st.st_mode))
+               return NULL;
+
+       return devt_to_devpath(st.st_rdev);
+}
+
+static int attach_hba_to_super(struct intel_super *super, struct sys_dev *device,
+       const char *devname)
+{
+       struct intel_hba *hba;
+
+       /* Check if HBA is already attached to super */
+       if ((hba = find_intel_hba(super, device)) != NULL)
+               return 1;
+
+       if (super->hba == NULL) {
+               super->hba = alloc_intel_hba(device);
+               return 1;
+       }
+
+       hba = super->hba;
+       if (device->type != hba->type) {
+               fprintf(stderr, Name ": %s is attached to Intel(R) %s RAID "
+                       "controller (%s),\n    but the container is assigned to Intel(R) "
+                       "%s RAID controller (",
+                       devname,
+                       get_sys_dev_type(device->type),
+                       device->pci_id ? : "Err!",
+                       get_sys_dev_type(hba->type));
+
+               while (hba) {
+                       fprintf(stderr, "%s", hba->pci_id ? : "Err!");
+                       if (hba->next)
+                               fprintf(stderr, ", ");
+                       hba = hba->next;
+               }
+
+               fprintf(stderr, ").\n"
+                       "    Mixing devices attached to different controllers "
+                       "is not allowed.\n");
+               return 2;
+       }
+       while (hba->next)
+               hba = hba->next;
+
+       hba->next = alloc_intel_hba(device);
+       return 1;
+}
+
+static int disk_attached_to_hba(int fd, struct intel_super *super, const char *devname)
+{
+       int result = 0;
+       struct sys_dev *list, *elem;
+       char *disk_path;
+
+       if ((list = find_intel_devices()) == NULL)
+               return 0;
+
+       disk_path = diskfd_to_devpath(fd);
+       if (!disk_path) {
+               free_sys_dev(&list);
+               return 0;
+       }
+
+       for (elem = list; elem; elem = elem->next) {
+               if (path_attached_to_hba(disk_path, elem->path))
+                       break;
+       }
+
+       if (elem)
+               result = attach_hba_to_super(super, elem, devname);
+
+       free(disk_path);
+       free_sys_dev(&list);
+
+       return result;
+}
+
 static struct supertype *match_metadata_desc_imsm(char *arg)
 {
        struct supertype *st;
@@ -863,10 +996,10 @@ static void brief_detail_super_imsm(struct supertype *st)
 static int imsm_read_serial(int fd, char *devname, __u8 *serial);
 static void fd2devname(int fd, char *name);

-static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_base, int verbose)
+static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_base, int verbose)
 {
-       /* dump an unsorted list of devices attached to ahci, as well as
-        * non-connected ports
+       /* dump an unsorted list of devices attached to Intel storage
+        * controller, as well as non-connected ports
         */
        int hba_len = strlen(hba_path) + 1;
        struct dirent *ent;
@@ -1026,6 +1159,56 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
        return err;
 }

+static int isci_enumerate_devices(const char *hba_path, int verbose)
+{
+       (void)hba_path;
+       (void)verbose;
+       return 0; /* TBD */
+}
+
+static void print_found_intel_controllers(struct sys_dev *elem)
+{
+       for (; elem; elem = elem->next) {
+               fprintf(stderr, Name ": found Intel(R) ");
+               if (elem->type == SYS_DEV_SATA)
+                       fprintf(stderr, "SATA ");
+               else if (elem->type == SYS_DEV_SAS)
+                       fprintf(stderr, "SAS ");
+               fprintf(stderr, "RAID controller");
+               if (elem->pci_id)
+                       fprintf(stderr, " at %s", elem->pci_id);
+               fprintf(stderr, ".\n");
+       }
+       fflush(stderr);
+}
+
+static int ahci_get_port_count(const char *hba_path, int *port_count)
+{
+       struct dirent *ent;
+       DIR *dir;
+       int host_base = -1;
+
+       *port_count = 0;
+       if ((dir = opendir(hba_path)) == NULL)
+               return -1;
+
+       for (ent = readdir(dir); ent; ent = readdir(dir)) {
+               int host;
+
+               if (sscanf(ent->d_name, "host%d", &host) != 1)
+                       continue;
+               if (*port_count == 0)
+                       host_base = host;
+               else if (host < host_base)
+                       host_base = host;
+
+               if (host + 1 > *port_count + host_base)
+                       *port_count = host + 1 - host_base;
+       }
+       closedir(dir);
+       return host_base;
+}
+
 static int detail_platform_imsm(int verbose, int enumerate_only)
 {
        /* There are two components to imsm platform support, the ahci SATA
@@ -1041,11 +1224,9 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
         */
        const struct imsm_orom *orom;
        struct sys_dev *list, *hba;
-       DIR *dir;
-       struct dirent *ent;
-       const char *hba_path;
        int host_base = 0;
        int port_count = 0;
+       int result = 0;

        if (enumerate_only) {
                if (check_env("IMSM_NO_PLATFORM") || find_imsm_orom())
@@ -1053,24 +1234,19 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
                return 2;
        }

-       list = find_driver_devices("pci", "ahci");
-       for (hba = list; hba; hba = hba->next)
-               if (devpath_to_vendor(hba->path) == 0x8086)
-                       break;
-
-       if (!hba) {
+       list = find_intel_devices();
+       if (!list) {
                if (verbose)
-                       fprintf(stderr, Name ": unable to find active ahci controller\n");
+                       fprintf(stderr, Name ": no active Intel(R) RAID "
+                               "controller found.\n");
                free_sys_dev(&list);
                return 2;
        } else if (verbose)
-               fprintf(stderr, Name ": found Intel SATA AHCI Controller\n");
-       hba_path = hba->path;
-       hba->path = NULL;
-       free_sys_dev(&list);
+               print_found_intel_controllers(list);

        orom = find_imsm_orom();
        if (!orom) {
+               free_sys_dev(&list);
                if (verbose)
                        fprintf(stderr, Name ": imsm option-rom not found\n");
                return 2;
@@ -1104,35 +1280,31 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
               imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
        printf("      Max Disks : %d\n", orom->tds);
        printf("    Max Volumes : %d\n", orom->vpa);
-       printf(" I/O Controller : %s\n", hba_path);
-
-       /* find the smallest scsi host number to determine a port number base */
-       dir = opendir(hba_path);
-       for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
-               int host;
-
-               if (sscanf(ent->d_name, "host%d", &host) != 1)
-                       continue;
-               if (port_count == 0)
-                       host_base = host;
-               else if (host < host_base)
-                       host_base = host;
-
-               if (host + 1 > port_count + host_base)
-                       port_count = host + 1 - host_base;
-
-       }
-       if (dir)
-               closedir(dir);

-       if (!port_count || imsm_enumerate_ports(hba_path, port_count,
-                                               host_base, verbose) != 0) {
-               if (verbose)
-                       fprintf(stderr, Name ": failed to enumerate ports\n");
-               return 2;
+       for (hba = list; hba; hba = hba->next) {
+               printf(" I/O Controller : %s (%s)\n",
+                       hba->path, get_sys_dev_type(hba->type));
+
+               if (hba->type == SYS_DEV_SATA) {
+                       host_base = ahci_get_port_count(hba->path, &port_count);
+                       if (ahci_enumerate_ports(hba->path, port_count, host_base, verbose)) {
+                               if (verbose)
+                                       fprintf(stderr, Name ": failed to enumerate "
+                                               "ports on SATA controller at %s.", hba->pci_id);
+                               result |= 2;
+                       }
+               } else if (hba->type == SYS_DEV_SAS) {
+                       if (isci_enumerate_devices(hba->path, verbose)) {
+                               if (verbose)
+                                       fprintf(stderr, Name ": failed to enumerate "
+                                               "devices on SAS controller at %s.", hba->pci_id);
+                               result |= 2;
+                       }
+               }
        }

-       return 0;
+       free_sys_dev(&list);
+       return result;
 }
 #endif

@@ -2266,6 +2438,8 @@ static void free_imsm_disks(struct intel_super *super)
 /* free all the pieces hanging off of a super pointer */
 static void __free_imsm(struct intel_super *super, int free_disks)
 {
+       struct intel_hba *elem, *next;
+
        if (super->buf) {
                free(super->buf);
                super->buf = NULL;
@@ -2273,10 +2447,15 @@ static void __free_imsm(struct intel_super *super, int free_disks)
        if (free_disks)
                free_imsm_disks(super);
        free_devlist(super);
-       if (super->hba) {
-               free((void *) super->hba);
-               super->hba = NULL;
+       elem = super->hba;
+       while (elem) {
+               if (elem->path)
+                       free((void *)elem->path);
+               next = elem->next;
+               free(elem);
+               elem = next;
        }
+       super->hba = NULL;
 }

 static void free_imsm(struct intel_super *super)
@@ -2307,20 +2486,6 @@ static struct intel_super *alloc_super(int creating_imsm)
                super->create_offset = ~((__u32 ) 0);
                if (!check_env("IMSM_NO_PLATFORM"))
                        super->orom = find_imsm_orom();
-               if (super->orom && !check_env("IMSM_TEST_OROM")) {
-                       struct sys_dev *list, *ent;
-
-                       /* find the first intel ahci controller */
-                       list = find_driver_devices("pci", "ahci");
-                       for (ent = list; ent; ent = ent->next)
-                               if (devpath_to_vendor(ent->path) == 0x8086)
-                                       break;
-                       if (ent) {
-                               super->hba = ent->path;
-                               ent->path = NULL;
-                       }
-                       free_sys_dev(&list);
-               }
        }

        return super;
@@ -3185,10 +3350,13 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
        /* if we are on an RAID enabled platform check that the disk is
         * attached to the raid controller
         */
-       if (super->hba && !disk_attached_to_hba(fd, super->hba)) {
+       rv = disk_attached_to_hba(fd, super, devname);
+       switch (rv) {
+       case 0:
                fprintf(stderr,
-                       Name ": %s is not attached to the raid controller: %s\n",
-                       devname ? : "disk", super->hba);
+                       Name ": %s is not attached to Intel(R) RAID controller.\n",
+                       devname ? : "disk");
+       case 2:
                return 1;
        }

