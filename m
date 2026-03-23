Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011007.outbound.protection.outlook.com [52.101.52.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC01175A92
	for <linux-raid@vger.kernel.org>; Mon, 23 Mar 2026 23:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774309487; cv=fail; b=Iv9i1AiU/rglQ97U18SwGo7YLp8p821HXVoepIYJcndUi5BtzTmHeNhRB5t/vqDcc+KpHYxanHW/E2oMNI7aqnTbyWCawbbC7LjTTAXHgztVJoZv/gt4fW5CxJCg3n5p8ovyS9D5km4Mx9o/n2qdVGSlILKddGSRYVBDWy39RxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774309487; c=relaxed/simple;
	bh=iJkd6TjHvsxncl4HOw+9GO8yFRTMa6PhsSr2pzxgSRM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lVF2hnnAXLVeafhQG8lMAyb+CsH9MwNIkBfO9SCcTsGjKV1K69nKSSCUZpwxVbvGAU2tkW00woJwY/v/s6iZbAYEwQi7j6x7xMuWfBfuKuboNzxIuVvlGFI+ZVCDoUfft3v3Q+oTT1r5In+z2Ix2EvQsoCIxLGhKBb/wiBu43Sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c8j23wV0; arc=fail smtp.client-ip=52.101.52.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c8j23wV0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WoKNWhxLxQ4nbjDb6NFEtkHIa4/G7xsqIvV2F3dimqk/w8vcEbCXdk1Ksf98fth2KI6KRC+mfH5VxE+wDSpSZHRV+dZuUi6AmZALd4pQPOyxCkm7qLx1ThBqsGV0FBuzYsDcrJVF8o6lhLhAqH/RjXMY83hBETlWD6p46luxRhFqI1IFri1VmJjoLxlJBVsLq9HypwvA1WsueyMewh+x2tJAiVl3ttmuAtGk4DjF5mXQYBv/7REtoKR5eYySI2feZ6HJ/91lPqoKkf0014HJ9j3ucwXDuu5JZXtmX4/+wDXkwlUu8MW62L4yCQ6QLP2AsbsjaYnuZWLaukRnfLTn7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hswIHzsARksIOb9uKXGXq1j8xIObP4Gl4rGuQK8/ryg=;
 b=oVkE/eh/22XZN4yFNS+mBiv54019ECrJvLgYwbF7amktHEsBwlsY0J1LGu1SnaYwFNkf1OPNX9WoWAcla2PNVopDQsXcCJHyyIUpVDnPIgjt/OdPxCHAvowiUKjDSJUb2kR+10vPxlUVKOE7l2j1PfOFA2+nSatXhnSKAVthyHOWK9hn1JT9eMNcmZJvOGRqCFRUUOEUMr8EVQIu62ztThtx35xRoaNP1aZAl10SKqCJfPtNXumG4dPRJQOpuQlKP1IzigbskdyRewZku2jKe0eCMon/iPzMz3pvqS7MA8ktq1gNG/6Wh+/isqJ3dh0+KumcSR5ov7poPMhgigwjFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hswIHzsARksIOb9uKXGXq1j8xIObP4Gl4rGuQK8/ryg=;
 b=c8j23wV0dL+01cfoUUwchV74lolnmGpt9VfEhDfzNC0fjcg/KZcKKvUaRkbKR17jonDV5vI1QTU21Ong/FW9A87RyBGJ+36ClQWQ9Fn3IGN2yWpDlGvoYzLTADz4MJD4H7l6u8qZaRrNNXp+dORHjY1DlxKQMz6z1Bt6APxzE9apPT8jp5H3z5sjXtzC2ELdVOmcupH3Jb0SYuU3wP39sQljJ4ouLSRLq9edY8jQAjGAVvdSvdl2PgII3BbTujLf8A4Q49t4MVHdRn7TtvqvF/rbTm2Jt20ZfGlAHJ6C3+sLUszu37kPsbOhQlDRYuLy3agNvrWcFSUact5NKB28nQ==
Received: from CH2PR04CA0027.namprd04.prod.outlook.com (2603:10b6:610:52::37)
 by CH1PPFDAD84AB72.namprd12.prod.outlook.com (2603:10b6:61f:fc00::627) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.9; Mon, 23 Mar
 2026 23:44:32 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:610:52:cafe::bc) by CH2PR04CA0027.outlook.office365.com
 (2603:10b6:610:52::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 23:44:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 23:44:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Mar
 2026 16:44:23 -0700
Received: from dev.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Mar
 2026 16:44:23 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>, "Chaitanya
 Kulkarni" <kch@nvidia.com>
Subject: [PATCH 0/2] Enable PCI P2PDMA support for RAID0 and NVMe Multipath
Date: Mon, 23 Mar 2026 16:44:14 -0700
Message-ID: <20260323234416.46944-1-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|CH1PPFDAD84AB72:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e6f7050-48c7-4a88-f517-08de8936220d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	aNtuuRMmFMwdzCJgtbYplFdaNjs3rvJ3yp0dRePItgJ+RG8dDSCuX+/NFtiLCS8LCgizvoGAmyMrddqUuvLyjwEtkiPudz8anavvgdQh7LjOec/B07kgPJx4aQ/s94QwUrtN7wyMpP/SDCXSLNvLuN4uKeW1rntXluiMAcVD9AUD1SuAQdYz8Koj3gYcktB3QW4X7hLKIgN7rDUixeuQo17/noeYRouWs0dO6UK2HCKIHdK+0t7uy9cJvwUzoBVGp2RCtvUl5aoWOo8q7ZguLx+4mHdvGZlm7/avYNGxqrTiverCnSQgu8ALrHaSuS4hpH76aqRTwCEQW/iU7VLtvSGzvYMPa/mSEIwIO4G7V4tcACcXY07AaWQvudwbkRbXgEeLGNK08DfBNnUxe3wY+glQ/ls5Nn+gnhhiu3LfkftMLs6wqiVlf6Ta+/P+VD4xFTd1gWTBAWykbYOnCq+Z24x0KKGlq2scdbVqB+drR+K32C7tAM2PT4jXPCB7ucDFe+VI9OHTcuBE1jcu9+/Z3fHtNZ7ZIVH5uRcn6BcRJdg+Gz/qJ/Im6ECynKu+kHTSTTQ9Ts0d1j5O1ojq2RhQX1lv1Omh/W5vgi7VziRATPvaPzKQ77Qh7Kgm/Pkcjpardg8/WuNLB5ijW5+BhycHscQQNuBQCHXS5rLhkoHVB0Iz6Zdj/V4L0O9XmT5PF0PsxsZpvkaPvAoQ5aYuCocEAjnxgBG0mUmqRsoqGCadXPnkfbXcx1L2WrU27SOtNVEpNDVxtSz4JN8uDBCsGs0RVA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GJvJACvFX+hy9P1ortZuNou3LoD5q0Qt2XK80lVQFO1GBPRTMl4K91dUCGLknQIAYSniks3mi3i1362Fwl9NbKF4A1EwW3hIrT/tlUl7cf34QI4OkBZOwBaix4KXTS6TRPh6sotzp4CFp5huNRj6zCLcHySNFcEdiTO2H1rWVdJxfAL4WiF1WDtxJs+osGDVQscA8n4+cd+x4BhDzOsw6PqkokNPULFk4C/9UYzBKXrkG9bnN6MPsPiKyIwd2sPclajrZQnKVTmSueytJCM+8a96Hg9g8x7+xegkcnKZ9/tPLbaZObI9W3E6RAyApMI9cD7ydyJHNhY2F5byInwtS8b5H721E7OJDPx7RNMViMtKE17957Sv7s4H/X8yMdzwLrlErurabGh3xvzmUhdddChhrGdQnp7O0GAl79HbssuBGqx1JYyxEi2IhBVv8Bya
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 23:44:32.4415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6f7050-48c7-4a88-f517-08de8936220d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFDAD84AB72

Hi,

This patch series extends PCI peer-to-peer DMA (P2PDMA) support to enable
direct data transfers between PCIe devices through RAID and NVMe multipath
block layers.

Background
==========

Current Linux kernel P2PDMA infrastructure supports direct peer-to-peer
transfers, but this support is not propagated through certain storage
stacks like MD RAID and NVMe multipath.

Patch Overview
==============

Patch 1/2: MD RAID0 PCI_P2PDMA support
---------------------------------------
Enables PCI_P2PDMA for MD RAID volumes by propagating the BLK_FEAT_PCI_P2PDMA
feature to the RAID device when all underlying member devices support P2PDMA.
This follows the same pattern as the NOWAIT flag handling in the MD layer.

Without this patch, even if all underlying NVMe devices in a RAID0 array
support P2PDMA, the RAID device itself does not advertise this capability,
preventing direct device-to-device transfers through the RAID layer.

Patch 2/2: NVMe Multipath PCI_P2PDMA support
--------------------------------------------
Adds PCI_P2PDMA support for NVMe multipath devices by setting
BLK_FEAT_PCI_P2PDMA in the queue limits during nvme_mpath_alloc_disk()
when the controller supports P2PDMA operations.

NVMe multipath provides high availability by creating a single block device
(/dev/nvmeXn1) that aggregates multiple paths to the same namespace. This
patch ensures P2PDMA capability is exposed through the multipath device,
enabling peer-to-peer DMA operations on multipath configurations.

Summary
=======
All four test scenarios demonstrate that P2PDMA capabilities are correctly
propagated through both the MD RAID0 layer (patch 1/2) and NVMe multipath
layer (patch 2/2). Direct peer-to-peer transfers complete successfully with
full data integrity verification, confirming that:

1. RAID0 devices properly inherit P2PDMA capability from member devices
2. NVMe multipath devices correctly expose P2PDMA support
3. P2P memory buffers can be used for transfers involving both types
4. Data integrity is maintained across all transfer combinations

I've added the blktest log as well at the end.

Repo:-

git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git

Branch HEAD:-

commit e7cbe110ab3c38b07e5bed91808b7f6a2c328ad6 (origin/for-next)
Merge: 4107f06b64ed 67807fbaf127
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Mar 23 07:58:45 2026 -0600

    Merge branch 'for-7.1/block' into for-next

    * for-7.1/block:
      block: fix bio_alloc_bioset slowpath GFP handling

-ck

Chaitanya Kulkarni (2):
  md: Add PCI_P2PDMA support for MD RAID volumes
  nvme-multipath: enable PCI P2PDMA for multipath devices

 drivers/md/md.c               | 7 ++++++-
 drivers/nvme/host/multipath.c | 3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)


