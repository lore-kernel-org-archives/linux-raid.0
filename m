Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DB63A875B;
	Wed, 13 May 2026 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778698373; cv=fail; b=OkKMzb9EmnNNeZgoFLs88NcwPvpfCv9cA6VMtXs9fhHXZgBNhugdpWtOC8lcxf6Xd5kqGB+xUt67oZItjofeRFH946Ll84eae2CznrBBxL5S3QaJgX/0NypNrCYW130b/gnjAzwp6dAR2JDFdlo1KL4Dt7OxIKU2STbVlM6HdFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778698373; c=relaxed/simple;
	bh=d2PdGrSywJC9A7P/Swk3eaohHwL7lYAf3LG7C5mfJrk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UDbtvi9sGlTi5VquqgmLp11DwGsHxQR7c8BdHzBdxvap3RjPqRY6rOd2isjdvWbIl27NpGy/aPzltrB036042i2A4gERDrZe8jobNNikLjDwNFxQw6nMUvxsRXbtWZIQ7w3Wj9j94sqb5WY/BxP6zBAv7O6AJ9k3+l+v+oVd9f0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Au1Y4s+D; arc=fail smtp.client-ip=40.93.194.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Au1Y4s+D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BNXxXF3CqMyAPEZSxHnDVtcwBmI2FC8Q1ZGuXtLIo5fXPvFmjtRle+wxZNR8TMF2xhRXB7LOf64sVn73bkx0+Kng5T8qXpyG5bsmEu9bSngfsdLKwORhvnJd9F8PgsAG62XjRg1IrWEEj8vov44uLsPL6W8cDcmxyCqIqXn9tVWe/nzCMnQbaMAYnN4aDnRmZMLwk2yusqb3tR5KZMVwtejAWONXEFMd4QzxPpxkzzudCdRG7rNepzGOgJRCtwHVkMZsjxs6PWwd6kPeuWQ74UOml3JyKLhzNNpqvUpGvGXshpsrBXUba9ERL1mjfuSFbNaK8qUR66QHntxBJqMNlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6n+NbE1/c+xiZhlvqvKorlEuC6tAR5/GMIayC6Le9ho=;
 b=dtB190Jd0KgP4sFnNjcyP4hk/5udOLqeQyZuKu/7rtry6KWUXQPMBAopnDc36YvsJPZ3Au+oS008zPBKoW5ndtnux0Ee3OBY7YqhyV7rOeY2VVyB8Ogrq583LrGRrHa2bnf9mnMg4J4wGhSITLPyGMvbTChRDN1Bra20UesIfzQHIg4Wa0q/nTbyRVU0KC/l9OoWQ2oTodUIuOPsTlzQprcSNYokxOmPRIhGrpLI8fcUf+AFSlmgqgZc6VYay6Wy65l3cp0Vpd5Fwm7V8rHKNkBQeO87OWauzgZ6o6AhI4PEvTy9ncFl6eroZfxk/xjWhBZB3t6S0nMNDY9Qoufnww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6n+NbE1/c+xiZhlvqvKorlEuC6tAR5/GMIayC6Le9ho=;
 b=Au1Y4s+D2d8f1v/dbDRxkr9kRp0a6ehT+OVKej/wMF6qsOw92gAIiDlFqL4fdN23d19rWl9Ez/Dj5k6mXQCP9L1d838hLIKoP5E1cU4esJn5pyAemJ2T6Bnp0gTvcIwmAwz4a+s8lOeQtS2Eoh736zo9z2ZrchJ1E8kP1BU9zOTy0UGiT2XY1pNP7laV0OzI8g7TZ5gR2cfVm35VPZ9wMyt176EQmYYU1C61Ufu65BgGnFPX818dF5uKi07I6Su27wH3qR+K28pN2x+TV+z1W+bvvEvLTU0bi9TRB8y9ljtUYyrAHQvt2Y4k+NLenGAK8Fx3KBO2dz8rv3chnLNc0g==
