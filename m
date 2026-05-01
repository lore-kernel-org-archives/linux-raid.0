Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E3B1FE451;
	Fri,  1 May 2026 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777679102; cv=none; b=MIF5HLXlBQ/R8junVVB8sZMBtjRFaNY0Oj9K9PlgWoRODyM6SLkY25uOJ/eC8XHRicxHtUvP+YsiCXMMkjQ6XU/SCSwCdCIa8u8MJaC85U15y8g1/XFtXz3LYePqKL1ZPcYt4zMbBw1M/5fV+jeP7FQ9bNh+b1zJUhCk6VJ+M0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777679102; c=relaxed/simple;
	bh=aqrijPcj80AasmQc1rNu3Vq2DQwxPSPGAhWWWwYWd+Y=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FUXjnktbfxeXyvs+ZNWinEVAPGTaxNjo18X5lXwnjgvDv79cMddhqL8KDs3Qn9KkS2zPULiPGzZUgEKLFFeErRC4AoUSiwterPEDnlzfuRtH20Pht18A7RwZJX/n674rLlqoS3MSAG/zW9hMzadhDPPdynKqnRSiZPZij4ON3nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=YXcLtHBp; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="YXcLtHBp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TAB+kZlsCbDF+Ebc5vLDXAhpf8/Ynxr8Ri4rQUd4xHo=; b=YXcLtHBpzSVzd0Eq0VoOkvAYsn
	eTeVSgOJt+4efo8EsvD29w8djQBM+DezT2lTVXmeMjjRM+qw41FV4SKmilJBPvJ/r0xn7C016LNAe
	UWb98MnCAKO4apdW2mZdKoKJzCwRu/yJOla7MIHkn8nwBzQSRJ4ddp8wp1udTbzZII1z3EfD0tmyJ
	CFjoA7XG2xJdiRAPLMIajsQh3fL0K1nQq5fFb7aDu5vIpKJS54w9G4pANPjsXLp6zmROmXSDN+7TQ
	517tSjVmlPCj4S3mAro5Yb80TrWlp04N7ZwbeOyRrJnqKNO4pY8uPcunEPFcpTKmt1Ba89SJk5cAF
	Mrf9utVw==;
Received: from [172.56.176.195] (port=4634 helo=merlin.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wIxXY-000000052t6-2KaX by authid <merlins.org> with srv_auth_plain;
	Fri, 01 May 2026 16:45:00 -0700
Received: from merlin by merlin.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc@merlins.org>)
	id 1wIxXV-0028fu-25;
	Fri, 01 May 2026 16:44:57 -0700
Date: Fri, 1 May 2026 16:44:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Attempt to replace 60TB Spinning Rust NAS with a Raspberry Pi 5 with
 Quad PCI Splitter and 18 2.5 Sata SSDs TLC and DRAM-less TeamGroup QLC
 drives: Unreliable single Lane PCI bus Under Load
Message-ID: <afU6-UuV7E0PYbcw@merlins.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 172.56.176.195
X-SA-Exim-Mail-From: marc@merlins.org

This is not a bug report per se, but reporting this in case it can be helpful.
Gemini AI said taht I'm just being unrealistic in putting a 4 way PCI splitter with 9 port sata cards behind that and 18 drives total on a Pi5 PCI bus which is not super resilient with PCI and Sata timeouts.
In this case, it caused QLC drives to corrupt their flash in a way that
they had to be block wiped and reset. Now they work fine in an N355 PC
with one sata controller per PCI lane and no PCI splitters.

http://marc.merlins.org/perso/linux/post_2026-04-13_Attempt-to-replace-my-60TB-Spinning-Rust-NAS-with-a-Raspberry-Pi-5-with-Quad-PCI-Splitter-and-18-2_5-Sata-SSDs-TLC-and-DRAM-less-TeamGroup-QLC-drives_-Unreliable-single-Lane-PCI-bus-Under-Load.html

Details here:

logs below for google searches or whatnot. No help needed, but sending in case it helps
nvme nvme0: controller is down; will reset: CSTS=0x3, PCI_STATUS=0x10
[57247.067230] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x400001 action 0x6 frozen
[57247.076133] ata8: SError: { RecovData Handshk }
[57247.081246] ata8.00: failed command: READ DMA
[57247.086014] ata8.00: cmd c8/00:08:c8:03:5b/00:00:00:00:00/e1 tag 2 dma 4096 in
[57247.086014]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[57247.101469] ata8.00: status: { DRDY }
[57247.105822] ata8: hard resetting link
[57247.153797] nvme nvme0: 3/0/0 default/read/poll queues
[57247.587051] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[57247.630423] ata8.00: supports DRM functions and may not be fully accessible
[57247.750869] ata8.00: supports DRM functions and may not be fully accessible
[57247.807025] ata8.00: configured for UDMA/133
[57247.811957] sd 7:0:0:0: [sdh] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=32s
[57247.822653] sd 7:0:0:0: [sdh] tag#2 Sense Key : 0xb [current] 
[57247.829121] sd 7:0:0:0: [sdh] tag#2 ASC=0x0 ASCQ=0x0 
[57247.835477] sd 7:0:0:0: [sdh] tag#2 CDB: opcode=0x88 88 00 00 00 00 00 01 5b 03 c8 00 00 00 08 00 00
[57247.845243] I/O error, dev sdh, sector 22741960 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[57247.855511] ata8: EH complete
[57247.872535] ata8.00: Enabling discard_zeroes_data
[60367.285453] ata9.00: exception Emask 0x10 SAct 0x0 SErr 0x400100 action 0x6 frozen
[60367.293666] ata9.00: irq_stat 0x08000000, interface fatal error
[60367.300313] ata9: SError: { UnrecovData Handshk }
[60367.306530] ata9.00: failed command: WRITE DMA EXT
[60367.311966] ata9.00: cmd 35/00:00:78:8c:f7/00:05:1e:00:00/e0 tag 9 dma 655360 out
[60367.311966]          res 50/00:00:ff:03:f7/00:00:1e:00:00/e0 Emask 0x10 (ATA bus error)
[60367.328871] ata9.00: status: { DRDY }
[60367.333036] ata9: hard resetting link
[60367.805496] ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[60367.863205] ata9.00: configured for UDMA/133
[60367.868064] ata9: EH complete
[60397.357520] nvme nvme0: controller is down; will reset: CSTS=0x3, PCI_STATUS=0x10
[60397.453616] nvme nvme0: 3/0/0 default/read/poll queues                                                 
[60398.929509] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400001 action 0x6 frozen                      
[60398.959616] ata1: SError: { RecovData Handshk }                                                        
[60398.966761] ata1.00: failed command: READ DMA                                                          
[60398.972859] ata1.00: cmd c8/00:08:78:b9:4a/00:00:00:00:00/e2 tag 22 dma 4096 in                        
[60398.972859]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[60398.990825] ata1.00: status: { DRDY }
[60398.995717] ata1: hard resetting link
[60399.473455] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[60399.541525] ata1.00: configured for UDMA/133
[60399.546657] sd 0:0:0:0: [sda] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=DRIVER_OK cmd_age=32s
[60399.557577] sd 0:0:0:0: [sda] tag#22 Sense Key : 0xb [current] 
[60399.564532] sd 0:0:0:0: [sda] tag#22 ASC=0x0 ASCQ=0x0 
[60399.570665] sd 0:0:0:0: [sda] tag#22 CDB: opcode=0x88 88 00 00 00 00 00 02 4a b9 78 00 00 00 08 00 00
[60399.580758] I/O error, dev sda, sector 38451576 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[60399.590585] ata1: EH complete
[60399.640204] ata1.00: Enabling discard_zeroes_data
[72688.943036] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400001 action 0x6 frozen
[72688.951084] ata1: SError: { RecovData Handshk }
[72688.956422] ata1.00: failed command: WRITE DMA
[72688.961594] ata1.00: cmd ca/00:20:00:ac:82/00:00:00:00:00/e5 tag 14 dma 16384 out
[72688.961594]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[72688.977731] ata1.00: status: { DRDY }                                                                  
[72688.981969] ata1: hard resetting link                                                                  
[72688.986211] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x400001 action 0x6 frozen                      
[72688.994663] ata2: SError: { RecovData Handshk }                                                        
[72688.999881] ata2.00: failed command: WRITE DMA                                                         
[72689.005000] ata2.00: cmd ca/00:20:c0:b0:82/00:00:00:00:00/e5 tag 19 dma 16384 out                      
[72689.005000]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)                       
[72689.022962] ata2.00: status: { DRDY }                                                                  
[72689.027430] ata2: hard resetting link
[72689.499039] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[72689.506396] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[72689.611777] ata1.00: configured for UDMA/133
[72689.616890] ata1: EH complete
[72689.723181] ata2.00: configured for UDMA/133
[72689.728156] ata2: EH complete
[72689.865333] ata1.00: Enabling discard_zeroes_data
[72689.871277] ata2.00: Enabling discard_zeroes_data
[73227.538624] nvme nvme1: controller is down; will reset: CSTS=0x3, PCI_STATUS=0x10
[73227.640436] nvme nvme1: D3 entry latency set to 8 seconds
[73227.658550] nvme nvme1: 1/0/0 default/read/poll queues
[86766.334170] nvme nvme0: controller is down; will reset: CSTS=0x3, PCI_STATUS=0x10
[86766.442187] nvme nvme0: 3/0/0 default/read/poll queues
[86766.863105] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x400001 action 0x6 frozen
[86766.877356] ata6: SError: { RecovData Handshk }
[86766.884232] ata6.00: failed command: WRITE DMA
[86766.891103] ata6.00: cmd ca/00:80:18:95:b5/00:00:00:00:00/e6 tag 20 dma 65536 out
[86766.891103]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[86766.908556] ata6.00: status: { DRDY }
[86766.914377] ata6: hard resetting link
[86766.919016] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x400001 action 0x6 frozen
[86766.930307] ata2: SError: { RecovData Handshk }
[86766.937937] ata2.00: failed command: READ DMA
[86766.943738] ata2.00: cmd c8/00:38:a0:e6:3b/00:00:00:00:00/e5 tag 4 dma 28672 in
[86766.943738]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[86766.965459] ata2.00: status: { DRDY }
[86766.970640] ata2: hard resetting link
[86766.976782] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x400001 action 0x6 frozen
[86766.989369] ata3: SError: { RecovData Handshk }
[86767.001777] ata3.00: failed command: WRITE DMA
[86767.010295] ata3.00: cmd ca/00:80:18:95:b5/00:00:00:00:00/e6 tag 21 dma 65536 out
[86767.010295]          res 40/00:00:06:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)                       
[86767.060215] ata3.00: status: { DRDY }                                                                  
[86767.071409] ata3: hard resetting link                                                                  
[86767.550253] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)                                     
[86767.563271] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)                                     
[86767.572715] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[86767.585598] ata6.00: supports DRM functions and may not be fully accessible
[86767.616959] ata6.00: supports DRM functions and may not be fully accessible
[86767.631980] ata3.00: configured for UDMA/133
[86767.639404] ata3: EH complete
[86767.643354] ata6.00: configured for UDMA/133
[86767.661059] ahci 0001:03:00.0: port does not support device sleep
[86767.663591] ata3.00: Enabling discard_zeroes_data
[86767.676336] ata6: EH complete
[86767.745871] ata2.00: configured for UDMA/133
[86767.754280] ata2: EH complete
[86767.772933] ata2.00: Enabling discard_zeroes_data
[95256.566913] nvme nvme0: controller is down; will reset: CSTS=0x3, PCI_STATUS=0x10
[95256.574928] nvme nvme1: controller is down; will reset: CSTS=0x3, PCI_STATUS=0x10
[95256.679475] nvme nvme1: D3 entry latency set to 8 seconds
[95256.689110] nvme nvme0: 2/0/0 default/read/poll queues
[95256.694718] nvme nvme1: 1/0/0 default/read/poll queues
[95256.697626] I/O error, dev nvme0n1, sector 264208 op 0x1:(WRITE) flags 0x29800 phys_seg 1 prio class 2
[95256.712397] I/O error, dev nvme0n1, sector 264208 op 0x1:(WRITE) flags 0x29800 phys_seg 1 prio class 2
[95256.722258] md: super_written gets error=-5
[95256.727133] md/raid1:md0: Disk failure on nvme0n1p2, disabling device.
[95256.727133] md/raid1:md0: Operation continuing on 1 devices.
[95256.742401] I/O error, dev nvme0n1, sector 77334752 op 0x1:(WRITE) flags 0x4000800 phys_seg 1 prio class 2
[95256.753375] BTRFS error (device nvme0n1p3): bdev /dev/nvme0n1p3 errs: wr 1, rd 1, flush 0, corrupt 0, gen 0
[95256.764177] I/O error, dev nvme0n1, sector 77335776 op 0x1:(WRITE) flags 0x4000800 phys_seg 1 prio class 2
[95256.774805] BTRFS error (device nvme0n1p3): bdev /dev/nvme0n1p3 errs: wr 2, rd 1, flush 0, corrupt 0, gen 0
[97602.825969] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[97602.833948] ata6.00: failed command: WRITE DMA EXT
[97602.839911] ata6.00: cmd 35/00:00:78:5a:4c/00:04:09:00:00/e0 tag 22 dma 524288 out
[97602.839911]          res 40/00:01:06:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[97602.858583] ata6.00: status: { DRDY }
[97602.863617] ata6: hard resetting link
[97603.337938] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[97603.346750] ata6.00: supports DRM functions and may not be fully accessible
[97603.370306] ata6.00: supports DRM functions and may not be fully accessible
[97603.430476] ata6.00: configured for UDMA/133
[97603.445466] ahci 0001:03:00.0: port does not support device sleep
[97603.452251] ata6: EH complete
[97637.643844] BTRFS warning (device dm-1): csum failed root 263 ino 3692950 off 386400256 csum 0xd04e5f48 expected csum 0x6b9afaa1 mirror 1
[97637.657936] BTRFS error (device dm-1): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[97638.110104] BTRFS warning (device dm-1): csum failed root 263 ino 3692950 off 386400256 csum 0xd04e5f48 expected csum 0x6b9afaa1 mirror 1
[97638.123856] BTRFS error (device dm-1): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[97662.159091] BTRFS warning (device dm-1): csum failed root 263 ino 3692950 off 386400256 csum 0xd04e5f48 expected csum 0x6b9afaa1 mirror 1
[97662.173941] BTRFS error (device dm-1): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
[97662.906008] BTRFS warning (device dm-1): csum failed root 263 ino 3692950 off 386400256 csum 0xd04e5f48 expected csum 0x6b9afaa1 mirror 1
[97662.920993] BTRFS error (device dm-1): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0



-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