* P2P Tests :-

lab@vm70:~/p2pmem-test$ lsblk

NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda     253:0    0   50G  0 disk
├─vda1  253:1    0   49G  0 part  /
├─vda14 253:14   0    4M  0 part
├─vda15 253:15   0  106M  0 part
└─vda16 259:0    0  913M  0 part
nvme1n1 259:2    0   10G  0 disk
nvme2n1 259:3    0   10G  0 disk
└─md127   9:127  0   20G  0 raid0
nvme4n1 259:4    0   10G  0 disk
nvme3n1 259:5    0   10G  0 disk
└─md127   9:127  0   20G  0 raid0


lab@vm70:~/p2pmem-test$ sudo ./p2pmem-test /dev/nvme2n1 /dev/nvme4n1
/sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 10 -s 1M --check
Running p2pmem-test: reading /dev/nvme2n1 (10.74GB): writing /dev/nvme4n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
skip-read = OFF : skip-write =  OFF : duration = INF sec.
buffer = 0x7f6ad2125000 (p2pmem): mmap = 1.049MB
PAGE_SIZE = 4096B
checking data with seed = 1773335040
MATCH on data check, 0x3c4f165f = 0x3c4f165f.
Transfer:
 10.49MB in 191.4 ms    54.80MB/s


lab@vm70:~/p2pmem-test$ sudo ./p2pmem-test /dev/nvme3n1 /dev/nvme4n1
                             /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 10 -s 1M --check
