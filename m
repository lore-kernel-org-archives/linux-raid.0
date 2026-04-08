Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26B136AB77
	for <linux-raid@vger.kernel.org>; Wed,  8 Apr 2026 07:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775633177; cv=fail; b=WyxxV4YDU38d6oIXLNy7AzShZCwGTvNeptFMxkhVwVop0NsOXgLBus6dXfnCqSxqxqRDmPe7CE/ctDo+xWa4ASXKu81oFJCEY6JybevCkjGLg5gq+9aUaI/vjXlOsecQvwIElwZrh25ksUkYg95K2kRhe7QrdgNOrrRSGqQ9pXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775633177; c=relaxed/simple;
	bh=pRsCBIitzNlwQi+YACsUb0kT0AHdBSfAjlW0jPKjBt8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b5985oIvb0y8timu/lg9zzawyQtpMENa8yawJoPCnAExYFweRBNDiyW2U6B0q5xJCr2i6nuxt3JhKJrCsV3q/EsvfeRGq/ycA0EQmmomOKEEZbNcQGBM8avICokS7vz6814DEoo0IshrBj2H+c9QzJdQjq6+dJ/NhDAoqxzOUZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=niOvtL+4; arc=fail smtp.client-ip=40.93.195.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="niOvtL+4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/JFwRjhcz7iLNGvhUy7qinA+8FJcosAV4zzbyhCKYt+++PRatg7rCW+n6Vv26htoOLgSwd0dMBNSYBVwcRD+WNQvnr7uCV8dnphDQ3C2/5m3MLvA/tG7ybs6ja9vm6IujaSXbrOjVmbKBHCFISOla758+zb4x/9thdg0266YA8m02ukEAwNkzGCSQ11dHzvfvmAayG+FivyLBTYpMupgPeRjfnoRFeOgxV6mUmqvt7ZKL5tHkdYNKALX6avr98oXt/UVIMf3f7vZbenn0MrZmHec9f8/51ecK/dwlPnRdAsROVbFEOPj9vnGVBfgfzaXnqF/Skap9DnRM/yoz2EuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02nJjDP1f5rKay5xTe8PYFQzB9GhFLKYqUAg8MPDyPE=;
 b=Rt5Oltkaa+r+jWPovdVDf0xJho3NANKHpFUDRvoh9TyuTezikpNLxLkQw5R7B19wEICG4p0JNu44PLj1HHW75Kr3m7wBVD37hZemrTLsdp9/YFxtoNO5sNDUMYb6Cc81ANUlVYYmhsvpgitF8W+A00DV33jtL1PchY0SpxKrsNgsT/auX4o9lf2WniL8mndFFvvTw24whMg6MK5e4XtdZuoEewHxx26iC4Y205lNMnsfyYsZ7lDib7T6cWiVItBgxTTLeZb/2AJQLzkOg6Xm27evnySAISoV5swCoelkejsQWq24ug0NyB8HggIcYQfcH1zQ2GvYwmCflQBRXOflwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02nJjDP1f5rKay5xTe8PYFQzB9GhFLKYqUAg8MPDyPE=;
 b=niOvtL+4fn+VYPIlCVNm9htFl4Db+in88o9pv8g3NRY5p0nI/Tb+y+SVbOEWetV3LOhdvyjuFlpMeBS+dS8v8hZuzN+mrebfX0LJwN4rdOU2Nq2nI/Ip02/J7fyqJbTux2ciaPGa2gT4BfejtjJ49aKBApijPyltdveGPivqDTFlBWkoZkYwvS8zgsVCusQkXvUAc9KkURn5xs6u0iufrIzhUrfKNboJnRzddWq9V7Z+yxRji+wpQweCcFFEUf5j19u+yK8HCuYyTw67tyd/CMUv2nMgqDjLmICH3fxbdediCz8rPL3z3g90RQuELJR6OH3f2IQDHQYL4WzCJY0DRg==
Received: from LV3P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:234::17)
 by CY8PR12MB7515.namprd12.prod.outlook.com (2603:10b6:930:93::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Wed, 8 Apr
 2026 07:26:01 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:234:cafe::57) by LV3P220CA0012.outlook.office365.com
 (2603:10b6:408:234::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Wed,
 8 Apr 2026 07:26:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 07:26:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 8 Apr
 2026 00:25:45 -0700
Received: from dev.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 8 Apr
 2026 00:25:44 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-raid@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
	<kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH V2 0/2] md/nvme: Enable PCI P2PDMA support for RAID0 and NVMe Multipath
Date: Wed, 8 Apr 2026 00:25:35 -0700
Message-ID: <20260408072537.46540-1-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|CY8PR12MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: be0205d6-920f-43ec-d4f1-08de954015bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	uFAYT4NfGmJfEdnr1pRnF5iF4d1mZIAQ4JieS9cqzPxvnLxzZ7tGa1LLdt06+dhjd5j4CFPXatk9r0+zn/TdcP2icG8Y5CE0Jci9fFGcGR+34rc0Rt39FyLRC6gyapV5xPuqXwyUbMBU05ozLuH2ND61GAFtVZk9mfWS4dOVoKZcOQ2doQk/JD2A7J33ZlyzmYlztP9YHVZTb8IV64EnCTkE5eBGCWvaOhOb0mp1D4seoj+4lSlVxYkoWg+oUuX8B7pX3JXP7kjeRfZCPAooL4Hh67/XSlwE9C3LFqHTmt2epyT25EDTNgDiFZNPCwp7y9+FoccO0RU74E6cEAQKrRLF5CRG47GAGuwL8gW1JtOh/oQKLIO7rdL2oRT+g0XJs1FvMOTsM2S7Gkvu7I2MGBqcHMh2+26/Ot+Mkc7Wrk0+kgTihP/aoZ7Vqi9LsrGdtZjxF3GIDeceZ8UmPXxF0W286Hw0PZLg/dh6cvOn3DaHH+ZpbuqhGa7OnwOfxwUT5N6ODPjrMI5MhEkYnKtgm9OPyweomJXMhZzd88QS07Rfg563dwsX/tE4bRIBmmh9zppsx5BDcGG8r6o8jfK7Quha1IAGYaHbEJ3AjBlymf1kbPG8LCprEmlNro//XYqblkaAoF3cHhRU79RctwiBnvGHvLBPV+UARayjQL/ZEzMfKZQWhan8jGvLaH38kJm+3EuuSvCSOQx/uO9O7YH5iXWGljll06ealphS/Rb0ydlRiK7uPktrvf/CzrXIrKymxY4qS6wOMO0/0ixM6IkfAw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/mTnLZlQ4bFl66BSHaVansQ8kKRhwjP0/VCbe98S7FO7M7jl7J8wD7zm/InzHr2rzIl+w+jUlma5Kc+xtuaZtJPxHvRymZDB5eMpzCY37z0p3UKTMWLH0mkCYy/nSwYvWwSbcV2nEK8Q5CENgji8JGbtJtfLULHfXisqdhSx5HvhJ5mtZpEae6MVvjEcUfHXRfk7bIrc4BjAWhxzGr/UcT2UhrQ/QJqct7I08OBMhcE4rrne5Ngev9puKqUVYFy+k0v/wrWab9B0vow9jYaGuYcFThHBavz6MH2R70x9jMbnoMTLXpduaij02ZW9+3UOhir2dT31vInrhgosw3HXhN3bgIU0rIXBHwlc0poJslW3KT93Bf3CUnN0u0+hlBumGIlP7vlUTGYcudc2rJFLwtsU37Ke0JREHKpT7dFLfgbqmXmE0zT6pnfutpG/Tivt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 07:26:00.6390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be0205d6-920f-43ec-d4f1-08de954015bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7515

