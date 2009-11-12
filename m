From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [patch 1/1] [mdadm] Add partition checks when creating a new array
Date: Thu, 12 Nov 2009 12:39:00 +0000
Message-ID: <EB332302649177439359CE520D92A0AF9F559760@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hello Neil,
I'm sending the patch that is connected with intel metadata compatibility.

The new code checks for existing partitions when creating an array.
If the metadata overwrites the last partition, the warning is shown to the user. The patch supports only MBR and GPT partition table types.
Despite the patch was implemented as IMSM compatibility issue I've decided to include the partition check for all metadata types as a generic code.
I would appreciate any feedback.

Regards,
Maciek.


diff --git a/Create.c b/Create.c
index c96b319..4849ac5 100644
--- a/Create.c
+++ b/Create.c
@@ -368,6 +368,8 @@ int Create(struct supertype *st, char *mddev,
 			warn |= check_ext2(fd, dname);
 			warn |= check_reiser(fd, dname);
 			warn |= check_raid(fd, dname);
+			// May metadata overwrite any partition?
+			warn |= check_partitions(fd, dname, freesize*2);
 			close(fd);
 		}
 	}
diff --git a/mdadm.h b/mdadm.h
index 261cdb7..3906571 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -787,6 +787,7 @@ extern int parse_layout_faulty(char *layout);
 extern int check_ext2(int fd, char *name);
 extern int check_reiser(int fd, char *name);
 extern int check_raid(int fd, char *name);
+extern int check_partitions(int fd, char *name, unsigned long long freesize);
 
 extern int get_mdp_major(void);
 extern int dev_open(char *dev, int flags);
diff --git a/util.c b/util.c
index 048c39f..a9e2504 100644
--- a/util.c
+++ b/util.c
@@ -65,6 +65,39 @@ struct blkpg_partition {
 	char volname[BLKPG_VOLNAMELTH];	/* volume label */
 };
 