Running p2pmem-test: reading /dev/nvme3n1 (10.74GB): writing /dev/nvme4n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
skip-read = OFF : skip-write =  OFF : duration = INF sec.
buffer = 0x7f9a2f478000 (p2pmem): mmap = 1.049MB
PAGE_SIZE = 4096B
checking data with seed = 1773335062
MATCH on data check, 0x6db73ca7 = 0x6db73ca7.
Transfer:
 10.49MB in 489.3 ms    21.43MB/s


lab@vm70:~/p2pmem-test$ sudo ./p2pmem-test /dev/nvme1n1 /dev/nvme3n1
                              /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 10 -s 1M --check

Running p2pmem-test: reading /dev/nvme1n1 (10.74GB): writing /dev/nvme3n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
skip-read = OFF : skip-write =  OFF : duration = INF sec.
buffer = 0x7fdc0cd93000 (p2pmem): mmap = 1.049MB
PAGE_SIZE = 4096B
checking data with seed = 1773334971

* pread: Remote I/O error *

lab@vm70:~/p2pmem-test$ sudo ./p2pmem-test /dev/md127 /dev/nvme4n1
			      /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 10 -s 1M --check
Running p2pmem-test: reading /dev/md127 (21.46GB): writing /dev/nvme4n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
skip-read = OFF : skip-write =  OFF : duration = INF sec.
buffer = 0x7fdddb745000 (p2pmem): mmap = 1.049MB
PAGE_SIZE = 4096B
checking data with seed = 1773334985

* pread: Remote I/O error *

# 7.0 with with PCI_P2PDMA patches


lab@vm70:~$ uname -r
7.0.0-rc2-p2pdma
lab@vm70:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda     253:0    0   50G  0 disk
├─vda1  253:1    0   49G  0 part  /
├─vda14 253:14   0    4M  0 part
├─vda15 253:15   0  106M  0 part
└─vda16 259:0    0  913M  0 part
nvme0n1 259:2    0   10G  0 disk
nvme2n1 259:3    0   10G  0 disk
└─md0     9:0    0   20G  0 raid0
nvme3n1 259:4    0   10G  0 disk
└─md0     9:0    0   20G  0 raid0
nvme4n1 259:5    0   10G  0 disk

lab@vm70:~/p2pmem-test$ sudo ./p2pmem-test /dev/nvme0n1 /dev/nvme3n1
                              /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 10 -s 1M --check
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/nvme3n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
skip-read = OFF : skip-write =  OFF : duration = INF sec.
buffer = 0x7f2ec7006000 (p2pmem): mmap = 1.049MB
PAGE_SIZE = 4096B
checking data with seed = 1773337740
MATCH on data check, 0x1a4324f = 0x1a4324f.
Transfer:
 10.49MB in 318.0 ms    32.98MB/s

lab@vm70:~/p2pmem-test$ sudo ./p2pmem-test /dev/nvme2n1 /dev/nvme3n1
			      /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 10 -s 1M --check
Running p2pmem-test: reading /dev/nvme2n1 (10.74GB): writing /dev/nvme3n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
skip-read = OFF : skip-write =  OFF : duration = INF sec.
buffer = 0x7f194de7e000 (p2pmem): mmap = 1.049MB
PAGE_SIZE = 4096B
checking data with seed = 1773337752
MATCH on data check, 0x57f470e7 = 0x57f470e7.
Transfer:
 10.49MB in 179.1 ms    58.55MB/s

lab@vm70:~/p2pmem-test$ sudo ./p2pmem-test /dev/md0 /dev/nvme3n1
			      /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 10 -s 1M --check
Running p2pmem-test: reading /dev/md0 (21.46GB): writing /dev/nvme3n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
skip-read = OFF : skip-write =  OFF : duration = INF sec.
buffer = 0x7f9972431000 (p2pmem): mmap = 1.049MB
PAGE_SIZE = 4096B
checking data with seed = 1773337761
MATCH on data check, 0x286fdcdb = 0x286fdcdb.
Transfer:
 10.49MB in 243.9 ms    42.99MB/s