Hi,

This patch series extends PCI peer-to-peer DMA (P2PDMA) support to enable
direct data transfers between PCIe devices through RAID and NVMe multipath
block layers.

Current Linux kernel P2PDMA infrastructure supports direct peer-to-peer
transfers, but this support is not propagated through certain storage
stacks like MD RAID and NVMe multipath. This adds two patches for
MD RAID 0/1/10 and NVMe to propogate P2PDMA support through the
storage stack.

All four test scenarios demonstrate that P2PDMA capabilities are correctly
propagated through both the MD RAID layer (patch 1/2) and NVMe multipath
layer (patch 2/2). Direct peer-to-peer transfers complete successfully with
full data integrity verification, confirming that:

1. RAID devices properly inherit P2PDMA capability from member devices
2. NVMe multipath devices correctly expose P2PDMA support
3. P2P memory buffers can be used for transfers involving both types
4. Data integrity is maintained across all transfer combinations

I've added the patch specific tests and blktest log as well at the end.

Repo:-

git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git

Branch HEAD:-

commit cb793ff1353d4eabd18d880c684b5311c7dc6400 (origin/for-next)
Merge: cc91702dedc5 2d148a214b24
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Apr 7 08:22:30 2026 -0600

    Merge branch 'for-7.1/block' into for-next
    
    * for-7.1/block:
      xfs: use bio_await in xfs_zone_gc_reset_sync
      block: add a bio_submit_or_kill helper
      block: factor out a bio_await helper
      block: unify the synchronous bi_end_io callbacks
      xfs: fix number of GC bvecs

-ck

Changes from V1:-
- Update patch 1 to explicitly support MD RAID 0/1/10.
- Fix signoff chain order for patch 2.
- Clear BLK_FEAT_PCI_P2PDMA in nvme_mpath_add_disk() when a newly
  added path does not support it, to handle multipath across different
  transports.
- Add nvme multipath test log for mixed transport TCP and PCIe.

Kiran Kumar Modukuri (2):
  md: propagate BLK_FEAT_PCI_P2PDMA from member devices
  nvme-multipath: enable PCI P2PDMA for multipath devices

 drivers/md/md.c               |  4 ++++
 drivers/md/raid0.c            |  1 +
 drivers/md/raid1.c            |  1 +
 drivers/md/raid10.c           |  1 +
 drivers/nvme/host/multipath.c | 18 ++++++++++++++++++
 5 files changed, 25 insertions(+)

========================================================
* MD RAID Personalities and NVMe testing :-
========================================================

* RAID test log :- 
========================

RAID Level	Personality	P2PDMA	Result
==============================================
RAID0	Striping	        Opted in	MATCH -- works
RAID1	Mirror	                Opted in	MATCH -- works
RAID10	Stripe+Mirror	        Opted in	MATCH -- works
RAID4	Parity (dedicated)	Not opted in	Remote I/O error -- rejected
RAID5	Parity (distributed)	Not opted in	Remote I/O error -- rejected


lab@vm70:~/p2pmem-test$ nvme list -v
Subsystem        Subsystem-NQN                                                                                    Controllers
---------------- ------------------------------------------------------------------------------------------------ ----------------
nvme-subsys0     nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns                                              nvme0, nvme1
nvme-subsys2     nqn.2019-08.org.qemu:nvme3                                                                       nvme2
nvme-subsys3     nqn.2019-08.org.qemu:nvme4                                                                       nvme3
nvme-subsys4     nqn.2019-08.org.qemu:nvme5                                                                       nvme4

Device   SN                   MN                                       FR       TxPort Address        Slot   Subsystem    Namespaces
-------- -------------------- ---------------------------------------- -------- ------ -------------- ------ ------------ ----------------
nvme0    shared1              QEMU NVMe Ctrl                           1.0      pcie   0000:0a:00.0          nvme-subsys0 nvme0n1
nvme1    shared1              QEMU NVMe Ctrl                           1.0      pcie   0000:0b:00.0          nvme-subsys0 nvme0n1
nvme2    nvme3                QEMU NVMe Ctrl                           1.0      pcie   0000:0c:00.0          nvme-subsys2 nvme2n1
nvme3    nvme4                QEMU NVMe Ctrl                           1.0      pcie   0000:0d:00.0          nvme-subsys3 nvme3n1
nvme4    nvme5                QEMU NVMe Ctrl                           1.0      pcie   0000:0e:00.0          nvme-subsys4 nvme4n1

Device       Generic      NSID       Usage                      Format           Controllers
------------ ------------ ---------- -------------------------- ---------------- ----------------
/dev/nvme0n1 /dev/ng0n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme0, nvme1
/dev/nvme2n1 /dev/ng2n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme2
/dev/nvme3n1 /dev/ng3n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme3
/dev/nvme4n1 /dev/ng4n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme4



lab@vm70:~/p2pmem-test$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda     253:0    0   50G  0 disk
├─vda1  253:1    0   49G  0 part  /
├─vda14 253:14   0    4M  0 part
├─vda15 253:15   0  106M  0 part  /boot/efi
└─vda16 259:0    0  913M  0 part  /boot
nvme4n1 259:1    0   10G  0 disk
└─md0     9:0    0   10G  0 raid1 /mnt/raid1
nvme2n1 259:2    0   10G  0 disk
nvme3n1 259:3    0   10G  0 disk
└─md0     9:0    0   10G  0 raid1 /mnt/raid1
nvme0n1 259:5    0   10G  0 disk

lab@vm70:~$ uname -r
7.0.0-rc2-p2pdma-v2+
lab@vm70:~$ cat /proc/mdstat
Personalities : [raid0] [raid1]
md0 : active raid1 nvme4n1[1] nvme3n1[0]
      10476544 blocks super 1.2 [2/2] [UU]