+struct MBR_part_record {
+  __u8 bootable;
+  __u8 first_head;
+  __u8 first_sector;
+  __u8 first_cyl;
+  __u8 part_type;
+  __u8 last_head;
+  __u8 last_sector;
+  __u8 last_cyl;
+  __u32 first_sect_lba;
+  __u32 blocks_num;
+};
+
+struct GPT_part_entry {
+  unsigned char type_guid[16];
+  unsigned char partition_guid[16];
+  unsigned char starting_lba[8];
+  unsigned char ending_lba[8];
+  unsigned char attr_bits[8];
+  unsigned char name[72];
+}; 
+
+/* MBR/GPT magic numbers */
+#define	MBR_SIGNATURE_MAGIC	__cpu_to_le16(0xAA55)
+#define	GPT_SIGNATURE_MAGIC	__cpu_to_le64(0x5452415020494645ULL)
+
+#define MBR_SIGNATURE_OFFSET         510
+#define MBR_PARTITION_TABLE_OFFSET   446
+#define MBR_PARTITIONS               4 
+#define MBR_GPT_PARTITION_TYPE       0xEE
+#define GPT_ALL_PARTITIONS_OFFSET    80
+#define GPT_ENTRY_SIZE_OFFSET        84
+
 /*
  * Parse a 128 bit uuid in 4 integers
  * format is 32 hexx nibbles with options :.<space> separator
@@ -1096,6 +1129,142 @@ int get_dev_size(int fd, char *dname, unsigned long long *sizep)
 	return 1;
 }
 
+
+/* Sets endofpart parameter to the last block used by the last GPT partition on the device.
+   Returns: 1 if successful 
+            -1 for unknown partition type
+            0 for other errors 
+*/
+int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
+{
+	unsigned char buf[512];
+	unsigned char empty_gpt_entry[16]= {0};
+	struct GPT_part_entry *part;
+	unsigned long long curr_part_end;
+	unsigned all_partitions, entry_size;
+	int part_nr;
+
+	*endofpart = 0;
+
+	// read GPT header
+	lseek(fd, 512, SEEK_SET);
+	if (read(fd, buf, 512) != 512)
+		return 0;
+
+	// get the number of partition entries and the entry size
+	all_partitions = __le32_to_cpu(buf[GPT_ALL_PARTITIONS_OFFSET]);
+	entry_size = __le32_to_cpu(buf[GPT_ENTRY_SIZE_OFFSET]); 
+	
+	// Check GPT signature
+	if (*((__u64*)buf) != GPT_SIGNATURE_MAGIC)
+		return -1;
+
+	// read first GPT partition entries
+	if (read(fd, buf, 512) != 512)
+		return 0;
+
+	part = (struct GPT_part_entry*)buf;
+
+	for (part_nr=0; part_nr < all_partitions; part_nr++) {
+		// is this valid partition?
+		if (memcmp(part->type_guid, empty_gpt_entry, 16)) { 
+			// check the last lba for the current partition 
+			curr_part_end = __le64_to_cpu(*(__u64*)part->ending_lba);
+			if (curr_part_end > *endofpart)
+				*endofpart = curr_part_end;
+		}
+	    
+		part = (struct GPT_part_entry*)((unsigned char*)part + entry_size);
+
+		if ((unsigned char *)part >= buf + 512) {
+			if (read(fd, buf, 512) != 512)
+				return 0;
+			part = (struct GPT_part_entry*)buf;
+		} 
+	}	
+	return 1;
+}
+
+/* Sets endofpart parameter to the last block used by the last partition on the device.
+   Returns: 1 if successful 
+            -1 for unknown partition type
+            0 for other errors 
+*/
+int get_last_partition_end(int fd, unsigned long long *endofpart)
+{
+	unsigned char boot_sect[512];
+	struct MBR_part_record *part;
+	unsigned long long curr_part_end;
+	int part_nr;
+	int retval = 0;
+
+	*endofpart = 0;
+
+	// read MBR
+	lseek(fd, 0, 0);
+	if (read(fd, boot_sect, 512) != 512)
+		goto abort;
+
+	// check MBP signature
+	if (*((__u16*)(boot_sect + MBR_SIGNATURE_OFFSET)) 
+	    == MBR_SIGNATURE_MAGIC) {
+		retval = 1;
+		// found the correct signature
+		part = (struct MBR_part_record*) 
+			  (boot_sect + MBR_PARTITION_TABLE_OFFSET);
+	  
+		for (part_nr=0; part_nr < MBR_PARTITIONS; part_nr++) {
+			// check for GPT type
+			if (part->part_type == MBR_GPT_PARTITION_TYPE) {
+				retval = get_gpt_last_partition_end(fd, endofpart);
+				break;
+			}
+			// check the last used lba for the current partition 
+			curr_part_end = __le32_to_cpu(part->first_sect_lba) + 
+				           __le32_to_cpu(part->blocks_num);
+			if (curr_part_end > *endofpart)
+				*endofpart = curr_part_end;
+
+			part++;
+		}
+	} else {
+		// Unknown partition table
+		retval = -1;
+	}
+ abort:	
+	return retval;
+}
+
+int check_partitions(int fd, char *dname, unsigned long long freesize)
+{
+	/*
+	 * Check where the last partition ends 
+	 */
+	unsigned long long endofpart;
+	int ret;
+	
+	if ((ret = get_last_partition_end(fd, &endofpart)) > 0) {
+		if (endofpart > freesize) {
+			fprintf(stderr,
+					Name ": Not enough space for metadata on %s.\n",
+					dname);					
+			return 1;
+		}
+	} else {
+		if (ret < 0) {
+			fprintf(stderr,
+					Name ": Unknown parition table on %s.\n",
+					dname);			      
+		} else {
+			fprintf(stderr,
+					Name ": Unknown error while reading %s.\n",
+					dname);			      
+		}
+		return 1;
+	}
+	return 0;
+}
+
 void get_one_disk(int mdfd, mdu_array_info_t *ainf, mdu_disk_info_t *disk)
 {
 	int d;