lab@vm70:~/p2pmem-test$ sudo ./p2pmem-test /dev/md0 /dev/nvme4n1
                              /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate -c 10 -s 1M --check
Running p2pmem-test: reading /dev/md0 (21.46GB): writing /dev/nvme4n1 (10.74GB): p2pmem buffer /sys/bus/pci/devices/0000:0c:00.0/p2pmem/allocate.
chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
skip-read = OFF : skip-write =  OFF : duration = INF sec.
buffer = 0x7f73a098e000 (p2pmem): mmap = 1.049MB
PAGE_SIZE = 4096B
checking data with seed = 1773337770
MATCH on data check, 0x5518d20f = 0x5518d20f.
Transfer:
 10.49MB in 251.7 ms    41.66MB/s


* blktest with these patches :-
29ec80128cdc (HEAD -> for-next) nvme-multipath: enable PCI P2PDMA for multipath devices
b4086566d2f7 md: Add PCI_P2PDMA support for MD RAID volumes
p2pdma-nvme-mpath-md (for-next) # 


blktests (master) # ./test-nvme.sh 
++ for t in loop tcp
++ echo '################NVMET_TRTYPES=loop############'
################NVMET_TRTYPES=loop############
++ NVME_IMG_SIZE=1G
++ NVME_NUM_ITER=1
++ NVMET_TRTYPES=loop
++ ./check nvme
nvme/002 (tr=loop) (create many subsystems and test discovery) [passed]
    runtime  35.359s  ...  34.600s
nvme/003 (tr=loop) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.232s  ...  10.214s
nvme/004 (tr=loop) (test nvme and nvmet UUID NS descriptors) [passed]
    runtime  0.690s  ...  0.643s
nvme/005 (tr=loop) (reset local loopback target)             [passed]
    runtime  1.041s  ...  0.995s
nvme/006 (tr=loop bd=device) (create an NVMeOF target)       [passed]
    runtime  0.093s  ...  0.089s
nvme/006 (tr=loop bd=file) (create an NVMeOF target)         [passed]
    runtime  0.085s  ...  0.083s
nvme/008 (tr=loop bd=device) (create an NVMeOF host)         [passed]
    runtime  0.777s  ...  0.648s
nvme/008 (tr=loop bd=file) (create an NVMeOF host)           [passed]
    runtime  0.728s  ...  0.644s
nvme/010 (tr=loop bd=device) (run data verification fio job) [passed]
    runtime  9.037s  ...  8.917s
nvme/010 (tr=loop bd=file) (run data verification fio job)   [passed]
    runtime  46.257s  ...  43.209s
nvme/012 (tr=loop bd=device) (run mkfs and data verification fio) [passed]
    runtime  47.039s  ...  46.860s
nvme/012 (tr=loop bd=file) (run mkfs and data verification fio) [passed]
    runtime  40.123s  ...  40.060s
nvme/014 (tr=loop bd=device) (flush a command from host)     [passed]
    runtime  8.451s  ...  8.331s
nvme/014 (tr=loop bd=file) (flush a command from host)       [passed]
    runtime  7.805s  ...  7.822s
nvme/016 (tr=loop) (create/delete many NVMeOF block device-backed ns and test discovery) [passed]
    runtime  0.132s  ...  0.139s
nvme/017 (tr=loop) (create/delete many file-ns and test discovery) [passed]
    runtime  0.146s  ...  0.146s
nvme/018 (tr=loop) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.657s  ...  0.631s
nvme/019 (tr=loop bd=device) (test NVMe DSM Discard command) [passed]
    runtime  0.642s  ...  0.654s
nvme/019 (tr=loop bd=file) (test NVMe DSM Discard command)   [passed]
    runtime  0.648s  ...  0.626s
nvme/021 (tr=loop bd=device) (test NVMe list command)        [passed]
    runtime  0.679s  ...  0.631s
nvme/021 (tr=loop bd=file) (test NVMe list command)          [passed]
    runtime  0.635s  ...  0.646s
nvme/022 (tr=loop bd=device) (test NVMe reset command)       [passed]
    runtime  1.007s  ...  0.993s
nvme/022 (tr=loop bd=file) (test NVMe reset command)         [passed]
    runtime  0.999s  ...  1.005s
nvme/023 (tr=loop bd=device) (test NVMe smart-log command)   [passed]
    runtime  0.650s  ...  0.635s
nvme/023 (tr=loop bd=file) (test NVMe smart-log command)     [passed]
    runtime  0.662s  ...  0.646s
nvme/025 (tr=loop bd=device) (test NVMe effects-log)         [passed]
    runtime  0.665s  ...  0.646s
nvme/025 (tr=loop bd=file) (test NVMe effects-log)           [passed]
    runtime  0.671s  ...  0.639s
nvme/026 (tr=loop bd=device) (test NVMe ns-descs)            [passed]
    runtime  0.716s  ...  0.631s
nvme/026 (tr=loop bd=file) (test NVMe ns-descs)              [passed]
    runtime  0.617s  ...  0.613s
nvme/027 (tr=loop bd=device) (test NVMe ns-rescan command)   [passed]
    runtime  0.656s  ...  0.646s
nvme/027 (tr=loop bd=file) (test NVMe ns-rescan command)     [passed]
    runtime  0.644s  ...  0.659s
