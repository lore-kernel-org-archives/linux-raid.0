From: Dave Jiang <djiang@mvista.com>
Subject: multi-hosting support for carrier grade Linux
Date: Tue, 5 Apr 2005 13:41:55 -0700
Message-ID: <20050405204155.GA32724@blade.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm attempting to implement multihost support of the MD for environments
such as carrier grade Linux. Multihost support allows the RAID array to
be claimed by a particular host via a unique ID (unique SCSI host ID,
FibreChannel WWN, or geographical address of a chassis blade. That way
another host that can access the disks do not claim the same disks that
are used by the RAID array. 

I would like to store a 64bit unique ID on the
superblock of the device. The least intrusive way IMHO to do this is
implementing the feature via the management app such as mdadm in
userland. However, it seems that after I instruct the kernel to create the MD array via mdadm, the kernel starts out with a blank superblock and clobbers the
data I have stored on the superblock via mdadm. Would it be acceptable
to modify the kernel such that the unique ID info is preserved during
the creation of the superblock by the kernel? Example patch follows:

Index: linux-2.6.10/drivers/md/md.c
===================================================================
--- linux-2.6.10.orig/drivers/md/md.c
+++ linux-2.6.10/drivers/md/md.c
@@ -640,6 +640,10 @@
 	struct list_head *tmp;
 	mdk_rdev_t *rdev2;
 	int next_spare = mddev->raid_disks;
+#ifdef CONFIG_MD_MULTIHOST	
+	u32 host_id_type;
+	u64 host_identifier;
+#endif	
 
 	/* make rdev->sb match mddev data..
 	 *
@@ -656,6 +660,13 @@
 
 	sb = (mdp_super_t*)page_address(rdev->sb_page);
 
+#ifdef CONFIG_MD_MULTIHOST
+	/* saving MULTIHOST entries */
+	read_disk_sb(rdev);
+	host_id_type = sb->this_disk.host_id_type;
+	host_identifier = sb->this_disk.host_identifier;
+#endif	
+
 	memset(sb, 0, sizeof(*sb));
 
 	sb->md_magic = MD_SB_MAGIC;
@@ -741,6 +752,13 @@
 	sb->spare_disks = spare;
 
 	sb->this_disk = sb->disks[rdev->desc_nr];
+
+#ifdef CONFIG_MD_MULTIHOST
+	/* MULTIHOST */
+	sb->this_disk.host_id_type = host_id_type;
+	sb->this_disk.host_identifier = host_identifier;
+#endif	
+
 	sb->sb_csum = calc_sb_csum(sb);
 }
 
@@ -3103,7 +3121,23 @@
 				seq_printf(seq, "	resync=DELAYED");
 		}
 
+#ifdef CONFIG_MD_MULTIHOST
+		ITERATE_RDEV(mddev,rdev,tmp2) {
+			char b[BDEVNAME_SIZE];
+			mdp_super_t *sb = (mdp_super_t*)page_address(rdev->sb_page);
+			if(sb->this_disk.host_id_type == 0)
+				break;
+			seq_printf(seq, "\n      %s[%d] : ", 
+					bdevname(rdev->bdev,b), rdev->desc_nr);
+			seq_printf(seq, "\n          MultiHost ID type : %d",
+					sb->this_disk.host_id_type);
+			seq_printf(seq, "\n          MultiHost ID : %llu",
+					sb->this_disk.host_identifier);
+		}
+		seq_printf(seq, "\n\n");
+#else		
 		seq_printf(seq, "\n");
+#endif /* CONFIG_MD_MULTIHOST */
 	}
 	mddev_unlock(mddev);
 	
Index: linux-2.6.10/include/linux/raid/md_p.h
===================================================================
--- linux-2.6.10.orig/include/linux/raid/md_p.h
+++ linux-2.6.10/include/linux/raid/md_p.h
@@ -85,7 +85,13 @@
 	__u32 minor;		/* 2 Device minor number		      */
 	__u32 raid_disk;	/* 3 The role of the device in the raid set   */
 	__u32 state;		/* 4 Operational state			      */
+#if CONFIG_MD_MULTIHOST
+	__u32 reserved[MD_SB_DESCRIPTOR_WORDS - 8];
+	__u32 host_id_type;
+	__u64 host_identifier;
+#else
 	__u32 reserved[MD_SB_DESCRIPTOR_WORDS - 5];
+#endif	/* CONFIG_MD_MULTIHOST */
 } mdp_disk_t;
 
 #define MD_SB_MAGIC		0xa92b4efc
Index: linux-2.6.10/drivers/md/Kconfig
===================================================================
--- linux-2.6.10.orig/drivers/md/Kconfig
+++ linux-2.6.10/drivers/md/Kconfig
@@ -164,6 +164,17 @@
 
 	  If unsure, say N.
 
+config MD_MULTIHOST
+	bool "Multi-Host support"
+	depends on BLK_DEV_MD
+	help
+	  Multi-Host is the ability to bind an MD volume to a particular host via
+	  a unique identifier. The choices of identifiers can be used are: unique
+	  SCSI host ID, Fibre Channel IEEE unique identifier (WWN), or telecom
+	  blade geographical address (IPMB address). 
+
+	  If unsure, say N
+	  
 config MD_FAULTY
 	tristate "Faulty test module for MD"
 	depends on BLK_DEV_MD


------------------------------------------------------
Dave Jiang
Software Engineer                               
MontaVista Software, Inc.                       
mailto:djiang@mvista.com
------------------------------------------------------