unused devices: <none>
lab@vm70:~$ cd ~/p2pmem-test/
lab@vm70:~/p2pmem-test$ echo "=== 4K x 100 chunks ===" && echo "lab123" | sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 2>&1 && echo "=== 1MB x 10 chunks ===" && sudo  ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 1048576 -c 10 2>&1 && echo "=== 4K x 100 multi-thread ===" && sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 -t 4 2>&1'
> ^C
lab@vm70:~/p2pmem-test$ echo "=== 4K x 100 chunks ===" && echo "lab123" | sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 2>&1 && echo "=== 1MB x 10 chunks ===" && sudo  ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 1048576 -c 10 2>&1 && echo "=== 4K x 100 multi-thread ===" && sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 -t 4
=== 4K x 100 chunks ===
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (10.73GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  100: total = 409.6kB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7fe4e84d2000 (p2pmem): mmap = 4.096kB
	PAGE_SIZE = 4096B
Transfer:
409.60kB in 58.8  ms     6.96MB/s
=== 1MB x 10 chunks ===
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (10.73GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7f12852c9000 (p2pmem): mmap = 1.049MB
	PAGE_SIZE = 4096B
Transfer:
 10.49MB in 3.4    s     3.11MB/s
=== 4K x 100 multi-thread ===
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (10.73GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  100: total = 409.6kB : thread(s) = 4 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7f6fc7e59000 (p2pmem): mmap = 16.38kB
	PAGE_SIZE = 4096B
Transfer:
409.60kB in 47.0  ms     8.72MB/s
lab@vm70:~/p2pmem-test$ sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate --check -s 1048576 -c 1
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (10.73GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 1048576 : number of chunks =  1: total = 1.049MB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7fa9b106b000 (p2pmem): mmap = 1.049MB
	PAGE_SIZE = 4096B
	checking data with seed = 1774381052
MATCH on data check, 0x584cb982 = 0x584cb982.
Transfer:
  1.05MB in 1.5    s   679.97kB/s
lab@vm70:~/p2pmem-test$ sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate --check -s 1048576 -c 10
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (10.73GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7f6d62bfb000 (p2pmem): mmap = 1.049MB
	PAGE_SIZE = 4096B
	checking data with seed = 1774381072
MATCH on data check, 0x4dc66c1 = 0x4dc66c1.
Transfer:
 10.49MB in 3.4    s     3.12MB/s
lab@vm70:~/p2pmem-test$ sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate --check -s 4096 -c 100
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (10.73GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  100: total = 409.6kB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7faa0ca47000 (p2pmem): mmap = 4.096kB
	PAGE_SIZE = 4096B
	checking data with seed = 1774381089
MATCH on data check, 0x246e0e13 = 0x246e0e13.
Transfer:
409.60kB in 66.3  ms     6.18MB/s


$ sudo mdadm --zero-superblock /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 2>&1 && sudo mdadm --create /dev/md0 --level=0 --raid-devices=3 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 <<< "y" 2>&1 && echo "=== Done ===" && cat /proc/mdstat'
mdadm: stopped /dev/md0
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
=== Done ===
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10]
md0 : active raid0 nvme4n1[2] nvme3n1[1] nvme2n1[0]
      31429632 blocks super 1.2 512k chunks

unused devices: <none>

lab@vm70:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda     253:0    0   50G  0 disk
├─vda1  253:1    0   49G  0 part  /
├─vda14 253:14   0    4M  0 part
├─vda15 253:15   0  106M  0 part  /boot/efi
└─vda16 259:0    0  913M  0 part  /boot
nvme0n1 259:2    0   10G  0 disk
nvme2n1 259:3    0   10G  0 disk
└─md0     9:0    0   30G  0 raid0
nvme3n1 259:4    0   10G  0 disk
└─md0     9:0    0   30G  0 raid0
nvme4n1 259:5    0   10G  0 disk
└─md0     9:0    0   30G  0 raid0


lab@vm70:~/p2pmem-test$ echo "=== 4K x 100 chunks ===" && echo "lab123" | sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 2>&1 && echo "=== 1MB x 10 chunks ===" && sudo  ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 1048576 -c 10 2>&1 && echo "=== 4K x 100 multi-thread ===" && sudo ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 -t 4 2>&1
=== 4K x 100 chunks ===
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (32.18GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  100: total = 409.6kB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7fa56ef6e000 (p2pmem): mmap = 4.096kB
	PAGE_SIZE = 4096B
Transfer:
409.60kB in 38.2  ms    10.74MB/s
=== 1MB x 10 chunks ===
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (32.18GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7f07c945e000 (p2pmem): mmap = 1.049MB
	PAGE_SIZE = 4096B
Transfer:
 10.49MB in 155.5 ms    67.44MB/s
=== 4K x 100 multi-thread ===
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (32.18GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  100: total = 409.6kB : thread(s) = 4 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7f32c8439000 (p2pmem): mmap = 16.38kB
	PAGE_SIZE = 4096B
Transfer:
409.60kB in 24.1  ms    16.99MB/s



lab@vm70:~/p2pmem-test$ sudo mdadm --create /dev/md0 --level=4 --raid-devices=3 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 --force <<< "y"
mdadm: /dev/nvme2n1 appears to be part of a raid array:
       level=raid0 devices=3 ctime=Tue Mar 24 20:29:33 2026
mdadm: /dev/nvme3n1 appears to be part of a raid array:
       level=raid0 devices=3 ctime=Tue Mar 24 20:29:33 2026
mdadm: /dev/nvme4n1 appears to be part of a raid array:
       level=raid0 devices=3 ctime=Tue Mar 24 20:29:33 2026
Continue creating array? mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.


lab@vm70:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda     253:0    0   50G  0 disk
├─vda1  253:1    0   49G  0 part  /
├─vda14 253:14   0    4M  0 part
├─vda15 253:15   0  106M  0 part  /boot/efi
└─vda16 259:0    0  913M  0 part  /boot
nvme0n1 259:2    0   10G  0 disk
nvme2n1 259:3    0   10G  0 disk
└─md0     9:0    0   20G  0 raid4
nvme3n1 259:4    0   10G  0 disk
└─md0     9:0    0   20G  0 raid4
nvme4n1 259:5    0   10G  0 disk
└─md0     9:0    0   20G  0 raid4

== basic DD test ===
lab@vm70:~$ sudo dd if=/dev/urandom bs=4096 count=110 of=/dev/md0
110+0 records in
110+0 records out
450560 bytes (451 kB, 440 KiB) copied, 0.00700321 s, 64.3 MB/s


lab@vm70:~$ echo "lab123" | sudo -S dmesg -C && echo "=== P2P test on RAID4 ===" && echo "lab123" | sudo -S ~/p2pmem-test/p2pmem-test /dev/nvme0n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate --check -s 4096 -c 1 2>&1; echo "exit_code=$?" && echo "=== dmesg ===" && dmesg

=== P2P test on RAID4 ===
Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/md0 (21.46GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  1: total = 4.096kB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7fd2c5a17000 (p2pmem): mmap = 4.096kB
	PAGE_SIZE = 4096B
	checking data with seed = 1774382878
pwrite: Remote I/O error
exit_code=1

=== dmesg ===


=======RAID10===========
sshpass -p 'lab123' ssh -o StrictHostKeyChecking=no -T lab@192.168.122.251 'echo "lab123" | sudo -S mdadm --stop /dev/md127 2>&1 && echo "lab123" | sudo -S mdadm --zero-superblock /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1 2>&1 && echo "=== Cleared ===" && echo "lab123" | sudo -S mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1 <<< "y" 2>&1 && echo "=== RAID10 created ===" && cat /proc/mdstat'

mdadm: stopped /dev/md127
mdadm: Unrecognised md component device - /dev/nvme5n1
=== Cleared ===
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
=== RAID10 created ===
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10]
md0 : active raid10 nvme5n1[3] nvme4n1[2] nvme3n1[1] nvme2n1[0]
      20953088 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      [>....................]  resync =  0.0% (12800/20953088) finish=27.2min speed=12800K/sec

unused devices: <none>


lab@vm70:~$ sudo nvme list -v
Subsystem        Subsystem-NQN                                                                                    Controllers
---------------- ------------------------------------------------------------------------------------------------ ----------------
nvme-subsys1     nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns                                              nvme0, nvme1
nvme-subsys2     nqn.2019-08.org.qemu:nvme3                                                                       nvme2
nvme-subsys3     nqn.2019-08.org.qemu:nvme4                                                                       nvme3
nvme-subsys4     nqn.2019-08.org.qemu:nvme5                                                                       nvme4
nvme-subsys5     nqn.2019-08.org.qemu:nvme6                                                                       nvme5

Device   SN                   MN                                       FR       TxPort Address        Slot   Subsystem    Namespaces
-------- -------------------- ---------------------------------------- -------- ------ -------------- ------ ------------ ----------------
nvme0    shared2              QEMU NVMe Ctrl                           1.0      pcie   0000:0a:00.0          nvme-subsys1 nvme1n1
nvme1    shared2              QEMU NVMe Ctrl                           1.0      pcie   0000:0b:00.0          nvme-subsys1 nvme1n1
nvme2    nvme3                QEMU NVMe Ctrl                           1.0      pcie   0000:0c:00.0          nvme-subsys2 nvme2n1
nvme3    nvme4                QEMU NVMe Ctrl                           1.0      pcie   0000:0d:00.0          nvme-subsys3 nvme3n1
nvme4    nvme5                QEMU NVMe Ctrl                           1.0      pcie   0000:0e:00.0          nvme-subsys4 nvme4n1
nvme5    nvme6                QEMU NVMe Ctrl                           1.0      pcie   0000:11:00.0          nvme-subsys5 nvme5n1

Device       Generic      NSID       Usage                      Format           Controllers
------------ ------------ ---------- -------------------------- ---------------- ----------------
/dev/nvme1n1 /dev/ng1n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme0, nvme1
/dev/nvme2n1 /dev/ng2n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme2
/dev/nvme3n1 /dev/ng3n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme3
/dev/nvme4n1 /dev/ng4n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme4
/dev/nvme5n1 /dev/ng5n1   0x1         10.74  GB /  10.74  GB    512   B +  0 B   nvme5


lab@vm70:~$ echo "=== 4K x 100 chunks ===" && echo "lab123" | sudo ~/p2pmem-test/p2pmem-test /dev/nvme1n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 2>&1 && echo "=== 1MB x 10 chunks ===" && sudo  ~/p2pmem-test/p2pmem-test /dev/nvme1n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 1048576 -c 10 2>&1 && echo "=== 4K x 100 multi-thread ===" && sudo ~/p2pmem-test/p2pmem-test /dev/nvme1n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 -t 4 2>&1
=== 4K x 100 chunks ===
Running p2pmem-test: reading /dev/nvme1n1 (10.74GB): writing /dev/md0 (21.46GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  100: total = 409.6kB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7ffa11234000 (p2pmem): mmap = 4.096kB
	PAGE_SIZE = 4096B
Transfer:
409.60kB in 76.9  ms     5.33MB/s
=== 1MB x 10 chunks ===
Running p2pmem-test: reading /dev/nvme1n1 (10.74GB): writing /dev/md0 (21.46GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 1048576 : number of chunks =  10: total = 10.49MB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7fcd6c9c2000 (p2pmem): mmap = 1.049MB
	PAGE_SIZE = 4096B
Transfer:
 10.49MB in 425.4 ms    24.65MB/s
=== 4K x 100 multi-thread ===
Running p2pmem-test: reading /dev/nvme1n1 (10.74GB): writing /dev/md0 (21.46GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  100: total = 409.6kB : thread(s) = 4 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7fbcedb55000 (p2pmem): mmap = 16.38kB
	PAGE_SIZE = 4096B
Transfer:
409.60kB in 46.5  ms     8.81MB/s




sudo -S mdadm --stop /dev/md0 2>&1 && echo "lab123" | sudo -S mdadm --zero-superblock /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1 2>&1 && echo "lab123" | sudo -S mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1 <<< "y" 2>&1 && echo "=== Done ===" && cat /proc/mdstat'
mdadm: stopped /dev/md0
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
=== Done ===
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10]
md0 : active raid5 nvme5n1[4](S) nvme4n1[2] nvme3n1[1] nvme2n1[0]
      31429632 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]

unused devices: <none>



lab@vm70:~$ cat /proc/mdstat
Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10]
md0 : active raid5 nvme5n1[4] nvme4n1[2] nvme3n1[1] nvme2n1[0]
      31429632 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
lab@vm70:~$ echo "=== 4K x 100 chunks ===" && echo "lab123" | sudo ~/p2pmem-test/p2pmem-test /dev/nvme1n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 2>&1 && echo "=== 1MB x 10 chunks ===" && sudo  ~/p2pmem-test/p2pmem-test /dev/nvme1n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 1048576 -c 10 2>&1 && echo "=== 4K x 100 multi-thread ===" && sudo ~/p2pmem-test/p2pmem-test /dev/nvme1n1 /dev/md0 /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -s 4096 -c 100 -t 4 2>&1
=== 4K x 100 chunks ===
Running p2pmem-test: reading /dev/nvme1n1 (10.74GB): writing /dev/md0 (32.18GB): p2pmem buffer /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
	chunk size = 4096 : number of chunks =  100: total = 409.6kB : thread(s) = 1 : overlap = OFF.
	skip-read = OFF : skip-write =  OFF : duration = INF sec.
	buffer = 0x7fc717569000 (p2pmem): mmap = 4.096kB
	PAGE_SIZE = 4096B
pwrite: Remote I/O error



* NVMe Device Inventory (nvme list -v) - Before TCP Path
========================================================

Subsystem        Subsystem-NQN                                                Controllers
---------------- ---------------------------------------------------------------- ----------------
nvme-subsys0     nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns         nvme0, nvme1
nvme-subsys2     nqn.2019-08.org.qemu:nvme3                                  nvme2
nvme-subsys3     nqn.2019-08.org.qemu:nvme4                                  nvme3
nvme-subsys4     nqn.2019-08.org.qemu:nvme5                                  nvme4
nvme-subsys5     nqn.2019-08.org.qemu:nvme6                                  nvme5

Device   SN         MN              FR       TxPort Address        Subsystem    Namespaces
-------- ---------- --------------- -------- ------ -------------- ------------ ----------
nvme0    shared1    QEMU NVMe Ctrl  1.0      pcie   0000:0a:00.0   nvme-subsys0 nvme0n1
nvme1    shared1    QEMU NVMe Ctrl  1.0      pcie   0000:0b:00.0   nvme-subsys0 nvme0n1
nvme2    nvme3      QEMU NVMe Ctrl  1.0      pcie   0000:0c:00.0   nvme-subsys2 nvme2n1
nvme3    nvme4      QEMU NVMe Ctrl  1.0      pcie   0000:0d:00.0   nvme-subsys3 nvme3n1
nvme4    nvme5      QEMU NVMe Ctrl  1.0      pcie   0000:0e:00.0   nvme-subsys4 nvme4n1
nvme5    nvme6      QEMU NVMe Ctrl  1.0      pcie   0000:11:00.0   nvme-subsys5 nvme5n1

Device       NSID  Usage                   Format          Controllers
------------ ----- ----------------------- --------------- ----------------
/dev/nvme0n1 0x1    10.74 GB / 10.74 GB    512 B + 0 B    nvme0, nvme1
/dev/nvme2n1 0x1    10.74 GB / 10.74 GB    512 B + 0 B    nvme2
/dev/nvme3n1 0x1    10.74 GB / 10.74 GB    512 B + 0 B    nvme3
/dev/nvme4n1 0x1    10.74 GB / 10.74 GB    512 B + 0 B    nvme4
/dev/nvme5n1 0x1    10.74 GB / 10.74 GB    512 B + 0 B    nvme5

--------------------------------------------------------------------------------
1.2  Shared Namespace Configuration (nvme-subsys0)
--------------------------------------------------------------------------------

nvme-subsys0 - NQN=nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns
               hostnqn=nqn.2014-08.org.nvmexpress:uuid:148a9e69-3f22-420f-afea-bfd5d4b77f36
               iopolicy=numa
\
 +- nvme0 pcie 0000:0a:00.0 live optimized
 +- nvme1 pcie 0000:0b:00.0 live optimized

Two PCIe paths (nvme0, nvme1) share a single 10.74 GB namespace (nvme0n1).
Both controllers have CMB (Controller Memory Buffer) enabled for P2PDMA.

--------------------------------------------------------------------------------
1.3  PCI P2PDMA / CMB Configuration
--------------------------------------------------------------------------------

CMB-enabled NVMe controllers:
  0000:0a:00.0 (nvme0) - CMB 64 MB  -> /sys/bus/pci/devices/0000:0a:00.0/p2pmem/
  0000:0b:00.0 (nvme1) - CMB 64 MB  -> /sys/bus/pci/devices/0000:0b:00.0/p2pmem/
  0000:0c:00.0 (nvme2) - CMB 64 MB  -> /sys/bus/pci/devices/0000:0c:00.0/p2pmem/

dmesg (boot):
  nvme 0000:0a:00.0: added peer-to-peer DMA memory 0x1808000000-0x180bffffff
  nvme 0000:0b:00.0: added peer-to-peer DMA memory 0x1804000000-0x1807ffffff
  nvme 0000:0c:00.0: added peer-to-peer DMA memory 0x1800000000-0x1803ffffff

================================================================================
2. Test 1: NVMe Multipath P2PDMA with Mixed Transport Paths
================================================================================

Objective:
  Verify that BLK_FEAT_PCI_P2PDMA is correctly set on the multipath head
  device when all paths support P2PDMA (PCIe-only), and correctly cleared
  when a non-P2P-capable path (NVMe-oF TCP) is added.

Test tool:
  p2pmem-test v1.1 (https://github.com/sbates130272/p2pmem-test)

P2PMEM buffer:
  /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate (nvme0 CMB, 64 MB)

Target device:
  /dev/nvme0n1 (multipath head, nvme-subsys0)

--------------------------------------------------------------------------------
2.1  Test 1a: P2PDMA with PCIe-only Multipath Paths (Expect PASS)
--------------------------------------------------------------------------------

Paths on nvme-subsys0:
  +- nvme0 pcie 0000:0a:00.0 live optimized
  +- nvme1 pcie 0000:0b:00.0 live optimized

Both paths are PCIe with CMB -> all paths support P2PDMA.
The patch sets BLK_FEAT_PCI_P2PDMA in nvme_mpath_alloc_disk() at head
device creation time because the first controller supports P2PDMA.

Command:
  p2pmem-test /dev/nvme0n1 /dev/nvme0n1 \
    /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -c 1 -s 4k --check

Output:
  Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/nvme0n1
  (10.74GB): p2pmem buffer
  /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
        chunk size = 4096 : number of chunks =  1: total = 4.096kB :
        thread(s) = 1 : overlap = OFF.
        skip-read = OFF : skip-write =  OFF : duration = INF sec.
        buffer = 0x7f2c38c87000 (p2pmem): mmap = 4.096kB
        PAGE_SIZE = 4096B
        checking data with seed = 1775572887
  MATCH on data check, 0x319c9110 = 0x319c9110.
  Transfer:
    4.10kB in 1.1   ms     3.89MB/s

Exit code: 0

Result: PASS
  P2PDMA transfer succeeded on multipath head device with data verification.

--------------------------------------------------------------------------------
2.2  Test 1b: Add NVMe-oF TCP Path, Then Test P2PDMA (Expect FAIL)
--------------------------------------------------------------------------------

Setup - NVMe-oF TCP target (nvmet) on loopback:
  Subsystem NQN: nqn.2019-08.org.qemu:nqn.2019-08.org.qemu:shared-ns
  Namespace 1:   backed by /dev/nvme0n1 (the multipath head itself)
  Device UUID:   00000000-0000-0000-0000-000000000000 (matches QEMU quirk)
  Transport:     TCP, 127.0.0.1:4420
  CNTLID min:    10 (avoids conflict with PCIe controller IDs)

Connect command:
  nvme connect -t tcp -n <NQN> -a 127.0.0.1 -s 4420

dmesg:
  nvmet: adding nsid 1 to subsystem nqn.2019-08.org.qemu:...shared-ns
  nvmet_tcp: enabling port 1 (127.0.0.1:4420)
  nvmet: Created nvm controller 10 for subsystem nqn.2019-08.org.qemu:...
  nvme nvme6: creating 2 I/O queues.
  nvme nvme6: new ctrl: NQN "nqn.2019-08.org.qemu:...shared-ns",
    addr 127.0.0.1:4420

Paths on nvme-subsys0 (after TCP connection):
  +- nvme0 pcie 0000:0a:00.0      live optimized
  +- nvme1 pcie 0000:0b:00.0      live optimized
  +- nvme6 tcp  127.0.0.1:4420    live optimized

NVMe device inventory (nvme list -v) confirming TCP path in shared namespace:

  Subsystem        Subsystem-NQN                                             Controllers
  ---------------- --------------------------------------------------------- ----------------
  nvme-subsys0     nqn.2019-08.org.qemu:...shared-ns                        nvme0, nvme1, nvme6

  Device   SN       MN              FR        TxPort Address         Subsystem     Namespaces
  -------- -------- --------------- --------- ------ --------------- ------------- ----------
  nvme0    shared1  QEMU NVMe Ctrl  7.0.0-rc  pcie   0000:0a:00.0   nvme-subsys0  nvme0n1
  nvme1    shared1  QEMU NVMe Ctrl  7.0.0-rc  pcie   0000:0b:00.0   nvme-subsys0  nvme0n1
  nvme6    shared1  QEMU NVMe Ctrl  7.0.0-rc  tcp    127.0.0.1:4420 nvme-subsys0  nvme0n1

  Device       NSID  Usage                  Format          Controllers
  ------------ ----- ---------------------- --------------- -------------------
  /dev/nvme0n1 0x1    10.74 GB / 10.74 GB   512 B + 0 B    nvme0, nvme1, nvme6

nvme6 (TCP) has joined the shared namespace alongside nvme0 and nvme1 (PCIe).
TCP does not support PCI P2PDMA, so the patch clears BLK_FEAT_PCI_P2PDMA
on the head disk in nvme_mpath_add_disk().

Command:
  p2pmem-test /dev/nvme0n1 /dev/nvme0n1 \
    /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate -c 1 -s 4k --check

Output:
  pread: Remote I/O error
  Running p2pmem-test: reading /dev/nvme0n1 (10.74GB): writing /dev/nvme0n1
  (10.74GB): p2pmem buffer
  /sys/bus/pci/devices/0000:0a:00.0/p2pmem/allocate.
        chunk size = 4096 : number of chunks =  1: total = 4.096kB :
        thread(s) = 1 : overlap = OFF.
        skip-read = OFF : skip-write =  OFF : duration = INF sec.
        buffer = 0x7f1ad3065000 (p2pmem): mmap = 4.096kB
        PAGE_SIZE = 4096B
        checking data with seed = 1775573026

Exit code: 1

Result: PASS (expected failure)
  P2PDMA transfer correctly rejected with "Remote I/O error".
  BLK_FEAT_PCI_P2PDMA was cleared from the multipath head because the
  TCP path (nvme6) does not support PCI P2PDMA.

================================================================================
3. Test Summary
================================================================================

  Test   Description                                   Expected  Actual  Result
  ------ --------------------------------------------- --------- ------- ------
  1a     P2PDMA on multipath head (PCIe-only paths)    PASS      PASS    OK
  1b     P2PDMA on multipath head (PCIe + TCP paths)   FAIL      FAIL    OK

Both tests confirm the patch correctly:
  - Sets BLK_FEAT_PCI_P2PDMA at multipath head allocation when the first
    controller supports P2PDMA.
  - Clears BLK_FEAT_PCI_P2PDMA in nvme_mpath_add_disk() when a newly added
    path does not support P2PDMA, preventing unsafe P2P DMA through a
    non-P2P-capable transport.


* BLKTEST Testing :-

++ for t in loop tcp
++ echo '################NVMET_TRTYPES=loop############'
################NVMET_TRTYPES=loop############
++ NVME_IMG_SIZE=1G
++ NVME_NUM_ITER=1
++ NVMET_TRTYPES=loop
++ ./check nvme
nvme/002 (tr=loop) (create many subsystems and test discovery) [passed]
    runtime  28.709s  ...  36.107s
nvme/003 (tr=loop) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.170s  ...  10.227s
nvme/004 (tr=loop) (test nvme and nvmet UUID NS descriptors) [passed]
    runtime  0.543s  ...  0.650s
nvme/005 (tr=loop) (reset local loopback target)             [passed]
    runtime  0.900s  ...  0.989s
nvme/006 (tr=loop bd=device) (create an NVMeOF target)       [passed]
    runtime  0.065s  ...  0.093s
nvme/006 (tr=loop bd=file) (create an NVMeOF target)         [passed]
    runtime  0.056s  ...  0.087s
nvme/008 (tr=loop bd=device) (create an NVMeOF host)         [passed]
    runtime  0.554s  ...  0.642s
nvme/008 (tr=loop bd=file) (create an NVMeOF host)           [passed]
    runtime  0.533s  ...  0.645s
nvme/010 (tr=loop bd=device) (run data verification fio job) [passed]
    runtime  5.737s  ...  9.706s
nvme/010 (tr=loop bd=file) (run data verification fio job)   [passed]
    runtime  29.743s  ...  40.205s
nvme/012 (tr=loop bd=device) (run mkfs and data verification fio) [passed]
    runtime  25.589s  ...  49.060s
nvme/012 (tr=loop bd=file) (run mkfs and data verification fio) [passed]
    runtime  28.039s  ...  38.910s
nvme/014 (tr=loop bd=device) (flush a command from host)     [passed]
    runtime  6.340s  ...  9.628s
nvme/014 (tr=loop bd=file) (flush a command from host)       [passed]
    runtime  6.237s  ...  9.359s
nvme/016 (tr=loop) (create/delete many NVMeOF block device-backed ns and test discovery) [passed]
    runtime  0.110s  ...  0.138s
nvme/017 (tr=loop) (create/delete many file-ns and test discovery) [passed]
    runtime  0.116s  ...  0.144s
nvme/018 (tr=loop) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.544s  ...  0.628s
nvme/019 (tr=loop bd=device) (test NVMe DSM Discard command) [passed]
    runtime  0.544s  ...  0.643s
nvme/019 (tr=loop bd=file) (test NVMe DSM Discard command)   [passed]
    runtime  0.529s  ...  0.619s
nvme/021 (tr=loop bd=device) (test NVMe list command)        [passed]
    runtime  0.538s  ...  0.645s
nvme/021 (tr=loop bd=file) (test NVMe list command)          [passed]
    runtime  0.523s  ...  0.618s
nvme/022 (tr=loop bd=device) (test NVMe reset command)       [passed]
    runtime  0.916s  ...  0.989s
nvme/022 (tr=loop bd=file) (test NVMe reset command)         [passed]
    runtime  0.917s  ...  0.998s
nvme/023 (tr=loop bd=device) (test NVMe smart-log command)   [passed]
    runtime  0.537s  ...  0.614s
nvme/023 (tr=loop bd=file) (test NVMe smart-log command)     [passed]
    runtime  0.525s  ...  0.640s
nvme/025 (tr=loop bd=device) (test NVMe effects-log)         [passed]
    runtime  0.547s  ...  0.639s
nvme/025 (tr=loop bd=file) (test NVMe effects-log)           [passed]
    runtime  0.531s  ...  0.629s
nvme/026 (tr=loop bd=device) (test NVMe ns-descs)            [passed]
    runtime  0.538s  ...  0.629s
nvme/026 (tr=loop bd=file) (test NVMe ns-descs)              [passed]
    runtime  0.532s  ...  0.646s
nvme/027 (tr=loop bd=device) (test NVMe ns-rescan command)   [passed]
    runtime  0.567s  ...  0.665s
nvme/027 (tr=loop bd=file) (test NVMe ns-rescan command)     [passed]
    runtime  0.557s  ...  0.639s
nvme/028 (tr=loop bd=device) (test NVMe list-subsys)         [passed]
    runtime  0.524s  ...  0.618s
nvme/028 (tr=loop bd=file) (test NVMe list-subsys)           [passed]
    runtime  0.532s  ...  0.619s
nvme/029 (tr=loop) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  0.723s  ...  0.963s
nvme/030 (tr=loop) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.391s  ...  0.396s
nvme/031 (tr=loop) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  5.120s  ...  5.812s
nvme/038 (tr=loop) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.019s  ...  0.034s
nvme/040 (tr=loop) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  6.977s  ...  6.994s
nvme/041 (tr=loop) (Create authenticated connections)        [passed]
    runtime  0.602s  ...  0.658s
nvme/042 (tr=loop) (Test dhchap key types for authenticated connections) [passed]
    runtime  3.454s  ...  3.831s
nvme/043 (tr=loop) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  4.373s  ...  4.797s
nvme/044 (tr=loop) (Test bi-directional authentication)      [passed]
    runtime  1.144s  ...  1.299s
nvme/045 (tr=loop) (Test re-authentication)                  [passed]
    runtime  1.266s  ...  1.591s
nvme/047 (tr=loop) (test different queue types for fabric transports) [not run]
    nvme_trtype=loop is not supported in this test
nvme/048 (tr=loop) (Test queue count changes on reconnect)   [not run]
    nvme_trtype=loop is not supported in this test
nvme/051 (tr=loop) (test nvmet concurrent ns enable/disable) [passed]
    runtime  1.319s  ...  1.397s
nvme/052 (tr=loop) (Test file-ns creation/deletion under one subsystem) [passed]
    runtime  5.657s  ...  6.286s
nvme/054 (tr=loop) (Test the NVMe reservation feature)       [passed]
    runtime  0.597s  ...  0.756s
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
    runtime  27.007s  ...  27.193s
nvme/058 (tr=loop) (test rapid namespace remapping)          [passed]
    runtime  3.878s  ...  4.693s
nvme/060 (tr=loop) (test nvme fabrics target reset)          [not run]
    nvme_trtype=loop is not supported in this test
nvme/061 (tr=loop) (test fabric target teardown and setup during I/O) [not run]
    nvme_trtype=loop is not supported in this test
nvme/062 (tr=loop) (Create TLS-encrypted connections)        [not run]
    nvme_trtype=loop is not supported in this test
nvme/063 (tr=loop) (Create authenticated TCP connections with secure concatenation) [not run]
    nvme_trtype=loop is not supported in this test
nvme/065 (tr=loop) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  1.956s  ...  2.316s
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
    runtime  10.185s  ...  10.235s
nvme/004 (tr=tcp) (test nvme and nvmet UUID NS descriptors)  [passed]
    runtime  0.264s  ...  0.370s
nvme/005 (tr=tcp) (reset local loopback target)              [passed]
    runtime  0.329s  ...  0.442s
nvme/006 (tr=tcp bd=device) (create an NVMeOF target)        [passed]
    runtime  0.076s  ...  0.097s
nvme/006 (tr=tcp bd=file) (create an NVMeOF target)          [passed]
    runtime  0.067s  ...  0.098s
nvme/008 (tr=tcp bd=device) (create an NVMeOF host)          [passed]
    runtime  0.253s  ...  0.364s
nvme/008 (tr=tcp bd=file) (create an NVMeOF host)            [passed]
    runtime  0.247s  ...  0.371s
nvme/010 (tr=tcp bd=device) (run data verification fio job)  [passed]
    runtime  38.475s  ...  76.177s
nvme/010 (tr=tcp bd=file) (run data verification fio job)    [passed]
    runtime  68.995s  ...  118.690s
nvme/012 (tr=tcp bd=device) (run mkfs and data verification fio) [passed]
    runtime  43.183s  ...  83.665s
nvme/012 (tr=tcp bd=file) (run mkfs and data verification fio) [passed]
    runtime  70.449s  ...  117.129s
nvme/014 (tr=tcp bd=device) (flush a command from host)      [passed]
    runtime  6.430s  ...  10.019s
nvme/014 (tr=tcp bd=file) (flush a command from host)        [passed]
    runtime  6.445s  ...  9.952s
nvme/016 (tr=tcp) (create/delete many NVMeOF block device-backed ns and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/017 (tr=tcp) (create/delete many file-ns and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/018 (tr=tcp) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.248s  ...  0.373s
nvme/019 (tr=tcp bd=device) (test NVMe DSM Discard command)  [passed]
    runtime  0.257s  ...  0.364s
nvme/019 (tr=tcp bd=file) (test NVMe DSM Discard command)    [passed]
    runtime  0.247s  ...  0.354s
nvme/021 (tr=tcp bd=device) (test NVMe list command)         [passed]
    runtime  0.250s  ...  0.374s
nvme/021 (tr=tcp bd=file) (test NVMe list command)           [passed]
    runtime  0.248s  ...  0.356s
nvme/022 (tr=tcp bd=device) (test NVMe reset command)        [passed]
    runtime  0.338s  ...  0.471s
nvme/022 (tr=tcp bd=file) (test NVMe reset command)          [passed]
    runtime  0.329s  ...  0.475s
nvme/023 (tr=tcp bd=device) (test NVMe smart-log command)    [passed]
    runtime  0.250s  ...  0.362s
nvme/023 (tr=tcp bd=file) (test NVMe smart-log command)      [passed]
    runtime  0.237s  ...  0.348s
nvme/025 (tr=tcp bd=device) (test NVMe effects-log)          [passed]
    runtime  0.261s  ...  0.374s
nvme/025 (tr=tcp bd=file) (test NVMe effects-log)            [passed]
    runtime  0.250s  ...  0.375s
nvme/026 (tr=tcp bd=device) (test NVMe ns-descs)             [passed]
    runtime  0.252s  ...  0.356s
nvme/026 (tr=tcp bd=file) (test NVMe ns-descs)               [passed]
    runtime  0.238s  ...  0.348s
nvme/027 (tr=tcp bd=device) (test NVMe ns-rescan command)    [passed]
    runtime  0.276s  ...  0.371s
nvme/027 (tr=tcp bd=file) (test NVMe ns-rescan command)      [passed]
    runtime  0.256s  ...  0.384s
nvme/028 (tr=tcp bd=device) (test NVMe list-subsys)          [passed]
    runtime  0.255s  ...  0.331s
nvme/028 (tr=tcp bd=file) (test NVMe list-subsys)            [passed]
    runtime  0.233s  ...  0.338s
nvme/029 (tr=tcp) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  0.456s  ...  0.745s
nvme/030 (tr=tcp) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.389s  ...  0.410s
nvme/031 (tr=tcp) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  2.221s  ...  3.007s
nvme/038 (tr=tcp) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.025s  ...  0.043s
nvme/040 (tr=tcp) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  6.380s  ...  6.446s
nvme/041 (tr=tcp) (Create authenticated connections)         [passed]
    runtime  0.307s  ...  0.408s
nvme/042 (tr=tcp) (Test dhchap key types for authenticated connections) [passed]
    runtime  1.330s  ...  1.791s
nvme/043 (tr=tcp) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  1.960s  ...  2.407s
nvme/044 (tr=tcp) (Test bi-directional authentication)       [passed]
    runtime  0.545s  ...  0.718s
nvme/045 (tr=tcp) (Test re-authentication)                   [passed]
    runtime  0.967s  ...  1.484s
nvme/047 (tr=tcp) (test different queue types for fabric transports) [passed]
    runtime  1.125s  ...  1.892s
nvme/048 (tr=tcp) (Test queue count changes on reconnect)    [passed]
    runtime  6.350s  ...  4.522s
nvme/051 (tr=tcp) (test nvmet concurrent ns enable/disable)  [passed]
    runtime  1.468s  ...  1.396s
nvme/052 (tr=tcp) (Test file-ns creation/deletion under one subsystem) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/054 (tr=tcp) (Test the NVMe reservation feature)        [passed]
    runtime  0.324s  ...  0.494s
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
    runtime  25.800s  ...  25.956s
nvme/058 (tr=tcp) (test rapid namespace remapping)           [passed]
    runtime  2.522s  ...  2.731s
nvme/060 (tr=tcp) (test nvme fabrics target reset)           [passed]
    runtime  19.013s  ...  19.427s
nvme/061 (tr=tcp) (test fabric target teardown and setup during I/O) [passed]
    runtime  9.203s  ...  8.568s
nvme/062 (tr=tcp) (Create TLS-encrypted connections)         [failed]
    runtime  1.092s  ...  5.228s
    --- tests/nvme/062.out	2026-01-28 12:04:48.888356244 -0800
    +++ /mnt/sda/blktests/results/nodev_tr_tcp/nvme/062.out.bad	2026-04-08 00:14:12.257544184 -0700
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
    runtime  1.296s  ...  1.951s
nvme/065 (tr=tcp) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  1.365s  ...  1.679s
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
    runtime  10.252s  ...  10.315s
nvme/004 (tr=rdma) (test nvme and nvmet UUID NS descriptors) [passed]
    runtime  0.446s  ...  0.689s
nvme/005 (tr=rdma) (reset local loopback target)             [passed]
    runtime  0.674s  ...  0.980s
nvme/006 (tr=rdma bd=device) (create an NVMeOF target)       [passed]
    runtime  0.100s  ...  0.137s
nvme/006 (tr=rdma bd=file) (create an NVMeOF target)         [passed]
    runtime  0.094s  ...  0.139s
nvme/008 (tr=rdma bd=device) (create an NVMeOF host)         [passed]
    runtime  0.439s  ...  0.700s
nvme/008 (tr=rdma bd=file) (create an NVMeOF host)           [passed]
    runtime  0.432s  ...  0.653s
nvme/010 (tr=rdma bd=device) (run data verification fio job) [passed]
    runtime  17.755s  ...  34.757s
nvme/010 (tr=rdma bd=file) (run data verification fio job)   [passed]
    runtime  36.496s  ...  66.017s
nvme/012 (tr=rdma bd=device) (run mkfs and data verification fio) [passed]
    runtime  25.971s  ...  41.224s
nvme/012 (tr=rdma bd=file) (run mkfs and data verification fio) [passed]
    runtime  37.642s  ...  74.188s
nvme/014 (tr=rdma bd=device) (flush a command from host)     [passed]
    runtime  6.299s  ...  9.645s
nvme/014 (tr=rdma bd=file) (flush a command from host)       [passed]
    runtime  6.283s  ...  8.407s
nvme/016 (tr=rdma) (create/delete many NVMeOF block device-backed ns and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/017 (tr=rdma) (create/delete many file-ns and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/018 (tr=rdma) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.415s  ...  0.681s
nvme/019 (tr=rdma bd=device) (test NVMe DSM Discard command) [passed]
    runtime  0.433s  ...  0.676s
nvme/019 (tr=rdma bd=file) (test NVMe DSM Discard command)   [passed]
    runtime  0.419s  ...  0.656s
nvme/021 (tr=rdma bd=device) (test NVMe list command)        [passed]
    runtime  0.422s  ...  0.689s
nvme/021 (tr=rdma bd=file) (test NVMe list command)          [passed]
    runtime  0.424s  ...  0.673s
nvme/022 (tr=rdma bd=device) (test NVMe reset command)       [passed]
    runtime  0.660s  ...  1.004s
nvme/022 (tr=rdma bd=file) (test NVMe reset command)         [passed]
    runtime  0.664s  ...  0.996s
nvme/023 (tr=rdma bd=device) (test NVMe smart-log command)   [passed]
    runtime  0.414s  ...  0.682s
nvme/023 (tr=rdma bd=file) (test NVMe smart-log command)     [passed]
    runtime  0.438s  ...  0.660s
nvme/025 (tr=rdma bd=device) (test NVMe effects-log)         [passed]
    runtime  0.432s  ...  0.678s
nvme/025 (tr=rdma bd=file) (test NVMe effects-log)           [passed]
    runtime  0.423s  ...  0.694s
nvme/026 (tr=rdma bd=device) (test NVMe ns-descs)            [passed]
    runtime  0.442s  ...  0.680s
nvme/026 (tr=rdma bd=file) (test NVMe ns-descs)              [passed]
    runtime  0.429s  ...  0.665s
nvme/027 (tr=rdma bd=device) (test NVMe ns-rescan command)   [passed]
    runtime  0.439s  ...  0.703s
nvme/027 (tr=rdma bd=file) (test NVMe ns-rescan command)     [passed]
    runtime  0.440s  ...  0.711s
nvme/028 (tr=rdma bd=device) (test NVMe list-subsys)         [passed]
    runtime  0.420s  ...  0.664s
nvme/028 (tr=rdma bd=file) (test NVMe list-subsys)           [passed]
    runtime  0.419s  ...  0.659s
nvme/029 (tr=rdma) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  0.655s  ...  1.036s
nvme/030 (tr=rdma) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.463s  ...  0.509s
nvme/031 (tr=rdma) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  3.843s  ...  5.647s
nvme/038 (tr=rdma) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.047s  ...  0.083s
nvme/040 (tr=rdma) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  6.615s  ...  7.016s
nvme/041 (tr=rdma) (Create authenticated connections)        [passed]
    runtime  0.493s  ...  0.731s
nvme/042 (tr=rdma) (Test dhchap key types for authenticated connections) [passed]
    runtime  2.513s  ...  3.721s
nvme/043 (tr=rdma) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  3.328s  ...  4.570s
nvme/044 (tr=rdma) (Test bi-directional authentication)      [passed]
    runtime  0.895s  ...  1.316s
nvme/045 (tr=rdma) (Test re-authentication)                  [passed]
    runtime  1.362s  ...  1.748s
nvme/047 (tr=rdma) (test different queue types for fabric transports) [passed]
    runtime  1.668s  ...  2.669s
nvme/048 (tr=rdma) (Test queue count changes on reconnect)   [passed]
    runtime  6.492s  ...  6.834s
nvme/051 (tr=rdma) (test nvmet concurrent ns enable/disable) [passed]
    runtime  1.348s  ...  1.413s
nvme/052 (tr=rdma) (Test file-ns creation/deletion under one subsystem) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/054 (tr=rdma) (Test the NVMe reservation feature)       [passed]
    runtime  0.494s  ...  0.795s
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
    runtime  26.364s  ...  26.931s
nvme/058 (tr=rdma) (test rapid namespace remapping)          [passed]
    runtime  3.229s  ...  4.240s
nvme/060 (tr=rdma) (test nvme fabrics target reset)          [passed]
    runtime  20.898s  ...  20.733s
nvme/061 (tr=rdma) (test fabric target teardown and setup during I/O) [passed]
    runtime  14.810s  ...  15.460s
nvme/062 (tr=rdma) (Create TLS-encrypted connections)        [not run]
    nvme_trtype=rdma is not supported in this test
nvme/063 (tr=rdma) (Create authenticated TCP connections with secure concatenation) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/065 (tr=rdma) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  1.764s  ...  2.293s
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
blktests (master) # 




-- 
2.39.5