nvme/028 (tr=loop bd=device) (test NVMe list-subsys)         [passed]
    runtime  0.636s  ...  0.623s
nvme/028 (tr=loop bd=file) (test NVMe list-subsys)           [passed]
    runtime  0.635s  ...  0.621s
nvme/029 (tr=loop) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  0.954s  ...  0.946s
nvme/030 (tr=loop) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.428s  ...  0.421s
nvme/031 (tr=loop) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  5.984s  ...  5.933s
nvme/038 (tr=loop) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.034s  ...  0.033s
nvme/040 (tr=loop) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  7.068s  ...  7.012s
nvme/041 (tr=loop) (Create authenticated connections)        [passed]
    runtime  0.705s  ...  0.949s
nvme/042 (tr=loop) (Test dhchap key types for authenticated connections) [passed]
    runtime  4.007s  ...  4.295s
nvme/043 (tr=loop) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  5.191s  ...  6.744s
nvme/044 (tr=loop) (Test bi-directional authentication)      [passed]
    runtime  1.307s  ...  2.293s
nvme/045 (tr=loop) (Test re-authentication)                  [passed]
    runtime  1.639s  ...  1.624s
nvme/047 (tr=loop) (test different queue types for fabric transports) [not run]
    nvme_trtype=loop is not supported in this test
nvme/048 (tr=loop) (Test queue count changes on reconnect)   [not run]
    nvme_trtype=loop is not supported in this test
nvme/051 (tr=loop) (test nvmet concurrent ns enable/disable) [passed]
    runtime  1.395s  ...  2.673s
nvme/052 (tr=loop) (Test file-ns creation/deletion under one subsystem) [passed]
    runtime  6.288s  ...  6.832s
nvme/054 (tr=loop) (Test the NVMe reservation feature)       [passed]
    runtime  0.806s  ...  1.287s
nvme/055 (tr=loop) (Test nvme write to a loop target ns just after ns is disabled) [not run]
    kernel option DEBUG_ATOMIC_SLEEP has not been enabled
nvme/056 (tr=loop) (enable zero copy offload and run rw traffic) [not run]
    Remote target required but NVME_TARGET_CONTROL is not set
    nvme_trtype=loop is not supported in this test
    kernel option ULP_DDP has not been enabled
    module nvme_tcp does not have parameter ddp_offload
    KERNELSRC not set
    Kernel sources do not have tools/net/ynl/cli.py
    NVME_IFACE not set
nvme/057 (tr=loop) (test nvme fabrics controller ANA failover during I/O) [passed]
    runtime  27.321s  ...  27.487s
nvme/058 (tr=loop) (test rapid namespace remapping)          [passed]
    runtime  4.709s  ...  4.932s
nvme/060 (tr=loop) (test nvme fabrics target reset)          [not run]
    nvme_trtype=loop is not supported in this test
nvme/061 (tr=loop) (test fabric target teardown and setup during I/O) [not run]
    nvme_trtype=loop is not supported in this test
nvme/062 (tr=loop) (Create TLS-encrypted connections)        [not run]
    nvme_trtype=loop is not supported in this test
nvme/063 (tr=loop) (Create authenticated TCP connections with secure concatenation) [not run]
    nvme_trtype=loop is not supported in this test