Received: from CY5PR16CA0002.namprd16.prod.outlook.com (2603:10b6:930:10::23)
 by CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 18:52:39 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:10:cafe::a7) by CY5PR16CA0002.outlook.office365.com
 (2603:10b6:930:10::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.18 via Frontend Transport; Wed, 13
 May 2026 18:52:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.13 via Frontend Transport; Wed, 13 May 2026 18:52:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 13 May
 2026 11:52:09 -0700
Received: from dev.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 13 May
 2026 11:52:08 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
	<kbusch@kernel.org>, <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>
CC: <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-nvme@lists.infradead.org>, <kmodukuri@nvidia.com>, Chaitanya Kulkarni
	<kch@nvidia.com>
Subject: [PATCH V4 0/3] md/nvme: Enable PCI P2PDMA support for RAID0 and NVMe Multipath 
Date: Wed, 13 May 2026 11:51:50 -0700
Message-ID: <20260513185153.95552-1-kch@nvidia.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: a8fd633e-a4fa-4576-56d8-08deb120ce6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|7416014|82310400026|1800799024|18002099003|11063799003|56012099003;
X-Microsoft-Antispam-Message-Info:
	x61uVqUNGL8qanUAphe8v5VNVy8ninCkCb5fXSxSYvJSFH36diSXO/Lm0MgvlDrvQgWK3Dm05jOIDFvKXvnIopzSpq6Wq5LqYcnMFz4DRArTqwSz2yz0WziQzupcRFN3dC1CTsdwyP9tSL+t26J2J+vDTE+83++bc4vybGGvS72l/XF4wtwl0WbdXYq8yEFFn6QxwsETbRY3kWsK5jeQWrBBbtGMHMkyIPRGIgDXACCfcHzG1/6jli6GzKzSOr4p53BpW/L3BLDxOoXWA/EfB705OZwEAMgPosIMdQhG1FX0jiBsTZOy/cWbtXxG6egbGXmfL6uu1YdpHhuYvnX0jq8Bt1WOZ5ebiYwuvDzQfB2YuzTNcdUVjv5Yj+I63OxhNCCnmOEA6Zt90jIPGESXpO6+XBL9hY408HDVBVpD1JF+Wn0kv/8y4FGYquITlVsMkNw/OkRUraNq4tWdTg5JfRyzFTPNhPAMPLT7PTQ1uAU8mk1v1BQjWOFisqrxi3djWm876wFShWTzkUIRSYtixfeWbq/ypy2adJ53GPGuaQPygY17NJLgsXHo2rSjVZFsRO/xxOkyU2XIHYPGYKFSJ8uZLPkh1PpX1m+D9AshWtk8223ccP2fIGAKVLq6lm5sAbJ9B7lsdbcfjkeUzw5b/3p13bWx3mfac24IkHTiC+ASz06/WzLWa1fEjE0/rXa+AaPKtsEdLTynw2seMo6VqrHn3wjpuvn/O9uqrAGtplI=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(7416014)(82310400026)(1800799024)(18002099003)(11063799003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	td7JQUxjhrz0awqwOlXzI+aB5QwxreQLxuEr/lTjX03q0fBzpngHOQhob8OhZ1tKr131Pb4+2vUXuYzOHvAuZyIp2iddUHHTWbw9LMHfUGMaY89UyDqy/+RutlzFgMxDiGV0x5I/ZKHx0uPe40So5FieQMOmdt10rez0Ti5+SY9/CsTeCGqf/FPyq5dR7mIPeIkKOJRkJFjI5OJn/1qLgvDERje/uNdASyose5nJ9ZtH6pMgT5RuE53gXlSMm1FpL6d2WkTWfPU7eDXoydCRMBX0rOpX+wz5F9BjE/AtVWVWTzEfsCZ0/6cItB7JWT4Gyc/MNLvKgF8J0OiIROstHTovx+kKB4QXgGxEhXlVq15+2uhnAUnw+FkjcJlHvgBVAalOf1OWEhvLTs7X1DHkd+fRpIt9iKfzbxqiUbEDPfmGSRtpbSWJ4aqXB6RTUMxm
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 18:52:39.2452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8fd633e-a4fa-4576-56d8-08deb120ce6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345

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
propagated through both the MD RAID layer (patch 2/3) and NVMe multipath
layer (patch 3/3). Direct peer-to-peer transfers complete successfully with
full data integrity verification, confirming that:

1. RAID devices properly inherit P2PDMA capability from member devices
2. NVMe multipath devices correctly expose P2PDMA support
3. P2P memory buffers can be used for transfers involving both types
4. Data integrity is maintained across all transfer combinations

I've added blktest log as well at the end.

Repo:-

git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git

Branch HEAD:-

commit 5d75bcab6af0916283c2675d831d39fe4d360b11 (origin/for-next)
Merge: feab7e5ae6ee 87d0740b7c4c
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed May 13 07:55:56 2026 -0600

    Merge branch 'block-7.1' into for-next
    
    * block-7.1:
      selftests: ublk: cap nthreads to kernel's actual nr_hw_queues

-ck

Changes from V3:-

1. Rebase on latest code and add review and tested by tags.

Changes from V2:-

1. Unconditionally set the BLK_FEAT_PCI_P2PDMA for md and nvme multipath.
   (Christoph)
2. Add a prep patch to diable BLK_FEAT_PCI_P2PDMA in the blk_stack_limit().
   (christoph)

Changes from V1:-

- Update patch 1 to explicitly support MD RAID 0/1/10.
- Fix signoff chain order for patch 2.
- Clear BLK_FEAT_PCI_P2PDMA in nvme_mpath_add_disk() when a newly
  added path does not support it, to handle multipath across different
  transports.
- Add nvme multipath test log for mixed transport TCP and PCIe.

Chaitanya Kulkarni (1):
  block: clear BLK_FEAT_PCI_P2PDMA in blk_stack_limits() for
    non-supporting devices

Kiran Kumar Modukuri (2):
  md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device
  nvme-multipath: enable PCI P2PDMA for multipath devices

 block/blk-settings.c          | 2 ++
 drivers/md/raid0.c            | 1 +
 drivers/md/raid1.c            | 1 +
 drivers/md/raid10.c           | 1 +
 drivers/nvme/host/multipath.c | 2 +-
 5 files changed, 6 insertions(+), 1 deletion(-)

++ for t in loop tcp
++ echo '################NVMET_TRTYPES=loop############'
################NVMET_TRTYPES=loop############
++ NVMET_TRTYPES=loop
++ ./check nvme
nvme/002 (tr=loop) (create many subsystems and test discovery) [passed]
    runtime  33.808s  ...  34.634s
nvme/003 (tr=loop) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.222s  ...  10.239s
nvme/004 (tr=loop) (test nvme and nvmet UUID NS descriptors) [passed]
    runtime  0.683s  ...  0.651s
nvme/005 (tr=loop) (reset local loopback target)             [passed]
    runtime  0.974s  ...  1.001s
nvme/006 (tr=loop bd=device) (create an NVMeOF target)       [passed]
    runtime  0.088s  ...  0.094s
nvme/006 (tr=loop bd=file) (create an NVMeOF target)         [passed]
    runtime  0.082s  ...  0.087s
nvme/008 (tr=loop bd=device) (create an NVMeOF host)         [passed]
    runtime  0.652s  ...  0.658s
nvme/008 (tr=loop bd=file) (create an NVMeOF host)           [passed]
    runtime  0.634s  ...  0.658s
nvme/010 (tr=loop bd=device) (run data verification fio job) [passed]
    runtime  9.426s  ...  9.469s
nvme/010 (tr=loop bd=file) (run data verification fio job)   [passed]
    runtime  41.443s  ...  43.716s
nvme/012 (tr=loop bd=device) (run mkfs and data verification fio) [passed]
    runtime  47.971s  ...  51.404s
nvme/012 (tr=loop bd=file) (run mkfs and data verification fio) [passed]
    runtime  38.937s  ...  38.971s
nvme/014 (tr=loop bd=device) (flush a command from host)     [passed]
    runtime  9.257s  ...  9.208s
nvme/014 (tr=loop bd=file) (flush a command from host)       [passed]
    runtime  8.874s  ...  8.863s
nvme/016 (tr=loop) (create/delete many NVMeOF block device-backed ns and test discovery) [passed]
    runtime  20.101s  ...  19.387s
nvme/017 (tr=loop) (create/delete many file-ns and test discovery) [passed]
    runtime  22.534s  ...  21.919s
nvme/018 (tr=loop) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.629s  ...  0.653s
nvme/019 (tr=loop bd=device) (test NVMe DSM Discard command) [passed]
    runtime  0.638s  ...  0.657s
nvme/019 (tr=loop bd=file) (test NVMe DSM Discard command)   [passed]
    runtime  0.624s  ...  0.611s
nvme/021 (tr=loop bd=device) (test NVMe list command)        [passed]
    runtime  0.633s  ...  0.639s
nvme/021 (tr=loop bd=file) (test NVMe list command)          [passed]
    runtime  0.647s  ...  0.632s
nvme/022 (tr=loop bd=device) (test NVMe reset command)       [passed]
    runtime  1.008s  ...  1.011s
nvme/022 (tr=loop bd=file) (test NVMe reset command)         [passed]
    runtime  1.010s  ...  1.006s
nvme/023 (tr=loop bd=device) (test NVMe smart-log command)   [passed]
    runtime  0.628s  ...  0.623s
nvme/023 (tr=loop bd=file) (test NVMe smart-log command)     [passed]
    runtime  0.624s  ...  0.627s
nvme/025 (tr=loop bd=device) (test NVMe effects-log)         [passed]
    runtime  0.647s  ...  0.647s
nvme/025 (tr=loop bd=file) (test NVMe effects-log)           [passed]
    runtime  0.638s  ...  0.636s
nvme/026 (tr=loop bd=device) (test NVMe ns-descs)            [passed]
    runtime  0.628s  ...  0.647s
nvme/026 (tr=loop bd=file) (test NVMe ns-descs)              [passed]
    runtime  0.623s  ...  0.637s
nvme/027 (tr=loop bd=device) (test NVMe ns-rescan command)   [passed]
    runtime  0.657s  ...  0.658s
nvme/027 (tr=loop bd=file) (test NVMe ns-rescan command)     [passed]
    runtime  0.650s  ...  0.641s
nvme/028 (tr=loop bd=device) (test NVMe list-subsys)         [passed]
    runtime  0.618s  ...  0.642s
nvme/028 (tr=loop bd=file) (test NVMe list-subsys)           [passed]
    runtime  0.631s  ...  0.627s
nvme/029 (tr=loop) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  0.954s  ...  0.952s
nvme/030 (tr=loop) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.432s  ...  0.437s
nvme/031 (tr=loop) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  5.813s  ...  5.999s
nvme/038 (tr=loop) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.035s  ...  0.034s
nvme/040 (tr=loop) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  7.029s  ...  7.022s
nvme/041 (tr=loop) (Create authenticated connections)        [passed]
    runtime  0.654s  ...  0.684s
nvme/042 (tr=loop) (Test dhchap key types for authenticated connections) [passed]
    runtime  3.866s  ...  3.856s
nvme/043 (tr=loop) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  4.834s  ...  4.886s
nvme/044 (tr=loop) (Test bi-directional authentication)      [passed]
    runtime  1.237s  ...  1.328s
nvme/045 (tr=loop) (Test re-authentication)                  [passed]
    runtime  1.570s  ...  1.609s
nvme/047 (tr=loop) (test different queue types for fabric transports) [not run]
    nvme_trtype=loop is not supported in this test
nvme/048 (tr=loop) (Test queue count changes on reconnect)   [not run]
    nvme_trtype=loop is not supported in this test
nvme/051 (tr=loop) (test nvmet concurrent ns enable/disable) [passed]
    runtime  1.362s  ...  1.407s
nvme/052 (tr=loop) (Test file-ns creation/deletion under one subsystem) [passed]
    runtime  6.258s  ...  6.282s
nvme/054 (tr=loop) (Test the NVMe reservation feature)       [passed]
    runtime  0.754s  ...  0.769s
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
    runtime  27.227s  ...  27.146s
nvme/058 (tr=loop) (test rapid namespace remapping)          [passed]
    runtime  4.646s  ...  4.746s
nvme/060 (tr=loop) (test nvme fabrics target reset)          [not run]
    nvme_trtype=loop is not supported in this test
nvme/061 (tr=loop) (test fabric target teardown and setup during I/O) [not run]
    nvme_trtype=loop is not supported in this test
nvme/062 (tr=loop) (Create TLS-encrypted connections)        [not run]
    nvme_trtype=loop is not supported in this test
nvme/063 (tr=loop) (Create authenticated TCP connections with secure concatenation) [not run]
    nvme_trtype=loop is not supported in this test
nvme/065 (tr=loop) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  2.310s  ...  2.270s
++ for t in loop tcp
++ echo '################NVMET_TRTYPES=tcp############'
################NVMET_TRTYPES=tcp############
++ NVMET_TRTYPES=tcp
++ ./check nvme
nvme/002 (tr=tcp) (create many subsystems and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/003 (tr=tcp) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.279s  ...  10.271s
nvme/004 (tr=tcp) (test nvme and nvmet UUID NS descriptors)  [passed]
    runtime  0.350s  ...  0.404s
nvme/005 (tr=tcp) (reset local loopback target)              [passed]
    runtime  0.434s  ...  0.466s
nvme/006 (tr=tcp bd=device) (create an NVMeOF target)        [passed]
    runtime  0.097s  ...  0.098s
nvme/006 (tr=tcp bd=file) (create an NVMeOF target)          [passed]
    runtime  0.089s  ...  0.094s
nvme/008 (tr=tcp bd=device) (create an NVMeOF host)          [passed]
    runtime  0.348s  ...  0.361s
nvme/008 (tr=tcp bd=file) (create an NVMeOF host)            [passed]
    runtime  0.370s  ...  0.395s
nvme/010 (tr=tcp bd=device) (run data verification fio job)  [passed]
    runtime  76.430s  ...  78.689s
nvme/010 (tr=tcp bd=file) (run data verification fio job)    [passed]
    runtime  120.407s  ...  116.963s
nvme/012 (tr=tcp bd=device) (run mkfs and data verification fio) [passed]
    runtime  85.918s  ...  84.974s
nvme/012 (tr=tcp bd=file) (run mkfs and data verification fio) [passed]
    runtime  120.326s  ...  120.123s
nvme/014 (tr=tcp bd=device) (flush a command from host)      [passed]
    runtime  9.603s  ...  9.522s
nvme/014 (tr=tcp bd=file) (flush a command from host)        [passed]
    runtime  9.319s  ...  9.297s
nvme/016 (tr=tcp) (create/delete many NVMeOF block device-backed ns and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/017 (tr=tcp) (create/delete many file-ns and test discovery) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/018 (tr=tcp) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.334s  ...  0.384s
nvme/019 (tr=tcp bd=device) (test NVMe DSM Discard command)  [passed]
    runtime  0.342s  ...  0.377s
nvme/019 (tr=tcp bd=file) (test NVMe DSM Discard command)    [passed]
    runtime  0.334s  ...  0.368s
nvme/021 (tr=tcp bd=device) (test NVMe list command)         [passed]
    runtime  0.357s  ...  0.400s
nvme/021 (tr=tcp bd=file) (test NVMe list command)           [passed]
    runtime  0.356s  ...  0.397s
nvme/022 (tr=tcp bd=device) (test NVMe reset command)        [passed]
    runtime  0.469s  ...  0.504s
nvme/022 (tr=tcp bd=file) (test NVMe reset command)          [passed]
    runtime  0.441s  ...  0.512s
nvme/023 (tr=tcp bd=device) (test NVMe smart-log command)    [passed]
    runtime  0.348s  ...  0.387s
nvme/023 (tr=tcp bd=file) (test NVMe smart-log command)      [passed]
    runtime  0.330s  ...  0.372s
nvme/025 (tr=tcp bd=device) (test NVMe effects-log)          [passed]
    runtime  0.351s  ...  0.384s
nvme/025 (tr=tcp bd=file) (test NVMe effects-log)            [passed]
    runtime  0.362s  ...  0.377s
nvme/026 (tr=tcp bd=device) (test NVMe ns-descs)             [passed]
    runtime  0.343s  ...  0.359s
nvme/026 (tr=tcp bd=file) (test NVMe ns-descs)               [passed]
    runtime  0.317s  ...  0.361s
nvme/027 (tr=tcp bd=device) (test NVMe ns-rescan command)    [passed]
    runtime  0.375s  ...  0.412s
nvme/027 (tr=tcp bd=file) (test NVMe ns-rescan command)      [passed]
    runtime  0.388s  ...  0.392s
nvme/028 (tr=tcp bd=device) (test NVMe list-subsys)          [passed]
    runtime  0.355s  ...  0.362s
nvme/028 (tr=tcp bd=file) (test NVMe list-subsys)            [passed]
    runtime  0.342s  ...  0.371s
nvme/029 (tr=tcp) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  0.698s  ...  0.742s
nvme/030 (tr=tcp) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.402s  ...  0.416s
nvme/031 (tr=tcp) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  3.068s  ...  3.161s
nvme/038 (tr=tcp) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.041s  ...  0.042s
nvme/040 (tr=tcp) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  6.442s  ...  6.478s
nvme/041 (tr=tcp) (Create authenticated connections)         [passed]
    runtime  0.408s  ...  0.407s
nvme/042 (tr=tcp) (Test dhchap key types for authenticated connections) [passed]
    runtime  1.803s  ...  1.879s
nvme/043 (tr=tcp) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  2.484s  ...  2.515s
nvme/044 (tr=tcp) (Test bi-directional authentication)       [passed]
    runtime  0.732s  ...  0.732s
nvme/045 (tr=tcp) (Test re-authentication)                   [passed]
    runtime  1.322s  ...  1.310s
nvme/047 (tr=tcp) (test different queue types for fabric transports) [passed]
    runtime  1.863s  ...  1.879s
nvme/048 (tr=tcp) (Test queue count changes on reconnect)    [passed]
    runtime  6.525s  ...  5.523s
nvme/051 (tr=tcp) (test nvmet concurrent ns enable/disable)  [passed]
    runtime  1.336s  ...  1.361s
nvme/052 (tr=tcp) (Test file-ns creation/deletion under one subsystem) [not run]
    nvme_trtype=tcp is not supported in this test
nvme/054 (tr=tcp) (Test the NVMe reservation feature)        [passed]
    runtime  0.493s  ...  0.491s
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
    runtime  25.906s  ...  25.963s
nvme/058 (tr=tcp) (test rapid namespace remapping)           [passed]
    runtime  3.145s  ...  3.126s
nvme/060 (tr=tcp) (test nvme fabrics target reset)           [passed]
    runtime  20.395s  ...  19.399s
nvme/061 (tr=tcp) (test fabric target teardown and setup during I/O) [passed]
    runtime  8.549s  ...  8.617s
nvme/062 (tr=tcp) (Create TLS-encrypted connections)         [failed]
    runtime  1.608s  ...  5.200s
    --- tests/nvme/062.out	2026-01-28 12:04:48.888356244 -0800
    +++ /mnt/sda/blktests/results/nodev_tr_tcp/nvme/062.out.bad	2026-05-13 11:33:33.891029529 -0700
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
    runtime  1.838s  ...  2.011s
nvme/065 (tr=tcp) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  1.749s  ...  1.758s
++ ./manage-rdma-nvme.sh --cleanup
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
  nvmet                    258048

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
++ NVMET_TRTYPES=rdma
++ ./check nvme
nvme/002 (tr=rdma) (create many subsystems and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/003 (tr=rdma) (test if we're sending keep-alives to a discovery controller) [passed]
    runtime  10.315s  ...  10.293s
nvme/004 (tr=rdma) (test nvme and nvmet UUID NS descriptors) [passed]
    runtime  0.695s  ...  0.750s
nvme/005 (tr=rdma) (reset local loopback target)             [passed]
    runtime  0.974s  ...  1.046s
nvme/006 (tr=rdma bd=device) (create an NVMeOF target)       [passed]
    runtime  0.136s  ...  0.149s
nvme/006 (tr=rdma bd=file) (create an NVMeOF target)         [passed]
    runtime  0.127s  ...  0.140s
nvme/008 (tr=rdma bd=device) (create an NVMeOF host)         [passed]
    runtime  0.684s  ...  0.685s
nvme/008 (tr=rdma bd=file) (create an NVMeOF host)           [passed]
    runtime  0.672s  ...  0.729s
nvme/010 (tr=rdma bd=device) (run data verification fio job) [passed]
    runtime  35.255s  ...  35.280s
nvme/010 (tr=rdma bd=file) (run data verification fio job)   [passed]
    runtime  68.570s  ...  66.260s
nvme/012 (tr=rdma bd=device) (run mkfs and data verification fio) [passed]
    runtime  47.482s  ...  42.242s
nvme/012 (tr=rdma bd=file) (run mkfs and data verification fio) [passed]
    runtime  61.407s  ...  62.511s
nvme/014 (tr=rdma bd=device) (flush a command from host)     [passed]
    runtime  9.855s  ...  9.321s
nvme/014 (tr=rdma bd=file) (flush a command from host)       [passed]
    runtime  9.919s  ...  9.175s
nvme/016 (tr=rdma) (create/delete many NVMeOF block device-backed ns and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/017 (tr=rdma) (create/delete many file-ns and test discovery) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/018 (tr=rdma) (unit test NVMe-oF out of range access on a file backend) [passed]
    runtime  0.654s  ...  0.737s
nvme/019 (tr=rdma bd=device) (test NVMe DSM Discard command) [passed]
    runtime  0.664s  ...  0.738s
nvme/019 (tr=rdma bd=file) (test NVMe DSM Discard command)   [passed]
    runtime  0.649s  ...  0.730s
nvme/021 (tr=rdma bd=device) (test NVMe list command)        [passed]
    runtime  0.676s  ...  0.729s
nvme/021 (tr=rdma bd=file) (test NVMe list command)          [passed]
    runtime  0.673s  ...  0.720s
nvme/022 (tr=rdma bd=device) (test NVMe reset command)       [passed]
    runtime  1.021s  ...  1.066s
nvme/022 (tr=rdma bd=file) (test NVMe reset command)         [passed]
    runtime  1.015s  ...  1.055s
nvme/023 (tr=rdma bd=device) (test NVMe smart-log command)   [passed]
    runtime  0.633s  ...  0.718s
nvme/023 (tr=rdma bd=file) (test NVMe smart-log command)     [passed]
    runtime  0.656s  ...  0.673s
nvme/025 (tr=rdma bd=device) (test NVMe effects-log)         [passed]
    runtime  0.706s  ...  0.715s
nvme/025 (tr=rdma bd=file) (test NVMe effects-log)           [passed]
    runtime  0.688s  ...  0.733s
nvme/026 (tr=rdma bd=device) (test NVMe ns-descs)            [passed]
    runtime  0.686s  ...  0.690s
nvme/026 (tr=rdma bd=file) (test NVMe ns-descs)              [passed]
    runtime  0.669s  ...  0.684s
nvme/027 (tr=rdma bd=device) (test NVMe ns-rescan command)   [passed]
    runtime  0.703s  ...  0.731s
nvme/027 (tr=rdma bd=file) (test NVMe ns-rescan command)     [passed]
    runtime  0.707s  ...  0.772s
nvme/028 (tr=rdma bd=device) (test NVMe list-subsys)         [passed]
    runtime  0.680s  ...  0.712s
nvme/028 (tr=rdma bd=file) (test NVMe list-subsys)           [passed]
    runtime  0.670s  ...  0.709s
nvme/029 (tr=rdma) (test userspace IO via nvme-cli read/write interface) [passed]
    runtime  1.077s  ...  1.087s
nvme/030 (tr=rdma) (ensure the discovery generation counter is updated appropriately) [passed]
    runtime  0.511s  ...  0.560s
nvme/031 (tr=rdma) (test deletion of NVMeOF controllers immediately after setup) [passed]
    runtime  5.869s  ...  6.106s
nvme/038 (tr=rdma) (test deletion of NVMeOF subsystem without enabling) [passed]
    runtime  0.084s  ...  0.085s
nvme/040 (tr=rdma) (test nvme fabrics controller reset/disconnect operation during I/O) [passed]
    runtime  7.024s  ...  6.994s
nvme/041 (tr=rdma) (Create authenticated connections)        [passed]
    runtime  0.718s  ...  0.769s
nvme/042 (tr=rdma) (Test dhchap key types for authenticated connections) [passed]
    runtime  3.759s  ...  3.968s
nvme/043 (tr=rdma) (Test hash and DH group variations for authenticated connections) [passed]
    runtime  4.487s  ...  4.880s
nvme/044 (tr=rdma) (Test bi-directional authentication)      [passed]
    runtime  1.279s  ...  1.393s
nvme/045 (tr=rdma) (Test re-authentication)                  [passed]
    runtime  1.837s  ...  1.892s
nvme/047 (tr=rdma) (test different queue types for fabric transports) [passed]
    runtime  2.642s  ...  2.700s
nvme/048 (tr=rdma) (Test queue count changes on reconnect)   [passed]
    runtime  5.810s  ...  6.860s
nvme/051 (tr=rdma) (test nvmet concurrent ns enable/disable) [passed]
    runtime  1.479s  ...  1.408s
nvme/052 (tr=rdma) (Test file-ns creation/deletion under one subsystem) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/054 (tr=rdma) (Test the NVMe reservation feature)       [passed]
    runtime  0.799s  ...  0.854s
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
    runtime  26.984s  ...  27.074s
nvme/058 (tr=rdma) (test rapid namespace remapping)          [passed]
    runtime  4.444s  ...  4.553s
nvme/060 (tr=rdma) (test nvme fabrics target reset)          [passed]
    runtime  20.696s  ...  22.308s
nvme/061 (tr=rdma) (test fabric target teardown and setup during I/O) [passed]
    runtime  15.375s  ...  15.348s
nvme/062 (tr=rdma) (Create TLS-encrypted connections)        [not run]
    nvme_trtype=rdma is not supported in this test
nvme/063 (tr=rdma) (Create authenticated TCP connections with secure concatenation) [not run]
    nvme_trtype=rdma is not supported in this test
nvme/065 (tr=rdma) (test unmap write zeroes sysfs interface with nvmet devices) [passed]
    runtime  2.369s  ...  2.466s
++ ./manage-rdma-nvme.sh --cleanup
====== RDMA NVMe Cleanup ======

[INFO] Disconnecting NVMe RDMA controllers...
[INFO] No NVMe RDMA controllers to disconnect
[INFO] Removing RDMA links...
[INFO] No RDMA links to remove
[INFO] Unloading NVMe RDMA modules...
[INFO] Unloading module: nvme_rdma
[INFO] Module nvme_rdma unloaded
[INFO] Unloading module: nvmet_rdma
[INFO] Module nvmet_rdma unloaded
[INFO] Unloading module: nvmet


-- 
2.39.5