nvme/065 (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  2.349s  ...  2.495s
++ for t in loop tcp
++ echo '################NVMET_TRTYPES=tcp############'
################NVMET_TRTYPES=tcp############
++ NVME_IMG_SIZE=1G
++ NVME_NUM_ITER=1
++ NVMET_TRTYPES=tcp
++ ./check nvme
nvme/002 (tr=tcp) (create many subsystems and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/003 (tr=tcp) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.244s  ...  10.249s
nvme/004 (tr=tcp) (test nvme and nvmet UUID NS descriptors)  [passed]
    runtime  0.379s  ...  0.380s
nvme/005 (tr=tcp) (reset local loopback target)              [passed]
    runtime  0.451s  ...  0.437s
nvme/006 (tr=tcp bd=device) (create an NVMeOF target)        [passed]
    runtime  0.097s  ...  0.101s
nvme/006 (tr=tcp bd=file) (create an NVMeOF target)          [passed]
    runtime  0.093s  ...  0.097s
nvme/008 (tr=tcp bd=device) (create an NVMeOF host)          [passed]
    runtime  0.389s  ...  0.369s
nvme/008 (tr=tcp bd=file) (create an NVMeOF host)            [passed]
    runtime  0.377s  ...  0.379s
nvme/010 (tr=tcp bd=device) (run data verification fio job)  [passed]
    runtime  77.447s  ...  76.703s
nvme/010 (tr=tcp bd=file) (run data verification fio job)    [passed]
    runtime  120.190s  ...  121.711s
nvme/012 (tr=tcp bd=device) (run mkfs and data verification fio) [passed]
    runtime  82.928s  ...  82.706s
nvme/012 (tr=tcp bd=file) (run mkfs and data verification fio) [passed]
    runtime    ...  118.897s
nvme/014 (tr=tcp bd=device) (flush a command from host)      [passed]
    runtime  7.825s  ...  8.880s
nvme/014 (tr=tcp bd=file) (flush a command from host)        [passed]
    runtime  7.862s  ...  8.690s
nvme/016 (tr=tcp) (create/delete many NVMeOF block device-backed ns and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/017 (tr=tcp) (create/delete many file-ns and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/018 (tr=tcp) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.355s  ...  0.357s
nvme/019 (tr=tcp bd=device) (test NVMe DSM Discard command)  [passed]
    runtime  0.364s  ...  0.369s
nvme/019 (tr=tcp bd=file) (test NVMe DSM Discard command)    [passed]
    runtime  0.352s  ...  0.345s
nvme/021 (tr=tcp bd=device) (test NVMe list command)         [passed]
    runtime  0.366s  ...  0.384s
nvme/021 (tr=tcp bd=file) (test NVMe list command)           [passed]
    runtime  0.375s  ...  0.377s
nvme/022 (tr=tcp bd=device) (test NVMe reset command)        [passed]
    runtime  0.464s  ...  0.465s
nvme/022 (tr=tcp bd=file) (test NVMe reset command)          [passed]
    runtime  0.452s  ...  0.460s
nvme/023 (tr=tcp bd=device) (test NVMe smart-log command)    [passed]
    runtime  0.377s  ...  0.375s
nvme/023 (tr=tcp bd=file) (test NVMe smart-log command)      [passed]
    runtime  0.352s  ...  0.355s
nvme/025 (tr=tcp bd=device) (test NVMe effects-log)          [passed]
    runtime  0.382s  ...  0.376s
nvme/025 (tr=tcp bd=file) (test NVMe effects-log)            [passed]
    runtime  0.365s  ...  0.378s
nvme/026 (tr=tcp bd=device) (test NVMe ns-descs)             [passed]
    runtime  0.361s  ...  0.361s
nvme/026 (tr=tcp bd=file) (test NVMe ns-descs)               [passed]
    runtime  0.362s  ...  0.354s
nvme/027 (tr=tcp bd=device) (test NVMe ns-rescan command)    [passed]
    runtime  0.385s  ...  0.390s
nvme/027 (tr=tcp bd=file) (test NVMe ns-rescan command)      [passed]
    runtime  0.390s  ...  0.398s
nvme/028 (tr=tcp bd=device) (test NVMe list-subsys)          [passed]
    runtime  0.353s  ...  0.368s
nvme/028 (tr=tcp bd=file) (test NVMe list-subsys)            [passed]
    runtime  0.357s  ...  0.346s
nvme/029 (tr=tcp) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  0.695s  ...  0.729s
nvme/030 (tr=tcp) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.400s  ...  0.401s
nvme/031 (tr=tcp) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  3.016s  ...  3.074s
nvme/038 (tr=tcp) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.042s  ...  0.042s
nvme/040 (tr=tcp) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  6.452s  ...  6.454s
nvme/041 (tr=tcp) (Create authenticated connections)         [passed]
    runtime  0.417s  ...  0.426s
nvme/042 (tr=tcp) (Test dhchap key types for authenticated connections) [passed]
    runtime  1.805s  ...  1.820s
nvme/043 (tr=tcp) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  2.411s  ...  2.432s
nvme/044 (tr=tcp) (Test bi-directional authentication)       [passed]
    runtime  0.739s  ...  0.741s
nvme/045 (tr=tcp) (Test re-authentication)                   [passed]
    runtime  1.338s  ...  1.326s
nvme/047 (tr=tcp) (test different queue types for fabric transports) [passed]
    runtime  1.864s  ...  1.856s
nvme/048 (tr=tcp) (Test queue count changes on reconnect)    [passed]
    runtime  5.535s  ...  5.553s
nvme/051 (tr=tcp) (test nvmet concurrent ns enable/disable)  [passed]
    runtime  1.344s  ...  1.432s
nvme/052 (tr=tcp) (Test file-ns creation/deletion under one subsystem) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/054 (tr=tcp) (Test the NVMe reservation feature)        [passed]
    runtime  0.484s  ...  0.508s
nvme/055 (tr=tcp) (Test nvme write to a loop target ns just after ns is disabled) [not run]
    nvme_trtype=tcp is not supported in this test
    kernel option DEBUG_ATOMIC_SLEEP has not been enabled
nvme/056 (tr=tcp) (enable zero copy offload and run rw traffic) [not run]
    Remote target required but NVME_TARGET_CONTROL is not set
    kernel option ULP_DDP has not been enabled
    module nvme_tcp does not have parameter ddp_offload
    KERNELSRC not set
    Kernel sources do not have tools/net/ynl/cli.py
    NVME_IFACE not set
nvme/057 (tr=tcp) (test nvme fabrics controller ANA failover during I/O) [passed]
    runtime  25.951s  ...  25.962s
nvme/058 (tr=tcp) (test rapid namespace remapping)           [passed]
    runtime  2.935s  ...  3.025s
nvme/060 (tr=tcp) (test nvme fabrics target reset)           [passed]
    runtime  19.400s  ...  19.329s
nvme/061 (tr=tcp) (test fabric target teardown and setup during I/O) [passed]
    runtime  8.566s  ...  8.596s
nvme/062 (tr=tcp) (Create TLS-encrypted connections)         [failed]
    runtime  5.221s  ...  5.232s
    --- tests/nvme/062.out	2026-01-28 12:04:48.888356244 -0800
    +++ /mnt/sda/blktests/results/nodev_tr_tcp/nvme/062.out.bad	2026-03-23 16:32:31.377957706 -0700
    @@ -2,9 +2,13 @@
     Test unencrypted connection w/ tls not required
     disconnected 1 controller(s)
     Test encrypted connection w/ tls not required
    -disconnected 1 controller(s)
    +FAIL: nvme connect return error code
    +WARNING: connection is not encrypted
    +disconnected 0 controller(s)
    ...
    (Run 'diff -u tests/nvme/062.out /mnt/sda/blktests/results/nodev_tr_tcp/nvme/062.out.bad' to see the entire diff)
nvme/063 (tr=tcp) (Create authenticated TCP connections with secure concatenation) [passed]
    runtime  1.907s  ...  1.969s
nvme/065 (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  2.495s  ...  2.314s
++ ./manage-rdma-nvme.sh --cleanup
====== RDMA NVMe Cleanup ======

[INFO] Disconnecting NVMe RDMA controllers...
[INFO] No NVMe RDMA controllers to disconnect
[INFO] Removing RDMA links...
[INFO] No RDMA links to remove
[INFO] Unloading NVMe RDMA modules...
[INFO] NVMe RDMA modules unloaded successfully
[INFO] Unloading soft-RDMA modules...
[INFO] Soft-RDMA modules unloaded successfully

[INFO] Verifying cleanup...
[INFO] Verification passed
[INFO] RDMA cleanup completed successfully


====== RDMA Network Configuration Status ======

Loaded Modules:
  None

RDMA Links:
  None

Network Interfaces (RDMA-capable):
  None

blktests Configuration:
  Not configured (run --setup first)

NVMe RDMA Controllers:
  None

=================================================
++ ./manage-rdma-nvme.sh --setup
====== RDMA NVMe Setup ======
RDMA Type: siw
Interface: auto-detect

[INFO] Checking prerequisites...
[INFO] Prerequisites check passed
[INFO] Loading RDMA module: siw
[INFO] Module siw loaded successfully
[INFO] Creating RDMA links...
[INFO] Creating RDMA link: ens5_siw
[INFO] Created RDMA link: ens5_siw -> ens5
++ ./manage-rdma-nvme.sh --status
====== RDMA Configuration Status ======

====== RDMA Network Configuration Status ======

Loaded Modules:
  siw                      217088

RDMA Links:
  link ens5_siw/1 state ACTIVE physical_state LINK_UP netdev ens5 

Network Interfaces (RDMA-capable):
  Interface: ens5
    IPv4: 192.168.0.46
    IPv6: fe80::5054:98ff:fe76:5440%ens5

blktests Configuration:
  Transport Address: 192.168.0.46:4420
  Transport Type: rdma
  Command: NVMET_TRTYPES=rdma ./check nvme/

NVMe RDMA Controllers:
  None

=================================================
++ echo '################NVMET_TRTYPES=rdma############'
################NVMET_TRTYPES=rdma############
++ NVME_IMG_SIZE=1G
++ NVME_NUM_ITER=1
++ nvme_trtype=rdma
++ ./check nvme
nvme/002 (tr=rdma) (create many subsystems and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/003 (tr=rdma) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.327s  ...  10.331s
nvme/004 (tr=rdma) (test nvme and nvmet UUID NS descriptors) [passed]
    runtime  0.689s  ...  0.689s
nvme/005 (tr=rdma) (reset local loopback target)             [passed]
    runtime  0.979s  ...  1.006s
nvme/006 (tr=rdma bd=device) (create an NVMeOF target)       [passed]
    runtime  0.147s  ...  0.143s
nvme/006 (tr=rdma bd=file) (create an NVMeOF target)         [passed]
    runtime  0.136s  ...  0.137s
nvme/008 (tr=rdma bd=device) (create an NVMeOF host)         [passed]
    runtime  0.691s  ...  0.702s
nvme/008 (tr=rdma bd=file) (create an NVMeOF host)           [passed]
    runtime  0.671s  ...  0.698s
nvme/010 (tr=rdma bd=device) (run data verification fio job) [passed]
    runtime  29.999s  ...  34.266s
nvme/010 (tr=rdma bd=file) (run data verification fio job)   [passed]
    runtime  59.734s  ...  62.762s
nvme/012 (tr=rdma bd=device) (run mkfs and data verification fio) [passed]
    runtime  34.220s  ...  41.940s
nvme/012 (tr=rdma bd=file) (run mkfs and data verification fio) [passed]
    runtime  58.929s  ...  71.674s
nvme/014 (tr=rdma bd=device) (flush a command from host)     [passed]
    runtime  7.554s  ...  8.508s
nvme/014 (tr=rdma bd=file) (flush a command from host)       [passed]
    runtime  7.404s  ...  8.398s
nvme/016 (tr=rdma) (create/delete many NVMeOF block device-backed ns and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/017 (tr=rdma) (create/delete many file-ns and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/018 (tr=rdma) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.671s  ...  0.671s
nvme/019 (tr=rdma bd=device) (test NVMe DSM Discard command) [passed]
    runtime  0.679s  ...  0.687s
nvme/019 (tr=rdma bd=file) (test NVMe DSM Discard command)   [passed]
    runtime  0.672s  ...  0.671s
nvme/021 (tr=rdma bd=device) (test NVMe list command)        [passed]
    runtime  0.647s  ...  0.686s
nvme/021 (tr=rdma bd=file) (test NVMe list command)          [passed]
    runtime  0.662s  ...  0.704s
nvme/022 (tr=rdma bd=device) (test NVMe reset command)       [passed]
    runtime  1.009s  ...  1.029s
nvme/022 (tr=rdma bd=file) (test NVMe reset command)         [passed]
    runtime  0.980s  ...  1.028s
nvme/023 (tr=rdma bd=device) (test NVMe smart-log command)   [passed]
    runtime  0.658s  ...  0.671s
nvme/023 (tr=rdma bd=file) (test NVMe smart-log command)     [passed]
    runtime  0.649s  ...  0.665s
nvme/025 (tr=rdma bd=device) (test NVMe effects-log)         [passed]
    runtime  0.683s  ...  0.698s
nvme/025 (tr=rdma bd=file) (test NVMe effects-log)           [passed]
    runtime  0.658s  ...  0.694s
nvme/026 (tr=rdma bd=device) (test NVMe ns-descs)            [passed]
    runtime  0.645s  ...  0.680s
nvme/026 (tr=rdma bd=file) (test NVMe ns-descs)              [passed]
    runtime  0.662s  ...  0.679s
nvme/027 (tr=rdma bd=device) (test NVMe ns-rescan command)   [passed]
    runtime  0.702s  ...  0.708s
nvme/027 (tr=rdma bd=file) (test NVMe ns-rescan command)     [passed]
    runtime  0.699s  ...  0.713s
nvme/028 (tr=rdma bd=device) (test NVMe list-subsys)         [passed]
    runtime  0.639s  ...  0.670s
nvme/028 (tr=rdma bd=file) (test NVMe list-subsys)           [passed]
    runtime  0.651s  ...  0.658s
nvme/029 (tr=rdma) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  1.048s  ...  1.045s
nvme/030 (tr=rdma) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.508s  ...  0.552s
nvme/031 (tr=rdma) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  5.746s  ...  5.820s
nvme/038 (tr=rdma) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.086s  ...  0.086s
nvme/040 (tr=rdma) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  7.008s  ...  7.010s
nvme/041 (tr=rdma) (Create authenticated connections)        [passed]
    runtime  0.732s  ...  0.783s
nvme/042 (tr=rdma) (Test dhchap key types for authenticated connections) [passed]
    runtime  3.669s  ...  3.780s
nvme/043 (tr=rdma) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  4.683s  ...  4.689s
nvme/044 (tr=rdma) (Test bi-directional authentication)      [passed]
    runtime  1.342s  ...  1.306s
nvme/045 (tr=rdma) (Test re-authentication)                  [passed]
    runtime  1.809s  ...  1.825s
nvme/047 (tr=rdma) (test different queue types for fabric transports) [passed]
    runtime  2.675s  ...  2.638s
nvme/048 (tr=rdma) (Test queue count changes on reconnect)   [passed]
    runtime  6.818s  ...  5.799s
nvme/051 (tr=rdma) (test nvmet concurrent ns enable/disable) [passed]
    runtime  1.389s  ...  1.465s
nvme/052 (tr=rdma) (Test file-ns creation/deletion under one subsystem) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/054 (tr=rdma) (Test the NVMe reservation feature)       [passed]
    runtime  0.802s  ...  0.804s
nvme/055 (tr=rdma) (Test nvme write to a loop target ns just after ns is disabled) [not run]
    nvme_trtype=rdma is not supported in this test
    kernel option DEBUG_ATOMIC_SLEEP has not been enabled
nvme/056 (tr=rdma) (enable zero copy offload and run rw traffic) [not run]
    Remote target required but NVME_TARGET_CONTROL is not set
    nvme_trtype=rdma is not supported in this test
    kernel option ULP_DDP has not been enabled
    module nvme_tcp does not have parameter ddp_offload
    KERNELSRC not set
    Kernel sources do not have tools/net/ynl/cli.py
    NVME_IFACE not set
nvme/057 (tr=rdma) (test nvme fabrics controller ANA failover during I/O) [passed]
    runtime  26.945s  ...  26.949s
nvme/058 (tr=rdma) (test rapid namespace remapping)          [passed]
    runtime  4.293s  ...  4.336s
nvme/060 (tr=rdma) (test nvme fabrics target reset)          [passed]
    runtime  20.730s  ...  20.756s
nvme/061 (tr=rdma) (test fabric target teardown and setup during I/O) [passed]
    runtime  15.686s  ...  15.514s
nvme/062 (tr=rdma) (Create TLS-encrypted connections)        [not run]
    nvme_trtype=rdma is not supported in this test
nvme/063 (tr=rdma) (Create authenticated TCP connections with secure concatenation) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/065 (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  2.314s  ...  2.336s
++ ./manage-rdma-nvme.sh --cleanup
====== RDMA NVMe Cleanup ======

[INFO] Disconnecting NVMe RDMA controllers...
[INFO] No NVMe RDMA controllers to disconnect
[INFO] Removing RDMA links...
[INFO] No RDMA links to remove
[INFO] Unloading NVMe RDMA modules...
[INFO] NVMe RDMA modules unloaded successfully
[INFO] Unloading soft-RDMA modules...
[INFO] Soft-RDMA modules unloaded successfully

[INFO] Verifying cleanup...
[INFO] Verification passed
[INFO] RDMA cleanup completed successfully


====== RDMA Network Configuration Status ======

Loaded Modules:
  None

RDMA Links:
  None

Network Interfaces (RDMA-capable):
  None

blktests Configuration:
  Not configured (run --setup first)

NVMe RDMA Controllers:
  None

==========================



-- 
2.39.5

